//
//  WMWordYoipCell.swift
//  BaiSi
//
//  Created by 王蒙 on 15/8/1.
//  Copyright © 2015年 wm. All rights reserved.
//

import UIKit
import SDWebImage

let WDCommentWillOpen = "WDCommentWillOpen"
class WMWordToipCell: UITableViewCell {

      /** 头像 */
    @IBOutlet weak var profileImageView: UIImageView!
    /** 昵称 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 时间 */
    @IBOutlet weak var createTimeLabel: UILabel!
    /** 顶 */
    @IBOutlet weak var dingButton: UIButton!
    /** 踩 */
    @IBOutlet weak var caiButton: UIButton!
    /** 分享 */
    @IBOutlet weak var shareButton: UIButton!
    /** 评论 */
    @IBOutlet weak var commentButton: UIButton!
    /**文本内容*/    
    @IBOutlet weak var text_Label: UILabel!
   
    var wordTopic: WDTopic? {
        didSet {
            if let wordToip = wordTopic {
               text_Label.text = wordToip.text
               text_Label.numberOfLines = 0
            
                nameLabel.text = wordToip.name
                nameLabel.textColor = bgcolor
                profileImageView.sd_setImageWithURL(NSURL(string: wordToip.profile_image))
                createTimeLabel.text = wordToip.create_time
                createTimeLabel.textColor = bgcolor
           
                dingButton.setTitle(String(wordToip.ding), forState: UIControlState.Normal)
                caiButton.setTitle(String(wordToip.cai), forState: UIControlState.Normal)
                shareButton.setTitle(String(wordToip.repost), forState: UIControlState.Normal)
                commentButton.setTitle(String(wordToip.comment), forState: UIControlState.Normal)
                /**
                设置图为圆角
                */
                profileImageView.layer.masksToBounds = true
                profileImageView.layer.cornerRadius = (profileImageView.frame.width / 2)

           
                 //添加手势
                text_Label.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: "commentClick")
                text_Label.addGestureRecognizer(tap)
            }
        }
    }
 
    
    
    func commentClick()
    
    {
     
        let info = [WDCommentWillOpen:wordTopic!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDCommentWillOpen, object: self, userInfo: info)
    
    }
    
    
 
    
    

    
}
