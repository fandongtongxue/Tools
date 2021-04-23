//
//  JuHePhoneResponseModel.swift
//  Tools
//
//  Created by Mac on 2021/4/23.
//

import UIKit

class JuHePhoneResponseModel: BaseModel {
    var error_code: Int = 0
    var reason = ""
    var result: JuHePhoneResponseModelResult?
    var resultcode = ""

}

class JuHePhoneResponseModelResult: BaseModel {
    var areacode = ""
    var card = ""
    var city = ""
    var company = ""
    var province = ""
    var zip = ""

}
