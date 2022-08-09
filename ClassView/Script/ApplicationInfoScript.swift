//
//  ApplicationInfo.swift
//  ClassView
//
//  Created by admin on 2022/8/1.
//

import Foundation
import Frida

class Application: ScriptDelegate {
    private var script: Script?

    func scriptDestroyed(_ script: Script) {
        print("\(script) scriptDestroyed")
    }

    func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?) {
        if let dic = message as? NSDictionary {
            if let p = dic["payload"] as? String {
                let arr = p.components(separatedBy: "&")
                AppDataManager.shared.target = arr[0]
                AppDataManager.shared.appName = arr[1]
                AppDataManager.shared.build = arr[2]
                AppDataManager.shared.version = arr[3]
                AppDataManager.shared.name = arr[4]
                AppDataManager.shared.udid = arr[5]
                AppDataManager.shared.idfv = arr[6]
                AppDataManager.shared.idfa = arr[7]
                SendDeviceInfo()
            }
        }
    }
    
    func application() {
        if let session = USBDeviceManager.shared.session {
//            output["Name"] = infoLookup("CFBundleName");
//            output["Bundle ID"] = ObjC.classes.NSBundle.mainBundle().bundleIdentifier().toString();
//            output["Version"] = infoLookup("CFBundleVersion");
//            output["Bundle"] = ObjC.classes.NSBundle.mainBundle().bundlePath().toString();
//            output["Data"] = ObjC.classes.NSProcessInfo.processInfo().environment().objectForKey_("HOME").toString();
//            output["Binary"] = ObjC.classes.NSBundle.mainBundle().executablePath().toString();
            let s = """
            function dictFromNSDictionary(nsDict) {
                var jsDict = {};
                var keys = nsDict.allKeys();
                var count = keys.count();
                for (var i = 0; i < count; i++) {
                    var key = keys.objectAtIndex_(i);
                    var value = nsDict.objectForKey_(key);
                    jsDict[key.toString()] = value.toString();
                }

                return jsDict;
            }

            function arrayFromNSArray(nsArray) {
                var jsArray = [];
                var count = nsArray.count();
                for (var i = 0; i < count; i++) {
                    jsArray[i] = nsArray.objectAtIndex_(i).toString();
                }
                return jsArray;
            }

            function infoDictionary() {
                if (ObjC.available && "NSBundle" in ObjC.classes) {
                    var info = ObjC.classes.NSBundle.mainBundle().infoDictionary();
                    return dictFromNSDictionary(info);
                }
                return null;
            }

            function infoLookup(key) {
                if (ObjC.available && "NSBundle" in ObjC.classes) {
                    var info = ObjC.classes.NSBundle.mainBundle().infoDictionary();
                    var value = info.objectForKey_(key);
                    if (value === null) {
                        return value;
                    } else if (value.class().toString() === "__NSCFArray") {
                        return arrayFromNSArray(value);
                    } else if (value.class().toString() === "__NSCFDictionary") {
                        return dictFromNSDictionary(value);
                    } else {
                        return value.toString();
                    }
                }
                return null;
            }
            
            const { UIDevice } = ObjC.classes;
            const { NSUUID } = ObjC.classes;
            const { ASIdentifierManager } = ObjC.classes;
            var name = UIDevice.currentDevice().name();
            var uuid = NSUUID.UUID().UUIDString();
            var idfv = UIDevice.currentDevice().identifierForVendor().UUIDString();
            var idfa = ASIdentifierManager.sharedManager().advertisingIdentifier().UUIDString();
            console.log(infoLookup("CFBundleName") + "&" + infoLookup("CFBundleDisplayName") + "&" + infoLookup("CFBundleVersion") + "&" + infoLookup("CFBundleShortVersionString") + "&" + name + "&" + uuid + "&" + idfv + "&" + idfa);
            """
            session.createScript(s, name: "Application", runtime: ScriptRuntime.auto) { scriptResult in
                do {
                    self.script = try scriptResult()
                    self.script?.delegate = self
                    self.script?.load() { result in
                        do {
                            if try result() {
                                print("Script Application loaded")
                            } else {
                                print("Script Application loaded failed")
                            }
                        } catch let e {
                            print(e)
                        }
                    }
                } catch let e {
                    print(e)
                }
            }
        } else {
            print("USBDeviceManager.shared.session not found")
        }
    }
}
