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
    var moment: Moment! {
        
        didSet {
            
            imageViewsAry.enumerateObjects { (objc, index, stop) in
                
                let imageView: MMImageView = objc as! MMImageView
                imageView.isHidden = true
            }
            
            // 图片区域
            let count:Int = Int(moment.fileCount!)
            if count == 0 {
                
                self.size = .zero
                return
            }
            
            // 更新视图数据
            previewView.pageNum = Int(count)
            previewView.scrollView.contentSize = CGSize(width: previewView.width * CGFloat(count), height: previewView.height)
       
            // 添加图片
            var imageView: MMImageView!
            for i in 0..<count {
                
                if i > 8 {
                    break
                }
                
                var rowNum = i / 3
                var colNum = i % 3
                if count == 4 {
                    
                    rowNum = i / 2
                    colNum = i % 2
                }
                
                let imageX = colNum * (kImageWidth + kImagePadding)
                let imageY = rowNum * (kImagePadding + kImageWidth)
                var frame = CGRect(x: imageX, y: imageY, width: kImageWidth, height: kImageWidth)
                
                // 单张图片需要计算实际显示Size
                if count == 1 {
                    
                    let singleSize = Utility.getSingleSize(CGSize(width: moment.singleWidth!, height: moment.singleHeight!))
                    frame = CGRect(x: 0.0, y: 0.0, width: singleSize.width, height: singleSize.height)
                }
                
                imageView = self.viewWithTag(1000 + i) as? MMImageView
                imageView.isHidden = false
                imageView.frame = frame
                imageView.image = UIImage(named: "moment_pic_" + i.description)
            }
            
            self.width = kTextWidth
            self.height = imageView.bottom
        }
    }
    // 图片视图数组
    var imageViewsAry: NSMutableArray!
    // 预览视图
        var previewView: MMImagePreviewView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        imageViewsAry = NSMutableArray()
        
        for i in 0..<9 {
          
            let imageView = MMImageView(frame: .zero)
            imageView.tag = 1000 + i
            imageView.block = { (imageViewd) in
                
                self.singleTapSmallViewCallback(imageView: imageViewd)
            }
            imageViewsAry.add(imageView)
            self.addSubview(imageView)
        }
        previewView = MMImagePreviewView(frame: UIScreen.main.bounds)
        
    }
    
    //MARK: 小图单击
    func singleTapSmallViewCallback(imageView: MMImageView) {
        
        let window = UIApplication.shared.windows.first
        
        // 解除隐藏
        window?.addSubview(previewView)
        window?.bringSubviewToFront(previewView)
        
        // 清空
        _ =  previewView.scrollView.subviews.map {
            
            $0.removeFromSuperview()
        }
        
        // 添加子视图
        let index = imageView.tag - 1000
        let count = Int(moment.fileCount!)
        var convertRect: CGRect!
        
        if count == 1 {
            
            previewView.pageControl.removeFromSuperview()
        }
        
        for i in 0..<count {
            // 转换Frame
            let pImageView:MMImageView = self.viewWithTag(1000 + i) as! MMImageView
            convertRect = pImageView.superview?.convert((pImageView.frame), to: window)
            // 添加
            let scrollView = MMScrollView(frame: CGRect(x: CGFloat(i) * previewView.width, y: 0.0 , width: previewView.width, height: previewView.height))
            scrollView.tag = 100 + i
            scrollView.maximumZoomScale = 2.0
            scrollView.image = pImageView.image
            scrollView.contentRect = convertRect

            // 单击
            scrollView.tapBigViewBlock = { (sssView: MMScrollView) in
                
                self.singleTapBigViewCallback(scrollView: sssView)
            }
            
            // 长按
            scrollView.longPressBigViewBlock = { (sssView) in
                
                self.longPresssBigViewCallback(scrollView: sssView)
            }
            previewView.scrollView.addSubview(scrollView)
            if i == index {
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.previewView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
                    self.previewView.pageControl.isHidden = false
                    scrollView.updateOriginRect()
                }
            }
            else {
                scrollView.updateOriginRect()
            }
        }
        
        // 更新offset
        var offset = previewView.scrollView.contentOffset
        offset.x = CGFloat(index) * kSCREEN_WIDTH
        previewView.scrollView.contentOffset = offset
    }
    
    //MARK: 大图单击||长按
    func singleTapBigViewCallback(scrollView: MMScrollView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.previewView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            self.previewView.pageControl.isHidden = true
            
            let rect = scrollView.contentRect
            scrollView.contentRect = rect
            scrollView.zoomScale = 1.0
        }) { (finished) in
            
            self.previewView.removeFromSuperview()
        }
    }
    
    //MARK : 长按
    func longPresssBigViewCallback(scrollView: MMScrollView) {
        
        print("长按")
    }
}


// 点击小图block
typealias tapSmallView = (_ imageView: MMImageView) ->()

//### 单个小图显示视图
class MMImageView: UIImageView {
    
    var block: tapSmallView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.contentScaleFactor = UIScreen.main.scale
        self.isUserInteractionEnabled = true
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureCallback(gesture:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func singleTapGestureCallback(gesture: UIGestureRecognizer) -> () {
        
        if self.block != nil {
            
            self.block(self)
        }
        
    }
}

