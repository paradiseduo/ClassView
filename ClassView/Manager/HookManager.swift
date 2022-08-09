//
//  HookManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation
import AVFoundation
import EventKit

let SENSITIVE = "1"
let GENERAL = "0"

func StartHook() {
    HookUIPasteboard()
    HookASIdentifierManager()
    HookATTrackingManager()
    HookAVAudioRecorder()
    HookAVAudioSession()
    HookCBCentralManager()
    HookCLGeocoder()
    HookCLLocationManager()
    HookCMMotionActivityManager()
    HookCMMotionManager()
    HookCMPedometer()
    HookCNContact()
    HookCNContactStore()
    HookCTCarrier()
    HookCTTelephonyNetworkInfo()
    HookAVCaptureDevice()
    HookEKEventStore()
}

func HookUIPasteboard() {
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- string", name: "获取剪切板字符串", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- strings", name: "获取剪切板字符串数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- URL", name: "获取剪切板URL", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- URLs", name: "获取剪切板URLs", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- image", name: "获取剪切板图片", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- images", name: "获取剪切板图片数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- color", name: "获取剪切板颜色", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "_UIConcretePasteboard", methodName: "- colors", name: "获取剪切板颜色数组", label: "获取剪切板内容", level: SENSITIVE, weight: "10"))
}

func HookASIdentifierManager() {
    USBDeviceManager.add(Hook(className: "ASIdentifierManager", methodName: "- isAdvertisingTrackingEnabled", name: "获取IDFA权限", label: "获取IDFA", level: SENSITIVE, weight: "3"))
    USBDeviceManager.add(Hook(className: "ASIdentifierManager", methodName: "- advertisingIdentifier", name: "读取IDFA", label: "获取IDFA", level: SENSITIVE, weight: "3"))
}

func HookATTrackingManager() {
    USBDeviceManager.add(Hook(className: "ATTrackingManager", methodName: "+ trackingAuthorizationStatus", name: "IOS14获取IDFA权限", label: "获取IDFA", level: SENSITIVE, weight: "3"))
    USBDeviceManager.add(Hook(className: "ATTrackingManager", methodName: "+ requestTrackingAuthorizationWithCompletionHandler:", name: "IOS14获取IDFA状态", label: "获取IDFA", level: SENSITIVE, weight: "3"))
}

func HookAVAudioRecorder() {
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- prepareToRecord", name: "准备录音", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- record", name: "开始录音", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- recordAtTime:", name: "录音时长1", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- recordForDuration:", name: "录音时长2", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- ecordAtTime:forDuration:", name: "录音时长3", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- pause", name: "录音暂停", label: "使用麦克风", level: SENSITIVE, weight: "6"))
    USBDeviceManager.add(Hook(className: "AVAudioRecorder", methodName: "- stop", name: "录音结束", label: "使用麦克风", level: SENSITIVE, weight: "6"))
}

func HookAVAudioSession() {
    USBDeviceManager.add(Hook(className: "AVAudioSession", methodName: "- outputVolume", name: "获取音量", label: "获取音量", level: GENERAL, weight: "100"))
}

func HookCBCentralManager() {
    USBDeviceManager.add(Hook(className: "CBCentralManager", methodName: "- init", name: "使用蓝牙", label: "使用蓝牙", level: SENSITIVE, weight: "2"))
    USBDeviceManager.add(Hook(className: "CBCentralManager", methodName: "- initWithDelegate:queue:", name: "使用蓝牙", label: "使用蓝牙", level: SENSITIVE, weight: "2"))
    USBDeviceManager.add(Hook(className: "CBCentralManager", methodName: "- initWithDelegate:queue:options:", name: "使用蓝牙", label: "使用蓝牙", level: SENSITIVE, weight: "2"))
}

func HookCLGeocoder() {
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- reverseGeocodeLocation:completionHandler:", name: "转换位置信息", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- reverseGeocodeLocation:preferredLocale:completionHandler:", name: "转换位置信息2", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- geocodeAddressString:completionHandler:", name: "根据地名获取经纬度", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- geocodeAddressString:inRegion:completionHandler:", name: "根据地名获取经纬度2", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- geocodeAddressString:inRegion:preferredLocale:completionHandler:", name: "根据地名获取经纬度3", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- geocodePostalAddress:completionHandler:", name: "根据邮编获取经纬度", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLGeocoder", methodName: "- geocodePostalAddress:preferredLocale:completionHandler:", name: "根据邮编获取经纬度", label: "使用位置信息", level: SENSITIVE, weight: "4"))
}

func HookCLLocationManager() {
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- requestWhenInUseAuthorization", name: "申请前台定位权限", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- requestAlwaysAuthorization", name: "申请始终定位权限", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- startUpdatingLocation", name: "开始更新位置信息", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- requestLocation", name: "获取一次位置信息", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- requestTemporaryFullAccuracyAuthorizationWithPurposeKey:completion:", name: "申请一次精确定位1", label: "使用位置信息", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CLLocationManager", methodName: "- requestTemporaryFullAccuracyAuthorizationWithPurposeKey:", name: "申请一次精确定位2", label: "使用位置信息", level: SENSITIVE, weight: "4"))
}

func HookCMMotionActivityManager() {
    USBDeviceManager.add(Hook(className: "CMMotionActivityManager", methodName: "- startActivityUpdatesToQueue:withHandler:", name: "使用健康记录", label: "使用健康记录", level: SENSITIVE, weight: "4"))
    USBDeviceManager.add(Hook(className: "CMMotionActivityManager", methodName: "+ authorizationStatus", name: "获取健康记录权限", label: "使用健康记录", level: SENSITIVE, weight: "4"))
}

func HookCMMotionManager() {
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- isAccelerometerAvailable", name: "获取加速度传感器状态", label: "使用加速度传感器", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startAccelerometerUpdates", name: "加速度传感器Pull", label: "使用加速度传感器", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startAccelerometerUpdatesToQueue:withHandler:", name: "加速度传感器Push", label: "使用加速度传感器", level: SENSITIVE, weight: "10"))
    
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- isGyroAvailable", name: "获取陀螺仪状态", label: "使用陀螺仪", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startGyroUpdates", name: "陀螺仪Pull", label: "使用陀螺仪", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startGyroUpdatesToQueue:withHandler:", name: "陀螺仪Push", label: "使用陀螺仪", level: SENSITIVE, weight: "10"))
    
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- isMagnetometerAvailable", name: "获取磁力计状态", label: "使用磁力计", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startMagnetometerUpdates", name: "磁力计Pull", label: "使用磁力计", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startMagnetometerUpdatesToQueue:withHandler:", name: "磁力计Push", label: "使用磁力计", level: SENSITIVE, weight: "10"))
    
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- isDeviceMotionAvailable", name: "获取设备运动状态", label: "使用设备运动", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startDeviceMotionUpdates", name: "设备运动Pull", label: "使用设备运动", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMMotionManager", methodName: "- startDeviceMotionUpdatesToQueue:withHandler:", name: "设备运动Push", label: "使用设备运动", level: SENSITIVE, weight: "10"))
}

func HookCMPedometer() {
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isStepCountingAvailable:withHandler:", name: "获取计步器是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isDistanceAvailable", name: "获取距离估计是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isFloorCountingAvailable", name: "获取楼层计数是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isPaceAvailable", name: "获取速度信息是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isCadenceAvailable", name: "获取节奏信息是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "+ isPedometerEventTrackingAvailable", name: "获取计步器事件是否可用", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "- queryPedometerDataFromDate:toDate:withHandler:", name: "查询计步器历史", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
    USBDeviceManager.add(Hook(className: "CMPedometer", methodName: "- startPedometerUpdatesFromDate:withHandler:", name: "查询累积步数", label: "活动与体能记录", level: SENSITIVE, weight: "10"))
}

func HookCNContact() {
    USBDeviceManager.add(Hook(className: "CNContact", methodName: "+ predicateForContactsMatchingName:", name: "检索通讯录中所有的联系人信息", label: "获取通讯录权限", level: SENSITIVE, weight: "8"))
    USBDeviceManager.add(Hook(className: "CNContact", methodName: "+ predicateForContactsInContainerWithIdentifier:", name: "检索通讯录中指定的联系人信息", label: "获取通讯录权限", level: SENSITIVE, weight: "8"))
}

func HookCNContactStore() {
    USBDeviceManager.add(Hook(className: "CNContactStore", methodName: "+ authorizationStatusForEntityType:", name: "获取通讯录权限", label: "获取通讯录权限", level: SENSITIVE, weight: "8"))
    USBDeviceManager.add(Hook(className: "CNContactStore", methodName: "- enumerateContactsWithFetchRequest:error:usingBlock:", name: "读取通讯录内容", label: "获取通讯录权限", level: SENSITIVE, weight: "8"))
}

func HookCTCarrier() {
    USBDeviceManager.add(Hook(className: "CTCarrier", methodName: "- carrierName", name: "获取电话卡运营商", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTCarrier", methodName: "- mobileCountryCode", name: "获取移动设备国家代码MCC", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTCarrier", methodName: "- mobileNetworkCode", name: "获取移动设备网络代码MNC", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTCarrier", methodName: "- isoCountryCode", name: "获取ISO国家代码", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTCarrier", methodName: "- allowsVOIP", name: "获取电话卡的VOIP", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
}

func HookCTTelephonyNetworkInfo() {
    USBDeviceManager.add(Hook(className: "CTTelephonyNetworkInfo", methodName: "- subscriberCellularProvider", name: "获取手机运营商iOS12", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTTelephonyNetworkInfo", methodName: "- currentRadioAccessTechnology", name: "获取电话卡网络类型", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTTelephonyNetworkInfo", methodName: "- serviceSubscriberCellularProviders", name: "获取手机运营商", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
    USBDeviceManager.add(Hook(className: "CTTelephonyNetworkInfo", methodName: "- serviceCurrentRadioAccessTechnology", name: "获取是否为飞行模式", label: "获取SIM卡信息", level: GENERAL, weight: "100"))
}

func HookAVCaptureDevice() {
    USBDeviceManager.add(HookArgs(className: "AVCaptureDevice", methodName: "+ authorizationStatusForMediaType:", resultHandle: { className, methodName, callStack, background, args in
        for item in args {
            if item == AVMediaType.video.rawValue {
                SendPermissionReport(name: "获取麦克风权限", label: "获取麦克风权限", level: SENSITIVE, weight: "2", stack: callStack, background: background)
                break
            } else if item == AVMediaType.audio.rawValue {
                SendPermissionReport(name: "获取相机权限", label: "获取相机权限", level: SENSITIVE, weight: "2", stack: callStack, background: background)
                break
            } else {
                SendPermissionReport(name: "获取媒体权限\(item)", label: "获取媒体库权限", level: GENERAL, weight: "100", stack: callStack, background: background)
                break
            }
        }
    }))
}

func HookEKEventStore() {
    USBDeviceManager.add(HookArgs(className: "EKEventStore", methodName: "+ authorizationStatusForEntityType:", resultHandle: { className, methodName, callStack, background, args in
        for item in args {
            if let i = Int(item) {
                if i == EKEntityType.event.rawValue {
                    SendPermissionReport(name: "获取日历权限", label: "获取日历权限", level: SENSITIVE, weight: "10", stack: callStack, background: background)
                    break
                } else if i == EKEntityType.reminder.rawValue {
                    SendPermissionReport(name: "获取备忘录权限", label: "获取备忘录权限", level: SENSITIVE, weight: "10", stack: callStack, background: background)
                    break
                }
            }
        }
    }))
    USBDeviceManager.add(HookArgs(className: "EKEventStore", methodName: "- requestAccessToEntityType:completion:", resultHandle: { className, methodName, callStack, background, args in
        for item in args {
            if let i = Int(item) {
                if i == EKEntityType.event.rawValue {
                    SendPermissionReport(name: "读取日历", label: "获取日历权限", level: SENSITIVE, weight: "10", stack: callStack, background: background)
                    break
                } else if i == EKEntityType.reminder.rawValue {
                    SendPermissionReport(name: "读取备忘录", label: "获取备忘录权限", level: SENSITIVE, weight: "10", stack: callStack, background: background)
                    break
                }
            }
        }
    }))
}
