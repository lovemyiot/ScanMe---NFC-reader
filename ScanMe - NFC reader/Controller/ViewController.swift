//
//  ViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 30/03/2021.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {

    // MARK: Properties
    
    var session: NFCTagReaderSession?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Functions
    
    

    // MARK: Actions
    
    @IBAction func detectPressed(_ sender: UIButton) {
        
    }
    
}

// MARK: - NFCTagReaderSessionDelegate

extension ViewController: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
    }
    
    
}

