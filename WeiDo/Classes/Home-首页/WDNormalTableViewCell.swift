//
//  WDNormalTableViewCell.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/10.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class WDNormalTableViewCell: WDStatusTableViewCell {

    override func setupUI() {
        super.setupUI()
  
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons =  pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        
    }
}
