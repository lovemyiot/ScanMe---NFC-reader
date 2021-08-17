//
//  CommandDetailsResponse.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import Foundation

struct CommandDetailsResponse: Codable {
    let commandId: Int
    let arguments: [String]?
    
    func toCommandType() -> CommandType {
        var commandType: CommandType = .unsupported
        switch commandId {
        case 1:
            commandType = .flashlight
            
        case 2:
            let phoneNumber = arguments?[0]
            let message = arguments?[1]
            commandType = .textMessage(phoneNumber: phoneNumber, message: message)
            
        case 3:
            let url = URL(string: arguments?[0] ?? "")
            commandType = .openUrl(url: url)
            
        case 4:
            let phoneNumber = arguments?[0]
            commandType = .call(phoneNumber: phoneNumber)
            
        default:
            commandType = .unsupported
        }
        return commandType
    }
}

enum CommandType {
    case flashlight
    case textMessage(phoneNumber: String?, message: String?)
    case openUrl(url: URL?)
    case call(phoneNumber: String?)
    case unsupported
}
