//
//  ImageCacheService.swift
//  VK_client
//
//  Created by Зинде Иван on 10/5/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import Foundation
import Alamofire

//Класс для кеширования изображений из сети в таблицах или коллекциях
class ImageCacheService {
    
    //Свйоство ссесии Alomofire
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    //Свойство жизненного цикла кэша
    private let cacheLifeTime : TimeInterval = 60 * 60 * 24
    
    //Свойство изображений в оперативной памяти
    private var images = [String: UIImage]()
    
    //Свойство контейнер таблица или коллекция
    private let container: DataReloadable
    
    //Конструктор на основании таблицы
    init(container: UITableView) {
        self.container = Table(tableView: container)
    }
    
    //Конструктор на основании коллекции
    init(container: UICollectionView) {
        self.container = Collection(collectionView: container)
    }
    
    //Вычисляемое свойство пути к кэшу
    private static let pathName : String = {
        //Установим путь
        let pathName = "images"
        //Получим путь к кэшу по умолчанию
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        //Добавим путь к кешу для стандартного пути
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        //Если данная дериктория не существует - попробуем ее создать
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        //Возвращаем путь к дериктории кэша
        return pathName
        
    }()
    
    //Метод получения пути к файлу
    private func getFilePath(url: String) -> String? {
        //Получим путь к кэшу по умолчанию
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        //Получим имя файла из всего пути
        let cacheName = url.split(separator: "/").last ?? "default"
        //Вернем весь путь до файла
        return cachesDirectory.appendingPathComponent(ImageCacheService.pathName + "/" + cacheName).path
    }
    
    //Метод сохраенения изображения в кэше
    private func saveImageInCache(url :String, image: UIImage){
        //Получим путь и данные изображения
        guard let fileLocalPath = getFilePath(url: url),
            let data = image.pngData()
            else { return }
        //Сохраним изображение
        FileManager.default.createFile(atPath: fileLocalPath, contents: data, attributes: nil)
    }
    
    //Метод получения изображения из кэша
    private func getImageFromCache(url : String) -> UIImage? {
        //Получим путь до файла и дату изменения файла
        guard let fileLocalPath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileLocalPath),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else {
                return nil
        }
        //Вычислим время которое прошло с изменения файла
        let lifeTime = Date().timeIntervalSince(modificationDate)
        //Если время меньше чем жизненный цикл кэша получим изображение
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileLocalPath)
            else {
                return nil
        }
        //Запишем изображение в оперативную память
        DispatchQueue.main.async { [weak self] in
            self?.images[url] = image
        }
        //Вернем изображение
        return image
    }
    
    //Метод загрузки фото из сети
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        //Загрузим фото из сети по ссылке
        ImageCacheService.session.request(url).responseData(
            queue: DispatchQueue.global(),
            completionHandler: { [weak self] response in
                guard let data = response.data,
                    let image = UIImage(data: data)
                    else  {
                        return
                }
                //Запишем фото в оперативную память
                DispatchQueue.main.async { [weak self] in
                    self?.images[url] = image
                }
                //Сохраним изображение в кэше
                self?.saveImageInCache(url: url, image: image)
                //Перезагрузим элемент контейнера
                DispatchQueue.main.async { [weak self] in
                    self?.container.reloadRow(atIndexPath: indexPath)
                }
            }
        )
    }
    
    //Метод получения изображения вне класса
    func getPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        //Получим изображения
        //  проверим есть ли данное изображение в оперативной памяти
        if let photo = images[url] {
            #if DEBUG
            print("\(url) : ОПЕРАТИВНАЯ ПАМЯТЬ")
            #endif
            image = photo
        //  проверим есть ли данное изображение в кэше
        } else if let photo = getImageFromCache(url: url) {
            #if DEBUG
            print("\(url) : ФИЗИЧЕСКАЯ ПАМЯТЬ")
            #endif
            image = photo
        //  загрузим изображение из сети
        } else {
            #if DEBUG
            print("\(url) : ЗАГРУЗКА ИЗ СЕТИ")
            #endif
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        
        return image
    }
}

//Расширение для работы с контейнерами
extension ImageCacheService {
    
    private class Table: DataReloadable {
        
        let tableView: UITableView
        
        init(tableView: UITableView) {
            self.tableView = tableView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    private class Collection: DataReloadable {
        
        let collectionView: UICollectionView
        
        init(collectionView: UICollectionView) {
            self.collectionView = collectionView
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collectionView.reloadItems(at: [indexPath])
        }
        
    }
    
}
