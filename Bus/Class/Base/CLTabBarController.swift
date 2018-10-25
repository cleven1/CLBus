//  CLMainViewController.swift
//  video
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//
import UIKit

class CLTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
}
extension CLTabBarController {
    
    fileprivate func setUpUI(){
        
        addChildViewController(title: "首页", vc: CLHomeViewController(), imageName: "bt_tabbar_search")
        
        addChildViewController(title:"换乘", vc: CLChangeViewController(), imageName: "bt_tabbar_transit")
        
        addChildViewController(title:"收藏", vc: CLChangeViewController(), imageName: "bt_tabbar_star")
        
        addChildViewController(title:"我", vc: CLProfileViewController(), imageName: "bt_tabbar_more")


    }
    
    
    fileprivate func addChildViewController(title:String,vc:UIViewController,imageName:String){
        
        vc.title = title
        //设置默认图片
        vc.tabBarItem.image = UIImage(named:imageName)
        //设置高亮图片
        vc.tabBarItem.selectedImage = UIImage(named: imageName +  "_select")?.withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.cl_colorWithHex(hex: 0x1296db)], for: .selected)
        
        let nav = CLNavigationController(rootViewController: vc)
        //添加子控制器
        addChildViewController(nav)
        
    }
    
}

