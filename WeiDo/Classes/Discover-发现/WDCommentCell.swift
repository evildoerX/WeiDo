//
//  WDCommentCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/7.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDCommentCell: UITableViewCell {
    
    @IBOutlet weak var image_view: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var create_timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var comment:WDLatestComments?
        {
        didSet{
            
            image_view.sd_setImageWithURL(NSURL(string: (comment?.profile_image)!), placeholderImage: UIImage(named: "greenAvatar_default"))
            nameLabel.text = comment?.username
            create_timeLabel.text = comment?.ctime
            contentLabel.text = comment?.content
            contentLabel.numberOfLines = 0          //设置无限换行
            contentLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping  //自动折行
            likeCountLabel.text = String(comment!.like_count)
        
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
    class func commentCell() -> WDCommentCell{
        return NSBundle.mainBundle().loadNibNamed("WDCommentCell", owner: nil, options: nil)[0] as! WDCommentCell
    }
    
}
