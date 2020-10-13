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
    
    private var refreshControl : UIRefreshControl?
    
    //Массив новостей
    private var newsList : [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.prefetchDataSource = self
        //Зарегистрируем ячейку таблицы
        newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        newsTableView.rowHeight = UITableView.automaticDimension
        loadNewsFromNetwork(startFrom: "")
        setupRefreshControl()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//Расширение для работы с сетью
extension NewsTableViewController {
    //Метод загрузки списка новостей из сети
    private func loadNewsFromNetwork(startFrom : String, completion: (() -> Void)? = nil){
        NetworkService.shared.loadNews(startFrom: startFrom, token: Session.instance.token, filter: .post, newsCount: 20){ [weak self] result in
            switch result {
            case let .success(news):
                DispatchQueue.main.async {
                    self?.newsList = news
                    self?.newsTableView.reloadData()
                    completion?()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}

extension NewsTableViewController {
    
    private func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Цвет спиннера
        refreshControl?.tintColor = .red
        // И прикрепляем функцию, которая будет вызываться контролом
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        newsTableView.refreshControl = refreshControl
    }
    
    @objc func refreshNews() {
        // Начинаем обновление новостей
        self.refreshControl?.beginRefreshing()
        
        loadNewsFromNetwork(startFrom: "") {  [weak self] in
            self?.refreshControl?.endRefreshing()
        }
        
    }
}

//Расширения для предзагрузки новостей
extension NewsTableViewController : UITableViewDataSourcePrefetching {
    //Метод определяет нужно ли предзагружать новости
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row == (newsList.count - 3)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)) {
            //Jтправляем сетевой запрос загрузки новостей
            NetworkService.shared.loadNews(startFrom: Session.instance.nextFrom, token: Session.instance.token, filter: .post, newsCount: 20){ [weak self] result in
                switch result {
                case let .success(news):
                    DispatchQueue.main.async {
                        //Добавим новости в конец ленты
                        self?.newsList += news as [News]
                        self?.newsTableView.reloadData()
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

//Расширение для работы с увеличением высоты текстового поля ячейки
extension NewsTableViewController : NewsCellDelegate {
    //Метод срабатывает при нажатии кнопки ячейки ShowMore
    func showMoreButtonTapped(cell: NewsCell) {
        newsTableView.beginUpdates()
        newsTableView.endUpdates()
    }
    
}
