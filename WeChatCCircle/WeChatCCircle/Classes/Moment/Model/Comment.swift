//
//  Comment.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class Comment: NSObject {

    // 正文
    var text: String?
    // 发布者名字
    var userName: String?
    // 发布时间戳
    var time: String?
    // 关联动态PK
    var pk: Int?
}
