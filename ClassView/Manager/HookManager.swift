//
//  HookManager.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation

let SENSITIVE = "1"
let GENERAL = "0"

func StartHook() {
    HookUIPasteboard()
    HookASIdentifierManager()
    HookATTrackingManager()
    HookAVAudioRecorder()
    HookAVAudioSession()
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
