//
//  ChelaileStationDetailModel.swift
//  Tools
//
//  Created by Mac on 2021/8/17.
//

import UIKit

class ChelaileStationDetailModel: BaseModel {
    var jsonr = ChelaileStationDetailModelJsonr()

    
}

class ChelaileStationDetailModelJsonr: BaseModel {
    var data = ChelaileStationDetailModelData()
    var status = ""

    
}

class ChelaileStationDetailModelData: BaseModel {
    var distance: Int = 0
    var lines = [ChelaileStationDetailModelLines]()
    var sId = ""
    var sn = ""
    var sType: Int = 0
    var tag = ""

    
}

class ChelaileStationDetailModelLines: BaseModel {
    var depIntervalM: Int = 0
    var fav: Int = 0
    var firstIsLast: Int = 0
    var h5NewStyle: Int = 0
    var intervalLeft: Int = 0
    var intervalRight: Int = 0
    var line = ChelaileStationDetailModelLine()
    var nextStation = ChelaileStationDetailModelNextStation()
    var preTimeDataType: Int = 0
    var priority: Int = 0
    var stnStates = [ChelaileStationDetailModelStnStates]()
    var targetStation = ChelaileStationDetailModelTargetStation()
    var traffic: Int = 0

    
}

class ChelaileStationDetailModelLine: BaseModel {
    var assistDesc = ""
    var desc = ""
    var direction: Int = 0
    var endSn = ""
    var h5NewStyle: Int = 0
    var hasBusInfo: Bool = false
    var isSubway: Int = 0
    var lineId = ""
    var lineNo = ""
    var maxJoinOrder: Int = 0
    var name = ""
    var notNeedRealData: Bool = false
    var price = ""
    var priceExpansion = ""
    var realCityId = ""
    var shortDesc = ""
    var sortPolicy = ""
    var startSn = ""
    var state: Int = 0
    var stationsNum: Int = 0
    var stopDistances = [Int]()
    var temOperation: Bool = false
    var thirdDir: Int = 0
    var type: Int = 0
    var version = ""

    
}

class ChelaileStationDetailModelNextStation: BaseModel {
    var couponFlag: Int = 0
    var distanceToSp: Int = 0
    var lat: Int = 0
    var lng: Int = 0
    var order: Int = 0
    var sId = ""
    var sn = ""

    
}

class ChelaileStationDetailModelStnStates: BaseModel {
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

class ChelaileStationDetailModelTargetStation: BaseModel {
    var couponFlag: Int = 0
    var distanceToSp: Int = 0
    var lat: Int = 0
    var lng: Int = 0
    var order: Int = 0
    var sId = ""
    var sn = ""

    
}


