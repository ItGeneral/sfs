//
//  BookMallViewController.swift
//  reader 书城controller
//
//  Created by JiuHua on 2019/10/1.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

struct BookInfoData {
    var type:String
    var bookInfoList:[BookInfoModel]
}

struct TypeIconMap {
    var type:String
    var icon:String
}

class BookMallViewController: UIViewController {
    
    var collectionView : UICollectionView?
    
    var searchView: UIView!
    
    //图书列表
    var bookList = [BookInfoData]()
    
    var typeLabelList = [TypeIconMap]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundColor()
        self.navigationController?.navigationBar.isHidden = true
        
        //初始化第一个section
        self.typeLabelList.append(TypeIconMap.init(type: "现代都市", icon: "modern_book_icon"))
        self.typeLabelList.append(TypeIconMap.init(type: "玄幻仙侠", icon: "fantasy_book_icon"))
        self.typeLabelList.append(TypeIconMap.init(type: "悬疑灵异", icon: "mysterious_book_icon"))
        self.typeLabelList.append(TypeIconMap.init(type: "历史军事", icon: "history_book_icon"))
        var sectionOneList = [BookInfoModel]()
        self.typeLabelList.forEach { (map: TypeIconMap) in
            let model = BookInfoModel()
            model.type = map.type
            model.coverUrl = map.icon
            sectionOneList.append(model)
        }
        bookList.append(BookInfoData(type: "", bookInfoList: sectionOneList))
        
        getBookData()
        
        initSearchView()
        
        setCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /// 初始化searchbar
    func initSearchView(){
        let searchBar : UISearchBar = UISearchBar.init()
        
        searchBar.placeholder = "搜索书城"
        
        searchBar.backgroundImage = UIImage.init()
        
        searchBar.image(for: .search, state: .normal)
        
        searchBar.showsBookmarkButton = true
        
        searchBar.backgroundColor = .color166()
        
        searchView = UIView.init()
        
        searchView.backgroundColor = .white
        
        searchView.addSubview(searchBar)
        searchBar.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.left.mas_equalTo()(10)
            make.width.mas_equalTo()(screenWidth - 100)
            make.height.mas_equalTo()(50)
        }
        
        self.view.addSubview(searchView)
        
        searchView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.top.mas_equalTo()(self.view.mas_safeAreaLayoutGuideTop)
            make.width.mas_equalTo()(screenWidth)
            make.height.mas_equalTo()(50)
        }
        
    }
    
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)

        collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView!)
        collectionView?.mas_makeConstraints({ (make : MASConstraintMaker?) in
            make?.height.mas_equalTo()(screenHeight)
            make?.width.mas_equalTo()(screenWidth)
            make?.top.mas_equalTo()(searchView.mas_bottom)?.offset()(5)
            make?.bottom.equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
        })
        //注册cell
        collectionView?.register(BookMallCollectionCell.self, forCellWithReuseIdentifier: "BookMallCollectionCell")
        collectionView?.register(BookMallCollectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
    }
    
}
extension BookMallViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.bookList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookList[section].bookInfoList.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: (screenWidth - 50)/4, height: 110)
        }else{
            return CGSize(width: (screenWidth - 40)/3, height: 200)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookMallCollectionCell", for: indexPath) as! BookMallCollectionCell
        let bookInfoModel = self.bookList[indexPath.section].bookInfoList[indexPath.row]
        if indexPath.section == 0 {
            cell.setSectionOneView(type: bookInfoModel.type, icon: bookInfoModel.coverUrl)
        }else{
            cell.setCollectionView(bookInfoModel.coverUrl, bookName: bookInfoModel.name)
        }
        return cell
    }

    ///设置collectionview 头和尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        //防止视图重叠，删除已有的所有子视图
        reusableView.subviews.forEach { (headerView:UIView) in
            headerView.removeFromSuperview()
        }
        if indexPath.section == 0 {
            return reusableView
        }
        
        let type = self.bookList[indexPath.section].type
        if kind == UICollectionView.elementKindSectionHeader {
            self.setHeaderView(reusableView: reusableView, type: type)
        }
        return reusableView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWidth, height: 0)
        }
        return CGSize(width: screenWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let type = self.bookList[indexPath.section].bookInfoList[indexPath.row].type
            let controller = BookListViewController()
            controller.setBookType(bookType: type!)
            self.navigationController?.pushViewController(controller, animated: false)
        }else{
            let bookDetail = self.bookList[indexPath.section].bookInfoList[indexPath.row]
            let bookDetailController = BookDetailViewController()
            bookDetailController.setBookDetail(bookDetail: bookDetail)
            self.navigationController?.pushViewController(bookDetailController, animated: false)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getBookData() {
        let url = "cloud/api/book/mall"
        AlamofireHelper.shareInstance.postRequest(url: url, params: [:], completion: {(result, error) in
            let json = JSON(result as Any)
            let bookDictionary = json["data"].dictionary
            let code = json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
        
            for index in bookDictionary!{
                let dataList = index.value.array
                var typeBookList = [BookInfoModel]()
                for index in dataList!{
                    let book = BookInfoModel()
                    book.id = index["id"].int!
                    book.name = index["name"].string!
                    book.author = index["author"].string!
                    book.coverUrl = index["coverUrl"].string!
                    book.introduce = index["introduce"].string!
                    book.type = index["type"].string!
                    book.tag = index["tag"].string!
                    book.wordNumber = index["wordNumber"].int!
                    typeBookList.append(book)
                }
                let bookInfo = BookInfoData(type: index.key, bookInfoList: typeBookList)
                self.bookList.append(bookInfo)
            }
            self.collectionView?.reloadData()
        })
    }
    
    ///设置collectionView header view
    func setHeaderView(reusableView: UICollectionReusableView, type:String){
        let lineView = UIView.init()
        reusableView.addSubview(lineView)
        lineView.backgroundColor = .backgroundColor()
        lineView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.height.mas_equalTo()(10)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        let headerView = UIView.init()
        reusableView.addSubview(headerView)
        headerView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(45)
            make?.top.mas_equalTo()(5)
        }
        
        let typeNameLabel = UILabel.init()
        typeNameLabel.text = type
        typeNameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        headerView.addSubview(typeNameLabel)
        typeNameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.height.mas_equalTo()(headerView.mas_height)
            make?.top.mas_equalTo()(10)
        }
        
        let iconImageView = UIImageView.init(image: UIImage.init(named: "setting_rightarrow"))
        headerView.addSubview(iconImageView)
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.mas_equalTo()(-20)
            make?.height.mas_equalTo()(12)
            make?.width.mas_equalTo()(12)
            make?.top.mas_equalTo()(25)
        }
        
        let moreLable = UILabel.init()
        moreLable.text = "更多好书"
        moreLable.textColor = .color166()
        headerView.addSubview(moreLable)
        moreLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.mas_equalTo()(iconImageView.mas_left)?.offset()(-5)
            make?.height.mas_equalTo()(headerView.mas_height)
            make?.top.mas_equalTo()(10)
        }
        headerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.clickHeaderView(sender:)))
        tap.name = type
        headerView.addGestureRecognizer(tap)
    }
    
    
    @objc func clickHeaderView(sender: UIGestureRecognizer) {
        let controller = BookListViewController()
        controller.setBookType(bookType: sender.name!)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
}
