//
//  ViewController.swift
//  InkeLive
//
//  Created by Mac on 2021/7/28.
//

import UIKit
import SnapKit
import HandyJSON

class InkeViewController: BaseViewController {
    
    var model = InkeResponseModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "映客直播"
        // Do any additional setup after loading the view.
        requestData()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func requestData(){
        FDNetwork.GET(url: "http://service.inke.com/api/live/near_recommend?latitude=36.132389&longitude=117.116180&uid=313054160", param: nil) { result in
            let resultDict = result as! [String: Any]
            self.model = InkeResponseModel.deserialize(from: resultDict) ?? InkeResponseModel()
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        } failure: { error in
            debugPrint(error)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LiveItemCell.classForCoder(), forCellWithReuseIdentifier: "LiveItemCell")
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()


}

extension InkeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveItemCell", for: indexPath) as! LiveItemCell
        if indexPath.item < model.data.count {
            cell.model = model.data[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((FD_ScreenWidth - 15 ) / 2)
        return CGSize(width:width , height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = model.data[indexPath.item]
        let playerVC = InkePlayerViewController()
        playerVC.data = data
        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true, completion: nil)
    }
}

