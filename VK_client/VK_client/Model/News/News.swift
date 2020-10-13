//
//  News.swift
//  VK_client
//
//  Created by Зинде Иван on 7/25/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

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
    var photoSizeXHeight : Double = 0
    var photoSizeXWidth : Double = 0
    var photoSizeM : String = ""
    var photoSizeMHeight : Double = 0
    var photoSizeMWidth : Double = 0
    var photoSizeS : String = ""
    var photoSizeSHeight : Double = 0
    var photoSizeSWidth : Double = 0
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
        self.photoSizeXHeight = item.photoSizeXHeight
        self.photoSizeXWidth = item.photoSizeXWidth
        self.photoSizeM = item.photoSizeM
        self.photoSizeMHeight = item.photoSizeMHeight
        self.photoSizeMWidth = item.photoSizeMWidth
        self.photoSizeS = item.photoSizeS
        self.photoSizeSHeight = item.photoSizeSHeight
        self.photoSizeSWidth = item.photoSizeSWidth
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
