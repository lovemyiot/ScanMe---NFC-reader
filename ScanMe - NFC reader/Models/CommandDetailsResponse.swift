//
//  CommandDetailsResponse.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct CommandDetailsResponse: Codable {
    let condition: Condition?
    let commands: [Command]
}

struct Condition: Codable {
    let type: ConditionType
    let startTime: String?
    let endTime: String?
    let coordinates: GeoPoint?
    let radius: Int?
    
    enum ConditionType: String, Codable {
        case time = "time"
        case location = "location"
    }
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
            commandType = .textMessage(phoneNumber: arguments?.phoneNumber, message: arguments?.message)
        case 3:
            let url = URL(string: arguments?.url ?? "")
            commandType = .openUrl(url: url)
        case 4:
            commandType = .call(phoneNumber: arguments?.phoneNumber)
        case 5:
            commandType = .wifi(ssid: arguments?.ssid, password: arguments?.wifiPassword)
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
    let ssid: String?
    let wifiPassword: String?
}
