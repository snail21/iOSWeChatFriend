//
//  MMOpeateMenuView.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

typealias likeMoment = ()
typealias commentMoment = ()

class MMOpeateMenuView: UIView {

    var show: Bool? {
        
        return false
    }
    // 视图
    var menuView: UIView!
    // 按钮
    var menuBtn: UIButton!
    
    // 赞
    var likeMomentBlock: likeMoment?
    // 评论
    var commentMomentBlock: commentMoment?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        // 菜单视图容器
        let view = UIView(frame: CGRect(x: kOperateWidth - kOperateBtnWidth, y: 0, width: kOperateWidth - kOperateBtnWidth, height: kOperateHeight))
        view.backgroundColor = UIColor(red: 70.0/255.0, green: 74.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        // 点赞
        let btn = UUButton(frame: <#T##CGRect#>)
    }
}
