//
//  PagerProtocols.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 15/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

public enum SPagerModels {
    public typealias CustomizationDictionary = [CustomKeys: Any]
    public typealias DataSource = [DataSourceElement]

    /// Dictionary with all the possible customizations
    ///
    /// - Keys:
    ///   - tabBackgroundColor: UIColor
    ///   - indicatorBackgroundColor: UIColor
    ///   - indicatorColor: UIColor
    ///   - textColor: UIColor
    ///   - badgeColor: UIColor
    ///   - isScrollinEnabled: Bool
    ///   - textFont: UIFont
    ///   - imageHeight: CGFloat
    ///   - imageTintColor: UIColor
    public enum CustomKeys: String {
        case tabBackgroundColor
        case indicatorBackgroundColor
        case indicatorColor
        case textColor
        case badgeColor
        case isScrollinEnabled
        case textFont
        case imageHeight
        case imageTintColor
    }
    
    public struct DataSourceElement {
        public let vc: UIViewController
        public let identifier: Any
        public let tabType: TabType
        
        public init(vc: UIViewController,
                    identifier: Any,
                    tabType: TabType) {
            self.vc = vc
            self.identifier = identifier
            self.tabType = tabType
        }
    }
    
    public enum TabType {
        case image(UIImage, NSAttributedString)
        case soloText(NSAttributedString)
    }
}

protocol MainPageViewControllerDelegate: class {
    func pagerDidFinishAnimating(to currentIndex: Int,
                                 direction: UIPageViewController.NavigationDirection)
    
    func pagerDidScroll(_ pager: UIPageViewController,
                        current index: Int,
                        direction: UIPageViewController.NavigationDirection,
                        completed percentage: CGFloat)
}
