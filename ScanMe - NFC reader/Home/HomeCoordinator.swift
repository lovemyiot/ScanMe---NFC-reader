//
//  HomeCoordinator.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 28/07/2021.
//

import Foundation
import XCoordinator

enum HomeRoute: Route {
    case home
}

class HomeCoordinator: NavigationCoordinator<HomeRoute> {
    init() {
        super.init(initialRoute: .home)
        rootViewController.modalPresentationStyle = .fullScreen
    }
    
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController: HomeViewController = HomeViewController.instantiate()
            viewController.viewModel = HomeViewModel(router: unownedRouter)
            return .push(viewController)
        }
    }
}
