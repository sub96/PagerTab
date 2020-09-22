//
//  MainPageViewController.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 14/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    
    // MARK: - Variables
    private var currentIndex: Int = 0
    private var destinationIndex: Int = 0
    private var tabRequestedScroll = false
    private var orderedViewControllers: SPagerModels.DataSource = []
    private var defaultIndex: Int = 0
    private var scrollView: UIScrollView?
    private weak var animatorDelegate: MainPageViewControllerDelegate?
    
    // MARK: - Life cycle
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        guard let defaultPage = orderedViewControllers[safe: defaultIndex]?.vc else { return }
        self.setViewControllers([defaultPage],
                                direction: .forward,
                                animated: false,
                                completion: nil)
    }
    
    // MARK: - Public methods
    func configureDataSource(with orderedViewControllers: SPagerModels.DataSource,
                             defaultIndex: Int,
                             animatorDelegate: MainPageViewControllerDelegate) {
        self.orderedViewControllers = orderedViewControllers
        self.animatorDelegate = animatorDelegate
        self.defaultIndex = defaultIndex
        self.currentIndex = defaultIndex
    }
    
    func isScrollingEnabled(_ isEnabled: Bool?) {
        self.scrollView?.isScrollEnabled = isEnabled ?? true
    }
    
    func tabDidRequestScroll(to index: Int, onCompletion: @escaping () -> Void) {
        tabRequestedScroll = true
        let destination = orderedViewControllers[index].vc
        let direction: NavigationDirection = index > currentIndex ?
            .forward : .reverse
        DispatchQueue.main.async { [unowned self] in
            self.setViewControllers([destination],
                                    direction: direction,
                                    animated: true) { _ in
                DispatchQueue.main.async {
                    self.currentIndex = index
                    self.tabRequestedScroll = false
                    self.animatorDelegate?.pagerDidFinishAnimating(to: index, direction: direction)
                    onCompletion()
                }
            }
        }
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    // MARK: - Private methods
    
    private func configureDelegates() {
        scrollView = view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        scrollView?.delegate = self
        self.dataSource = self
        self.delegate = self
    }
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(where: { $0.vc == viewController })
            else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex].vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(where: { $0.vc == viewController })
            else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex].vc
    }
}

extension MainPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        self.destinationIndex = orderedViewControllers
            .firstIndex(where: { $0.vc == pendingViewControllers.first }) ?? 9
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed && finished {
            guard let source = orderedViewControllers
                .firstIndex(where: { $0.vc == previousViewControllers.first }) else { return }
            currentIndex = destinationIndex
            let direction: NavigationDirection = destinationIndex > source ?
                .forward : .reverse
            animatorDelegate?.pagerDidFinishAnimating(to: currentIndex,
                                                      direction: direction)
        }
    }
}

extension MainPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !tabRequestedScroll else { return }
        
        let point = scrollView.contentOffset
        let percentComplete = abs(point.x - view.frame.size.width) / view.frame.size.width
        
        var direction: NavigationDirection
        
        if (destinationIndex == 0 && currentIndex == 0) {
            direction = .reverse
        } else {
            direction = destinationIndex >= currentIndex ?
                .forward : .reverse
        }
        animatorDelegate?.pagerDidScroll(self,
                                         current: self.currentIndex,
                                         direction: direction,
                                         completed: percentComplete)
    }
}
