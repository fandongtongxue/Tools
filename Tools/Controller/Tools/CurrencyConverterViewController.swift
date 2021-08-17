//
//  CurrencyConverterViewController.swift
//  Tools
//
//  Created by 范东 on 2021/8/11.
//

import UIKit

class CurrencyConverterViewController: BaseViewController {

    var model = CurrencyConverterModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "汇率换算"
        requestData()
    }
    

    func requestData(){
//        https://v6.exchangerate-api.com/v6/cf8304250ab3543002479bfd/latest/CNY
        FDNetwork.GET(url: "https://v6.exchangerate-api.com/v6/cf8304250ab3543002479bfd/latest/CNY", param: [:]) { result in
            let resultDict = result as! [String: Any]
            self.model = CurrencyConverterModel.deserialize(from: resultDict) ?? CurrencyConverterModel()
        } failure: { error in
            
        }

    }

}
