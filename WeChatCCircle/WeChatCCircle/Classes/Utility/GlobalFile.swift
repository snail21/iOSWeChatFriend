//
//  GlobalFile.swift
//  SwiftProjectFrame
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation


//MARK: 屏幕设置系列
let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let kSCREEN_BOUNDS = UIScreen.main.bounds
//顶部电池条的状态栏高度
let kStatubarHeight = UIApplication.shared.statusBarFrame.size.height  //状态栏高度
let WD_NavBarHeight: CGFloat = 44.0
let WD_TabBarHeight = UIApplication.shared.statusBarFrame.size.height > 20 ? 83 : 49  //底部tabbar高度
let WD_TopHeight = (kStatubarHeight + WD_NavBarHeight) //整个导航栏高度

/** 高度667(6s)为基准比例！！！做到不同屏幕适配高度*/
let GET_HEI =  kSCREEN_HEIGHT/667.0

/** 宽度375.0f(6s)为基准比例！！！做到不同屏幕适配宽度  */
let GET_WID =  kSCREEN_WIDTH/375.0

let __LEFT = __X(x:12)


/** 适配屏幕宽度比例*f  */
func __X(x:CGFloat) -> CGFloat {
    return GET_WID * x
}

/** 适配屏幕高度比例*f  */
func __Y(y:CGFloat) -> CGFloat {
    return GET_HEI * y
}

func __FONT(x:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: __X(x: x))
}

func __setCGRECT(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

/**  如果传入进来的name为空，会导致崩溃 因为必须返回有值 */
func __setImageName(name:String) -> UIImage {
    
    return UIImage(named: name)!
}


func __CGFloat(number:AnyObject) -> CGFloat {
    return CGFloat(truncating: number as! NSNumber)
}


let KUserDefauls = UserDefaults.standard


//MARK: 分享枚举
enum ShareEnum_num: NSInteger {
    case ShareCopyLink = 0
    case ShareWeiXFriend
    case ShareWeiXCircle
    case ShareQQFriend
    case ShareWeiBoFriend
}

