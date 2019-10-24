//
//  BookShelfModel.swift
//  reader
//
//  Created by JiuHua on 2019/10/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import Foundation
class BookShelfModel: NSObject {
 
    var bookName:String!
    
    var coverUrl:String!
    
    var id:Int!
    
    /**
     * 自定义唯一id
     */
    var accountId:Int!
    
    /**
     * 设备唯一ID
     */
    var deviceUniqueId:String!
    
    /**
     * 书ID
     */
    var bookId:Int!
    
    /**
     * 章节id
     */
    var bookChapterId:Int!
    
    
}
