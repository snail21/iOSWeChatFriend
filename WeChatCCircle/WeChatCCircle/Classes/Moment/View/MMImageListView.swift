//
//  MMImageListView.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

//### 图片显示集合
class MMImageListView: UIView {
    
    // 动态
    var moment: Moment!
    // 图片视图数组
    var imageViewsAry: NSMutableArray!
    // 预览视图
    //    var previewView: mmImag
    
    
    
}


// 点击小图block
typealias tapSmallView = (_ imageView: UIImageView) ->()

//### 单个小图显示视图
class MMImageView: UIImageView {
    
    var block: tapSmallView!
}

