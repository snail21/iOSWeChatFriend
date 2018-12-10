//
//  MMOpeateMenuView.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

typealias likeMoment = () -> ()
typealias commentMoment = () -> ()

class MMOpeateMenuView: UIView {

    
    // 视图
    lazy var menuView: UIView = {
        
        // 菜单视图容器
        let view = UIView(frame: CGRect(x: kOperateWidth - kOperateBtnWidth, y: 0, width: kOperateWidth - kOperateBtnWidth, height: kOperateHeight))
        view.backgroundColor = UIColor(red: 70.0/255.0, green: 74.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        
        return view
       
    }()
    // 按钮
    var menuBtn: UIButton!
    
    // 赞
    var likeMomentBlock: likeMoment?
    // 评论
    var commentMomentBlock: commentMoment?
    
    var show: Bool? {
        
        didSet {
            
            var menu_left = kOperateWidth - kOperateBtnWidth
            var menu_width = 0.0
            
            if show! {
                
                menu_left = Int(0.0)
                menu_width = Double(kOperateWidth - kOperateBtnWidth)
            }
            
            self.menuView.width = CGFloat(menu_width)
            self.menuView.left = CGFloat(menu_left)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        show = true
        
       
        
        // 点赞
        let btn = UUButton(frame: CGRect(x: 0, y: 0, width: Int(self.menuView.width / 2), height: kOperateHeight))
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.spacing = 3
        btn.setTitle("赞", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setImage(UIImage(named: "moment_like"), for: .normal)
        btn.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
        self.menuView.addSubview(btn)
        
        // 分割线
        let line = UIView(frame: CGRect(x: btn.right - 5.0, y: 8.0, width: 0.5, height: CGFloat(kOperateHeight - 16)))
        line.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.menuView.addSubview(line)
        
        // 评论
        let pBtn = UUButton(frame: CGRect(x: line.right, y: 0.0, width: btn.width, height: CGFloat(kOperateHeight)))
        pBtn.backgroundColor = UIColor.clear
        pBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        pBtn.spacing = 3
        pBtn.setTitle("评论", for: .normal)
        pBtn.setTitleColor(UIColor.white, for: .normal)
        pBtn.setImage(UIImage(named: "moment_comment"), for: .normal)
        pBtn.addTarget(self, action: #selector(commentClick), for: .touchUpInside)
        self.menuView.addSubview(pBtn)
        
        self.addSubview(self.menuView)
        
        //菜单操作按钮
        let button = UIButton(frame: CGRect(x: CGFloat(kOperateWidth - kOperateBtnWidth), y: 0.0, width:CGFloat( kOperateBtnWidth), height: CGFloat(kOperateHeight)))
        button.setImage(UIImage(named: "moment_operate"), for: .normal)
        button.setImage(UIImage(named: "moment_operate_hl"), for: .highlighted)
        button.addTarget(self, action: #selector(menuClick), for: .touchUpInside)
        self.menuBtn = button
        self.addSubview(self.menuBtn)
        
    }
    
    //MARK: 按钮点击事件
    
    // 弹出视图
    @objc func menuClick() {
        
        self.show = !show!
        var menu_left = kOperateWidth - kOperateBtnWidth
        var menu_width = 0
        
        if show! {
            menu_left = 0
            menu_width = kOperateWidth - kOperateBtnWidth
        }
        UIView.animate(withDuration: 0.2) {
            
            self.menuView.width = CGFloat(menu_width)
            self.menuView.left = CGFloat(menu_left)
        }
    }
    
    // 喜欢
    @objc func likeClick() {
        
        if self.likeMomentBlock != nil {
            
            self.likeMomentBlock!()
        }
    }
    
    // 评论
    @objc func commentClick() {
        
        if self.commentMomentBlock != nil {
            
            self.commentMomentBlock!()
        }
    }
}
