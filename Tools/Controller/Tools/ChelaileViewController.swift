//
//  ChelaileViewController.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit
import CoreLocation

class ChelaileViewController: BaseViewController {
    
    var addressModel = ChelaileAddressModel()
    var infoModel = ChelaileHomePageInfoModel()
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "车来了公交查询"
        locationManager.requestWhenInUseAuthorization()
        view.makeToastActivity(.center)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    

    func requestAddressData(){
//        https://web.chelaile.net.cn/cdatasource/citylist?type=gpsRealtimeCity&lat=36.184828&lng=117.089176&gpstype=wgs&s=h5&v=2.2.15&src=webapp_default&userId=
        FDNetwork.GET(url: "https://web.chelaile.net.cn/cdatasource/citylist", param: ["type":"gpsRealtimeCity","gpstype":"wgs","s":"h5","v":"2.2.15","src":"webapp_default","lat":"\(latitude)","lng":"\(longitude)"]) { result in
            let resultDict = result as! [String: Any]
            self.addressModel = ChelaileAddressModel.deserialize(from: resultDict) ?? ChelaileAddressModel()
            self.requestStationData()
        } failure: { error in
            self.view.makeToast(error)
            self.view.hideToastActivity()
        }

    }
    
    @objc func requestStationData(){
        //            https://api.chelaile.net.cn/bus/stop!homePageInfo.action?type=1&act=2&gpstype=wgs&gpsAccuracy=65.000000&cityId=<变量>&hist=&s=IOS&sign=&dpi=3&push_open=1&v=5.50.4&lat=￼&lng=￼
        FDNetwork.GET(url: "https://api.chelaile.net.cn/bus/stop!homePageInfo.action", param: ["type":"1","act":"2","gpstype":"wgs","gpsAccuracy":"65.000000","cityId":self.addressModel.data.gpsRealtimeCity.cityId,"s":"IOS","dpi":"3","push_open":"1","v":"5.50.4","lat":"\(latitude)","lng":"\(longitude)","sign":"","hist":""]) { response in
            let dict = response as! [String: Any]
            self.infoModel = ChelaileHomePageInfoModel.deserialize(from: dict) ?? ChelaileHomePageInfoModel()
            self.tableView.reloadData()
            self.view.hideToastActivity()
            self.refreshControl.endRefreshing()
        } failure: { error in
            self.view.makeToast(error)
            self.view.hideToastActivity()
            self.refreshControl.endRefreshing()
        }
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChelaileStationListCell.classForCoder(), forCellReuseIdentifier: "ChelaileStationListCell")
        tableView.register(ChelaileLineListCell.classForCoder(), forCellReuseIdentifier: "ChelaileLineListCell")
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(requestStationData), for: .valueChanged)
        return refreshControl
    }()

}

extension ChelaileViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return infoModel.jsonr.data.nearSts.count
        }
        return infoModel.jsonr.data.lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChelaileStationListCell", for: indexPath) as! ChelaileStationListCell
            cell.nameLabel.text = "站点 "+infoModel.jsonr.data.nearSts[indexPath.row].sn
            cell.contentLabel.text = infoModel.jsonr.data.nearSts[indexPath.row].lineNames
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChelaileLineListCell", for: indexPath) as! ChelaileLineListCell
        if infoModel.jsonr.data.lines[indexPath.row].line.name.contains("路") {
            cell.nameLabel.text = infoModel.jsonr.data.lines[indexPath.row].line.name
        }else{
            cell.nameLabel.text = infoModel.jsonr.data.lines[indexPath.row].line.name + " 路"
        }
        cell.contentLabel.text = "开往 "+infoModel.jsonr.data.lines[indexPath.row].line.endSn
        if infoModel.jsonr.data.lines[indexPath.row].stnState.travelTime != -1 {
            if infoModel.jsonr.data.lines[indexPath.row].stnState.travelTime > 0 {
                let currentTime = Int(Date().timeIntervalSince1970)
                let arrivalTime = infoModel.jsonr.data.lines[indexPath.row].stnState.arrivalTime / 1000
                let duration = arrivalTime - currentTime
                cell.statusLabel.text = "\(infoModel.jsonr.data.lines[indexPath.row].stnState.value)"+"站 · "+"\( Int(duration) / 60)"+" 分钟"
            }else{
                cell.statusLabel.text = "即将到站"
            }
        }else{
            cell.statusLabel.text = infoModel.jsonr.data.lines[indexPath.row].line.desc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let detailVC = ChelaileDetailViewController()
            detailVC.station = infoModel.jsonr.data.nearSts[indexPath.row]
            detailVC.cityId = addressModel.data.gpsRealtimeCity.cityId
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ChelaileViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways  {
            locationManager.requestLocation()
        }else{
            view.makeToast("请到设置里打开快捷工具的定位权限")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        view.makeToast(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        latitude = location?.coordinate.latitude ?? 0.0
        longitude = location?.coordinate.longitude ?? 0.0
        requestAddressData()
    }
}
