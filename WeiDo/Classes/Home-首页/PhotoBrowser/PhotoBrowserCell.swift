//
//  PhotoBrowserCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate:NSObjectProtocol
{
    func PhotoBrowserCellDidSelected(cell: PhotoBrowserCell)

}

class PhotoBrowserCell: UICollectionViewCell {
    
    
    weak var photoBrowserCellDelegate: PhotoBrowserCellDelegate?
    
    var imageURL: NSURL?
        {
        didSet{
             resetPosition()
            iconView.sd_setImageWithURL(imageURL) { (image, _, _, _) -> Void in
             
             self.setImagePosition()
            }
            
            bgImageview.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "userGuide1"))
           
        }
    }
 
    /**
     重置图片的属性
     */
    private func resetPosition()
    {
      scrollview.contentInset = UIEdgeInsetsZero
        scrollview.contentOffset = CGPointZero
        scrollview.contentSize = CGSizeZero
        iconView.transform = CGAffineTransformIdentity
    
    }
    
    /**
     设置图片的位置
     */
    private func setImagePosition()
    {
        //拿到图片的尺寸
        let size = self.displaySize(iconView.image!)
        //判断是长图还是短图
        if size.height < UIScreen.mainScreen().bounds.height
        {
             //设置短图的尺寸
            iconView.frame = CGRect(origin: CGPointZero, size: size)
            //处理居中显示
            let y = (UIScreen.mainScreen().bounds.height - size.height) * 0.5
            scrollview.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
        
        }else
        {
            //是长图
                  iconView.frame = CGRect(origin: CGPointZero, size: size)
            scrollview.contentSize = size
        
        }
    
    
    }
    /**
     等比缩放图片

     */
    private func displaySize(image: UIImage) -> CGSize
    {
        // 1.拿到图片的宽高比
        let scale = image.size.height / image.size.width
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.width
        let height = width * scale
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    private func setupUI()
    {
        // 背景毛玻璃效果
        let blureffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let visualView = UIVisualEffectView(effect: blureffect)
        visualView.frame = UIScreen.mainScreen().bounds
        visualView.alpha = 1
    
        bgImageview.frame = UIScreen.mainScreen().bounds
        // 1.添加子控件
    
        contentView.addSubview(bgImageview)
        contentView.addSubview(visualView)
        scrollview.addSubview(iconView)
        contentView.addSubview(scrollview)    
        // 2.布局子控件
        scrollview.frame = UIScreen.mainScreen().bounds
        
        //处理缩放
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        
        //监听图片的点击
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.close))
        iconView.addGestureRecognizer(tap)
        iconView.userInteractionEnabled = true
        
    }
    
    func close()
    {
     photoBrowserCellDelegate?.PhotoBrowserCellDidSelected(self)
    
    }
  

    
    // MARK: - 懒加载
    private lazy var scrollview: UIScrollView = UIScrollView()
     lazy var iconView: UIImageView = UIImageView()
    
    private lazy var bgImageview: UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension PhotoBrowserCell: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        
        return iconView
        
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        var offsetx = (UIScreen.mainScreen().bounds.width - (view?.frame.width)!) * 0.5
        var offsety = (UIScreen.mainScreen().bounds.height - (view?.frame.height)!) * 0.5
        offsetx = offsetx < 0 ? 0 : offsetx
        offsety = offsety < 0 ? 0 : offsety
        scrollview.contentInset = UIEdgeInsetsMake(offsety, offsetx, offsety, offsetx)
    }
    
    
  
}