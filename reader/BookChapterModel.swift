//
//  BookChapterModel.swift
//  reader
//
//  Created by JiuHua on 2019/10/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class BookChapterModel: NSObject {

    var id:Int!
    /**
     * 书名id
     */
    var bookId:Int!
    
    /**
     * 书卷id
     */
    var volumeId:Int!
    
    /**
     * 章节名称
     */
    var name:String!
    
    /**
     * 章节内容
     */
    var content:String!
    
    /**
     * 前一章节id
     */
    var previousId:Int!
    
    /**
     * 后一章节id
     */
    var nextId:Int!
    
    //序号
    var sortNo:Int!
    
    /// 内容高度
    var heightSize:CGFloat!
    
    /// 书名
    var bookName:String!
 
   
    
}
