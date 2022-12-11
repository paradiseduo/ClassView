//
//  RequestManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

class RequestManager {
    static let shared = RequestManager()
    
    var permissions = MessageModel(messages: [Message]())
    var requests = MessageModel(messages: [Message]())
}

func SendPermissionReport(name: String, label: String, level: String, weight: String, stack: String, background: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var body = PermissionCheck(name: name, label: label, level: level, weight: weight, stack: stack)
    body["calldate"] = dateFormatter.string(from: Date())
    body["udid"] = AppDataManager.shared.udid
    body["background"] = background
    
    if body["level"] == SENSITIVE {
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted), let s = String(data: jsonData, encoding: String.Encoding.utf8) {
            RequestManager.shared.permissions.messages.append(Message(id: RequestManager.shared.permissions.messages.count, message: s))
        }
    }
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
    if body["level"] == SENSITIVE {
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted), let s = String(data: jsonData, encoding: String.Encoding.utf8) {
            RequestManager.shared.requests.messages.append(Message(id: RequestManager.shared.requests.messages.count, message: s))
        }
    }
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
