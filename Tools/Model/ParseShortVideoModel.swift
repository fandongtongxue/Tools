//
//  ParseShortVideoModel.swift
//  Tools
//
//  Created by Mac on 2021/4/16.
//

import UIKit

class ParseShortVideoModel: BaseModel {
    var code: Int = 0
    var data: ParseShortVideoModelData?
    var msg: String?

}

class ParseShortVideoModelData: BaseModel {
    var author: String?
    var avatar: String?
    var cover: String?
    var like: Int = 0
    var music: ParseShortVideoModelMusic?
    var time: Int = 0
    var title: String?
    var uid: String?
    var url: String?

}

class ParseShortVideoModelMusic: BaseModel {
    var author: String?
    var avatar: String?
    var url: String?

}

