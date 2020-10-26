//
//  AsyncDisplayKitPhotoNode.swift
//  VK_client
//
//  Created by Зинде Иван on 10/26/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import AsyncDisplayKit

//Класс ячейки фото друга
class AsyncFriendPhotoNode: ASCellNode {
    let imageNode = ASNetworkImageNode()
    var ratio : CGFloat = 0
    
    required init(with photo: Photo) {
        super.init()
        imageNode.url = URL(string: photo.photoSizeX)!
        ratio = CGFloat(photo.photoSizeXHeight)/CGFloat(photo.photoSizeXWidth)
        imageNode.contentMode = .scaleAspectFill
        self.addSubnode(self.imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec { 
        let width = constrainedSize.max.width
        imageNode.style.preferredSize = CGSize(width: width, height: width * ratio)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
