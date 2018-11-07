//
//  API+changeLine.swift
//  Bus
//
//  Created by cleven on 2018/11/1.
//  Copyright © 2018年 cleven. All rights reserved.
//

import Foundation

extension HYBNetworking {

    /// 获取换成线路
    class func getChangeLineData(start:String,end:String,success:@escaping success,failure:@escaping failure) {
        
        //"https://restapi.amap.com/v3/direction/transit/integrated?key=bf9efd0af01f4bcdf541ca210faea905&origin=121.514632,31.298043&destination=121.50072369540932,31.31926019825491&city=310000&extensions=base&strategy=0&nightflag=1"
        
        let url = "https://restapi.amap.com/v3/direction/transit/integrated?key=bf9efd0af01f4bcdf541ca210faea905&origin=\(start)&destination=\(end)&city=310000&extensions=base&strategy=0&nightflag=1"
        
        HYBNetworking.getWithUrl(url, refreshCache: false, success: { (response) in
            guard let response = response as? [String:Any] else {return}
            if (response["info"] as! String) != "OK" {
                failure(CLUtil.errorFormat(response["info"] as! String))
                return
            }
            guard let route = response["route"] as? [String:Any] else {failure(CLUtil.errorFormat("获取数据失败"));return}
            
            guard let transits = route["transits"] as? [[String:Any]] else {failure(CLUtil.errorFormat("获取数据失败"));return}
            
            var tempArray:[CLTransitsModel] = [CLTransitsModel]()
            for dict in transits {
                if let model = CLTransitsModel.deserialize(from: dict) {
                    tempArray.append(model)
                }
            }
            success(tempArray)
        }) { (error) in
            failure(CLUtil.errorFormat("获取数据失败"))
        }
        
    }
    
    /// 搜索附近公共场所
    class func searchAroundData(text:String, success:@escaping success,failure:@escaping failure) {
        let url = "https://restapi.amap.com/v3/place/text?key=bf9efd0af01f4bcdf541ca210faea905&keywords=\(text)&city=310000&citylimit=true"
        
        HYBNetworking.getWithUrl(url, refreshCache: false, params: nil, success: { (response) in
            guard let response = response as? [String:Any] else {return}
            if (response["info"] as! String) != "OK" {
                failure(["error":response["info"] as! String])
                return
            }
            if let model = CLAroundModel.deserialize(from: response) {
                success(model)
            }else{
                failure(CLUtil.errorFormat("转模型失败"))
            }
        }) { (error) in
            failure(CLUtil.errorFormat("搜索失败"))
        }
    }
}
