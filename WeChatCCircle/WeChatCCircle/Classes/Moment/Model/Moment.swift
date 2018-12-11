//
//  Moment.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class Moment: NSObject {
    
    // 正文
    @objc var text: String?
    // 发布位置
    @objc var location: String?
    // 发布者名字
    @objc var userName: String?
    // 发布者头像路径[本地路径]
    @objc var userThumbPath: String?
    // 赞的人[逗号隔开字符串]
    @objc var praiseNameList: String?
    // 单张图片的宽度
    var singleWidth: CGFloat?
    // 单张图片的高度
    var singleHeight: CGFloat?
    // 图片数量
    var fileCount: CGFloat?
    // 发布时间戳
    var time: String?
    // 显示/收起 全文
    var isFullText: Bool?
    // 是否已经点赞
    var isPraise: Bool?
    // 评论集合
    var commentList: NSMutableArray?
    // Moment对应的cell高度
    var rowHeight: CGFloat?
}
