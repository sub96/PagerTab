//
//  TabCell.swift
//  PagerTab
//
//  Created by Suhaib Al Saghir on 14/05/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

protocol TabCellProtocol: class {
    
    func animate(isShowing: Bool)
}

class TabCell: UIView, XibConnected, TabCellProtocol {

    @IBOutlet private weak var tabImageView: UIImageView!
    @IBOutlet private weak var tabLabel: UILabel!
    
    @IBOutlet private weak var notificationView: RoundedView!
    @IBOutlet private weak var notificationCounter: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        connectXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        connectXib()
    }
    
    func configure(with tabType: TabType) {
        switch tabType {
        case .soloText(let text):
            self.tabImageView.isHidden = true
            self.tabLabel.attributedText = text

        case .image(let image, let text):
            self.tabImageView.image = image
            self.tabLabel.attributedText = text
        }
    }
    
    func setTextColor(_ color: UIColor?) {
        self.tabLabel.textColor = color
    }
    
    func setBadgeColor(_ color: UIColor?) {
        self.notificationView.backgroundColor = color
    }
    
    func updateCounter(with count: Int) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.notificationCounter.text = String(count)
            self?.notificationView.alpha = count == 0 ? 0 : 1
        }
    }
    
    func animate(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isShowing {
                self.tabLabel.transform = .init(scaleX: 1.2, y: 1.2)
                self.tabLabel.alpha = 1
//                self.notificationView.transform = .init(scaleX: 1.2, y: 1.2)
//                self.notificationView.alpha = 1
            } else {
                self.tabLabel.transform = .identity
                self.tabLabel.alpha = 0.6
//                self.notificationView.transform = .identity
//                self.notificationView.alpha = 0.6
            }
        }
    }
}
