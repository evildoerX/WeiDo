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
let WDMessageStatusReplyWillOpen = "WDMessageStatusReplyWillOpen"

class WDMessageCell: UITableViewCell {
    
    

    @IBOutlet weak var content_view: UIView!
  
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var create_time: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
  
    
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var statusContentLabel: UILabel!

    
    /// 提到我的
    var Mention: WDMention?
        {
    
    
        didSet{
           nameLabel.text = Mention?.screen_name
            create_time.text = Mention?.created_at
            //显示表情
            contentLabel.attributedText = EmoticonPackage.emoticonString(Mention?.text ?? "")
          
       

            
            image_view.sd_setImageWithURL(NSURL(string: (Mention?.profile_image_url)!))
                setTap(#selector(WDMessageCell.mentionClick))
            
            //没有原文就隐藏
            if Mention?.statusText == nil
            {
              statusContentLabel.hidden = true
            }
            else{
            statusContentLabel.attributedText = EmoticonPackage.emoticonString(Mention?.statusText ?? "")
            statusContentLabel.numberOfLines = 0
            statusContentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
            }
        
            
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
    
    
    
 

    
    func mentionClick()
    {
        let info = [WDMessageReplyWillOpen:Mention!.id]
        NSNotificationCenter.defaultCenter().postNotificationName(WDMessageReplyWillOpen, object: self, userInfo: info)
        
        
        let statusinfo = [WDMessageStatusReplyWillOpen:Mention!.statusId]
    NSNotificationCenter.defaultCenter().postNotificationName(WDMessageStatusReplyWillOpen, object: self, userInfo: statusinfo)
        
    }
    
    
}
