//
//  MainViewController.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor(red: 0.85 , green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        self.tabBar.tintColor = UIColor(red: 14.0/255.0 , green: 178.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        loadViewFrame()
        
    }
    
    func loadViewFrame() {
        
        let titles: NSArray = ["微信", "通讯录", "发现", "我"]
        let viewControllers:NSMutableArray = NSMutableArray()
        
        titles.enumerateObjects { (objc, index, stop) in
            
            let comImage = UIImage(named: "tabbar_" + index.description)
            let comImageH = UIImage(named: "tabbar_hl_" + index.description)
            
            let item = UITabBarItem(title: objc as? String, image: comImage, selectedImage: comImageH)
            item.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10) ], for: .normal)
            
            let controller = DisconverviewVC()
            controller.vcType = index
            controller.title = objc as? String
            controller.tabBarItem = item
            
            let navController = UINavigationController(rootViewController: controller)
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19)]
            navController.navigationBar.setBackgroundImage(UIImage(named: "navigaitonbar"), for: UIBarMetrics.default)
            navController.navigationBar.tintColor = UIColor.white
            navController.navigationBar.barStyle = UIBarStyle.blackOpaque
            navController.navigationBar.isTranslucent = false
            viewControllers.add(navController)
        }
        
        self.viewControllers = viewControllers as? [UIViewController]
    }
}
