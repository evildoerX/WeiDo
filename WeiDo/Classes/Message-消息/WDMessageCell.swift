//
//  WDMessageCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import SDWebImage

class WDMessageCell: UITableViewCell {
    
    

    
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
            contentLabel.numberOfLines = 0          //设置无限换行
            
            
            contentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping  //自动折行
            
            image_view.sd_setImageWithURL(NSURL(string: (toMe?.profile_image_url)!))
        
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
            contentLabel.numberOfLines = 0          //设置无限换行
            
            contentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping  //自动折行
            

     
       
            image_view.sd_setImageWithURL(NSURL(string: (Mention?.profile_image_url)!))
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
            contentLabel.numberOfLines = 0          //设置无限换行
            
            contentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping  //自动折行
            image_view.sd_setImageWithURL(NSURL(string: (ByMe?.profile_image_url)!))
     
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
    
    class func toMeCell() -> WDMessageCell{
        return NSBundle.mainBundle().loadNibNamed("WDMessageCell", owner: nil, options: nil)[0] as! WDMessageCell
    }

    
}
