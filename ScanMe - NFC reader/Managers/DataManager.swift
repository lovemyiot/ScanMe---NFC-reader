//
//  DataManager.swift
//  ScanMe - NFC reader
//
//  Created by Jacek Kopaczel on 01/08/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager {
    static let shared = DataManager()
    private let database: Firestore
    
    private init() {
        self.database = Firestore.firestore()
    }
    
    func fetchCommand(for identifier: String, from collectionName: String,completion: @escaping (Result<CommandDetailsResponse, FirestoreError>) -> Void) {
        let documentReference = database.collection(collectionName).document(identifier)
        documentReference.getDocument { documentSnapshot, error in
            let result = Result {
                try documentSnapshot?.data(as: CommandDetailsResponse.self)
            }
            switch result {
            case .success(let tagDetails):
                guard let details = tagDetails else {
                    completion(.failure(.documentNotExist))
                    return
                }
                completion(.success(details))
            case .failure(_):
                completion(.failure(.decodingError))
            }
        }
    }
}
