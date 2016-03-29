//
//  PhotoBrowserViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SVProgressHUD


private let photoBrowserCellReuseIdentifier = "pictureCell"

class PhotoBrowserViewController: UIViewController {

    
    var currentIndex: Int?
    var pictureURLs: [NSURL]?
    
    
    init(index: Int, urls: [NSURL])
    {
        // Swift语法规定, 必须先初始化本类属性, 再初始化父类
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 初始化UI
        setupUI()
    }
    
    private func setupUI(){
        
   
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        view.addSubview(indexLabel)
        
        // 2.布局子控件
        closeBtn.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 10, y: -10))
        saveBtn.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 30), offset: CGPoint(x: -10, y: -10))
        indexLabel.xmg_AlignVertical(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 30), offset: CGPoint(x: 0, y: -270))
        
        collectionView.frame = UIScreen.mainScreen().bounds
        
        // 3.设置数据源
        collectionView.dataSource = self
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
        indexLabel.text = String("\(currentIndex! + 1)/\(pictureURLs!.count)")
        
        //设置手势
        collectionView.userInteractionEnabled = true
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(PhotoBrowserViewController.cellClick))
        tap.direction = UISwipeGestureRecognizerDirection.Down
        collectionView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func close()
    {
     
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
     保存图片功能
     */
    func save()
    {
        // 1.拿到当前正在显示的cell
        let index = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(index) as! PhotoBrowserCell
       
        
        // 2.保存图片
        let image = cell.iconView.image
        
    UIImageWriteToSavedPhotosAlbum(image! ,self,#selector(PhotoBrowserViewController.image(_:didFinishSavingWithError:contextInfo:)),nil)
   
      
        
    }
    
    
  //  func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject)
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject){
        
        if didFinishSavingWithError != nil
        {
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
            print(didFinishSavingWithError)
        }else
        {
            SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
            
        }
    }

    
    // MARK: - 懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action: #selector(PhotoBrowserViewController.close), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.backgroundColor = UIColor.clearColor()
        
        btn.addTarget(self, action: #selector(PhotoBrowserViewController.save), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var indexLabel: UILabel =
    {
        let indexLabel = UILabel()
        indexLabel.textColor = UIColor.whiteColor()
        indexLabel.textAlignment = NSTextAlignment.Center
        return indexLabel
    }()
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserLayout())
}



extension PhotoBrowserViewController :UICollectionViewDataSource, PhotoBrowserCellDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoBrowserCellReuseIdentifier, forIndexPath: indexPath) as! PhotoBrowserCell
  
        cell.imageURL = pictureURLs![currentIndex!]
        cell.photoBrowserCellDelegate = self
       
     
       
        return cell
    }
    
    
    
    
    func PhotoBrowserCellDidSelected(cell: PhotoBrowserCell) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func cellClick()
    {
     dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class PhotoBrowserLayout : UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.scrollEnabled = false
        collectionView?.bounces =  false

  
    }
}

