//
//  AsyncDisplayKitFriendsPhotoCcollection.swift
//  VK_client
//
//  Created by Зинде Иван on 10/26/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation
import AsyncDisplayKit

//Класс для отображения альбома пользователя
class AsyncFriendsPhotoCollectionViewController : ASDKViewController<ASCollectionNode> {
    //Свойство для хранения текущего ID друга
    var friendID : Int?
    //Свойство для хранения коллеции фото
    var photos = [Photo]()
    //Свойство количество фото для отображения
    private var photoCount : Int = 4
    //Свойство содержащее ссылку на класс работы с сетевыми запросами
    private let networkService = NetworkService.shared
    //Коллекция 
    let collectionNode: ASCollectionNode
    
    override init() {
        collectionNode = ASCollectionNode(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)
        collectionNode.backgroundColor = .systemBackground
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhotosFromNetwork()
    }
    
}


extension AsyncFriendsPhotoCollectionViewController {
    //Метод загрузки фото из сети
    private func loadPhotosFromNetwork(){
        networkService.loadPhotos(token: Session.instance.token, ownerID: friendID ?? 0, albumID: .profile, photoCount: photoCount){ [weak self] result in
            switch result {
            case let .success(photos):
                DispatchQueue.main.async {
                    self?.photos = photos
                    self?.collectionNode.reloadData()
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension AsyncFriendsPhotoCollectionViewController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode,
                        constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let size = CGSize(width: (view.frame.size.width / 4),
                          height: (view.frame.size.width / 4))
        let range = ASSizeRange(min: size,
                                max: size)
        return range
    }
}

extension AsyncFriendsPhotoCollectionViewController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode,
                        nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photo = photos[indexPath.row]
        return {
            return AsyncFriendPhotoNode(with: photo)
        }
    }
    
}

