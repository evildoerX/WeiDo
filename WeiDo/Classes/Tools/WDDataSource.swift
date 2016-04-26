//
//  WDDataSource.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/4/26.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


typealias tableViewCellConfigure = (cell:AnyObject, item:AnyObject)-> ()

class WDDataSource: NSObject, UITableViewDataSource {

    var items = [AnyObject]()
    var cellIdentifer:String?
    
    var cellConfigure: tableViewCellConfigure?
    
    
    
    init(items:[AnyObject],cellIdentifier:String,cellConfigure:tableViewCellConfigure) {
        
        self.items = items
        self.cellIdentifer = cellIdentifier
        self.cellConfigure = cellConfigure
        
        super.init()
    }
    
    
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func itemsAtIndexPath(indexPath:NSIndexPath) -> AnyObject
    {
        return items[indexPath.row]
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer!, forIndexPath: indexPath)
        let item = itemsAtIndexPath(indexPath)
        self.cellConfigure!(cell: cell,item: item)
        return cell
    }
    
}
