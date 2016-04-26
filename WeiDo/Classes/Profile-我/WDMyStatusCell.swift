//
//  WDMyStatusCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/3/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDMyStatusCell: UITableViewCell {
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var createtimeLabel: UILabel!
    
    @IBOutlet weak var commentCount: UILabel!

    @IBOutlet weak var contentImageView: UIImageView!
    
    
    var mineStatus:WDMineStatus?
        {
    
        didSet{

            //同时显示表情
            content.attributedText = EmoticonPackage.emoticonString(mineStatus!.text ?? "")
            createtimeLabel.text = mineStatus!.created_at
            commentCount.text = String(mineStatus!.comments_count)
            
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
    
    
    class func myStatusCell() -> WDMyStatusCell{
        return NSBundle.mainBundle().loadNibNamed("WDMyStatusCell", owner: nil, options: nil)[0] as! WDMyStatusCell
    }
    
}
