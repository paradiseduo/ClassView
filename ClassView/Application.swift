//
//  Application.swift
//  ClassView
//
//  Created by admin on 2022/7/27.
//

import Foundation
import SwiftUI

struct Applicaiton: Hashable, Identifiable {
    var id: Int

    var bundleid: String
    var name: String
    var pid: Int
    
    var iconImage: NSImage
    var icon: Image {
        Image(nsImage: iconImage)
    }
}
