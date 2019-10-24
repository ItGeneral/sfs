//
//  BookInfoModel.swift
//  reader
//
//  Created by JiuHua on 2019/10/4.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class BookInfoModel: NSObject {

    var id:Int!
    
    var name:String!
    
    var type:String!
    
    var introduce:String!
    
    var wordNumber:Int!
    
    var coverUrl:String!
    
    var author:String!
    
    var tag:String!
    
    var latestRevisionTime:String!
    //章节总数
    var chapterCount:Int!
    
    var lastChapterName:String!
    
    var lastChapterId:Int!
    
}
