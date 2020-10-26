//
//  Photo.swift
//  VK_client
//
//  Created by Зинде Иван on 8/17/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation
import RealmSwift

//Класс фото
class Photo: Object, Decodable{
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var photoSizeX : String = ""
    @objc dynamic var photoSizeM : String = ""
    @objc dynamic var photoSizeS : String = ""
    var photoSizeXHeight : Double = 0
    var photoSizeXWidth : Double = 0
    var photoSizeMHeight : Double = 0
    var photoSizeMWidth : Double = 0
    var photoSizeSHeight : Double = 0
    var photoSizeSWidth : Double = 0

    enum CodingKeys: String, CodingKey {
    case id
    case ownerID = "owner_id"
    case sizes
    }
    
    enum PhotoKeys: String, CodingKey {
    case height, url, type, width
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerID  = try values.decode(Int.self, forKey: .ownerID)
        
        var photosValues = try values.nestedUnkeyedContainer(forKey: .sizes)
       
        while !photosValues.isAtEnd {
            let photo = try photosValues.nestedContainer(keyedBy: PhotoKeys.self)
            let photoType = try photo.decode(String.self, forKey: .type)
            let photoURL = try photo.decode(String.self, forKey: .url)
            let photoHeight = try photo.decode(Double.self, forKey: .height)
            let photoWidth = try photo.decode(Double.self, forKey: .width)
            switch photoType {
            case "x":
                photoSizeX = photoURL
                photoSizeXHeight = photoHeight
                photoSizeXWidth = photoWidth
            case "s":
                photoSizeS = photoURL
                photoSizeSHeight = photoHeight
                photoSizeSWidth = photoWidth
            case "m":
                photoSizeM = photoURL
                photoSizeMHeight = photoHeight
                photoSizeMWidth = photoWidth
            default:
                continue
            }
        }
        
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

