//
//  MonentViewVC.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class MonentViewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "好友动态"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "moment_camera"), style: .plain, target: self, action: #selector(addMoment))
        
        loadViewFrame()
        loadViewData()
    }
    
    // 加载视图
    func loadViewFrame() {
        
        
    }
    
    // 加载数据
    func loadViewData() {
        
    }
    
    //MARK: 发布动态
    @objc func addMoment() {
        
        print("新增")
    }


}
