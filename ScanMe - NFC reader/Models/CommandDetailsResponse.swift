//
//  CommandDetailsResponse.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import Foundation

struct CommandDetailsResponse: Codable {
    let commands: [Command]
}

struct Command: Codable {
    let commandId: Int
    let arguments: Arguments?
    
    func toCommandType() -> CommandType {
        var commandType: CommandType = .unsupported
        switch commandId {
        case 1:
            commandType = .flashlight
        case 2:
            let phoneNumber = arguments?.phoneNumber
            let message = arguments?.message
            commandType = .textMessage(phoneNumber: phoneNumber, message: message)
        case 3:
            let url = URL(string: arguments?.url ?? "")
            commandType = .openUrl(url: url)
        case 4:
            let phoneNumber = arguments?.phoneNumber
            commandType = .call(phoneNumber: phoneNumber)
        default:
            commandType = .unsupported
        }
        return commandType
    }
}

struct Arguments: Codable {
    let phoneNumber: String?
    let message: String?
    let url: String?
}

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
