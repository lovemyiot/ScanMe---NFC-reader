//
//  CommandViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import UIKit
import MessageUI
import AVFoundation

class CommandViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CommandViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        viewModel.fetchCommand {
            self.activityIndicator.stopAnimating()
            self.processReceivedCommand()
        }
    }
    
    private func processReceivedCommand() {
        guard let command = viewModel.command else { return }
        switch command {
        case .flashlight:
            toggleFlashlight(on: true)
            
        case .textMessage(let phoneNumber, let message):
            showTextMessageViewController(phoneNumber: phoneNumber, message: message)
            
        case .openUrl(let url):
            showSafariViewController(url: url)
            
        case .call(let phoneNumber):
            call(phoneNumber)
            
        case .unsupported:
            showAlert(title: DescriptionKeys.commandNotSupportedTitle, message: DescriptionKeys.commandNotSupported)
        }
    }
    
    private func call(_ phoneNumber: String?) {
        guard let phoneNumber = phoneNumber, let phoneNumberUrl = URL(string: "tel://\(phoneNumber)") else {
            showAlert(title: DescriptionKeys.validationError, message: DescriptionKeys.nonValidParameters)
            return
        }
        UIApplication.shared.open(phoneNumberUrl)
    }
    
    private func toggleFlashlight(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Flashlight could not be used.")
            }
        } else {
            print("Flashlight is not available on this device.")
        }
    }
    
    private func showTextMessageViewController(phoneNumber: String?, message: String?) {
        guard let phoneNumber = phoneNumber, let message = message else {
            showAlert(title: DescriptionKeys.validationError, message: DescriptionKeys.nonValidParameters)
            return
        }
        if MFMessageComposeViewController.canSendText() {
            let viewController = viewModel.sendTextMessageViewController(message: message, to: phoneNumber)
            viewController.modalPresentationStyle = .pageSheet
            present(viewController, animated: true, completion: nil)
        } else {
            showAlert(title: DescriptionKeys.smsNotSupportedTitle, message: DescriptionKeys.smsNotSupported)
        }
    }
    
    private func showSafariViewController(url: URL?) {
        guard let url = url else {
            showAlert(title: DescriptionKeys.validationError, message: DescriptionKeys.nonValidParameters)
            return
        }
        let viewController = viewModel.safariViewController(url)
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true, completion: nil)
    }
}
