//
//  CommandManager.swift
//  ScanMe - NFC reader
//
//  Created by jacek.kopaczel on 26/08/2021.
//

import Foundation

class CommandManager {
    static let shared = CommandManager()
        
    private init() { }
    
    func processCommands(_ commandDetails: CommandDetailsResponse, completion: @escaping (CommandType?) -> Void) {
        guard let condition = commandDetails.condition, commandDetails.commands.count > 1 else {
            if let firstCommand = commandDetails.commands.first {
                completion(firstCommand.toCommandType())
                return
            }
            completion(nil)
            return
        }
        
        switch condition.type {
        case .time:
            guard let startTime = condition.startTime,
                  let endTime = condition.endTime,
                  let startDate = todayAt(startTime),
                  let endDate = todayAt(endTime) else {
                completion(nil)
                return
            }
            let now = Date()
            let command = (now > startDate && now < endDate) ? commandDetails.commands[0] : commandDetails.commands[1]
            completion(command.toCommandType())
        default:
            completion(nil)
        }
        
    }
    
    private func todayAt(_ time: String) -> Date? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let defaultDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        dateFormatter.defaultDate = calendar.date(from: defaultDateComponents)
        return dateFormatter.date(from: time)
        
    }
}
