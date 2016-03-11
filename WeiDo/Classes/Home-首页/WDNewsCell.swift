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
            
            newsImageView.sd_setImageWithURL(NSURL(string: (sportnew?.picUrl)!))
            titleLabel?.text = sportnew?.newsDescription
            descriptionLabel.text = sportnew?.title
            createtimeLabel.text = sportnew?.ctime
           
            //添加图片点击
            newsImageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "sportnewClick")
           newsImageView.addGestureRecognizer(tap)
        }
    
    }
    
    
    var amusementnew:WDNews?
        {
        didSet{
            
            newsImageView.sd_setImageWithURL(NSURL(string: (amusementnew?.picUrl)!))
            titleLabel?.text = amusementnew?.newsDescription
            descriptionLabel.text = amusementnew?.title
            createtimeLabel.text = amusementnew?.ctime
            
            //添加图片点击
            newsImageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "amusementClick")
            newsImageView.addGestureRecognizer(tap)
        }
    }
    
    var technologynew:WDNews?
        {
        didSet{
            
            newsImageView.sd_setImageWithURL(NSURL(string: (technologynew?.picUrl)!))
            titleLabel?.text = technologynew?.newsDescription
            descriptionLabel.text = technologynew?.title
            createtimeLabel.text = technologynew?.ctime
            
            //添加图片点击
            newsImageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "technologynewClick")
            newsImageView.addGestureRecognizer(tap)
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
