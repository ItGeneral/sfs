//
//  UserInfoModel.swift
//  reader
//
//  Created by JiuHua on 2019/10/30.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit

class UserInfoModel: NSObject, NSCoding {
    
    var accountName: String = ""
    
    var headUrl: String = ""
    
    var phone: String = ""
    
    var id: Int = 0
    
    //构造方法
    required init(id:Int=0, accountName:String="", headUrl:String = "", phone:String = "") {
        self.id = id
        self.accountName = accountName
        self.headUrl = headUrl
        self.phone = phone
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? Int ?? 0
        self.accountName = decoder.decodeObject(forKey: "accountName") as? String ?? ""
        self.headUrl = decoder.decodeObject(forKey: "headUrl") as? String ?? ""
        self.phone = decoder.decodeObject(forKey: "phone") as? String ?? ""
    }

    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey:"id")
        coder.encode(accountName, forKey:"accountName")
        coder.encode(headUrl, forKey:"headUrl")
        coder.encode(phone, forKey:"phone")
    }

}

struct UserCellModel{
    
    var cellName: String!
    
    var cellIcon: String!
    
    static func initUserCell(cellName:String, cellIcon:String) -> UserCellModel {
        
        var cell = UserCellModel()
        
        cell.cellName = cellName
        
        cell.cellIcon = cellIcon
        
        return cell
    }
    
}
