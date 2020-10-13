//
//  NewsCell.swift
//  VK_client
//
//  Created by Зинде Иван on 7/25/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import UIKit

class NewsCell : UITableViewCell {
    
    @IBOutlet private weak var newsIconView : UIImageView!
    @IBOutlet private weak var newsOwner : UILabel!
    @IBOutlet private weak var newsDate : UILabel!
    @IBOutlet private weak var newsText : UILabel!
    @IBOutlet private weak var newsImage : UIImageView!
    @IBOutlet private weak var likeButton : UIButton!
    @IBOutlet private weak var commentButton : UIButton!
    @IBOutlet private weak var shareButton : UIButton!
    @IBOutlet private weak var likeLabel : UILabel!
    @IBOutlet private weak var watchedCountLabel : UILabel!
    @IBOutlet private weak var shareLabel : UILabel!
    @IBOutlet private weak var commentLabel : UILabel!
    @IBOutlet private weak var newsImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newsTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showMoreButton: UIButton!
    
    //Стандартная высота текстового поля
    private let newsTextHeightConstraintConst = CGFloat(95)
    
    var likeCount : Int = 0
    
    var delegate: NewsCellDelegate?
     
    //Свойство нажатия кнопки Показать больше
    var showMoreIsPressed : Bool = false{
        didSet {
            if showMoreIsPressed {
                let newsTextHeight = calculateLabelHeight(text: newsText.text ?? "", font: newsText.font)
                newsTextHeightConstraint.constant = CGFloat(newsTextHeight)
                showMoreButton.setTitle("Show less...", for: .normal)
                
            } else {
                newsTextHeightConstraint.constant = CGFloat(newsTextHeightConstraintConst)
                showMoreButton.setTitle("Show more...", for: .normal)
            }
        }
    }
    
    private var likePressed : Bool = false{
        didSet {
            
            if likePressed {
                //Увеличим количество лайков на 1
                likeCount += 1
                //Установим картинку заполненного сердца
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                //Изменим цвет элементов
                likeLabel.textColor = .red
                likeButton.tintColor = .red
            }
                //Если лайк отжат
            else {
                //Уменьшим количество лайков на 1
                likeCount -= 1
                //Установим картинку пустого сердца
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                //Изменим цвет элементов
                likeLabel.textColor = .gray
                likeButton.tintColor = .gray
            }
        }
        
    }

    //Метод нажатия лайка
    @IBAction private func likeButtonPressed(_ sender: Any) {
        likePressed = !likePressed
    }
    
    //Метод нажатия кнопки Показать больше/меньше
    @IBAction private func changeNewsTextHeight(_ sender: Any) {
        showMoreIsPressed = !showMoreIsPressed
        delegate?.showMoreButtonTapped(cell: self)
    }
    
    
    //Метод конфигурирования ячейки
    func configure(news: News){
        //Установим автора
        self.newsOwner.text = String(news.owner)
        //Установим текст новости
        self.newsText.text = news.text
        //Сконфигурируем высоту текстового поля новостей
        configureNewsTextHeight()
        //Установим дату новости
        self.newsDate.text = news.date
        //Установим количество просмотров
        self.watchedCountLabel.text = String(news.viewsCount)
        //Установим надпись лайков
        self.likeLabel.text = String(news.likesCount)
        self.commentLabel.text = String(news.commentsCount)
        self.shareLabel.text = String(news.repostsCount)
        //Сконфигурируем высоту изображения
        configureNewsImageHeight(photoWidth: news.photoSizeXWidth, photoHeight: news.photoSizeXHeight)
        //Установим картинку новости
        self.newsImage.sd_setImage(with: URL(string: news.photoSizeX), placeholderImage: UIImage(named: "newsImageError"))
        
        //Установим иконку новости
        self.newsIconView.sd_setImage(with: URL(string: news.photo50), placeholderImage: UIImage(named: "error"))
        //Установим количество лайков
        self.likeCount = news.likesCount
    }
    
    //Метод вычисления высоты текстового поля по содержимому
    private func calculateLabelHeight(text: String, font: UIFont) -> Double {
        let maxWidth = newsText.frame.width
        // получаем размеры блока под надпись
        // используем максимальную ширину и максимально возможную высоту
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        // получаем высоту блока, переводим её в Double
        let height = Double(rect.size.height)
        
        return ceil(height)
        
    }
    
    //Метод установки высоты текстового поля
    private func configureNewsTextHeight () {
        let newsTextHeight = calculateLabelHeight(text: newsText.text ?? "", font: newsText.font)
        if CGFloat(newsTextHeight) < newsTextHeightConstraintConst {
            newsTextHeightConstraint.constant = CGFloat(newsTextHeight)
            showMoreButton.isHidden = true
        } else {
            if showMoreIsPressed {
                newsTextHeightConstraint.constant = CGFloat(newsTextHeight)
            } else {
                newsTextHeightConstraint.constant = newsTextHeightConstraintConst
            }
            showMoreButton.isHidden = false
        }
    }
    
    //Метод установки высоты изображения
    private func configureNewsImageHeight (photoWidth: Double, photoHeight: Double) {
        var ratio: CGFloat = 1.0000
        if photoHeight != 0 {
            ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
        }
        newsImageHeightConstraint.constant = ceil(newsImage.frame.width / ratio)
    }
}

//Протокол делегатов ячейки новостей
protocol NewsCellDelegate {
    func showMoreButtonTapped(cell: NewsCell)
}
