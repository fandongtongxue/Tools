//
//  ChelaileAddressModel.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit

class ChelaileAddressModel: BaseModel {
    var data = ChelaileAddressModelData()
    var status = ""

}

class ChelaileAddressModelData: BaseModel {
    var gpsRealtimeCity = ChelaileAddressModelGpsRealtimeCity()

}

class ChelaileAddressModelGpsRealtimeCity: BaseModel {
    var cityId = ""
    var cityName = ""
    var cityVersion: Int = 0
    var hot: Int = 0
    var pinyin = ""
    var supportSubway: Int = 0

}
