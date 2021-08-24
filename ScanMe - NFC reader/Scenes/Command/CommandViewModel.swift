//
//  CommandViewModel.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import XCoordinator
import AVFoundation
import MessageUI

class CommandViewModel: NSObject {
    private let router: UnownedRouter<MainRoute>
    private let tagIdentifier: String
    var commands: [CommandType] = []
    
    var onTextMessage: ((MFMessageComposeViewController) -> Void)?
    var onAlert: ((String, String) -> Void)?
    
    init(router: UnownedRouter<MainRoute>, tagIdentifier: String) {
        self.router = router
        self.tagIdentifier = tagIdentifier
    }
    
    func goBack() {
        router.trigger(.back)
    }
    
    func fetchCommand(completion: @escaping () -> Void) {
        DataManager.shared.fetchCommand(for: tagIdentifier, from: FirestoreKeys.tagsCollection) {
            switch $0 {
            case .success(let commandDetails):
                print("Command details for tag \(self.tagIdentifier): \(commandDetails)")
                commandDetails.commands.forEach {
                    self.commands.append($0.toCommandType())
                }
                completion()
            case .failure(let error):
                switch error {
                case .decodingError:
                    print("Error decoding response from Firestore!")
                case .documentNotExist:
                    print("Document does not exist in Firestore!")
                }
            }
        }
    }
    
    func processCommand() {
//        guard let command = self.command else { return }
//        switch command {
//        case .flashlight:
//            toggleFlashlight()
//
//        case .textMessage(let phoneNumber, let message):
//            sendText(message: message, to: phoneNumber)
//
//        case .openUrl(let url):
//            open(url)
//
//        case .call(let phoneNumber):
//            call(phoneNumber)
//
//        case .unsupported:
//            onAlert?(DescriptionKeys.commandNotSupportedTitle, DescriptionKeys.commandNotSupported)
//        }
    }
    
    private func call(_ phoneNumber: String?) {
        guard let phoneNumber = phoneNumber, let phoneNumberUrl = URL(string: "tel://\(phoneNumber)") else {
            onAlert?(DescriptionKeys.validationError, DescriptionKeys.nonValidParameters)
            return
        }
        UIApplication.shared.open(phoneNumberUrl)
    }
    
    private func toggleFlashlight(mode: AVCaptureDevice.TorchMode? = nil) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                guard let mode = mode else {
                    device.torchMode = device.torchMode == .off ? .on : .off
                    device.unlockForConfiguration()
                    return
                }
                device.torchMode = mode
                device.unlockForConfiguration()
            } catch {
                print("Flashlight could not be used.")
            }
        } else {
            print("Flashlight is not available on this device.")
        }
    }
    
    private func sendText(message: String?, to phoneNumber: String?) {
        guard let phoneNumber = phoneNumber, let message = message else {
            onAlert?(DescriptionKeys.validationError, DescriptionKeys.nonValidParameters)
            return
        }
        if MFMessageComposeViewController.canSendText() {
            let messageViewController = MFMessageComposeViewController()
            messageViewController.body = message
            messageViewController.recipients = [phoneNumber]
            messageViewController.messageComposeDelegate = self
            onTextMessage?(messageViewController)
        } else {
            onAlert?(DescriptionKeys.smsNotSupportedTitle, DescriptionKeys.smsNotSupported)
        }
    }
    
    private func open(_ url: URL?) {
        guard let url = url else {
            onAlert?(DescriptionKeys.validationError, DescriptionKeys.nonValidParameters)
            return
        }
        UIApplication.shared.open(url)
    }
}

extension CommandViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
