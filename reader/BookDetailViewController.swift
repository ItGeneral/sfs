//
//  BookDetailViewController.swift
//  reader
//
//  Created by JiuHua on 2019/10/4.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import UIKit
import Masonry
import SwiftyJSON
import CLToast

class BookDetailViewController: UIViewController,UIGestureRecognizerDelegate {

    var bookDetail = BookInfoModel()
    //猜你喜欢的图书列表
    var youLikeBookList = [BookInfoModel]()
    
    var tableView: UITableView!
    //显示目录
    var contentLabel = UILabel.init()
    
    var scrollView:UIScrollView!
    var collectionView:UICollectionView!
    
    
    func setBookDetail(bookDetail: BookInfoModel){
        self.bookDetail = bookDetail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        self.view.backgroundColor = .backgroundColor()
        self.setNavigationBar()
        self.drawBookDetailView(navigationBarHeight: navigationBarHeight!)
        self.getBookDetail()
        self.getYouLikeBookData()
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backToPrevious))
        item.image = UIImage.init(named: "lefterbackicon_titlebar_24x24_")
        self.navigationItem.leftBarButtonItem = item
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: false)
    }

    
    @objc func gotoContentController(){
        let controller = BookContentViewController()
        controller.initChapterList(chapterCount: self.bookDetail.chapterCount, bookId: self.bookDetail.id)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func getBookDetail() {
        let url = "cloud/api/book/detail/" + String(self.bookDetail.id)
        AlamofireHelper.shareInstance.postRequest(url: url, params: [:], completion: {(result, error) in
            let json = JSON(result as Any)
            let bookDetail = JSON(json["data"])
            let code = json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            self.bookDetail.chapterCount = bookDetail["chapterCount"].int!
            self.bookDetail.lastChapterId = bookDetail["lastChapterId"].int!
            self.bookDetail.lastChapterName = bookDetail["lastChapterName"].string!
            self.contentLabel.text = "      共" + String(self.bookDetail.chapterCount) + "章"
        })
    }
   
    func drawBookDetailView(navigationBarHeight: CGFloat) {
        self.scrollView = UIScrollView.init()
        self.scrollView.isScrollEnabled = true
        self.view.addSubview(self.scrollView)
        self.scrollView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.bottom.mas_equalTo()(self.view.mas_safeAreaLayoutGuideBottom)
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(screenHeight)
        }
        
        let coverView = UIView.init()
        self.scrollView.addSubview(coverView)
        coverView.backgroundColor = .white
        coverView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(30)
            make?.height.mas_equalTo()(150)
            make?.width.mas_equalTo()(screenWidth)
        }
        let coverImageView = UIImageView.init()
        coverImageView.sd_setImage(with: URL(string: bookDetail.coverUrl), placeholderImage: UIImage(named: ""))
        coverView.addSubview(coverImageView)
        coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(20)
            make?.left.mas_equalTo()(20)
            make?.width.mas_equalTo()(90)
            make?.height.mas_equalTo()(120)
        }
        
        let nameLabel = UILabel.init()
        nameLabel.text = bookDetail.name
        coverView.addSubview(nameLabel)
        nameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        nameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.height.mas_equalTo()(30)
            make?.top.mas_equalTo()(20)
        }
        
        let authorLabel = UILabel.init()
        authorLabel.text = bookDetail.author
        authorLabel.textColor = .color51()
        coverView.addSubview(authorLabel)
        authorLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let typeLabel = UILabel.init()
        typeLabel.text = bookDetail.type
        typeLabel.textColor = .color51()
        coverView.addSubview(typeLabel)
        typeLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(authorLabel.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(nameLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let wordCountLable = UILabel.init()
        wordCountLable.text = "共" + String(format:"%.2f", CGFloat.init(integerLiteral: bookDetail.wordNumber)/10000) + "万字"
        wordCountLable.textColor = .color51()
        coverView.addSubview(wordCountLable)
        wordCountLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(coverImageView.mas_right)?.offset()(20)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        let stateLable = UILabel.init()
        stateLable.text = "已完结"
        stateLable.textColor = .color51()
        coverView.addSubview(stateLable)
        stateLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(wordCountLable.mas_right)?.offset()(30)
            make?.top.mas_equalTo()(authorLabel.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(30)
        }
        
        //详细介绍view
        let tagAndIntroduceView = UIView.init()
        tagAndIntroduceView.backgroundColor = .white
        
        let introduceTextView = UITextView.init()
        introduceTextView.text = bookDetail.introduce
        introduceTextView.autoresizingMask = .flexibleHeight
        introduceTextView.isEditable = false
        introduceTextView.isScrollEnabled = false
        introduceTextView.font = UIFont.italicSystemFont(ofSize: 18)
        introduceTextView.backgroundColor = .white
        tagAndIntroduceView.addSubview(introduceTextView)
        let constrainSize = CGSize.init(width: screenWidth, height: CGFloat(0))
        let size = introduceTextView.sizeThatFits(constrainSize)
        introduceTextView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(size.height)
            if size.width < screenWidth {
                make?.width.mas_equalTo()(screenWidth)
            }else {
                make?.width.mas_equalTo()(size.width)
            }
        }
        
        let tagView = UIView.init()
        tagView.backgroundColor = .white
        tagAndIntroduceView.addSubview(tagView)
        tagView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(introduceTextView.mas_bottom)?.offset()(0)
            make?.height.mas_equalTo()(50)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        let tags = bookDetail.tag.split(separator: ",")
        var lastLabel = UILabel.init()
        for i in 0...tags.count - 1 {
            if i > 3 {
                break
            }
            let tagLabel = UILabel.init()
            tagLabel.backgroundColor = .backgroundColor()
            tagLabel.text = String(tags[i])
            tagLabel.layer.cornerRadius = 15
            tagLabel.clipsToBounds = true
            tagLabel.textAlignment = .center
            tagView.addSubview(tagLabel)
            let textLength = tagLabel.text!.count * 30
            tagLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
                make?.top.mas_equalTo()(12)
                if i == 0 {
                    make?.left.mas_equalTo()(10)
                }else{
                    make?.left.mas_equalTo()(lastLabel.mas_right)?.offset()(10)
                }
                make?.width.mas_equalTo()(textLength)
                make?.height.mas_equalTo()(28)
            }
            lastLabel = tagLabel
        }
        
        self.scrollView.addSubview(tagAndIntroduceView)
        tagAndIntroduceView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(coverView.mas_bottom)?.offset()(10)
            make?.height.mas_equalTo()(constrainSize.height)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.scrollView.addSubview(lineView)
        lineView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.right.mas_equalTo()(-10)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.height.mas_equalTo()(1)
            make?.top.mas_equalTo()(lastLabel.mas_bottom)?.offset()(15)
        }
        
        
        //目录view显示
        let contentView = UIView.init()
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(gotoContentController))
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
        self.scrollView.addSubview(contentView)
        contentView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(50)
            make?.top.mas_equalTo()(lineView.mas_bottom)?.offset()(5)
            make?.width.mas_equalTo()(screenWidth)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(contentView.mas_height)
            make?.left.mas_equalTo()(10)
        }
        
        let iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: "setting_rightarrow")
        contentView.addSubview(iconImageView)
        iconImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.mas_equalTo()(-15)
            make?.center.mas_equalTo()(contentLabel)
            make?.width.mas_equalTo()(10)
            make?.height.mas_equalTo()(12)
        }
        
        let contentStateLable = UILabel.init()
        contentStateLable.text = "已完结"
        contentStateLable.font = UIFont.init(descriptor: .init(), size: 14)
        contentView.addSubview(contentStateLable)
        contentStateLable.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.mas_equalTo()(iconImageView.mas_left)?.offset()(60)
            make?.center.mas_equalTo()(contentLabel)
        }
        
        let bottomLine = UIView.init()
        bottomLine.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        self.scrollView.addSubview(bottomLine)
        bottomLine.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.left.mas_equalTo()(10)
            make?.right.mas_equalTo()(-10)
            make?.width.mas_equalTo()(screenWidth - 20)
            make?.height.mas_equalTo()(1)
            make?.top.mas_equalTo()(contentLabel.mas_bottom)?.offset()(0)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
        
        collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView.scrollsToTop = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.top.mas_equalTo()(bottomLine.mas_bottom)?.offset()(0)
            make?.width.mas_equalTo()(screenWidth)
            make?.height.mas_equalTo()(500)
        }
        self.collectionView?.register(BookMallCollectionCell.self, forCellWithReuseIdentifier: "BookMallCollectionCell")
        collectionView?.register(BookMallCollectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: self.collectionView.contentSize.height + bottomLine.frame.height + contentView.frame.height + tagAndIntroduceView.frame.height + size.height)
    }
    
}

extension BookDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.youLikeBookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookMallCollectionCell", for: indexPath) as! BookMallCollectionCell
        if self.youLikeBookList.count > 0 {
            let bookInfoModel = self.youLikeBookList[indexPath.row]
            cell.subviews.forEach { (subView: UIView) in
                subView.removeFromSuperview()
            }
            cell.backgroundColor = UIColor.white
            let coverImageView = UIImageView.init()
            coverImageView.sd_setImage(with: URL(string: bookInfoModel.coverUrl), placeholderImage: UIImage(named: ""))
            cell.addSubview(coverImageView)
            coverImageView.mas_makeConstraints { (make: MASConstraintMaker?) in
                make?.left.right().mas_equalTo()(0)
                make?.height.mas_equalTo()(150)
            }
            
            let bookNameLabel = UILabel.init()
            bookNameLabel.text = bookInfoModel.name
            bookNameLabel.textAlignment = .center
            bookNameLabel.numberOfLines = 0
            cell.addSubview(bookNameLabel)
            bookNameLabel.mas_makeConstraints { (make: MASConstraintMaker?) in
                make?.top.mas_equalTo()(coverImageView.mas_bottom)?.offset()(5)
                make?.centerX.mas_equalTo()(coverImageView)
                make?.width.mas_equalTo()((screenWidth - 40)/3)
                make?.height.mas_equalTo()(45)
            }
            bookNameLabel.sizeToFit()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 40)/3, height: 200)
    }
    
    ///设置collectionview 头和尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        //防止视图重叠，删除已有的所有子视图
        reusableView.subviews.forEach { (headerView:UIView) in
            headerView.removeFromSuperview()
        }
        if kind == UICollectionView.elementKindSectionHeader {
            self.setHeaderView(reusableView: reusableView, type: self.bookDetail.type)
        }
        return reusableView
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
    
    func getYouLikeBookData() {
        let url = "cloud/api/book/list"
        let param:[String:Any] = ["type": self.bookDetail.type, "pageNo": 1, "pageSize": 9]
        AlamofireHelper.shareInstance.postRequest(url: url, params:param, completion: {(result, error) in
            let json = JSON(result as Any)
            let data = JSON(json["data"])
            let code = json["errorCode"].int!
            if code != 200 {
                CLToast.cl_show(msg: "网络异常，请稍后重试")
                return
            }
            let list = data["list"].array
            for index in list!{
                let book = BookInfoModel()
                book.id = index["id"].int!
                book.name = index["name"].string!
                book.author = index["author"].string!
                book.coverUrl = index["coverUrl"].string!
                book.introduce = index["introduce"].string!
                book.type = index["type"].string!
                book.tag = index["tag"].string!
                book.wordNumber = index["wordNumber"].int!
                self.youLikeBookList.append(book)
            }
            self.collectionView?.reloadData()
        })
    }
}
