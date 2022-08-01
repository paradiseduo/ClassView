//
//  ContentView.swift
//  ClassView
//
//  Created by admin on 2022/2/17.
//

import SwiftUI
import Frida

struct ContentView: View {
    @State var applications: [Applicaiton]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("ClassView")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .onAppear {
                    USBDeviceManager.listUSBDevice { devices in
                        if let dd = devices.first {
                            USBDeviceManager.shared.listApplication(device: dd) { apps in
                                applications = apps
                            }
                        }
                    }
                }
            
            if applications.count == 0 {
                Applist(apps: applications).hidden()
            } else {
                Applist(apps: applications)
            }
            
        }.padding()
    }
}
