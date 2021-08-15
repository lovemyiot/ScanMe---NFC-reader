//
//  CommandViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import UIKit

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
            viewModel.toggleFlashlight(on: true)
            
        case .textMessage(let phoneNumber, let message):
            viewModel.sendTextMessage(message: message, to: phoneNumber)
            
        case .openUrl(let url):
            showSafariViewController(url: url)
            
        case .unsupported:
            showAlert(title: DescriptionKeys.commandNotSupportedTitle, message: DescriptionKeys.commandNotSupported)
        }
    }
    
    private func showSafariViewController(url: URL?) {
        guard let url = url else {
            showAlert(title: DescriptionKeys.validationError, message: DescriptionKeys.nonValidUrl)
            return
        }
        let viewController = viewModel.safariViewController(url)
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true, completion: nil)
    }

}
