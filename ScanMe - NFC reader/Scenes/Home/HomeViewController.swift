//
//  HomeViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 30/03/2021.
//

import UIKit
import CoreNFC

class HomeViewController: UIViewController {
    @IBOutlet private weak var detectButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var session: NFCTagReaderSession?
    var viewModel: HomeViewModel! {
        didSet {
            viewModel.onTextMessage = { [weak self] vc in
                self?.present(vc, animated: true, completion: nil)
            }
            viewModel.onAlert = { [weak self] title, message in
                self?.showAlert(title: title, message: message)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNFCAvailability()
        setupView()
        CommandManager.shared.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        detectButton.layer.cornerRadius = 6
        activityIndicator.hidesWhenStopped = true
    }
    
    private func checkNFCAvailability() {
        if !NFCTagReaderSession.readingAvailable {
            detectButton.isEnabled = false
            showAlert(title: DescriptionKeys.scanningNotSupportedTitle, message: DescriptionKeys.scanningNotSupported)
        }
    }
    
    @IBAction func detectPressed(_ sender: UIButton) {
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        session?.alertMessage = DescriptionKeys.sessionAlert
        session?.begin()
    }
}

// MARK: - NFCTagReaderSessionDelegate
extension HomeViewController: NFCTagReaderSessionDelegate {
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
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
                let identifier = mifareTag.identifier.map { String(format: "%.2hhx", $0) }.joined()
                print("MiFare tag detected: \(identifier)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewModel.fetchCommand(for: identifier) { [weak self] commandDetails in
                        self?.viewModel.processCommand(commandDetails) { [weak self] in
                            DispatchQueue.main.async {
                                self?.activityIndicator.stopAnimating()
                            }
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


