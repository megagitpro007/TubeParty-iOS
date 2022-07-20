//
//  TubePartyRepositories.swift
//  TubeParty
//
//  Created by iZE Appsynth on 12/7/2565 BE.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseStorage

protocol TubePartyRepository {
    func sendMessage(newMessage: MessageModel)
    func getMessageList() -> Observable<[MessageModel]>
    func uploadFile(storageRef: StorageReference, image: UIImage, senderID: String) -> Observable<StorageUploadTask>
}

public class TubePartyRepositoryImpl: TubePartyRepository {
    
    private let fireStore: Firestore
    private var ref: DocumentReference? = nil
    
    init(fireStore: Firestore = Firestore.firestore()) {
        self.fireStore = fireStore
    }
    
    // TODO - need to return error state for handle on scene
    public func sendMessage(newMessage: MessageModel) {
        self.ref = self.fireStore.collection("message_list")
            .addDocument(data: newMessage.toJSON()) { error in
                if let error = error  {
                    print("🔥 \(error.localizedDescription)")
                } else {
                    print("🔥 update success")
                }
            }
    }
    
    public func getMessageList() -> Observable<[MessageModel]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.fireStore.collection("message_list").addSnapshotListener { query, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    var messageList: [MessageModel] = []
                    for document in query!.documents {
                        let dict = document.data()
                        let decoder = JSONDecoder()
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                              let newObject = try? decoder.decode(MessageModel.self, from: jsonData) else { return }
                        messageList.append(newObject)
                    }
                    observer.onNext(messageList)
                }
            }
            return Disposables.create()
        }
    }
    
    func uploadFile(storageRef: StorageReference, image: UIImage, senderID: String) -> Observable<StorageUploadTask> {
        
        return Observable.create { observer -> Disposable in
            guard let data = image.pngData() else { return Disposables.create() }
            let riversRef = storageRef.child("images/\(senderID).jpg")
            let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else { return }
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                }
            }
            observer.onNext(uploadTask)
            return Disposables.create()
        }
    }
    
}


//
//public protocol TubePartyRepositoryProtocol {
//    func getMessageList() -> Observable<[MessageModel]>
//}
//
//public class TubePartyRepository: BaseFirebaseRepository, TubePartyRepositoryProtocol {
//
//    public func getMessageList() -> Observable<[MessageModel]> {
//        return self.getDocumentsListener(collection: "message_list")
//    }
//
//}
//
//open class BaseFirebaseRepository {
//
//    private let fireStore: Firestore
//
//    init(fireStore: Firestore = Firestore.firestore()) {
//        self.fireStore = fireStore
//    }
//
//    open func getDocuments<T: Decodable>(collection: String) -> Observable<[T]> {
//        return Observable<[T]>.create { observer in
//            self.fireStore.collection(collection).getDocuments { snapshot, error in
//                guard let snapshot = snapshot else {
//                    observer.onError(error!)
//                    return
//                }
//                let datas: [T] = snapshot.documents.compactMap { document -> T? in
//                    guard
//                        let json = try? JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted),
//                        let object = try? JSONDecoder().decode(T.self, from: json)
//                    else { return nil }
//                    return object
//                }
//                observer.onNext(datas)
//            }
//            return Disposables.create()
//        }
//    }
//
//    open func getDocumentsListener<T: Decodable>(collection: String) -> Observable<[T]> {
//        return Observable<[T]>.create { observer in
//            self.fireStore.collection(collection).addSnapshotListener { snapshot, error in
//                guard let snapshot = snapshot else {
//                    observer.onError(error!)
//                    return
//                }
//                let datas: [T] = snapshot.documents.compactMap { document -> T? in
//                    guard
//                        let json = try? JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted),
//                        let object = try? JSONDecoder().decode(T.self, from: json)
//                    else { return nil }
//                    return object
//                }
//                observer.onNext(datas)
//            }
//            return Disposables.create()
//        }
//    }
//}

