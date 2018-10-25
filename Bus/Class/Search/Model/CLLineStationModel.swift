//
//  CLLineStationModel.swift
//  Bus
//
//  Created by cleven on 2018/10/19.
//  Copyright © 2018年 cleven. All rights reserved.
//

import UIKit
import HandyJSON

struct CLLineStationModel: HandyJSON {
    
    /// 正方向
    var forwardStops:[CLLineStation]?
    /// 反方向
    var reverseStops:[CLLineStation]?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &forwardStops, name: "stops")
        mapper.specify(property: &reverseStops, name: "stops")
    }
}

struct CLLineStation: HandyJSON {
    var isFirst:Bool = false
    var isLast:Bool = false
    var index:Int = 0
    var id:String?
    var zdmc:String?
}
