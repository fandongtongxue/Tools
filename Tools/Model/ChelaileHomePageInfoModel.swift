//
//  Ch.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit

class ChelaileHomePageInfoModel: BaseModel {
    var jsonr = ChelaileHomePageInfoModelJsonr()

    
}

class ChelaileHomePageInfoModelJsonr: BaseModel {
    var data = ChelaileHomePageInfoModelData()
    var status = ""

    
}

class ChelaileHomePageInfoModelData: BaseModel {
    var lines = [ChelaileHomePageInfoModelLines]()
    var maxInterval: Int = 0
    var nearSts = [ChelaileHomePageInfoModelNearSts]()
    var tag = ""
    var toast = ""

    
}

class ChelaileHomePageInfoModelLines: BaseModel {
    var depIntervalM: Int = 0
    var fav: Int = 0
    var firstIsLast: Int = 0
    var h5NewStyle: Int = 0
    var intervalLeft: Int = 0
    var intervalRight: Int = 0
    var line = ChelaileHomePageInfoModelLine()
    var nextStn = ChelaileHomePageInfoModelNextStn()
    var preTimeDataType: Int = 0
    var stnState = ChelaileHomePageInfoModelStnState()
    var targetStation = ChelaileHomePageInfoModelTargetStation()
    var top: Bool = false

    
}

class ChelaileHomePageInfoModelTargetStation: BaseModel {
    var couponFlag: Int = 0
    var distanceToSp: Int = 0
    var lat: Int = 0
    var lng: Int = 0
    var order: Int = 0
    var sId = ""
    var sn = ""

    
}

class ChelaileHomePageInfoModelStnState: BaseModel {
    var arrivalTime: Int = 0
    var busId = ""
    var distanceToDest: Int = 0
    var licence = ""
    var order: Int = 0
    var pRate: Int = 0
    var rType: Int = 0
    var state: Int = 0
    var travelTime: Int = 0
    var value: Int = 0

    
}

class ChelaileHomePageInfoModelLine: BaseModel {
    var assistDesc = ""
    var desc = ""
    var direction: Int = 0
    var endSn = ""
    var h5NewStyle: Int = 0
    var isSubway: Int = 0
    var lineId = ""
    var lineNo = ""
    var name = ""
    var realCityId = ""
    var shortDesc = ""
    var sortPolicy = ""
    var state: Int = 0
    var temOperation: Bool = false
    var type: Int = 0

    
}

class ChelaileHomePageInfoModelNextStn: BaseModel {
    var couponFlag: Int = 0
    var distanceToSp: Int = 0
    var lat: Int = 0
    var lng: Int = 0
    var order: Int = 0
    var sId = ""
    var sn = ""

    
}

class ChelaileHomePageInfoModelNearSts: BaseModel {
    var distance: Int = 0
    var hasBusInfo: Bool = false
    var isSubway: Int = 0
    var lineNameList = [String]()
    var lineNames = ""
    var namesakeStSize: Int = 0
    var sId = ""
    var sn = ""
    var sortPolicy = ""

    
}

