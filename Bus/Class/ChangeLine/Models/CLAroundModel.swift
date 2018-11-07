//
//  CLAroundModel.swift
//  Bus
//
//  Created by cleven on 2018/11/7.
//  Copyright © 2018 cleven. All rights reserved.
//

import UIKit
import HandyJSON

struct CLAroundModel: HandyJSON {

    var status:String?
    var count:String?
    var infocode:String?
    var pois:[CLAroundPoisModel]?
}

struct CLAroundPoisModel: HandyJSON {
    var id:String? //"B00156EVR7",
    var name:String? //"五角场",
    var type:String? //"地名地址信息;热点地名;热点地名",
    var typecode:String? //"190700",
    var address:String? //"杨浦区",
    var location:String? //"121.514158,31.299059",
    var pname:String? //"上海市",
    var cityname:String? //"上海市"
    var adname:String? //"杨浦区",
    
}
