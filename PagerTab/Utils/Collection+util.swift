//
//  Collection+util.swift
//  VoNo
//
//  Created by Suhaib Al Saghir on 6/3/19.
//  Copyright © 2019 DTT Multimedia. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
