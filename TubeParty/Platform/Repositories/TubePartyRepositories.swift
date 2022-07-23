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

protocol TubePartyRepository {
    func sendMessage(newMessage: MessageModel)
    func getMessageList() -> Observable<[MessageModel]>
    func uploadProfileImage(image: UIImage, senderID: String) -> Observable<Percent>
    func updateUserProfile(userProfile: UserProfile) -> Observable<Void>
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
    
    func updateUserProfile(userProfile: UserProfile) -> Observable<Void> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.fireStore.collection("message_list")
                .whereField("sender_id", isEqualTo: userProfile.senderID)
                .getDocuments() { (querySnapshot, err) in
                    
                    if let error = err {
                        observer.onError(error)
                    }
                    
                    for exx in querySnapshot!.documents {
                        print("🔥exx.documentID : \(exx.documentID)")
                        exx.reference.updateData([
                            "profile_name": userProfile.name,
                            "profile_url": userProfile.profileURL
                        ])
                    }
                    observer.onNext(())
                }
            return Disposables.create()
        }
    }
    
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
    
    public func uploadProfileImage(image: UIImage, senderID: String) -> Observable<Percent> {
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self, let data = image.pngData() else { return Disposables.create() }
            
            let riversRef = self.storageRef.child("images/\(senderID).jpg")
            
            let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
                riversRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return observer.onError(error!) }
                    if var userProfile: UserProfile = UserDefaultsManager.get(by: .userProfile) {
                        userProfile.profileURL = downloadURL.absoluteString
                        UserDefaultsManager.set(userProfile, by: .userProfile)
                    }
                }
            }
            
            uploadTask.observe(.progress) { snapshot in
                if let totalUnitCount = snapshot.progress?.totalUnitCount,
                   let completedUnitCount = snapshot.progress?.completedUnitCount {
                    let onepercent = totalUnitCount / 100
                    let percent = completedUnitCount / onepercent
                    observer.onNext(Percent(percent))
                }
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

