//
//  HomeViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 30/03/2021.
//

import UIKit
import CoreNFC

class HomeViewController: UIViewController {
    var session: NFCNDEFReaderSession?
    
    let viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func detectPressed(_ sender: UIButton) {
        session = NFCNDEFReaderSession(delegate: viewModel, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = DescriptionKeys.sessionAlert
        session?.begin()
    }
}
