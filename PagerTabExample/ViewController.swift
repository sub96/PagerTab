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
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataSource = DataSource()
        let first = UIViewController()
        first.view.backgroundColor = .yellow
        dataSource.append((vc: first, tabType: .soloText(.init(string: "cucu"))))
        dataSource.append((vc: UIViewController(), tabType: .soloText(.init(string: "yoyo"))))

        self.configure(with: dataSource)
        
        var customKeys = CustomizationDictionary()
        self.view.backgroundColor = UIColor.purple
        customKeys[.tabBackgroundColor] = UIColor.green
        customKeys[.indicatorColor] = UIColor.blue
        self.customize(with: customKeys)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.count += 1
            self.updateCounter(at: 1, with: self.count)
        }
    }
}

