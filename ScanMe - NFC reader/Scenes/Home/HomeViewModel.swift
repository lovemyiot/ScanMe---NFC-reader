//
//  HomeViewModel.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 22/07/2021.
//

import CoreNFC
import XCoordinator

class HomeViewModel: NSObject {
    let router: UnownedRouter<MainRoute>
    
    init(router: UnownedRouter<MainRoute>) {
        self.router = router
    }
    
    func scanningNotSupportedAlert() -> UIAlertController {
        let alertController = UIAlertController(
                    title: "Scanning Not Supported",
                    message: "This device doesn't support tag scanning.",
                    preferredStyle: .alert
                )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}

// MARK: - NFCTagReaderSessionDelegate
extension HomeViewModel: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session active.")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Session ended: \(error.localizedDescription)")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else { return }
        if tags.count > 1 {
            session.alertMessage = DescriptionKeys.tooManyTags
            session.invalidate()
        }
        session.connect(to: tag) { error in
            if error != nil {
                session.invalidate(errorMessage: DescriptionKeys.connectionFailed)
            }
            
            switch tag {
            case .miFare(let mifareTag):
                let identifier = mifareTag.identifier.map { String(format: "%.2hhx", $0) }.joined()
                print("MiFare tag detected: \(identifier)")
                DataManager.shared.fetchCommand(for: identifier, from: FirestoreKeys.tagsCollection) {
                    switch $0 {
                    case .success(let tagDetails):
                        print("Command ID for tag \(identifier): \(tagDetails)")
                    case .failure(let error):
                        switch error {
                        case .decodingError:
                            print("Error decoding response from Firestore!")
                        case .documentNotExist:
                            print("Document does not exist in Firestore!")
                        }
                    }
                }
            default:
                print("Unsupported tag type detected!")
            }
            session.invalidate()
        }
    }
}
