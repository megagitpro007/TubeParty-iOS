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

public typealias Percent = Int
public typealias ImageURL = URL
public typealias UploadImageResponse = (Percent, ImageURL?)

public enum UploadImageType: String {
    case profile = "avatars"
    case fromchat = "chatroom"
}

protocol TubePartyRepository {
    func sendMessage(newMessage: MessageModel) -> Observable<Void>
    func getMessageList() -> Observable<[MessageModel]>
    func updateUserProfile(userProfile: UserProfile) -> Single<Void>
    func uploadImage(image: UIImage, senderID: String, type: UploadImageType) -> Observable<UploadImageResponse>
}

public class TubePartyRepositoryImpl: TubePartyRepository {
    
    let fireStore: Firestore
    let firebaseStorage: Storage
    let storageRef: StorageReference
    var ref: DocumentReference? = nil
    
    init(fireStore: Firestore = Firestore.firestore()) {
        self.fireStore = fireStore
        firebaseStorage = Storage.storage()
        storageRef = firebaseStorage.reference()
    }
    
    // should to be Single<T>
    func updateUserProfile(userProfile: UserProfile) -> Single<Void> {
        return Single.create { [weak self] prom in
            self?.fireStore.collection("message_list")
                .whereField("sender_id", isEqualTo: userProfile.senderID)
                .getDocuments() { (querySnapshot, err) in
                    guard let querySnapshot = querySnapshot, err == nil else {
                        if let error = err {
                            prom(.failure(error))
                        }
                        return
                    }
                    
                    for exx in querySnapshot.documents {
                        exx.reference.updateData([
                            "profile_name": userProfile.name,
                            "profile_url": userProfile.profileURL
                        ])
                    }
                    
                    prom(.success(()))
                }
            return Disposables.create()
        }
    }
    
    public func sendMessage(newMessage: MessageModel) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            self.ref = self.fireStore.collection("message_list")
                .addDocument(data: newMessage.toJSON()) { error in
                    if let error = error  {
                        observer.onError(error)
                    } else {
                        observer.onNext(())
                    }
                }
            return Disposables.create()
        }
    }
    
    public func getMessageList() -> Observable<[MessageModel]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.fireStore.collection("message_list").addSnapshotListener { query, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    
// TODO: - convert for to map
//                    var messageList: [MessageModel] = []
//                    for document in query!.documents {
//                        let dict = document.data()
//                        let decoder = JSONDecoder()
//                        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
//                              let newObject = try? decoder.decode(MessageModel.self, from: jsonData) else { return }
//                        messageList.append(newObject)
//                    }
                    
                    guard let document = query?.documents else { return }
                    let newData: [MessageModel] = document.compactMap {
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: $0.data(), options: .prettyPrinted),
                              let newObject = try? JSONDecoder().decode(MessageModel.self, from: jsonData) else { return nil }
                        return newObject
                    }
                    
                    observer.onNext(newData)
                }
            }
            return Disposables.create()
        }
    }
    
    public func uploadImage(image: UIImage, senderID: String, type: UploadImageType) -> Observable<UploadImageResponse> {
        return Observable.create { [weak self] observer -> Disposable in
            
            guard let self = self, let data = image.pngData() else { return Disposables.create() }
            
            let storageRef = self.storageRef.child("\(type.rawValue)/\(senderID).jpg")
            var percent: Int64 = 0
            let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return observer.onError(error!) }
                    observer.onNext((Percent(percent), downloadURL))
                }
            }
            
            uploadTask.observe(.progress) { snapshot in
                guard let total = snapshot.progress?.totalUnitCount,
                      let completed = snapshot.progress?.completedUnitCount else { return }
                percent = completed * 100 / total
                observer.onNext((Percent(percent), nil))
                if percent == 100 {
                    observer.onCompleted()
                }
            }
            
            uploadTask.observe(.failure) { error in
                guard let error = error.error else { return }
                observer.onError(error)
            }
            
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

