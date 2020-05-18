//
//  XibConnected.swift
//  VoNo
//
//  Created by Suhaib Al Saghir on 4/24/19.
//  Copyright © 2019 DTT Multimedia. All rights reserved.
//

import UIKit

// TODO: update
extension UIView {
    func constraint(to parent: UIView,
                    with insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom),
                self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.right),
                self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.left)
            ]
        )
    }
    
    func constraintToSafeArea(_ parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let guide = parent.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: guide.topAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
}
