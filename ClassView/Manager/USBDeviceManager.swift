//
//  ModelData.swift
//  ClassView
//
//  Created by admin on 2022/7/27.
//

import Foundation
import Frida

class USBDeviceManager {
    static let shared = USBDeviceManager()
    private let manager = DeviceManager()
    var device: Device?
    var session: Session?
    private var hooks = [Hook]()
    var pid: UInt = 0
    
    func deviceManager() -> DeviceManager {
        return manager
    }
    
    static func listUSBDevice(result: @escaping ([Device])->()) {
        var usbDevices = [Device]()
        USBDeviceManager.shared.deviceManager().enumerateDevices { resultDevice in
            do {
                let devices = try resultDevice()
                usbDevices = devices.filter({ $0.kind == Device.Kind.usb })
                result(usbDevices)
            } catch {
                result(usbDevices)
            }
        }
    }
    
    func listApplication(device: Device, result: @escaping ([Applicaiton])->()) {
        var applications = [Applicaiton]()
        USBDeviceManager.shared.device = device
        device.enumerateApplications(identifiers: nil, scope: Scope.full) { resultApplication in
            do {
                let apps = try resultApplication()
                for (index, item) in apps.enumerated() {
                    applications.append(Applicaiton(id: index, bundleid: item.identifier, name: item.name, pid: Int(item.pid ?? 0), iconImage: item.icons.first ?? NSImage()))
                }
                result(applications)
            } catch {
                result(applications)
            }
        }
    }
    
    func attach(bundleid: String, handle: @escaping (Session?) -> ()) {
        if let device = USBDeviceManager.shared.device {
            device.spawn(bundleid, argv: nil, envp: nil, env: nil, cwd: nil, stdio: nil) { result in
                do {
                    let pid = try result()
                    USBDeviceManager.shared.pid = pid
                    device.attach(to: pid, realm: .native) { result in
                        do {
                            let session = try result()
                            USBDeviceManager.shared.session = session
                            handle(session)
                        } catch {
                            handle(nil)
                        }
                        device.resume(pid) { result in
                            
                        }
                    }
                } catch {
                    handle(nil)
                }
            }
        } else {
            handle(nil)
        }
    }
    
    func add(_ hook: Hook) {
        hook.hook()
        self.hooks.append(hook)
    }
}
