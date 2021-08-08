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
    
    private func setupView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        viewModel.fetchCommand {
            self.activityIndicator.stopAnimating()
        }
    }

}
