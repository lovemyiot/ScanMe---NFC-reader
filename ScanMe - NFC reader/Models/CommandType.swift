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
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .flashlight:
            return DescriptionKeys.flashlightButton
        case .textMessage:
            return DescriptionKeys.textMessageButton
        case .openUrl:
            return DescriptionKeys.openUrlButton
        case .call:
            return DescriptionKeys.callButton
        case .unsupported:
            return DescriptionKeys.unsupported
        }
    }
}
