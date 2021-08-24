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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var commandNameLabel: UILabel!
    @IBOutlet private weak var proceedButton: UIButton!
    
    var viewModel: CommandViewModel! {
        didSet {
            viewModel.onTextMessage = { [weak self] viewController in
                self?.present(viewController, animated: true, completion: nil)
            }
            viewModel.onAlert = { [weak self] title, message in
                self?.showAlert(title: title, message: message)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        commandNameLabel.layer.masksToBounds = true
        commandNameLabel.layer.cornerRadius = 3
        proceedButton.layer.cornerRadius = 6
    }
    
    private func fetchData() {
        viewModel.fetchCommand {
            self.commandNameLabel.text = self.viewModel.command?.title
            self.commandNameLabel.isHidden = false
            self.proceedButton.setTitle(self.viewModel.command?.buttonTitle, for: [])
            self.proceedButton.isHidden = false
            self.proceedButton.isEnabled = self.viewModel.command != .unsupported
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        viewModel.goBack()
    }
    
    @IBAction func proceedTapped(_ sender: UIButton) {
        viewModel.processCommand()
    }
}
