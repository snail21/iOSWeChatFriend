//
//  MonentViewVC.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class MonentViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MomentCellDelegate {

    let cellIdentifer: NSString = "momentCell"
    
    var momentList: NSMutableArray!
    var tableView: UITableView!
    var headerView: UIView!
    var coverImageView: UIImageView!
    var headImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "好友动态"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "moment_camera"), style: .plain, target: self, action: #selector(addMoment))
        
        loadViewFrame()
        loadViewData()
    }
    
    // 加载视图
    func loadViewFrame() {
        
        // 封面
        let imageView = UIImageView(frame: CGRect(x: 0, y: -WD_TopHeight, width: kSCREEN_WIDTH, height: 270))
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.contentScaleFactor = UIScreen.main.scale
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "moment_cover")
        self.coverImageView = imageView
        
        
        // 用户头像
        let imageViewt = UIImageView(frame: CGRect(x: kSCREEN_WIDTH - 85, y: self.coverImageView.bottom - 40, width: 75, height: 75))
        imageViewt.backgroundColor = UIColor.clear
        imageViewt.layer.borderColor = UIColor.white.cgColor
        imageViewt.layer.borderWidth = 2
        imageViewt.isUserInteractionEnabled = true
        imageViewt.contentMode = .scaleAspectFill
        imageViewt.image = UIImage(named: "moment_head")
        self.headImageView = imageViewt
        
        // 表头
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 270))
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.addSubview(coverImageView)
        view.addSubview(headImageView)
        self.headerView = view
        
        // 表格
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - WD_TopHeight))
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tableView.separatorInset = .zero
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 0
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.register(MomentCell.self, forCellReuseIdentifier: cellIdentifer as String)
        self.view.addSubview(self.tableView)
    }
    
    // 加载数据
    func loadViewData() {
        
        self.momentList = NSMutableArray()
        var commentList: NSMutableArray!
        
        for i in 0..<10 {
            
            // 评论
            commentList = NSMutableArray()
            let num:Int = Int(arc4random() % 5 + 1)
            
            for j:Int in 0..<num {
                
                let comment = Comment()
                comment.userName = "胡一菲"
                comment.text = "天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来."
                comment.time = "1487649503"
                comment.pk = j
                commentList.add(comment)
            }
            
            let moment = Moment()
            moment.commentList = commentList
            moment.praiseNameList = "胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇"
            moment.userName = "Jeanne"
            moment.time = "1487649403"
            moment.singleWidth = 500
            moment.singleHeight = 315
            moment.location = "重庆 · 渝北"
            moment.isPraise = false
            
            if i == 5 {
                
                moment.commentList = nil
                moment.praiseNameList = nil
                moment.text = "蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，18107891687主要指以四川成都为中心的川西平原一带的刺绣。😁蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。😁蜀绣又名“川绣”，是在丝绸或其他织物上采用蚕丝线绣出花纹图案的中国传统工艺，https://www.baidu.com，主要指以四川成都为中心的川西平原一带的刺绣。蜀绣最早见于西汉的记载，当时的工艺已相当成熟，同时传承了图案配色鲜艳、常用红绿颜色的特点。"
                moment.fileCount = 1
//                moment.isFullText = true
            }
            else if (i == 1) {
                
                moment.text = "天界大乱，九州屠戮，当初被推下地狱的她已经浴火归来 😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍 "
                moment.fileCount = CGFloat(arc4random() % 10)
                moment.praiseNameList = nil
            }
            else if (i == 2) {
                
                moment.fileCount = 9
            }
            else {
                moment.text = "天界大乱，九州屠戮，当初被推下地狱cheerylau@126.com的她已经浴火归来，😭😭剑指仙界'你们杀了他，我便覆了你的天，毁了你的界，永世不得超生又如何！'👍👍"
                moment.fileCount = CGFloat(arc4random() % 10)
            }
            self.momentList.add(moment)
            
        }
    }
    
    //MARK： Table cell delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.momentList != nil) {
            return self.momentList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MomentCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer as String, for: indexPath) as! MomentCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        cell.moment = self.momentList[indexPath.row] as? Moment
        cell.delegate = self
        cell.tag = indexPath.row
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let moment: Moment = self.momentList.object(at: indexPath.row) as! Moment
        return moment.rowHeight ?? 200
        
//        return 600
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let indexPath = self.tableView.indexPathForRow(at: CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y))
        
        if indexPath != nil {
            
                    let cell: MomentCell = self.tableView.cellForRow(at: indexPath!) as! MomentCell
                    cell.menuView.show = false
        }
    }
    
    
    //MARK: 发布动态
    @objc func addMoment() {
        
        print("新增")
    }

    //MARK: MomentCellDelegate
    @objc func didClickProfile(cell: MomentCell) {
        
        print("点击用户头像")
    }
    
    // 点赞
    func didLikeMoment(cell: MomentCell) {
        
        print("点赞")
        let moment = cell.moment
        var tempAry = NSMutableArray()
        if moment?.praiseNameList != nil {
            
            tempAry = NSMutableArray(array: (moment?.praiseNameList?.components(separatedBy: "，"))!)
            
        }
        
        if (moment?.isPraise)! {
            
            moment?.isPraise = false
            tempAry.remove("小宝")
        }
        else {
            moment?.isPraise = true
            tempAry.add("小宝")
        }
        
        let tempStr = NSMutableString()
        let count = tempAry.count
        
        for i in 0..<count {
            
            if i == 0 {
                
                tempStr.append(tempAry.object(at: i) as! String)
            }
            else {
                
                tempStr.append(("，" + (tempAry.object(at: i) as! String)))
            }
        }
        
        moment?.praiseNameList = tempStr as String
        self.momentList.replaceObject(at: cell.tag, with: moment as Any)
        self.tableView.reloadData()
    }
    
    // 评论
    func didAddComment(cell: MomentCell) {
        
        print("评论")
    }
    
    // 查看全文、 收起
    func didSelectFullText(cell: MomentCell) {
        
        print("全文、收起")
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        let moment:Moment = (self.momentList[indexPath!.row] as? Moment)!
        moment.isFullText = !(moment.isFullText ?? false)
        
        self.momentList.replaceObject(at: (indexPath?.row)!, with: moment)
        
        self.tableView.reloadRows(at: [indexPath!], with: .none)
    }
    
    // 删除
    func didDeleMoment(cell: MomentCell) {
        
        
        print("删除")
        
        let alert = UIAlertController(title: "确定删除吗？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            
            // 取消
        }))
        
        alert.addAction(UIAlertAction(title: "删除", style: .cancel, handler: { (action) in
            
            // 删除
            self.momentList.remove(cell.moment)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 选择评论
    func didSelectComment(comment: Comment) {
        
        print("点击评论")
    }
    
    // 点击高亮文字
    func didClickLink(link: MLLink, linkText: String) {
        
        print("点击a高亮文字： " + linkText )
    }
}
