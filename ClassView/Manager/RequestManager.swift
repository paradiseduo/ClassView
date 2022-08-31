//
//  RequestManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

func SendPermissionReport(name: String, label: String, level: String, weight: String, stack: String, background: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var body = PermissionCheck(name: name, label: label, level: level, weight: weight, stack: stack)
    body["calldate"] = dateFormatter.string(from: Date())
    body["udid"] = AppDataManager.shared.udid
    body["background"] = background
    
    print(body)
}

func SendRequestReport(url: String, header: String, method: String, body: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var body = RequestCheck(url: url, header: header, method: method, body: body)
    body["calldate"] = dateFormatter.string(from: Date())
    body["udid"] = AppDataManager.shared.udid
    body["version"] = AppDataManager.shared.version
    body["app"] = AppDataManager.shared.appName
    body["build"] = AppDataManager.shared.build
    print(body)
}

func SendDeviceInfo() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let body = [
        "device_name": AppDataManager.shared.name,
        "platform": "ios",
        "udid": AppDataManager.shared.udid,
        "device_id": AppDataManager.shared.deviceid,
        "version": AppDataManager.shared.version,
        "build": AppDataManager.shared.build,
        "app": AppDataManager.shared.appName
    ]
    
    print(body)
}
