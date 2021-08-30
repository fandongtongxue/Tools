//
//  InkeResponseModel.swift
//
//
//  Created by JSONConverter on 2021/07/21.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

import Foundation
import HandyJSON

class InkeResponseModel: BaseModel {
	var data = [InkeResponseModelData]()
	var dm_error: Int = 0
	var error_msg = ""
	var has_more: Int = 0
	var offset: Int = 0

	
}

class InkeResponseModelData: BaseModel {
	var live_info = InkeResponseModelLive_info()
	var type = ""

	
}

class InkeResponseModelLive_info: BaseModel {
	var bg_image = ""
	var bg_image_type = ""
	var bg_image_v2 = ""
	var city = ""
	var cover = ""
	var creator = InkeResponseModelCreator()
	var default_bg_image = ""
	var distance = ""
	var end_time: Int = 0
	var extra = InkeResponseModelExtra()
	var extra_stream_addrs = [InkeResponseModelExtra_stream_addrs]()
	var gps_position = ""
	var group: Int = 0
	var id = ""
	var image = ""
	var label_tags = InkeResponseModelLabel_tags()
	var landscape: Int = 0
	var link: Int = 0
	var live_type = ""
	var live_type_subordinate: Int = 0
	var location = ""
	var mode: Int = 0
	var multi: Int = 0
	var name = ""
	var numbers = InkeResponseModelNumbers()
	var online_users: Int = 0
	var pub_stat: Int = 0
	var quality: Int = 0
	var real_number_text = ""
	var req_source: Int = 0
	var room = InkeResponseModelRoom()
	var room_id: Int = 0
	var rotate: Int = 0
	var share_addr = ""
	var sharpness = ""
	var slot: Int = 0
	var start_time: Int = 0
	var status: Int = 0
	var stream_addr = ""
	var stream_multi_addr = ""
	var sub_live_type = ""
	var token = ""
	var version: Int = 0

	
}

class InkeResponseModelNumbers: BaseModel {
	var liveid = ""
	var real: Int = 0

	
}

class InkeResponseModelExtra: BaseModel {
	var cover = ""

	
}

class InkeResponseModelLabel_tags: BaseModel {
	var posa = ""
	var posb = InkeResponseModelPosb()
	var posc = InkeResponseModelPosc()
	var posd = InkeResponseModelPosd()
	var pose = ""
	var posg = ""
	var posh = ""
	var posi = ""
	var posj = ""

	
}

class InkeResponseModelPosd: BaseModel {
	var end_color = ""
	var frame = ""
	var icon = ""
	var start_color = ""

	
}

class InkeResponseModelPosb: BaseModel {
	var text = ""

	
}

class InkeResponseModelPosc: BaseModel {
	var text = ""

	
}

class InkeResponseModelExtra_stream_addrs: BaseModel {
	var id = ""
	var link: Int = 0
	var multi: Int = 0
	var quality: Int = 0
	var sharpness = ""
	var stream_addr = ""

	
}

class InkeResponseModelCreator: BaseModel {
	var age: Int = 0
	var albums = [String]()
	var audio_desc = InkeResponseModelAudio_desc()
	var birth = ""
	var current_value = ""
	var description = ""
	var emotion = ""
	var extra_resource_id: Int = 0
	var gender: Int = 0
	var gmutex: Int = 0
	var height: Int = 0
	var hometown = ""
	var id: Int = 0
	var inke_verify: Int = 0
	var introduction_v2 = ""
	var last_audio_desc_stat: Int = 0
	var level: Int = 0
	var liverank = InkeResponseModelLiverank()
	var location = ""
	var next_diff = ""
	var nick = ""
	var portrait = ""
	var profession = ""
	var rank_veri: Int = 0
	var register_at: Int = 0
	var sex: Int = 0
	var short_id = ""
	var stat: Int = 0
	var third_platform = ""
	var unlock_privilege_count: Int = 0
	var unset_stat: Int = 0
	var veri_info = ""
	var verified: Int = 0
	var verified_prefix = ""
	var verified_reason = ""
	var verify_extra = ""
	var verify_list = [InkeResponseModelVerify_list]()
	var vip_info = InkeResponseModelVip_info()
	var want_type = ""
	var wechat_info = InkeResponseModelWechat_info()
	var weight: Int = 0

	
}

class InkeResponseModelVip_info: BaseModel {
	var copywriting = ""
	var end_date = ""
	var end_time = ""
	var is_display: Bool = false
	var is_vip: Bool = false
	var public_chat_vip_icon = ""
	var vip_icon = ""
	var vip_tab = ""

	
}

class InkeResponseModelWechat_info: BaseModel {
	var stat: Int = 0

	
}

class InkeResponseModelLiverank: BaseModel {
	var dis_score: Int = 0
	var is_gray: Int = 0
	var isLevel: Int = 0
	var level: Int = 0
	var level_maxed: Int = 0
	var old_res: Int = 0
	var pic = ""
	var privilege_total_count: Int = 0
	var privilege_unlock_count: Int = 0
	var rate: Float = 0.0
	var score: Int = 0
	var stage_match = ""
	var uid: Int = 0

	
}

class InkeResponseModelAudio_desc: BaseModel {
	var duration: Int = 0
	var url = ""

	
}

class InkeResponseModelVerify_list: BaseModel {
	var expire_at: Int = 0
	var expire_at_str = ""
	var extra_resource_id: Int = 0
	var id: Int = 0
	var is_selected: Bool = false
	var reason = ""
	var type = ""
	var verified_prefix = ""

	
}

class InkeResponseModelRoom: BaseModel {
	var annoncement = ""
	var cover = ""
	var cover_check = ""
	var cover_status: Int = 0
	var id: Int = 0
	var liveid = ""
	var name = ""
	var owner: Int = 0
	var playid: Int = 0
	var show_room_id: Int = 0
	var show_room_resource = ""
	var status: Int = 0
	var title = ""

	
}
