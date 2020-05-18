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

public typealias DataSource = [(vc: UIViewController, tabType: TabType)]
public typealias CustomizationDictionary = [CustomKeys: Any]

public enum TabType {
    case image(UIImage, NSAttributedString)
    case soloText(NSAttributedString)
}

/// Dictionary with all the possible customizations
///
/// - Keys:
///   - tabBackgroundColor: UIColor
///   - indicatorColor: UIColor
public enum CustomKeys: String {
    case tabBackgroundColor
    case indicatorColor
    case textColor
    case badgeColor
}

