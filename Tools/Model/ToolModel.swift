//
//  ToolModel.swift
//  Tools
//
//  Created by Mac on 2021/4/13.
//

import UIKit

public let MyToolSaveKey = "MyToolSaveKey"

public let iCloudSwitchKey = "iCloudSwitchKey"

class ToolModel: BaseModel {
    var id = 0
    var name = ""
    var backgroundColorHex = ""
    var desc_md = ""
    var desc_en_md = ""
    var icon = ""
    var name_en = ""
    var selected = false
}
