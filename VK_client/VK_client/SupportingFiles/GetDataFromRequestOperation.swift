//
//  GetDataFromRequestOperation.swift
//  VK_client
//
//  Created by Зинде Иван on 9/27/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation
import Alamofire

//Класс операции получения данных из сети
class GetDataFromRequestOperation: AsyncOperation {

    private var request: DataRequest

    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}
