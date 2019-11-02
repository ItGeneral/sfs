//
//  ReadHistoryModel.swift
//  reader
//
//  Created by JiuHua on 2019/10/31.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class ReadHistoryModel: NSObject {
    
    /**
     * 书ID
     */
    var bookId:Int!
    
    /**
     * 章节id
     */
    var bookChapterId:Int!
    
    /**
     * 书名称
     */
    var bookName:String!
    
    /**
     * 书封面地址
     */
    var coverUrl:String!
    
    /**
     * 作者
     */
    var author:String!
    
    /**
     * 最近阅读时间
     */
    var updateTime:String!

}
