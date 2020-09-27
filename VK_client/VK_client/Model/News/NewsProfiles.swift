//
//  NewsProfiles.swift
//  VK_client
//
//  Created by Зинде Иван on 9/26/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

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
