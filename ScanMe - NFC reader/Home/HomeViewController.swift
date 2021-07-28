//
//  HomeViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 30/03/2021.
//

import UIKit
import CoreNFC

class HomeViewController: UIViewController {
    var session: NFCTagReaderSession?
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNFCAvailability()
        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func checkNFCAvailability() {
        if !NFCTagReaderSession.readingAvailable {
            let alertController = UIAlertController(
                        title: "Scanning Not Supported",
                        message: "This device doesn't support tag scanning.",
                        preferredStyle: .alert
                    )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func detectPressed(_ sender: UIButton) {
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: viewModel)
        session?.alertMessage = DescriptionKeys.sessionAlert
        session?.begin()
    }
}
