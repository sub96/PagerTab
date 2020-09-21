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

class TabCell: UIView, TabCellProtocol {

    @IBOutlet private weak var tabImageView: UIImageView!
    @IBOutlet private weak var tabLabel: UILabel!
    
    @IBOutlet private weak var notificationView: UIView!
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
        self.notificationView.layer.cornerRadius = self.notificationView.bounds.height / 2
    }
    
    func setTextColor(_ color: UIColor?) {
        self.tabLabel.textColor = color
    }
    
    func setBadgeColor(_ color: UIColor?) {
        self.notificationView.backgroundColor = color
    }
    
    func setTextFont(_ font: UIFont?) {
        self.tabLabel.font = font
    }
    
    func updateCounter(with count: Int) {
        self.notificationView.isHidden = count == 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.notificationCounter.text = count >= 99 ? "+\(99)" : String(count)
            if count == 0 {
                self?.notificationView.alpha = 0
            } else {
                let isSelected = self?.notificationView.transform != .identity
                self?.notificationView.alpha = isSelected ? 1 : 0.6
            }
        }
    }
    
    func animate(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if isShowing {
                self?.tabLabel.transform = .init(scaleX: 1.1, y: 1.1)
                self?.tabLabel.alpha = 1
                
                self?.notificationView.transform = .init(scaleX: 1.1, y: 1.1)
                self?.notificationView.alpha = self?.notificationCounter.text == "0" ? 0 : 1
            } else {
                self?.tabLabel.transform = .identity
                self?.tabLabel.alpha = 0.6
                
                self?.notificationView.transform = .identity
                self?.notificationView.alpha = self?.notificationCounter.text == "0" ? 0 : 0.6
                
            }
        }
    }
}

extension TabCell {
    func connectXib() {
        
        self.backgroundColor = .clear
        let view = self.loadNib()
        view.frame = self.bounds
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ]
        )
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView //swiftlint:disable:this force_cast
    }
}
