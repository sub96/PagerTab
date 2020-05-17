//
//  PagerProtocols.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 15/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

protocol MainPageViewControllerDelegate: class {
    func pagerDidFinishAnimating(_ pager: UIPageViewController,
                                 to currentIndex: Int,
                                 direction: UIPageViewController.NavigationDirection)
    
    func pagerDidScroll(_ pager: UIPageViewController,
                        current index: Int,
                        direction: UIPageViewController.NavigationDirection,
                        completed percentage: CGFloat)
}

typealias DataSource = [(vc: UIViewController, tabType: TabType)]

enum TabType {
    case image(UIImage, NSAttributedString)
    case soloText(NSAttributedString)
}

