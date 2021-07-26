//
//  HomeViewModel.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 22/07/2021.
//

import CoreNFC

class HomeViewModel: NSObject {
    
}

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
            default:
                print("Unsupported tag type detected!")
            }
            session.invalidate()
        }
    }
    
    
}
