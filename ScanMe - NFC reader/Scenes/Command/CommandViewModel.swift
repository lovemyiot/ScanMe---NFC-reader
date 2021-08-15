//
//  CommandViewModel.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import XCoordinator
import AVFoundation
import SafariServices
import MessageUI

class CommandViewModel: NSObject {
    let router: UnownedRouter<MainRoute>
    private let tagIdentifier: String
    var command: CommandType?
    
    init(router: UnownedRouter<MainRoute>, tagIdentifier: String) {
        self.router = router
        self.tagIdentifier = tagIdentifier
    }
    
    func fetchCommand(completion: @escaping () -> Void) {
        DataManager.shared.fetchCommand(for: tagIdentifier, from: FirestoreKeys.tagsCollection) {
            switch $0 {
            case .success(let commandDetails):
                print("Command details for tag \(self.tagIdentifier): \(commandDetails)")
                self.command = commandDetails.toCommandType()
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
    
    func sendTextMessageViewController(message: String, to phoneNumber: String) -> MFMessageComposeViewController {
        let viewController = MFMessageComposeViewController()
        viewController.body = message
        viewController.recipients = [phoneNumber]
        viewController.messageComposeDelegate = self
        return viewController
    }
    
    func safariViewController(_ url: URL) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }
}

extension CommandViewModel: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
