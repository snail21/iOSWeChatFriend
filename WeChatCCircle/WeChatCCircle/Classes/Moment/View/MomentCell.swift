//
//  MomentCell.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

@objc protocol MomentCellDelegate {
    
    // 点击用户头像
    @objc optional func didClickProfile(cell: MomentCell)
    // 删除
    @objc optional func didDeleMoment(cell: MomentCell)
    // 点赞
    @objc optional func didLikeMoment(cell: MomentCell)
    // 评论
    @objc optional func didAddComment(cell: MomentCell)
    // 查看全文/收起
    @objc optional func didSelectFullText(cell: MomentCell)
    // 选择评论
    @objc optional func didSelectComment(cell: MomentCell)
    // 点击高亮文字
    @objc optional func didClickLink(link: MLLink, linkText: String)
   
}

class MomentCell: UITableViewCell {
    
    // 头像
    let headImageView: UIImageView? = nil
    // 名称
    let nameLab: UILabel? = nil
    // 时间
    let timeLab: UILabel? = nil
    // 位置
    let locationLab: UILabel? = nil
    // 删除
    let deleteBtn: UIButton? = nil
    // 全文
    let showAllBtn: UIButton? = nil
    // 内容
    let linkLab: MLLinkLabel? = nil
    // 图片
//    let imageListVIew
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}


class CommentLabel: UIView {
    
    
}
