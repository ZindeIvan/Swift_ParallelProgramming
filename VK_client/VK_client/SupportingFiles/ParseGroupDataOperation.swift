//
//  ParseGroupDataOperation.swift
//  VK_client
//
//  Created by Зинде Иван on 9/27/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Класс операции парсинга данных групп из сети
class ParseGroupDataOperation : Operation {
    
    var outputData : [Group] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataFromRequestOperation,
            let data = getDataOperation.data,
            let items = try? JSONDecoder().decode(ServerResponse<Group>.self, from: data).response.items
            else {
                return
        }
        outputData = items
    }
}
