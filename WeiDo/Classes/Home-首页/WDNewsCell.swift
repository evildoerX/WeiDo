//
//  WDNewsCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/11.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage




class WDNewsCell: UITableViewCell {
    

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createtimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var newsImageView: UIImageView!
    
    var sportnew:WDNews?
        {
        didSet{

        setData(sportnew)
            //添加图片点击
        addTap("sportnewClick")
        }
    
    }
    
    
    var amusementnew:WDNews?
        {
        didSet{
            
           setData(amusementnew)
            
            //添加图片点击
           addTap("amusementClick")
        }
    }
    
    var technologynew:WDNews?
        {
        didSet{
            
            setData(technologynew)
            //添加图片点击
            addTap("technologynewClick")
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     加载数据
     */
    func setData(new:WDNews?)
    {
        newsImageView.sd_setImageWithURL(NSURL(string: (new?.picUrl)!))
        titleLabel?.text = new?.newsDescription
        descriptionLabel.text = new?.title
        createtimeLabel.text = new?.ctime
    }
    
    /**
     添加图片点击
     */
    func addTap(action: Selector)
    {
        newsImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: action)
        newsImageView.addGestureRecognizer(tap)
    }
    
    
    func sportnewClick()
    {
        let str = sportnew?.url
        let info = [WDSportNewsWillOpen:str!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDSportNewsWillOpen, object: self, userInfo: info)
    }
    
    
    func amusementClick()
    {
        let str = amusementnew?.url
        let info = [WDAmusementNewsWillOpen:str!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDAmusementNewsWillOpen, object: self, userInfo: info)

    
    }
    
    func technologynewClick()
    {
        let str = technologynew?.url
        let info = [WDTechnologyNewsWillOpen:str!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDTechnologyNewsWillOpen, object: self, userInfo: info)
        

    
    }
    
    class func newsCell() -> WDNewsCell{
        return NSBundle.mainBundle().loadNibNamed("WDNewsCell", owner: nil, options: nil)[0] as! WDNewsCell
    }
    
    
}
