//
//  MLLabelUtil.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/5.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class MLLabelUtil: NSObject {
    
    class func kMLLinkLable() -> MLLinkLabel{
        
        let linkLab = MLLinkLabel()
        linkLab.lineBreakMode = .byWordWrapping
        linkLab.textColor = UIColor.black
        linkLab.font = kComtTextFont
        linkLab.numberOfLines = 0
        linkLab.linkTextAttributes = [NSAttributedString.Key.foregroundColor: kHLTextColor]
        linkLab.activeLinkTextAttributes = [NSAttributedString.Key.foregroundColor: kHLTextColor, NSAttributedString.Key.backgroundColor: kHLBgColor]
        linkLab.activeLinkToNilDelay = 0.3
        
        return linkLab
    }
    
    class func kMLLinkLabelAttributedText(objc: Any) -> NSMutableAttributedString? {
        
        var attributedText: NSMutableAttributedString?
        
        if objc is Comment {
            
            let comment = objc as! Comment
            if comment.pk! % 2 == 0 {
                
                let likeStr: NSString = "Jeanne回复" + comment.userName! + ":" + comment.text! as NSString
                attributedText = NSMutableAttributedString(string: likeStr as String)
                attributedText?.setAttributes([NSAttributedString.Key.font : kComHLTextFont, NSAttributedString.Key.link:"Jeanne"], range: likeStr.range(of: "Jeanne"));
                attributedText?.setAttributes([NSAttributedString.Key.font:kComHLTextFont,NSAttributedString.Key.link:comment.userName as Any], range: likeStr.range(of: comment.userName!))
            }
            else {
                
                let likeStr: NSString = comment.userName! + ":" + comment.text! as NSString
                attributedText = NSMutableAttributedString(string: likeStr as String)
                attributedText?.setAttributes([NSAttributedString.Key.font: kComHLTextFont, NSAttributedString.Key.link: comment.userName as Any], range: likeStr.range(of: comment.userName!))
            }
            
        }
        
        if objc is String {
            
            let content = objc as! String
            let likeStr: NSString = "[赞]" + content as NSString
            attributedText = NSMutableAttributedString(string: likeStr as String)
            let nameList: NSArray =  content.components(separatedBy: ",") as NSArray
            nameList.enumerateObjects { (objc, index, stop) in
                
                let name: String = objc as! String
                attributedText?.setAttributes([NSAttributedString.Key.font: kComHLTextFont, NSAttributedString.Key.link: objc], range: likeStr.range(of: name))
            }
            
            // 添加赞的图片
            let range = NSMakeRange(0, 3)
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: "moment_like_hl")
            textAttachment.bounds = CGRect(x: 0, y: -3.0, width: (textAttachment.image?.size.width)!, height: (textAttachment.image?.size.height)!)
            let imageStr = NSAttributedString(attachment: textAttachment)
            attributedText?.replaceCharacters(in: range, with: imageStr)
        }
        
//        if attributedText == nil {
//
//            attributedText = NSMutableAttributedString(string: "")
//        }
        
        return attributedText
    }
    
}
