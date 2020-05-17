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
    
    func animate(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isShowing {
                self.transform = .init(scaleX: 1.2, y: 1.2)
                self.alpha = 1
            } else {
                self.transform = .identity
                self.alpha = 0.6
            }
        }
    }
}
