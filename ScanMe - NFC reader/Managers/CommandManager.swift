//
//  CommandManager.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 26/08/2021.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class CommandManager: NSObject {
    static let shared = CommandManager()
    
    let locationManager: CLLocationManager
    private var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
        
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
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
            
        case .location:
            guard let coordinates = condition.coordinates,
                  let radius = condition.radius else {
                completion(nil)
                return
            }
            onLocationUpdate = { [weak self] userCoordinates in
                guard let self = self else { return }
                let convertedCoordinates = self.convertToCoordinates(point: coordinates)
                let convertedRadius = CLLocationDistance(radius)
                let region = CLCircularRegion(center: convertedCoordinates, radius: convertedRadius, identifier: "region")
                let command = region.contains(userCoordinates) ? commandDetails.commands[0] : commandDetails.commands[1]
                completion(command.toCommandType())
            }
            locationManager.requestLocation()
        }
    }
    
    private func convertToCoordinates(point: GeoPoint) -> CLLocationCoordinate2D {
        let latitude = CLLocationDegrees(point.latitude)
        let longitude = CLLocationDegrees(point.longitude)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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

extension CommandManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate?(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error.localizedDescription)")
    }
}
