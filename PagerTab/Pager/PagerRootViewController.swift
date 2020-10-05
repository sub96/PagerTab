//
//  PagerRootViewController.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 14/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

public protocol PagerRootDelegate: class {
    func pagerDidFinishAnimating()
}

open class PagerRootViewController: UIViewController {

    // MARK: - UI Variables
    private var tabContainer = UIView()
    private var tabStackView = UIStackView()
    private var indicatorView = UIView()
    private var indicatorContainer = UIView()
    private weak var indicatorWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Data Variables
    private var dataSource: SPagerModels.DataSource = []
    private var defaultIndex: Int = 0
    private var tabs: [TabCell] = []
    private var pager: MainPageViewController!
    private var customizationDictionary: SPagerModels.CustomizationDictionary = [:]
    
    // MARK: - Delegate
    private weak var delegate: PagerRootDelegate?

    private var isInitialized = false
    
    // MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isInitialized {
            animate(from: 0, to: defaultIndex)
            isInitialized = true
        }
    }
    
    // MARK: - Public methods
    public func configure(with dataSource: SPagerModels.DataSource,
                          defaultIndex: Int?,
                          delegate: PagerRootDelegate? = nil) {
        self.dataSource = dataSource
        self.defaultIndex = defaultIndex ?? 0
        self.delegate = delegate
        prepareUI()
        configureTabStackView()
        customize()
    }
    
    public func customize(with dictionary: SPagerModels.CustomizationDictionary) {
        self.customizationDictionary = dictionary
    }
    
    public func isScrollingEnabled(_ isEnabled: Bool) {
        pager.isScrollingEnabled(isEnabled)
    }
    
    public func updateCounter(at index: Int, with count: Int) {
        tabs[safe: index]?.updateCounter(with: count)
    }
    
    public func updateBadgeColor(at index: Int, with color: UIColor) {
        guard index <= tabs.count - 1 else { return }
        tabs[index].setBadgeColor(color)
    }
    
    public func setTabHidden(isHidden: Bool) {
        self.tabContainer.isHidden = isHidden
    }
    
    public func getCurrentIndex() -> Int {
        return pager.getCurrentIndex()
    }
    
    public func getCurrentVC() -> UIViewController {
        let index = getCurrentIndex()
        return dataSource[index].vc
    }
    
    public func set(viewControllers: [UIViewController],
                    direction: UIPageViewController.NavigationDirection,
                    animated: Bool,
                    completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            self?.pager.setViewControllers(viewControllers,
                                           direction: direction,
                                           animated: animated,
                                           completion: completion)
        }
    }
}

// MARK: - Private methods
private extension PagerRootViewController {
    
    /// Main function that prepares the UI
    func prepareUI() {
        let tabContainer = generateTabBar()
        let containerView = generateContainerView()
        
        let mainStackView = UIStackView(arrangedSubviews: [tabContainer, containerView])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        mainStackView.constraintToSafeArea(self.view)
    
    }
    
    func generateTabBar() -> UIView {
        
        configureTabContainer()
        let indicatorContainer = configureIndicatorView()
        
        let topStack = UIStackView(arrangedSubviews: [tabContainer, indicatorContainer])
        topStack.axis = .vertical
        tabStackView.distribution = .fillEqually
        
        return topStack
    }
    
    func configureTabContainer() {
        tabContainer.addSubview(tabStackView)
        tabStackView.constraint(to: tabContainer)
    }
    
    func configureIndicatorView() -> UIView {

        indicatorContainer.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        indicatorView.backgroundColor = .green
        
        return indicatorContainer
    }
    
    func generateContainerView() -> UIView {
        let container = UIView()
        
        self.pager = MainPageViewController(transitionStyle: .scroll,
                                            navigationOrientation: .horizontal,
                                            options: nil)
        
        pager.configureDataSource(with: dataSource,
                                  defaultIndex: defaultIndex,
                                  animatorDelegate: self)
        addChild(pager)
        
        pager.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(pager.view)
        pager.view.constraint(to: container)
        pager.didMove(toParent: self)
        return container
    }
    
    func configureTabStackView() {
        self.indicatorWidthConstraint?.constant = UIScreen.main.bounds.width / CGFloat(dataSource.count)
        tabStackView.isMultipleTouchEnabled = false
        for data in dataSource {
            let tabCell = TabCell()
            tabCell.configure(with: data.tabType)
            let tapGesture = UITapGestureRecognizer.init(target: self,
                                                         action: #selector(tabDidTapped(_:)))
            tabCell.addGestureRecognizer(tapGesture)
            tabCell.animate(isShowing: false)
            self.tabs.append(tabCell)
            self.tabStackView.addArrangedSubview(tabCell)
        }
    }
    
    @objc func tabDidTapped(_ gesture: UITapGestureRecognizer) {
        guard let currentIndex = pager?.getCurrentIndex(),
            let destinationIndex = tabs.firstIndex(where: { $0 == gesture.view }),
            currentIndex != destinationIndex
            else { return }
        
        // Disable user interaction to not spam the user
        self.tabStackView.isUserInteractionEnabled = false
        self.pager.view.endEditing(true)
        
        // Tell the pager that the user request scrolling
        self.pager?.tabDidRequestScroll(to: destinationIndex, onCompletion: { [weak self] in
            // Re enable user interaction
            self?.tabStackView.isUserInteractionEnabled = true
        })

        // Animate
        self.animate(from: currentIndex, to: destinationIndex)
    }
    
    func animate(from currentIndex: Int, to destinationIndex: Int) {
        self.tabs[safe: currentIndex]?.animate(isShowing: false)
        self.tabs[safe: destinationIndex]?.animate(isShowing: true)

        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.indicatorView.frame.origin = CGPoint(x: CGFloat(destinationIndex) * self.indicatorView.bounds.width,
                                                      y: 0)
        }
    }
    
    func customize() {
        self.customizationDictionary.forEach { key, value in
            switch key {
            case .tabBackgroundColor:
                self.tabContainer.backgroundColor = value as? UIColor
                
            case .indicatorBackgroundColor:
                self.indicatorContainer.backgroundColor = value as? UIColor

            case .indicatorColor:
                self.indicatorView.backgroundColor = value as? UIColor
                
            case .textColor:
                self.tabs.forEach { $0.setTextColor(value as? UIColor) }
            
            case .badgeColor:
                self.tabs.forEach { $0.setBadgeColor(value as? UIColor) }

            case .isScrollinEnabled:
                self.pager.isScrollingEnabled(value as? Bool)
                
            case .textFont:
                self.tabs.forEach { $0.setTextFont(value as? UIFont) }
                
            case .imageHeight:
                self.tabs.forEach { $0.setImageHeight(value as? CGFloat) }
                
            case .imageTintColor:
                self.tabs.forEach { $0.setImageTint(value as? UIColor) }
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
    
    func pagerDidFinishAnimating(to currentIndex: Int,
                                 direction: UIPageViewController.NavigationDirection) {
        let previousIndex = direction == .forward ?
            currentIndex - 1 : currentIndex + 1
        
        self.animate(from: previousIndex, to: currentIndex)
        self.delegate?.pagerDidFinishAnimating()
    }
}
