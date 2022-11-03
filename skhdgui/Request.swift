//
//  Request.swift
//  skhdgui
//
//  Created by Gregory Ling on 11/2/22.
//

import Foundation

enum Request : Codable {
    case showStatusBar(label: String, color: Int?)
    case showModeOptions(mode: String)
    case rawList(title: String, values: [String])
    case next
    case previous
    case click
    case hideWindow
    case hideStatusBar
    
    private enum CodingKeys : String, CodingKey {
        case showStatusBar = "s"
        case showModeOptions = "w"
        case rawList = "r"
        case next = "n"
        case previous = "p"
        case click = "c"
        case hideWindow = "W"
        case hideStatusBar = "S"
    }
    
    private enum ShowStatusBarCodingKeys : String, CodingKey {
        case label = "l"
        case color = "c"
    }
    
    private enum ShowModeOptionsCodingKeys : String, CodingKey {
        case mode = "m"
    }
    
    private enum RawListCodingKeys : String, CodingKey {
        case title = "t"
        case values = "v"
    }
}
