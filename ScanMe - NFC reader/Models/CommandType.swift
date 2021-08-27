//
//  CommandType.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 26/08/2021.
//

import Foundation

enum CommandType: Equatable {
    case flashlight
    case textMessage(phoneNumber: String?, message: String?)
    case openUrl(url: URL?)
    case call(phoneNumber: String?)
    case wifi(ssid: String?, password: String?)
    case unsupported
    
    var title: String {
        switch self {
        case .flashlight:
            return DescriptionKeys.flashlight
        case .textMessage:
            return DescriptionKeys.textMessage
        case .openUrl:
            return DescriptionKeys.openUrl
        case .call:
            return DescriptionKeys.call
        case .unsupported:
            return DescriptionKeys.unsupported
        case .wifi:
            return DescriptionKeys.wifi
        }
    }
}
