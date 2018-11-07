//
//  LocationManager.swift
//  Wire-iOS
//
//  Created by cleven on 2018/6/23.
//  Copyright © 2018年 Zeta Project Germany GmbH. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    typealias locationCallBack = (_ curLocation:CLLocation?,_ curAddress:String?,_ errorReason:String?)->()
    
    //MARK:-属性
    
    ///单例,唯一调用方法
    static let shareManager:LocationManager =  LocationManager()
    
    
    private override init() {
        
    }
    
    var manager:CLLocationManager?
    
    //当前坐标
    var curLocation: CLLocation?
    //当前选中位置的坐标
    var curAddressCoordinate: CLLocationCoordinate2D?
    //当前位置地址
    var curAddress: String?
    // 国家
    var curCountry:String?
    /// 当前省份
    var curProvince: String?
    /// 当前城市
    var curCity: String?
    
    
    //回调闭包
    var  callBack:locationCallBack?
    
    func creatLocationManager() -> LocationManager{
        manager = CLLocationManager()
        //设置定位服务管理器代理
        manager?.delegate = self
        //设置定位模式
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        manager?.distanceFilter = 100
        //发送授权申请
        manager?.requestWhenInUseAuthorization()
        
        return self
    }
    
    //更新位置
    open func startLocation(resultBack:@escaping locationCallBack){
        
        self.callBack = resultBack
        
        if CLLocationManager.locationServicesEnabled(){
            //允许使用定位服务的话，开启定位服务更新
            manager?.startUpdatingLocation()
            print("定位开始")
        }
    }
    
}


extension LocationManager:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        curLocation = locations.last!
        //停止定位
        if locations.count > 0{
            manager.stopUpdatingLocation()
            LonLatToCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callBack!(nil,nil,"定位失败===\(error)")
    }
    
    ///经纬度逆编
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.curLocation!) { (placemark, error) -> Void in
            if(error == nil){
                let firstPlaceMark = placemark!.first
                self.curProvince = ""
                self.curCity = ""
                self.curAddress = ""
                self.curCountry = ""
                //国家
                if let country = firstPlaceMark?.country {
                    self.curCountry = country
                }
                //省
                if let administrativeArea = firstPlaceMark?.administrativeArea {
                    self.curAddress?.append(administrativeArea)
                    self.curProvince = administrativeArea
                }
                //自治区
                if let subAdministrativeArea = firstPlaceMark?.subAdministrativeArea {
                    self.curAddress?.append(subAdministrativeArea)
                }
                //市
                if let locality = firstPlaceMark?.locality {
                    self.curAddress?.append(locality)
                    self.curCity = locality
                }
                //区
                if let subLocality = firstPlaceMark?.subLocality {
                    self.curAddress?.append(subLocality)
                }
                //地名
                if let name = firstPlaceMark?.name {
                    self.curAddress?.append(name)
                }
                
                self.callBack!(self.curLocation,self.curAddress,nil)
                
            }else{
                self.callBack!(nil,nil,"\(String(describing: error))")
            }
        }
    }
    
    
    /// 地理编码
    public func geocoder(address:String?,callBack:@escaping (CLLocationCoordinate2D)->()) {
        guard let address = address else {return}
        let geocoder = CLGeocoder()
        //位置信息
        geocoder.geocodeAddressString(address, completionHandler: {(_ placemarks: [CLPlacemark]?, _ error: Error?) -> Void in
            if error != nil || placemarks?.count == 0 {
                return
            }
            //创建placemark对象
            let placemark = placemarks?.first
            //经度
            guard let longitude = placemark?.location?.coordinate.longitude else {return}
            //纬度
            guard let latitude = placemark?.location?.coordinate.latitude else {return}
            print("经度：\(longitude)，纬度：\(latitude)")
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            callBack(location)
        })
    }

    
}
