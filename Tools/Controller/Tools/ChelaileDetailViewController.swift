//
//  ChelaileDetailViewController.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit

class ChelaileDetailViewController: BaseViewController {
    
    var station = ChelaileHomePageInfoModelNearSts()
    var cityId = ""
    
    var model = ChelaileStationDetailModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = station.sn
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        requestData()
    }
    

    @objc func requestData(){
//        https://api.chelaile.net.cn/bus/stop!stationDetail.action?&destSId=-1&gpsAccuracy=65.000000&lorder=1&stats_act=refresh&stationId=0538-1764&cityId=093&sign=&stats_referer=nearby&s=IOS&dpi=3&push_open=1&v=5.50.4
        FDNetwork.GET(url: "https://api.chelaile.net.cn/bus/stop!stationDetail.action", param: ["destSId":"-1","gpsAccuracy":"65.000000","lorder":"1","stats_act":"refresh","stationId":station.sId,"cityId":cityId,"sign":"","stats_referer":"nearby","s":"IOS","dpi":"3","push_open":"1","v":"5.50.4"]) { result in
            let resultDict = result as! [String: Any]
            self.model = ChelaileStationDetailModel.deserialize(from: resultDict) ?? ChelaileStationDetailModel()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        } failure: { error in
            self.view.makeToast(error)
            self.refreshControl.endRefreshing()
        }

    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChelaileLineListCell.classForCoder(), forCellReuseIdentifier: "ChelaileLineListCell")
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()

}

extension ChelaileDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.jsonr.data.lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChelaileLineListCell", for: indexPath) as! ChelaileLineListCell
        if model.jsonr.data.lines[indexPath.row].line.name.contains("路") {
            cell.nameLabel.text = model.jsonr.data.lines[indexPath.row].line.name
        }else{
            cell.nameLabel.text = model.jsonr.data.lines[indexPath.row].line.name + " 路"
        }
        cell.contentLabel.text = "开往 "+model.jsonr.data.lines[indexPath.row].line.endSn
        let stnState = model.jsonr.data.lines[indexPath.row].stnStates.first
        if stnState?.travelTime != -1 {
            if stnState?.travelTime ?? 0 > 0 {
                let currentTime = Int(Date().timeIntervalSince1970)
                let arrivalTime = (stnState?.arrivalTime ?? 0) / 1000
                let duration = arrivalTime - currentTime
                if stnState?.value != 0 {
                    cell.statusLabel.text = "\(stnState?.value ?? 0)"+"站 · "+"\( Int(duration) / 60)"+" 分钟"
                }else{
                    cell.statusLabel.text = "即将到站"
                }
            }else{
                cell.statusLabel.text = "即将到站"
            }
        }else{
            cell.statusLabel.text = model.jsonr.data.lines[indexPath.row].line.desc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
