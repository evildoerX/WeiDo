//
//  SQLiteManager.swift
//  WeiDo
//
//  Created by 卢良潇 on 16/2/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {

    
    private static let manager: SQLiteManager = SQLiteManager()
    /// 单例
    class func shareManager() -> SQLiteManager {
        return manager
    }

 var dbqueue:FMDatabaseQueue?
 ///打开数据库
      func openDB(DBName:String)
      {
     //根据传入的数据库名字拼接数据库路径
     let path = DBName.docDir()
        print(path)
        //创建数据库对象
       dbqueue = FMDatabaseQueue(path: path)
        //打开数据库
      
        //创建表
        createTable()
}


   private func createTable()
   {
      // 1.编写SQL语句
    let sql =  "CREATE TABLE IF NOT EXISTS T_Status( \n" +
        "statusId INTEGER PRIMARY KEY, \n" +
        "statusText TEXT, \n" +
        "userId INTEGER \n" +
    "); \n"

    //建表 在sqlite中除了查询都是update
    dbqueue!.inDatabase { (db) -> Void in
        db.executeUpdate(sql, withArgumentsInArray: nil)
    }
    }
}