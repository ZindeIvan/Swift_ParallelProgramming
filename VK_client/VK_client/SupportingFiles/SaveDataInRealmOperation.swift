//
//  SaveDataInRealmOperation.swift
//  VK_client
//
//  Created by Зинде Иван on 9/27/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Класс операции сохранения данных в Realm
class SaveDataInRealmOperation : Operation {
    
    override func main() {
        guard let parseData = dependencies.first as? ParseGroupDataOperation else {
            return
        }
        try? RealmService.shared?.saveInRealm(objects: parseData.outputData)
    }
}
