//
//  MMImagePreviewView.swift
//  WeChatCCircle
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

//### 点击预览时的承载视图
class MMImagePreviewView: UIView, UIScrollViewDelegate {
    
    // j横向滚动视图
    var scrollView: UIScrollView!
    // 页码指示
    var pageControl: UIPageControl!
    // 页码页数
    var pageNum: Int!
    // 页码索引
    var pageIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() -> () {
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.isUserInteractionEnabled = true
        
        // 添加子视图
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        //页面控制
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.height - 40 , width: kSCREEN_WIDTH, height: 20))
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(pageControl)
    }
    
    func setPageNum(page: Int) {
        
        pageNum = page
        pageControl.numberOfPages = page
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        pageIndex = Int(scrollView.contentOffset.x / self.width)
        pageControl.currentPage = pageIndex
    }

}

typealias tapBigViewBlock = (_ scrollView: MMScrollView) -> ()
typealias longPressBigViewBlock = (_ scrollView: MMScrollView) -> ()

//### 单个大图显示视图
class MMScrollView: UIScrollView, UIScrollViewDelegate {
    
    // 显示的大图
    var imageView: UIImageView!
    // 原始Frame
    var originRect: CGRect!
    // 过程Frame
    var contentRect: CGRect? {
        
        didSet {
            self.imageView.frame = contentRect!
        }
    }
    // 图片
    var image: UIImage? {
        
        didSet {
            imageView.image = image
        }
    }
    // 点击大图（关闭预览）
    var tapBigViewBlock: tapBigViewBlock?
    // 长按显示大图
    var longPressBigViewBlock: longPressBigViewBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载视图
    func addContentView() {
        
        self.backgroundColor = UIColor.clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = true
        self.minimumZoomScale = 1.0
        self.bouncesZoom = true
        self.delegate = self
        
        // 显示图片
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.contentScaleFactor = UIScreen.main.scale
        imageView.backgroundColor = UIColor.red
        self.addSubview(imageView)

        // 双击
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureCallback(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        // 单击
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureCallback(gesture:)))
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
        // 长按
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureCallback(gesture:)))
        self.addGestureRecognizer(longPress)
    }
    
    //MARK: 更新Frame
    func updateOriginRect() {
        
        let picSize = self.imageView.image?.size
        if picSize?.width == 0 || picSize?.height == 0 {
            
            return
        }
        
        let scaleX = self.frame.size.width / (picSize?.width)!
        let scaleY = self.frame.size.height / (picSize?.height)!
        
        if scaleX > scaleY {
            
            let imgViewWidth = (picSize?.width)! * scaleY
            self.maximumZoomScale = self.frame.size.width / imgViewWidth
            originRect = CGRect(x: self.frame.size.width / 2 - imgViewWidth / 2 , y: 0, width: imgViewWidth, height: self.frame.size.height)
        }
        else {
           
            let imgViewHeight = (picSize?.height)! * scaleX
            self.maximumZoomScale = self.frame.size.height  / imgViewHeight
            originRect = CGRect(x: 0, y: self.frame.size.height / 2 - imgViewHeight / 2, width: self.frame.size.width, height: imgViewHeight)
            self.zoomScale = 1.0
        }
        
        UIView.animate(withDuration: 0.4) {
            
            self.imageView.frame = self.originRect
        }
        
    }
    
    //MARK: 手势处理
   @objc func singleTapGestureCallback(gesture: UITapGestureRecognizer) {
        
        if (self.tapBigViewBlock != nil) {
            
            self.tapBigViewBlock!(self)
        }
    }
    
  @objc  func doubleTapGestureCallback(gesture: UITapGestureRecognizer) {
        
        var zoomScale = self.zoomScale
        if zoomScale == self.maximumZoomScale {
            
            zoomScale = 0
        }
        else {
            zoomScale = self.maximumZoomScale
        }
        
        UIView.animate(withDuration: 0.35) {
            self.zoomScale = zoomScale
        }
    }
    
   @objc func longPressGestureCallback(gesture: UILongPressGestureRecognizer) {
        
        if self.longPressBigViewBlock != nil {
            
            self.longPressBigViewBlock!(self)
        }
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let boundsSize = scrollView.bounds.size
        let imgFrame = self.imageView.frame
        let contentSize = scrollView.contentSize
        var centerPoint = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        
        if imgFrame.size.width <= boundsSize.width {
            
            centerPoint.x = boundsSize.width / 2
        }
        
        if imgFrame.size.height <= boundsSize.height {
            
            centerPoint.y = boundsSize.height / 2
        }
        self.imageView.center = centerPoint
    }
    
    
}
