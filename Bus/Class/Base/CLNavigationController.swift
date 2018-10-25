//
//  CLNavigationController.swift
//  Bus
//
//  Created by cleven on 2018/10/25.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit

class CLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count >= 1{
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }

}
