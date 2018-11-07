//
//  String+trim.swift
//  Bus
//
//  Created by cleven on 2018/11/5.
//  Copyright © 2018 cleven. All rights reserved.
//

import Foundation

extension String {
    public var trim:String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
