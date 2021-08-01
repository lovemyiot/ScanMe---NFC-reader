//
//  CommandViewModel.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import XCoordinator

class CommandViewModel {
    let router: UnownedRouter<MainRoute>
    
    init(router: UnownedRouter<MainRoute>) {
        self.router = router
    }
}
