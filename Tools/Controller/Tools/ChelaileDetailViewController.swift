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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = station.sn
        requestData()
    }
    

    func requestData(){
//        https://api.chelaile.net.cn/bus/stop!stationDetail.action?&destSId=-1&gpsAccuracy=65.000000&lorder=1&stats_act=refresh&stationId=0538-1764&cityId=093&sign=&stats_referer=nearby&s=IOS&dpi=3&push_open=1&v=5.50.4
        FDNetwork.GET(url: "https://api.chelaile.net.cn/bus/stop!stationDetail.action", param: ["destSId":"-1","gpsAccuracy":"65.000000","lorder":"1","stats_act":"refresh","stationId":station.sId,"cityId":cityId,"sign":"","stats_referer":"nearby","s":"IOS","dpi":"3","push_open":"1","v":"5.50.4"]) { result in
            self.view.makeToast(result as? String)
        } failure: { error in
            self.view.makeToast(error)
        }

    }

}
