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
    
    
    // MARK: Test method for saving new records in Firestore
    func addElement(collectionName: String, identifier: String) {
        let collection = database.collection(collectionName)
        var numberOfDocuments = 0
        collection.getDocuments { snapshot, error in
            if error != nil {
                print("Error fetching documents from Firestore: \(error!.localizedDescription).")
            }
            guard let count = snapshot?.documents.count else {
                print("No documents found in Firestore.")
                return
            }
            numberOfDocuments = count
            let documentReference = collection.document(identifier)
            documentReference.setData(["commandId" : numberOfDocuments + 1])
        }
    }
}
