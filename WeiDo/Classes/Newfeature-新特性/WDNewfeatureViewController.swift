//
//  WDNewfeatureViewController.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/6.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
class WDNewfeatureViewController: UICollectionViewController {
    
    /// 页面个数
    private let  pageCount = 2
    /// 布局对象
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()

    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册一个cell
     
        collectionView?.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    
        
    }
    
    // MARK: - UICollectionViewDataSource
    // 1.返回一个有多少个cell
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    // 2.返回对应indexPath的cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
        
        // 2.设置cell的数据
       
        cell.imageIndex = indexPath.item
        
        // 3.返回cell
        return cell
    }
    
    // 完全显示一个cell之后调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
   
        
        // 1.拿到当前显示的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems().last!
        print(path)
        if path.item == (pageCount - 1)
        {
            // 2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            // 3.让cell执行按钮动画
            cell.startBtnAnimation()
        }
    }
}

class NewfeatureCell: UICollectionViewCell
{
    /// 保存图片的索引
   
    private var imageIndex:Int? {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    /**
     让按钮做动画
     */
    func startBtnAnimation()
    {
        startButton.hidden = false
        
        // 执行动画
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        
        // UIViewAnimationOptions(rawValue: 0) == OC knilOptions
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 清空形变
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customBtnClick()
    {
      NSNotificationCenter.defaultCenter().postNotificationName(WDSwitchRootViewControllerKey, object: true)
    }
    
    private func setupUI(){
        // 1.添加子控件到contentView上
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件的位置
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -100))
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.hidden = true
        btn.addTarget(self, action: "customBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
}

private class NewfeatureLayout: UICollectionViewFlowLayout {
    

    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}