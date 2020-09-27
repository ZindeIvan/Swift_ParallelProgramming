//
//  NewsOwner.swift
//  VK_client
//
//  Created by Зинде Иван on 9/26/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Протокол владельца новостей
protocol NewsOwner {
    var photo50: String {get}
    var name : String {get}
    var id : Int {get}
}
