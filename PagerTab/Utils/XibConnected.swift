//
//  XibConnected.swift
//  Vormats Demos
//
//  Created by Vakhid Betrakhmadov on 4/24/19.
//  Copyright © 2019 DTT Multimedia. All rights reserved.
//

import UIKit

protocol XibConnected: class { }

extension XibConnected where Self: UIView {
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
