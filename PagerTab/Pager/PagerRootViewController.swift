//
//  PagerRootViewController.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 14/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class PagerRootViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var tabStackView: UIStackView!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    private var dataSource: DataSource = []
    private var tabs: [TabCell] = []
    private weak var pager: MainPageViewController?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabs.first?.animate(isShowing: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed",
            let pager = segue.destination as? MainPageViewController {
            self.pager = pager
            pager.configureDataSource(with: dataSource,
                                      animatorDelegate: self)
            
        }
    }
    
    // MARK: - Public methods
    func configure(with dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: - Private methods
    private func configureTab() {
        self.indicatorWidthConstraint.constant = UIScreen.main.bounds.width / CGFloat(dataSource.count)
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
            let destinationIndex = tabs.firstIndex(where: { $0 == gesture.view })
            else { return }
        
        print("Tab requested scrolling from \(currentIndex) to \(destinationIndex)")
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
