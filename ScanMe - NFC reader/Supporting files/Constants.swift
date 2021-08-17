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
    
    //MARK: - Device support
    static let scanningNotSupported = "This device doesn't support tag scanning."
    static let scanningNotSupportedTitle = "Scanning Not Supported"
    static let smsNotSupported = "This device doesn't support sending text messages."
    static let smsNotSupportedTitle = "SMS Not Supported"
    
    //MARK: - Command support
    static let commandNotSupported = "Received command is not supported."
    static let commandNotSupportedTitle = "Command Not Supported"
    
    //MARK: - Command validation
    static let nonValidParameters = "Received parameters are not valid."
    static let validationError = "Validation Error"
    
    //MARK: - Command names
    static let flashlight = "Toggle flashlight"
    static let flashlightButton = "Toggle"
    static let textMessage = "Text message"
    static let textMessageButton = "Send text"
    static let openUrl = "Open URL"
    static let openUrlButton = "Open website"
    static let call = "Make a call"
    static let callButton = "Call"
    static let unsupported = "Unsupported"
}

enum FirestoreKeys {
    static let tagsCollection = "tags"
}
