//
//  AppRow.swift
//  ClassView
//
//  Created by admin on 2022/7/27.
//

import Foundation
import SwiftUI
import Frida

struct AppRow: View {
    var app: Applicaiton
    
    var body: some View {
        HStack(alignment: .center) {
            app.icon.resizable().frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(app.name)
                    .font(.title)
                Text(app.bundleid)
                    .font(.body)
            }
            .padding()
        }
        .padding()
    }
}


struct Applist: View {
    @State var apps: [Applicaiton]
    @State var classNames: [ClassName]?
    var application = Application()
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            List(apps) { app in
                AppRow(app: app)
                    .listStyle(SidebarListStyle())
                    .onTapGesture {
                        classNames?.removeAll()
                        USBDeviceManager.shared.attach(bundleid: app.bundleid) { session in
//                            Class().classes(handle: { success, result in
//                                if success {
//                                    classNames = result
//                                }
//                            })
                            application.application()
                            StartHook()
                            let sw = NewWindowController(rootView: MessageDetailView(model: RequestManager.shared.permissions))
                            sw.window?.title = "堆栈详情"
                            sw.showWindow(nil)
                            let rw = NewWindowController(rootView: MessageDetailView(model: RequestManager.shared.requests))
                            rw.window?.title = "请求详情"
                            rw.showWindow(nil)
                            let nw = NewWindowController(rootView: ImageDetailView(messages: [String]()))
                            nw.window?.title = "图片详情"
                            nw.showWindow(nil)
                        }
                    }
            }
            if let cc = classNames {
                Classlist(datas: cc)
            }
        }
        .padding()
    }
}
