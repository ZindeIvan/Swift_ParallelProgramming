//
//  News.swift
//  VK_client
//
//  Created by Зинде Иван on 7/25/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Класс Новости для разбора ответа сервера
class NewsItems :  Decodable{
    //Идентификатор новости
    var id : Int = 0
    //Количество просмотров
    var viewsCount : Int = 0
    //Количество отметок Нравится
    var likesCount : Int = 0
    //Количество репостов
    var repostsCount : Int = 0
    //Количество комментариев
    var commentsCount : Int = 0
    //Фото новости
    var photoSizeX : String = ""
    var photoSizeM : String = ""
    var photoSizeS : String = ""
    //Идентификатор новости (если с "-" то группы в противном случае пользователь)
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
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
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
            //Получим только первую картинку
            break
        }
        
    }
    
}

//Класс владельца новостей типа Пользователь для разбора ответа сервера
class NewsProfiles :  Decodable, NewsOwner{
    var id : Int = 0
    var firstName : String = ""
    var lastName : String = ""
    var photo50 : String = ""
    var name : String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        self.name = "\(self.firstName) \(self.lastName)"
    }
}

//Класс владельца новостей типа Группа для разбора ответа сервера
class NewsGroups :  Decodable, NewsOwner{
    var id : Int = 0
    var name : String = ""
    var photo50 : String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name
        
        case photo50 = "photo_50"
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        
    }
}

//Протокол владельца новостей
protocol NewsOwner {
    var photo50: String {get}
    var name : String {get}
    var id : Int {get}
}

//Класс новостей
class News {
    //Количество просмотров
    var viewsCount : Int = 0
    //Количество лайков
    var likesCount : Int = 0
    //Количество репостов
    var repostsCount : Int = 0
    //Количество комментариев
    var commentsCount : Int = 0
    //Фото
    var photoSizeX : String = ""
    var photoSizeM : String = ""
    var photoSizeS : String = ""
    //Дата
    var date : String = ""
    //Текст новости
    var text : String?
    //Имя владельца новости
    var owner : String = ""
    //Фото владельца новости
    var photo50 : String = ""
    //Идентификатор владельца новости
    var ownerID : Int = 0
    //Тип владельца новости
    var ownerType : OwnerType?
    
    enum OwnerType {
        case group, user
    }
    
    //Конструктор по ответу сервера и владельцу новости
    init(item : NewsItems, owner : NewsOwner) {
        self.viewsCount = item.viewsCount
        self.likesCount = item.likesCount
        self.repostsCount = item.repostsCount
        self.commentsCount = item.commentsCount
        self.photoSizeX = item.photoSizeX
        self.photoSizeM = item.photoSizeM
        self.photoSizeS = item.photoSizeS
        self.date = item.localDate
        self.text = item.text
        
        self.owner  = owner.name
        self.ownerID = owner.id
        self.photo50 = owner.photo50
        
        if item.ownerID < 0 {
            self.ownerType = .group
        } else {
            self.ownerType = .user
        }
    }
    
}
