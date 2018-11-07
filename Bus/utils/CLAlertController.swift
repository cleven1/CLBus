//
//  CLAlertController.swift
//  Bus
//
//  Created by cleven on 2018/10/31.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class CLAlertController: NSObject {

    static func alertViewShow(title: String, msg: String, cancelTitle: String, confirmTitle: String, showView: UIView, handler:@escaping () -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: nil)
        let userAction = UIAlertAction(title: confirmTitle, style: .cancel) { (_) in
            handler()
        }
        alert.addAction(cancelAction)
        alert.addAction(userAction)
        (showView.currentController())?.present(alert, animated: true, completion: nil)
    }
}
