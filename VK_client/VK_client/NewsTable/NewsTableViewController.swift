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
    private var newsList : [News] = []
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
        cell.newsOwner.text = String(newsList[indexPath.row].owner)
        //Установим текст новости
        cell.newsText.text = newsList[indexPath.row].text
        //Установим дату новости
        cell.newsDate.text = newsList[indexPath.row].date
        //Установим количество просмотров
        cell.watchedCountLabel.text = String(newsList[indexPath.row].viewsCount)
        //Установим надписьлайков
        cell.likeLabel.text = String(newsList[indexPath.row].likesCount)
        cell.commentLabel.text = String(newsList[indexPath.row].commentsCount)
        cell.shareLabel.text = String(newsList[indexPath.row].repostsCount)
        //Установим картинку новости
        cell.newsImage.sd_setImage(with: URL(string: newsList[indexPath.row].photoSizeX), placeholderImage: UIImage(named: "newsImageError"))
        //Установим иконку новости
        cell.newsIconView.sd_setImage(with: URL(string: newsList[indexPath.row].photo50), placeholderImage: UIImage(named: "error"))
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
    //Метод загрузки списка новостей из сети
    func loadNewsFromNetwork(){
        networkService.loadNews(token: Session.instance.token, filter: .post, newsCount: 10){ [weak self] result in
            switch result {
            case let .success(news):
                DispatchQueue.main.async {
                    self?.newsList = news
                    self?.newsTableView.reloadData()
                }
            case let .failure(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

