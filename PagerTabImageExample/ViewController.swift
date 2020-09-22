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

    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataSource = DataSource()
        let first = UIViewController()
        first.view.backgroundColor = .blue
        let second = UIViewController()
        first.view.backgroundColor = .green
        let third = UIViewController()
        first.view.backgroundColor = .yellow
        let forth = UIViewController()
        first.view.backgroundColor = .purple
        
        let title1 = NSAttributedString.init(string: "Voice Memo")
        let title2 = NSAttributedString.init(string: "Voice to Text")
        let title3 = NSAttributedString.init(string: "Text Memo")
        let title4 = NSAttributedString.init(string: "Picture Memo")

        dataSource.append((vc: first,
                           tabType: .image(UIImage.init(named: "image3")!,
                                           title1)))
        dataSource.append((vc: second,
                           tabType: .image(UIImage.init(named: "image4")!,
                                           title2)))
        dataSource.append((vc: third,
                           tabType: .image(UIImage.init(named: "image2")!,
                                           title3)))
        dataSource.append((vc: forth,
                           tabType: .image(UIImage.init(named: "image1")!,
                                           title4)))
        
        var customKeys = CustomizationDictionary()
        customKeys[.tabBackgroundColor] = UIColor.green
        customKeys[.indicatorColor] = UIColor.blue
        customKeys[.textColor] = UIColor.white
        customKeys[.isScrollinEnabled] = false
        customKeys[.textFont] = UIFont.systemFont(ofSize: 12)
        self.customize(with: customKeys)
        
        self.configure(with: dataSource)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.count += 1
            self.updateCounter(at: 1, with: self.count)
            
            if self.count == 30 {
                print("cucu")
                self.updateBadgeColor(at: 1, with: .red)
            }
        }
    }
}

