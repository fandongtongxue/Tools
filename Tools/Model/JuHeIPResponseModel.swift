//
//  JuHeIPResponseModel.swift
//  Tools
//
//  Created by Mac on 2021/4/23.
//

import UIKit

class JuHeIPResponseModel: BaseModel {
    var error_code: Int = 0
    var reason = ""
    var result: JuHeIPResponseModelResult?
    var resultcode = ""

}

class JuHeIPResponseModelResult: BaseModel {
    var City = ""
    var Country = ""
    var Isp = ""
    var Province = ""

}

