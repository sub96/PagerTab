//
//  ViewController.swift
//  PagerTabExample
//
//  Created by Suhaib Al Saghir on 18/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import PagerTab

class ViewController: PagerRootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataSource = DataSource()
        let first = UIViewController()
        first.view.backgroundColor = .yellow
        dataSource.append((vc: first, tabType: .soloText(.init(string: "cucu"))))
        dataSource.append((vc: UIViewController(), tabType: .soloText(.init(string: "yoyo"))))

        self.configure(with: dataSource)
        
        var customKeys = CustomizationDictionary()
        customKeys[.tabBackgroundColor] = UIColor.green
        customKeys[.indicatorColor] = UIColor.blue
        self.customise(with: customKeys)
    }
}

