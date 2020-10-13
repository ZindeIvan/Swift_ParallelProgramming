//
//  NetworkService.swift
//  VK_client
//
//  Created by Зинде Иван on 8/12/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


//Класс для работы с сетевыми запросами
class NetworkService {
    //Свойство основной ссылки на API
    private let baseURL : String = "https://api.vk.com"
    //Свойство версии API
    private let apiVersion : String = "5.124"
    
    static let shared = NetworkService()
    
    private init(){}
    
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    //Перечисление типов альбомов фото пользователей
    enum AlbumID : String {
        case wall = "wall"
        case profile = "profile"
        case saved = "saved"
    }
    
    enum NewsfeedFilters : String {
        case post = "post"
        case photo = "photo"
    }
    
    //Метод формирования сетевого запроса и вывода результата в кансоль
    private func networkRequest<T: Decodable>( type : T.Type, URL : String, method : HTTPMethod, parameters : Parameters, completion: ((Swift.Result<[Any], Error>) -> Void)? = nil){
        
        AF.request(URL, method: method, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(let data):
                
                do {
                    let items = try JSONDecoder().decode(ServerResponse<T>.self, from: data).response.items
                    
                    completion?(.success(items))
                } catch {
                    completion?(.failure(error))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
            
        }
    }
    
    //Метод загрузки друзей пользователя
    func loadFriends(token: String, completion: ((Swift.Result<[User], Error>) -> Void)? = nil){
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "user_id" : Session.instance.userID,
            "order": "name",
            "count" : 20,
            "offset" : 0,
            "fields" : "photo_50",
            "v": apiVersion
        ]
        
        networkRequest( type: User.self, URL: baseURL + path, method: .get, parameters: params) { result in
            
            switch result {
            case let .success(users):
                completion?(.success(users as! [User]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
            
        }
        
    }
    
    //Метод загрузки друзей пользователя через Promise
    func loadFriendsPromise(token: String, usersCount: Int)-> Promise<[User]> {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "user_id" : Session.instance.userID,
            "order": "name",
            "count" : usersCount,
            "offset" : 0,
            "fields" : "photo_50",
            "v": apiVersion
        ]
        
        return Promise { resolver in
            networkRequest( type: User.self, URL: baseURL + path, method: .get, parameters: params) { result in
                
                switch result {
                case let .success(users):
                    resolver.fulfill(users as! [User])
                case let .failure(error):
                    print(error.localizedDescription)
                    resolver.reject(error)
                }
                
            }
        }
    }
    
    //Метод загрузки групп пользователя
    func loadGroups(token: String, completion: ((Swift.Result<[Group], Error>) -> Void)? = nil){
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "count" : 10,
            "v": apiVersion
        ]
        
        networkRequest( type: Group.self, URL: baseURL + path, method: .get, parameters: params){ result in
            
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [Group]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
            
        }
        
    }
    
    //Метод получения запроса групп пользователя
    func getGroupsRequest(token: String, groupsCount : Int)-> DataRequest{
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "extended": 1,
            "count" : groupsCount,
            "v": apiVersion
        ]
        
        return AF.request(baseURL + path, method: .get, parameters: parameters)
        
    }
    
    //Метод поиска групп
    func groupsSearch(token: String, searchQuery : String?, completion: ((Swift.Result<[Group], Error>) -> Void)? = nil){
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchQuery ?? "",
            "sort" : 2,
            "offset" : 0,
            "count" : 20,
            "v": apiVersion
        ]
        
        networkRequest( type: Group.self, URL: baseURL + path, method: .get, parameters: params){ result in
            
            
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [Group]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
            
        }
        
    }
    
    //Метод загрузки фото пользователя
    func loadPhotos(token: String, ownerID : Int, albumID : AlbumID, photoCount : Int,completion: ((Swift.Result<[Photo], Error>) -> Void)? = nil) {
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id" : ownerID,
            "album_id": albumID.rawValue,
            "rev" : 1,
            "offset" : 0,
            "count" : photoCount,
            "v": apiVersion
        ]
        
        networkRequest( type: Photo.self, URL: baseURL + path, method: .get, parameters: params){ result in
            
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [Photo]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
            
        }
        
    }
    
    //Метод загрузки новостей пользователя
    func loadNews(startFrom : String, token: String, filter : NewsfeedFilters, newsCount : Int, completion: ((Swift.Result<[News], Error>) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filter" : filter.rawValue,
            "start_from": startFrom,
            "count" : newsCount,
            "v": apiVersion
        ]
        
        networkNewsRequest(URL: baseURL + path, method: .get, parameters: params){ result in
            
            switch result {
            case let .success(news):
                completion?(.success(news))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
            
        }
        
    }
    
    //Метод разбора ответа запроса новостей с сервера
    private func networkNewsRequest(URL : String, method : HTTPMethod, parameters : Parameters, completion: ((Swift.Result<[News], Error>) -> Void)? = nil){
        
        AF.request(URL, method: method, parameters: parameters).responseData { response in
            
            switch response.result {
                
            case .success(let data):
                
                var newsItems : [NewsItems]?
                var groups : [NewsGroups]?
                var profiles : [NewsProfiles]?
                var nextFrom : String?
                
                let jsonParseGroup = DispatchGroup()
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    do {
                        let itemsresponse = try JSONDecoder().decode(ServerNewsResponse.self, from: data).response?.items
                        newsItems = itemsresponse
                    } catch {
                        completion?(.failure(error))
                    }
                }
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    do {
                        let groupsresponse = try JSONDecoder().decode(ServerNewsResponse.self, from: data).response?.groups
                        groups = groupsresponse
                    } catch {
                        completion?(.failure(error))
                    }
                }
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    do {
                        let profilesresponse = try JSONDecoder().decode(ServerNewsResponse.self, from: data).response?.profiles
                        profiles = profilesresponse
                    } catch {
                        completion?(.failure(error))
                    }
                }
                
                DispatchQueue.global().async(group: jsonParseGroup) {
                    do {
                        let nextFromresponse = try JSONDecoder().decode(ServerNewsResponse.self, from: data).response?.next_from
                        nextFrom = nextFromresponse
                    } catch {
                        completion?(.failure(error))
                    }
                }
                
                jsonParseGroup.notify(queue: DispatchQueue.main) {
                    guard let news = newsItems else {return}
                    var newsResult : [News] = []
                    for element in news {
                        if element.ownerID < 0 {
                            guard let group = groups?.filter({$0.id == -element.ownerID}).first else {continue}
                            newsResult.append(News(item: element, owner: group))
                        } else {
                            guard let user = profiles?.filter({$0.id == element.ownerID}).first else {continue}
                            newsResult.append(News(item: element, owner: user))
                        }
                    }
                    Session.instance.nextFrom = nextFrom ?? ""
                    completion?(.success(newsResult))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
            
        }
    }
    
}

class ServerResponse<T: Decodable> : Decodable {
    var response : Response<T>
}

class Response<T: Decodable> : Decodable {
    var count : Int = 0
    var items : [T] = []
}

class ServerNewsResponse : Decodable {
    var response : NewsResponse?
}

class NewsResponse : Decodable{
    var items : [NewsItems] = []
    var profiles : [NewsProfiles] = []
    var groups : [NewsGroups] = []
    var next_from : String = ""
    
    
}

