//
//  PagerRootViewController.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 14/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

open class PagerRootViewController: UIViewController {

    // MARK: - UI Variables
    private var tabContainer = UIView()
    private var tabStackView = UIStackView()
    private var indicatorView = UIView()
    private weak var indicatorWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Data Variables
    private var dataSource: DataSource = []
    private var tabs: [TabCell] = []
    private var pager: MainPageViewController!
    private var customizationDictionary: CustomizationDictionary = [:]
    // MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
        configureTab()
        customize()
        tabs.first?.animate(isShowing: true)
    }
    
    // MARK: - Public methods
    public func configure(with dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    public func customize(with dictionary: CustomizationDictionary) {
        self.customizationDictionary = dictionary
    }
    
    public func updateCounter(at index: Int, with count: Int) {
        tabs[safe: index]?.updateCounter(with: count)
    }
}

// MARK: - Private methods
extension PagerRootViewController {
    
    /// Main function that prepares the UI
    private func prepareUI() {
        let tabContainer = generateTabBar()
        let containerView = generateContainerView()
        
        let mainStackView = UIStackView(arrangedSubviews: [tabContainer, containerView])
        mainStackView.axis = .vertical
        self.view.addSubview(mainStackView)
        mainStackView.constraintToSafeArea(self.view)
    
    }
    
    private func generateTabBar() -> UIView {
        
        let tabContainer = configureTabContainer()
        let indicatorContainer = configureIndicatorView()
        
        let topStack = UIStackView(arrangedSubviews: [tabContainer, indicatorContainer])
        topStack.axis = .vertical
        tabStackView.distribution = .fillEqually
        
        return topStack
    }
    
    private func configureTabContainer() -> UIView {
        self.tabContainer = UIView()
        
        tabContainer.addSubview(tabStackView)
        tabStackView.constraint(to: tabContainer)
        
        return tabContainer
    }
    
    private func configureIndicatorView() -> UIView {
        let indicatorContainer = UIView()
        indicatorContainer.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: Add customise key for height constraint
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: indicatorContainer.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: indicatorContainer.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: indicatorContainer.leadingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        // The width constrait will be later updated when the datasource is available
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 30)
        indicatorWidthConstraint?.isActive = true
        
        // TODO: Add customise key for color
        indicatorView.backgroundColor = .green
        
        return indicatorContainer
    }
    
    private func generateContainerView() -> UIView {
        let container = UIView()
        
        self.pager = MainPageViewController.init(transitionStyle: .scroll,
                                                 navigationOrientation: .horizontal,
                                                 options: nil)
        
        pager.configureDataSource(with: dataSource,
                                  animatorDelegate: self)
        addChild(pager)
        
        pager.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(pager.view)
        pager.view.constraint(to: container)
        pager.didMove(toParent: self)
        return container
    }
    
    private func configureTab() {
        self.indicatorWidthConstraint?.constant = UIScreen.main.bounds.width / CGFloat(dataSource.count)
        tabStackView.isMultipleTouchEnabled = false
        for data in dataSource {
            let tabCell = TabCell()
            tabCell.configure(with: data.tabType)
            let tapGesture = UITapGestureRecognizer.init(target: self,
                                                         action: #selector(tabDidTapped(_:)))
            tabCell.addGestureRecognizer(tapGesture)
            self.tabs.append(tabCell)
            self.tabStackView.addArrangedSubview(tabCell)
        }
    }
    
    @objc private func tabDidTapped(_ gesture: UITapGestureRecognizer) {
        guard let currentIndex = pager?.getCurrentIndex(),
            let destinationIndex = tabs.firstIndex(where: { $0 == gesture.view }),
            currentIndex != destinationIndex
            else { return }
        
        // Disable user interaction to not spam the user
        self.tabStackView.isUserInteractionEnabled = false
        
        // Tell the pager that the user request scrolling
        self.pager?.tabDidRequestScroll(to: destinationIndex, onCompletion: { [weak self] in
            // Re enable user interaction
            self?.tabStackView.isUserInteractionEnabled = true
        })
        
        // Animate
        self.tabs[safe: currentIndex]?.animate(isShowing: false)
        self.tabs[safe: destinationIndex]?.animate(isShowing: true)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.indicatorView.frame.origin = CGPoint(x: CGFloat(destinationIndex) * self.indicatorView.bounds.width,
                                                      y: 0)
        }
    }
    
    private func customize() {
        self.customizationDictionary.forEach { key, value in
            switch key {
            case .tabBackgroundColor:
                self.tabContainer.backgroundColor = value as? UIColor
                
            case .indicatorColor:
                self.indicatorView.backgroundColor = value as? UIColor
                
            case .textColor:
                self.tabs.forEach { $0.setTextColor(value as? UIColor) }
            
            case .badgeColor:
                self.tabs.forEach { $0.setBadgeColor(value as? UIColor) }
            }
        }
    }
}

extension PagerRootViewController: MainPageViewControllerDelegate {
    func pagerDidScroll(_ pager: UIPageViewController,
                        current index: Int,
                        direction: UIPageViewController.NavigationDirection,
                        completed percentage: CGFloat) {
        
        guard percentage != .zero else { return }
        let progress = percentage * indicatorView.bounds.width
        let current = CGFloat(index) * indicatorView.bounds.width
        let sign: CGFloat = direction == .forward ? 1 : -1
        self.indicatorView.frame.origin = CGPoint(x: current + (sign * progress),
                                                  y: 0)
    }
    
    func pagerDidFinishAnimating(_ pager: UIPageViewController,
                                 to currentIndex: Int,
                                 direction: UIPageViewController.NavigationDirection) {
        let previousIndex = direction == .forward ?
            currentIndex - 1 : currentIndex + 1
        
        self.tabs[safe: previousIndex]?.animate(isShowing: false)
        self.tabs[safe: currentIndex]?.animate(isShowing: true)
    }
}
