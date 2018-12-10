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
    @objc optional func didSelectComment(comment: Comment)
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
    lazy var commentView: UIView = {
        
        return UIView()
    }()
    // 赞和评论视图背景
    var bgImageView: UIImageView!
    // 操作视图
    var menuView: MMOpeateMenuView!
    // 动态
    var moment: Moment! {
        
        didSet {
            
            headImageView?.image = UIImage(named: "moment_head")
            nameLab?.text = moment.userName
            
            // 正文
            showAllBtn?.isHidden = true
            linkLab?.isHidden = true
            var bottom = (nameLab?.bottom)! + CGFloat(kPaddingValue)
            var rowHeight:CGFloat = 0.0
            
            if moment.text?.count != 0 {
                
                linkLab?.isHidden = false
                linkLab?.text = moment.text
                
                // 判断显示全文/ 收起
                let attrStrSize = linkLab?.preferredSize(withMaxWidth: kTextWidth)
                var labH: CGFloat = (attrStrSize?.height)!
                
                if labH > maxLimitHeight {
                    
                    if moment.isFullText != true {
                        
                        labH = maxLimitHeight
                        self.showAllBtn?.setTitle("全文", for: .normal)
                    }
                    else {
                        self.showAllBtn?.setTitle("收起", for: .normal)
                    }
                    showAllBtn?.isHidden = false
                }
                linkLab?.frame = CGRect(x: (nameLab?.left)!, y: bottom, width: (attrStrSize?.width)!, height: labH)
                showAllBtn?.frame = CGRect(x: (nameLab?.left)!, y: (linkLab?.bottom)! + CGFloat(kArrowHeight), width: CGFloat(kMoreLabWidth), height: CGFloat(kMoreLabHeight))
                
                if (showAllBtn?.isHidden)! {
                    
                    bottom = (linkLab?.bottom)! + CGFloat(kPaddingValue)
                }
                else {
                    bottom = (showAllBtn?.bottom)! + CGFloat(kPaddingValue)
                }
            }
            
            // 图片
            imageListView.moment = moment
            if moment.fileCount! > 0 {
                
                imageListView.origin = CGPoint(x: (nameLab?.left)!, y: bottom)
                bottom = imageListView.bottom + CGFloat(kPaddingValue)
            }
            
            // 位置
            locationLab?.frame = CGRect(x: (nameLab?.left)!, y: bottom, width: (nameLab?.width)!, height: CGFloat(kTimeLabH))
            timeLab?.text = Utility.getDateFormat(byTimestamp: Int64(moment!.time!)!)
            let textW = (timeLab!.text! as NSString).boundingRect(with: CGSize(width: 200, height: CGFloat(kTimeLabH)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: timeLab?.font as Any], context: nil).size.width
            
            
            if moment.location?.count != 0 {
                
                locationLab?.isHidden = false
                locationLab?.text = moment.location
                timeLab?.frame = CGRect(x: (nameLab?.left)!, y: (locationLab?.bottom)! + CGFloat(kPaddingValue), width: textW, height: CGFloat(kTimeLabH))
            }
            else {
                locationLab?.isHidden = true
                timeLab?.frame = CGRect(x: (nameLab?.left)!, y: bottom, width: textW, height: CGFloat(kTimeLabH))
            }
            
            deleteBtn?.frame = CGRect(x: (timeLab?.right)! + 25.0, y: (timeLab?.top)!, width: 30.0, height: CGFloat(kTimeLabH))
            bottom = (timeLab?.bottom)! + CGFloat(kPaddingValue)
            
            // 操作视图
            menuView.frame = CGRect(x: kSCREEN_WIDTH - CGFloat(kOperateWidth) - 10.0, y: (timeLab?.top)! - CGFloat((kOperateHeight-kTimeLabH)/2), width: CGFloat(kOperateWidth), height: CGFloat(kOperateHeight))
            menuView.show = false
            
            // 处理评论、赞
            self.commentView.frame = .zero
            bgImageView.frame = .zero
            bgImageView.image = nil
            let _ = self.commentView.subviews.map {
                  $0.removeFromSuperview()
            }
            
            // 处理赞
            var top: CGFloat = 0.0
            let width = kSCREEN_WIDTH - CGFloat(kRightMargin) - (nameLab?.left)!
            
            
            if  moment.praiseNameList?.count != 0 {
                
                let likeLab = MLLabelUtil.kMLLinkLable()
                likeLab.delegate = self
                likeLab.attributedText = MLLabelUtil.kMLLinkLabelAttributedText(objc: moment.praiseNameList)
                let attrStrSize = likeLab.preferredSize(withMaxWidth: CGFloat(kTextWidth))
                likeLab.frame = CGRect(x: 5.0, y: 8.0, width: attrStrSize.width, height: attrStrSize.height)
                self.commentView.addSubview(likeLab)
                
                // 分割线
                let line = UIView(frame: CGRect(x: 0.0, y: likeLab.bottom + 7.0, width: width, height: 0.5))
                line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                self.commentView.addSubview(line)
            
                // 更新
                top = attrStrSize.height + 15
            }
            
            // 处理评论
            let count = moment.commentList?.count ?? 0
            if count > 0 {
                
                for i in 0..<count  {
                    let lab = CommentLabel(frame: CGRect(x: 0.0, y: top, width: width, height: 0.0))
                    lab.comment = (moment.commentList![i] as! Comment)
                    lab.didClickTextBlock = { (comments: Comment) in
                        
                        if self.delegate != nil {
                            
                            self.delegate?.didSelectComment!(comment:comments)
                        }
                    }
                    
                    lab.didClickLinkTextBlock = { (links, linkText) in
                        
                        if self.delegate != nil {
                            
                            self.delegate?.didClickLink!(link: links, linkText: linkText)
                        }
                    }
                    self.commentView.addSubview(lab)
                    
                    //更新
                    top += lab.height
                }
            }
            
            // 更新UI
            if top > 0 {
                
                bgImageView.frame = CGRect(x: (nameLab?.left)!, y: bottom, width: width, height: top + CGFloat(kArrowHeight))
                bgImageView.image = UIImage(named: "comment_bg")?.stretchableImage(withLeftCapWidth: 40, topCapHeight: 30)
                self.commentView.frame = CGRect(x: (nameLab?.left)!, y: bottom + CGFloat(kArrowHeight), width: width, height: top)
                rowHeight = self.commentView.bottom + CGFloat(kBlnk)
            }
            else {
                rowHeight = (timeLab?.bottom)! + CGFloat(kBlnk)
            }
            
            moment.rowHeight = rowHeight
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

        self.contentView.addSubview(self.commentView)
        
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
