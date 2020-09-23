//
//  NewsTableViewController.swift
//  VK_client
//
//  Created by Зинде Иван on 7/25/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import UIKit
import SDWebImage

//Класс экрана новостей
class NewsTableViewController : BaseViewController {

    //Таблица новостей
    @IBOutlet weak var newsTableView : UITableView!
    
    //Массив новостей
    private var newsList : [News] = [
    
//        News(newsID: "news1", newsWatchedCount: 1321, likeCount: 32, newsOwner: "Daly planet", newsDate:  "12.05.2020", newsText: "The object, known as Comet, was discovered by an instrument floating in space and it is falling towards the Earth. As it gets closer, the comet should be visible in the Southern Hemisphere just before sunrise, without any equipment."),
//        News(newsID: "news2", newsWatchedCount: 200, likeCount: 88, newsOwner: "Justice Society of America", newsDate:  "15.04.2020", newsText: "Justice Society of America held anual veteran meeting"),
//        News(newsID: "news3", newsWatchedCount: 5820, likeCount: 588, newsOwner: "Teen titans", newsDate:  "10.02.2020", newsText: "Teen titans are looking for new talants. You can send your C.V. to tt@wayneenterprises.com")
    
    ]
    //Свойство содержащее ссылку на класс работы с сетевыми запросами
    let networkService = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        //Зарегистрируем ячейку таблицы
        newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        newsTableView.rowHeight = UITableView.automaticDimension
        loadNewsFromNetwork()
    }
    
}

extension NewsTableViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Возвращаем количество строк таблицы
        newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else { fatalError() }
        //Установим автора
        cell.newsOwner.text = String(newsList[indexPath.row].ownerID)
        //Установим текст новости
        cell.newsText.text = newsList[indexPath.row].text
        //Установим дату новости
        cell.newsDate.text = newsList[indexPath.row].localDate
        //Установим количество просмотров
        cell.watchedCountLabel.text = String(newsList[indexPath.row].viewsCount)
        //Установим надписьлайков
        cell.likeLabel.text = String(newsList[indexPath.row].likesCount)
        cell.commentLabel.text = String(newsList[indexPath.row].commentsCount)
        cell.shareLabel.text = String(newsList[indexPath.row].repostsCount)
        //Установим иконку новости
        cell.newsImage.sd_setImage(with: URL(string: newsList[indexPath.row].photoSizeM), placeholderImage: UIImage(named: "error"))
        //Установим картинку новости
//        cell.newsImage.image = UIImage(named: newsList[indexPath.row].newsID + "_image")
        //Установим количество лайков
        cell.likeCount = newsList[indexPath.row].likesCount
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 615
    }

    
}

//Расширение для работы с сетью
extension NewsTableViewController {
    //Метод загрузки списка групп из сети в базу
    func loadNewsFromNetwork(){
        networkService.loadNews(token: Session.instance.token, filter: .post, newsCount: 5){ [weak self] result in
            switch result {
            case let .success(news):
                DispatchQueue.main.async {
                    //Сохраним полученные данные в Realm
                    self?.newsList = news
                    self?.newsTableView.reloadData()
                }
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

