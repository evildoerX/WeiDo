//
//  WDPictureCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

let WDPictureShare = "WDPictureShare"
let WDPictureTextShare = "WDPictureTextShare"



class WDPictureCell: UITableViewCell {
    
  
    //头像
    @IBOutlet weak var profileImageView: UIImageView!
    //昵称
    @IBOutlet weak var nameLabel: UILabel!
    //时间
    @IBOutlet weak var createTimeLabel: UILabel!
    
    //顶
    @IBOutlet weak var dingButton: UIButton!
    //踩
    @IBOutlet weak var caiButton: UIButton!
    //分享
    @IBOutlet weak var shareButton: UIButton!
    //评论
    @IBOutlet weak var commentButton: UIButton!
    
    //文本内容
    @IBOutlet weak var text_Label: UILabel!
    //图片

    @IBOutlet weak var Image_view: UIImageView!
    //gif标记
    @IBOutlet weak var gifMark: UIImageView!
    
    
    var pictureTopic: WDTopic? {
        didSet {
            if let pictureToip = pictureTopic {
              text_Label.text = pictureToip.text
                
                text_Label.numberOfLines = 0
                
                nameLabel.text = pictureToip.name
                nameLabel.textColor = bgcolor
                profileImageView.sd_setImageWithURL(NSURL(string: pictureToip.profile_image))
                Image_view.sd_setImageWithURL(NSURL(string: pictureToip.cdn_img!))
                createTimeLabel.text = pictureToip.create_time
                createTimeLabel.textColor = bgcolor
                
                
                dingButton.setTitle(String(pictureToip.ding), forState: UIControlState.Normal)
                caiButton.setTitle(String(pictureToip.cai), forState: UIControlState.Normal)
                shareButton.setTitle(String(pictureToip.repost), forState: UIControlState.Normal)
                commentButton.setTitle(String(pictureToip.comment), forState: UIControlState.Normal)
               //当图片后缀为gif时显示
                
                gifMark.hidden = !pictureToip.cdn_img!.hasSuffix("gif")
               
                
                //添加手势
                Image_view.userInteractionEnabled = true
                let imageTap = UITapGestureRecognizer(target: self, action: #selector(WDPictureCell.imageClick))
                Image_view.addGestureRecognizer(imageTap)
                
                /**
                设置图为圆角
                */
                profileImageView.kay_addCorner(radius: profileImageView.frame.width / 2)


            }
        }
    }

    
  
    @IBAction func shareClick(sender: AnyObject) {
        
        let info = [WDPictureShare:pictureTopic!.cdn_img!,WDPictureTextShare:pictureTopic!.text]
        
        NSNotificationCenter.defaultCenter().postNotificationName(WDPictureShare, object: self, userInfo: info)

        
    }
    
 
    func imageClick()
    {
    
        let info = [WDPictureWillOpen:pictureTopic!.cdn_img!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDPictureWillOpen, object: self, userInfo: info)
        
      
    }
    
 
    
}
