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
