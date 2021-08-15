//
//  HomeViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 30/03/2021.
//

import UIKit
import CoreNFC

class HomeViewController: UIViewController {
    @IBOutlet weak var detectButton: UIButton!
    
    var session: NFCTagReaderSession?
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNFCAvailability()
        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        detectButton.layer.cornerRadius = 6
    }
    
    private func checkNFCAvailability() {
        if !NFCTagReaderSession.readingAvailable {
            detectButton.isEnabled = false
            showAlert(title: DescriptionKeys.scanningNotSupportedTitle, message: DescriptionKeys.scanningNotSupported)
        }
    }
    
    @IBAction func detectPressed(_ sender: UIButton) {
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: viewModel)
        session?.alertMessage = DescriptionKeys.sessionAlert
        session?.begin()
    }
}
