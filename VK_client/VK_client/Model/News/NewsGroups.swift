//
//  NewsGroups.swift
//  VK_client
//
//  Created by Зинде Иван on 9/26/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

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
