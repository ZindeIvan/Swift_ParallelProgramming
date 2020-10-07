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
    @IBOutlet private weak var newsTableView : UITableView!
    
    //Массив новостей
    private var newsList : [News] = []
    
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
        //Сконфигурируем ячейку
        cell.configure(news: newsList[indexPath.row])
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 615
    }

    
}

//Расширение для работы с сетью
extension NewsTableViewController {
    //Метод загрузки списка новостей из сети
    private func loadNewsFromNetwork(){
        NetworkService.shared.loadNews(token: Session.instance.token, filter: .post, newsCount: 10){ [weak self] result in
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

