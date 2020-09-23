//
//  News.swift
//  VK_client
//
//  Created by Зинде Иван on 7/25/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Класс Новости
class News :  Decodable{
    //Идентификатор новости
    var id : Int = 0
    //Количество просмотров
    var viewsCount : Int = 0
    //Количество отметок Нравится
    var likesCount : Int = 0
    var repostsCount : Int = 0
    var commentsCount : Int = 0
    var photoSizeX : String = ""
    var photoSizeM : String = ""
    var photoSizeS : String = ""
    //Автор новости
    var ownerID : Int = 0
    //Дата Новости
    var unixDate : Double = 0
    var localDate : String = ""
    //Текст Новости
    var text : String?
    
    enum CodingKeys: String, CodingKey {
        case date, text, comments, likes, reposts, views, attachments
        case id = "post_id"
        case ownerID = "source_id"
    }
    
    enum CountKeys : String, CodingKey {
        case count
    }
    
    enum AttachmentsKeys : String, CodingKey {
        case type, photo
    }
    
    enum PhotoKeys : String, CodingKey {
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case height, url, type, width
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.unixDate = try values.decode(Double.self, forKey: .date)
        
        let date = Date(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        self.localDate = dateFormatter.string(from: date)
        
        self.text = try? values.decode(String.self, forKey: .text)
        self.ownerID = try values.decode(Int.self, forKey: .ownerID)
        
        let commentsValues = try? values.nestedContainer(keyedBy: CountKeys.self, forKey : .comments)
        self.commentsCount = try commentsValues?.decode(Int.self, forKey: .count) ?? 0
        
        let repostsValues = try? values.nestedContainer(keyedBy: CountKeys.self, forKey : .reposts)
        self.repostsCount = try repostsValues?.decode(Int.self, forKey: .count) ?? 0
        
        let likesValues = try? values.nestedContainer(keyedBy: CountKeys.self, forKey : .likes)
        self.likesCount = try likesValues?.decode(Int.self, forKey: .count) ?? 0
        
        let viewsValues = try? values.nestedContainer(keyedBy: CountKeys.self, forKey : .views)
        self.viewsCount = try viewsValues?.decode(Int.self, forKey: .count) ?? 0
        
        guard var attachmentsArray = try? values.nestedUnkeyedContainer(forKey: .attachments) else {return}
        
        while !attachmentsArray.isAtEnd {
            let attachmentsValues = try attachmentsArray.nestedContainer(keyedBy: AttachmentsKeys.self)
            let attachmentsType = try attachmentsValues.decode(String.self, forKey: .type)
            if attachmentsType != AttachmentsKeys.photo.rawValue {
                continue
            }
            else {
                let photoValues = try attachmentsValues.nestedContainer(keyedBy: PhotoKeys.self, forKey : .photo)
                var sizeArray = try photoValues.nestedUnkeyedContainer(forKey: .sizes)
                while !sizeArray.isAtEnd {
                    let photo = try sizeArray.nestedContainer(keyedBy: SizesKeys.self)
                    let photoType = try photo.decode(String.self, forKey: .type)
                    let photoURL = try photo.decode(String.self, forKey: .url)
                    switch photoType {
                    case "x":
                        self.photoSizeX = photoURL
                    case "s":
                        self.photoSizeS = photoURL
                    case "m":
                        self.photoSizeM = photoURL
                    default:
                        continue
                    }
                }
                
            }
            break
        }
        
    }
    
}
