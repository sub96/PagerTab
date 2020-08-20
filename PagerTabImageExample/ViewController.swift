//
//  ViewController.swift
//  PagerTabImageExample
//
//  Created by Suhaib Al Saghir on 10/07/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import PagerTab

class ViewController: PagerRootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var dataSource = DataSource()
        let first = UIViewController()
        first.view.backgroundColor = .blue
        let second = UIViewController()
        first.view.backgroundColor = .green
        dataSource.append((vc: first,
                           tabType: .soloText(.init(string: "Sent"))))
        dataSource.append((vc: UIViewController(),
                           tabType: .soloText(.init(string: "Pending"))))
        dataSource.append((vc: second,
                           tabType: .soloText(.init(string: "Reminders"))))

        self.configure(with: dataSource)
        
        var customKeys = CustomizationDictionary()
        customKeys[.tabBackgroundColor] = UIColor.systemRed
        customKeys[.indicatorColor] = UIColor.blue
        customKeys[.textColor] = UIColor.white
        customKeys[.isScrollinEnabled] = false
        self.customize(with: customKeys)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.count += 1
            self.updateCounter(at: 1, with: self.count)
        }
    }
}

