//
//  Item.swift
//  Music Player
//
//  Created by William D'Olier on 15/11/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
