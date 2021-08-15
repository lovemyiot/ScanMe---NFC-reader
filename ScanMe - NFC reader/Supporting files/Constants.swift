//
//  Constants.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 22/07/2021.
//

import Foundation

enum DescriptionKeys {
    //MARK: - NFC session
    static let sessionAlert = "Hold your iPhone near the item to see what happens."
    static let tooManyTags = "More than 1 tag detected. Please remove other items and try again."
    static let connectionFailed = "Connection failed. Try again."
    static let scanningNotSupported = "This device doesn't support tag scanning."
    static let scanningNotSupportedTitle = "Scanning Not Supported"
    
    //MARK: - Command support
    static let commandNotSupported = "Received command is not supported."
    static let commandNotSupportedTitle = "Command Not Supported"
    
    //MARK: - Command validation
    static let nonValidUrl = "Received URL is not a valid URL."
    static let validationError = "Validation Error"
}

enum FirestoreKeys {
    static let tagsCollection = "tags"
}
