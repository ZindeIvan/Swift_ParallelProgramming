//
//  DataReloadable.swift
//  VK_client
//
//  Created by Зинде Иван on 10/5/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation

//Протокол для контейнеров кэша
protocol DataReloadable {
    
    func reloadRow(atIndexPath indexPath: IndexPath)
    
}
