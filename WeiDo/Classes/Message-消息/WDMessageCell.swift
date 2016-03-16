//
//  WDMessageCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

let WDMessageCellSelected = "WDMessageCellSelected"
let WDMessageReplyWillOpen = "WDMessageReplyWillOpen"

class WDMessageCell: UITableViewCell {
    
    

    @IBOutlet weak var content_view: UIView!
  
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var create_time: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
  
    
    @IBOutlet weak var image_view: UIImageView!
    
    /// 我收到的
    var toMe: WDToMe?{
        didSet{

            
            nameLabel.text = toMe!.screen_name
            create_time.text = toMe!.created_at
           //同时显示表情
            contentLabel.attributedText = EmoticonPackage.emoticonString(toMe!.text ?? "")
            
            image_view.sd_setImageWithURL(NSURL(string: (toMe?.profile_image_url)!))
            
            
            setTap("toMeClick")

        }
    
    }
    
    /// 提到我的
    var Mention: WDMention?
        {
    
    
        didSet{
           nameLabel.text = Mention?.screen_name
            create_time.text = Mention?.created_at
            //显示表情
            contentLabel.attributedText = EmoticonPackage.emoticonString(Mention?.text ?? "")
       
            image_view.sd_setImageWithURL(NSURL(string: (Mention?.profile_image_url)!))
      
            

            setTap("mentionClick")
            
        }
    }
    
    /// 我发出的
    var ByMe: WDByMe?
         {
        didSet{
            nameLabel.text = ByMe?.screen_name
            create_time.text = ByMe?.created_at
            //显示表情
            contentLabel.attributedText = EmoticonPackage.emoticonString(ByMe?.text ?? "")
     
            image_view.sd_setImageWithURL(NSURL(string: (ByMe?.profile_image_url)!))
          
            setTap("byMeClick")
     
        }
  
        
    }
    
    /**
     设置圆角和手势
     */
    func setTap(action:Selector)
   {
    /**
    *  设置图片为圆角
    */
    image_view.layer.masksToBounds = true
    image_view.layer.cornerRadius = (image_view.frame.width / 2)
    
    /// 添加手势
    content_view.userInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: action)
    content_view.addGestureRecognizer(tap)
    
    
    contentLabel.numberOfLines = 0          //设置无限换行
    
    
    contentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping  //自动折行
    
    }
    
    
    
    func byMeClick()
    {
        let info = [WDMessageCellSelected:ByMe!.id]
        NSNotificationCenter.defaultCenter().postNotificationName(WDMessageCellSelected, object: self, userInfo: info)
    
    }
    
    func toMeClick()
    {
        let info = [WDMessageReplyWillOpen:toMe!.id]
        NSNotificationCenter.defaultCenter().postNotificationName(WDMessageReplyWillOpen, object: self, userInfo: info)
    }
    
    func mentionClick()
    {
        let info = [WDMessageReplyWillOpen:Mention!.id]
        NSNotificationCenter.defaultCenter().postNotificationName(WDMessageReplyWillOpen, object: self, userInfo: info)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func toMeCell() -> WDMessageCell{
        return NSBundle.mainBundle().loadNibNamed("WDMessageCell", owner: nil, options: nil)[0] as! WDMessageCell
    }

    
}
