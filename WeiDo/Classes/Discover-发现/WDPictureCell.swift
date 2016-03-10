//
//  WDPictureCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage
/// 选中图片的通知名称
let CellPictureViewSelected = "CellPictureViewSelected"
/// 选中图片的索引对应的key名称
let CellPictureViewIndexKey = "CellPictureViewIndexKey"

/// 选中图片的路径对应的key的名称
let CellPictureViewURLsKey = "CellPictureViewURLsKey"
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
                text_Label.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: "commentClick")
                text_Label.addGestureRecognizer(tap)

            }
        }
    }

    
  
    
    func commentClick()
        
    {
        
        let info = [WDCommentWillOpen:pictureTopic!]
        NSNotificationCenter.defaultCenter().postNotificationName(WDCommentWillOpen, object: self, userInfo: info)
        
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor(white: 0.9, alpha: 0.5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class func pictureCell() -> WDPictureCell{
        return NSBundle.mainBundle().loadNibNamed("WDPictureCell", owner: nil, options: nil)[0] as! WDPictureCell
    }
    
    
}
