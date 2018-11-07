//
//  UIView+Extension.swift
//  Bus
//
//  Created by cleven on 2018/11/2.
//  Copyright © 2018 cleven. All rights reserved.
//

import UIKit

extension UIView {
    //返回该view所在VC
    func currentController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
