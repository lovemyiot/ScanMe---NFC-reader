//
//  UIViewController.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 28/07/2021.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    static func instantiate<T: UIViewController>(from storyboardName: String = "Main") -> T {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? T else {
            fatalError("Could not instantiate a UIViewController with identifier: \(className) in storyboard: \(storyboardName).")
        }
        return viewController
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .alert
                )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
