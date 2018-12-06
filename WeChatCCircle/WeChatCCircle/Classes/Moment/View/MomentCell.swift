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

class MomentCell: UITableViewCell, MLLinkLabelDelegate {

    
    
    // 头像
    var headImageView: UIImageView?
    // 名称
    var nameLab: UILabel?
    // 时间
    var timeLab: UILabel?
    // 位置
    var locationLab: UILabel?
    // 删除
    var deleteBtn: UIButton?
    // 全文
    var showAllBtn: UIButton?
    // 内容
    var linkLab: MLLinkLabel?
    // 图片
    var imageListView: MMImageListView!
    // 赞和评论视图
    var commentView: UIView!
    // 赞和评论视图背景
    var bgImageView: UIImageView!
    // 操作视图
    var menuView: MMOpeateMenuView!
    // 动态
    var moment: Moment! {
        
        didSet {
            
            
        }
    }
    // 代理
    var delegate: MomentCellDelegate?
    // 最大高度限制
    var maxLimitHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        // 头像视图
        headImageView = UIImageView(frame: CGRect(x: 10, y: kBlnk, width: kFaceWidth, height: kFaceWidth))
        headImageView?.contentMode = .scaleAspectFill
        headImageView?.isUserInteractionEnabled = true
        headImageView?.layer.masksToBounds = true
        self.contentView.addSubview(headImageView!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickHead(gesture:)))
        headImageView?.addGestureRecognizer(tapGesture)
        
        // 名字视图
        nameLab = UILabel(frame: CGRect(x: (headImageView?.right)! + 10, y: (headImageView?.top)!, width: CGFloat(kFaceWidth), height: 20.0))
        nameLab?.font = UIFont.systemFont(ofSize: 17)
        nameLab?.textColor = kHLTextColor
        nameLab?.backgroundColor = UIColor.clear
        self.contentView.addSubview(nameLab!)
        
        // 正文视图
        linkLab = MLLabelUtil.kMLLinkLable()
        linkLab?.font = kTextFont
        linkLab?.delegate = self
        linkLab?.linkTextAttributes = [NSAttributedString.Key.foregroundColor: kLinkTextColor]
        linkLab?.activeLinkTextAttributes = [NSAttributedString.Key.foregroundColor: kLinkTextColor, NSAttributedString.Key.backgroundColor: kHLBgColor]
        self.contentView.addSubview(linkLab!)
        
        // 查看“全文”按钮
        showAllBtn = UIButton(type: .custom)
        showAllBtn?.titleLabel?.font = kTextFont
        showAllBtn?.contentHorizontalAlignment = .left
        showAllBtn?.backgroundColor = UIColor.clear
        showAllBtn?.setTitle("全文", for: .normal)
        showAllBtn?.setTitleColor(kHLTextColor, for: .normal)
        showAllBtn?.addTarget(self, action: #selector(fullTextClicked(sender:)), for: .touchUpInside)
        self.contentView.addSubview(showAllBtn!)
        
        // 图片区
        imageListView = MMImageListView(frame: .zero)
        self.contentView.addSubview(imageListView)
        
        // 位置视图
        locationLab = UILabel()
        locationLab?.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
        locationLab?.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(locationLab!)
        
        // 时间视图
        timeLab = UILabel()
        timeLab?.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
        timeLab?.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(timeLab!)
        
        // 删除视图
        deleteBtn = UIButton(type: .custom)
        deleteBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deleteBtn?.backgroundColor = UIColor.clear
        deleteBtn?.setTitle("删除", for: .normal)
        deleteBtn?.setTitleColor(kHLTextColor, for: .normal)
        deleteBtn?.addTarget(self, action: #selector(deleteMoment(sender:)), for: .touchUpInside)
        self.contentView.addSubview(deleteBtn!)
        
        // 评论视图
        bgImageView = UIImageView()
        self.contentView.addSubview(bgImageView)
        commentView = UIView()
        self.contentView.addSubview(commentView)
        
        // 操作视图
        menuView = MMOpeateMenuView(frame: .zero)
        menuView.likeMomentBlock = { () in
            
            if  self.delegate != nil {
                
                self.delegate?.didLikeMoment!(cell: self)
            }
        }
        
        menuView.commentMomentBlock = {() in
            
            if self.delegate != nil {
                
                self.delegate?.didAddComment!(cell: self)
            }
        }
        self.contentView.addSubview(menuView)
        maxLimitHeight = (linkLab?.font.lineHeight)! * 6
    }
    
    //MARK: 点击事件
    // 头像点击事件
    @objc func clickHead(gesture: UITapGestureRecognizer) {
        
        if (self.delegate != nil) {
            
            self.delegate?.didClickProfile!(cell: self)
        }
    }
    // 查看全文/ 收起
    @objc func fullTextClicked(sender: UIButton) {
        
        showAllBtn?.titleLabel?.backgroundColor = kHLBgColor

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:
            {
                self.showAllBtn?.titleLabel?.backgroundColor = UIColor.clear
                self.moment.isFullText = !self.moment.isFullText!
                if self.delegate != nil {
                    self.delegate?.didSelectFullText!(cell: self)
                }
        })
    }
    // 删除动态
    @objc func deleteMoment(sender: UIButton) {
        
       deleteBtn?.titleLabel?.backgroundColor = UIColor.lightGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          
            self.deleteBtn?.titleLabel?.backgroundColor = UIColor.clear
            if self.delegate != nil {
                
                self.delegate?.didDeleMoment!(cell: self)
            }
        }
    }
    
    //MARK: Delegate
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
        
        if self.delegate != nil {
            
            self.delegate?.didClickLink!(link: link, linkText: linkText)
        }
    }
    
}

//### 评论

typealias didClickLinkText = (_ link: MLLink, _ linkText: String) -> ()
typealias didClickText = (_ comment: Comment) -> ()

class CommentLabel: UIView, MLLinkLabelDelegate {

    
    // 内容Label
    var linkLab: MLLinkLabel!
    // 评论
    var comment: Comment! {
        
        didSet{
            
            linkLab.attributedText = MLLabelUtil.kMLLinkLabelAttributedText(objc: comment)
            let attrStrSize = linkLab.preferredSize(withMaxWidth: kTextWidth)
            linkLab.frame = CGRect(x: 5.0, y: 3.0, width: attrStrSize.width, height: attrStrSize.height)
            self.height = attrStrSize.height + 5
        }
    }
    // 点击评论高亮内容
    var didClickLinkTextBlock: didClickLinkText!
    // 点击评论
    var didClickTextBlock: didClickText!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        linkLab = MLLabelUtil.kMLLinkLable()
        linkLab.delegate = self
        self.addSubview(linkLab)
    }
    
    //MARK: 代理
    func didClick(_ link: MLLink!, linkText: String!, linkLabel: MLLinkLabel!) {
        
        if (self.didClickLinkTextBlock != nil) {
            
            self.didClickLinkTextBlock(link, linkText)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.backgroundColor = kHLBgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.backgroundColor = UIColor.clear
            if (self.didClickTextBlock != nil) {
                
                self.didClickTextBlock(self.comment)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.backgroundColor = UIColor.clear
    }
    
}
