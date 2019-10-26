//
//  BookShelfViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/2.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

class BookShelfViewController: UIViewController {
    
    var collectionView : UICollectionView?
    
    var bookShelfModelList = [BookShelfModel]()
    
    var addBookShelfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollentionView()
        
        initAddBookShelfView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        getBookShelfData()
    }
    
    func initAddBookShelfView() {
        
        addBookShelfView = UIView.init()
        
        addBookShelfView.backgroundColor = .backgroundColor()
        
        self.view.addSubview(addBookShelfView)
        
        addBookShelfView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(view)
            make.width.mas_equalTo()((screenWidth - 40)/3)
            make.height.mas_equalTo()(185)
        }
        
        let iconAddButton = UIButton.init()

        iconAddButton.setImage(UIImage.init(named: "icon_add"), for: .normal)
        
        addBookShelfView.addSubview(iconAddButton)
        
        iconAddButton.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.center.mas_equalTo()(addBookShelfView)
            make.width.mas_equalTo()(30)
            make.height.mas_equalTo()(30)
        }
        
        iconAddButton.addTarget(self, action: #selector(doAddBookShelf), for: .touchUpInside)
        
        addBookShelfView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(doAddBookShelf))
        
        addBookShelfView.addGestureRecognizer(tap)
        
        if self.bookShelfModelList.count > 0{
            addBookShelfView.isHidden = true
        }else {
            addBookShelfView.isHidden = false
        }
        
    }
    
    /// 去书城添加书架
    @objc func doAddBookShelf(){
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    func initCollentionView() {
        self.view.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: (screenWidth - 40)/3, height: 185)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 5, right: 10)
        
        collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView!)
        collectionView?.mas_makeConstraints({ (make : MASConstraintMaker?) in
            make?.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(screenHeight)
            make?.bottom.mas_equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
        })
        
        //注册cell
        collectionView?.register(BookShelfCollectionViewCell.self, forCellWithReuseIdentifier: "BookShelfCollectionViewCell")
    }
    
    //请求数据
     func getBookShelfData() {
        let url = "cloud/api/book/shelf/list"
        let accountId = ReadUserDefaults.integer("ACCOUNT_ID")
        let deviceUniqueId = ReaderUtil.getDeviceUUID()
        let param:[String : Any] = ["accountId": accountId, "deviceUniqueId": deviceUniqueId]
        AlamofireHelper.shareInstance.postRequest(url: url, params: param, completion: {(result, error) in
            self.bookShelfModelList = []
            let json = JSON(result as Any)
            let indexList = json["data"].array
            let code = json["errorCode"].type == SwiftyJSON.Type.null ? 500 : json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            for index in indexList!{
                let bookShelf = BookShelfModel()
                bookShelf.accountId = index["accountId"].int!
                bookShelf.bookName = index["bookName"].string!
                bookShelf.bookId = index["bookId"].int!
                bookShelf.bookChapterId = index["bookChapterId"].int!
                bookShelf.deviceUniqueId = index["deviceUniqueId"].string!
                bookShelf.id = index["id"].int!
                bookShelf.coverUrl = index["coverUrl"].string!
                self.bookShelfModelList.append(bookShelf)
            }
            self.collectionView?.reloadData()
            
            if self.bookShelfModelList.count > 0 {
                self.addBookShelfView.isHidden = true
            }else {
                self.addBookShelfView.isHidden = false
            }
            
            
        })
    }

}
extension BookShelfViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookShelfModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookShelfCollectionViewCell", for: indexPath) as! BookShelfCollectionViewCell
        
        if self.bookShelfModelList.count > 0 {
            let bookShelfModel = self.bookShelfModelList[indexPath.row]
            cell.setCollectionView(bookShelfModel.coverUrl, bookName: bookShelfModel.bookName)
        }
        cell.layer.contentsScale = UIScreen.main.scale;
        cell.layer.shadowOpacity = 0.1;
        cell.layer.shadowRadius = 4.0;
        cell.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        cell.layer.shadowPath = UIBezierPath.init(rect: cell.bounds).cgPath
        //设置缓存
        cell.layer.shouldRasterize = true
        //设置抗锯齿边缘
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookShelf = self.bookShelfModelList[indexPath.row]
        let controller = ReadViewScrollController()
        controller.bookId = bookShelf.bookId
        controller.chapterId = bookShelf.bookChapterId
        self.navigationController?.pushViewController(controller, animated: false)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
