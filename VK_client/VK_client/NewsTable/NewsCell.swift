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
    
    var likeCount : Int = 0{
        didSet {
            //Обновим количество лайков
            //Зададим анимацию смены текста
            let animationType : AnimationOptions
            //Если старое значение меньше - справа и слева в обратном случае
            if  oldValue < likeCount {
                animationType = .transitionFlipFromRight
            }
            else {
                animationType = .transitionFlipFromLeft
            }
            //Зададим анимацию смены текста
            UIView.transition(with: self.likeLabel,
                              duration: 0.5,
                              options: animationType,
                              animations: {
                                self.likeLabel.text = String(self.likeCount)
            })
        }
    }
    //Метод нажатия лайка
    @IBAction func likeButtonPressed(_ sender: Any) {
        likePressed = !likePressed
    }
    
    //Метод конфигурирования ячейки
    func configure(news: News){
        //Установим автора
        self.newsOwner.text = String(news.owner)
        //Установим текст новости
        self.newsText.text = news.text
        //Установим дату новости
        self.newsDate.text = news.date
        //Установим количество просмотров
        self.watchedCountLabel.text = String(news.viewsCount)
        //Установим надпись лайков
        self.likeLabel.text = String(news.likesCount)
        self.commentLabel.text = String(news.commentsCount)
        self.shareLabel.text = String(news.repostsCount)
        //Установим картинку новости
        
        let photoWidth = news.photoSizeXWidth
        let photoHeight = news.photoSizeXHeight
        
        var ratio: CGFloat = 1.0000
        if photoHeight != 0 {
            ratio = CGFloat(photoWidth) / CGFloat(photoHeight)
        }
        newsImageHeightConstraint.constant = ceil(newsImage.frame.width / ratio)
        
        self.newsImage.sd_setImage(with: URL(string: news.photoSizeX), placeholderImage: UIImage(named: "newsImageError"))
        
        //Установим иконку новости
        self.newsIconView.sd_setImage(with: URL(string: news.photo50), placeholderImage: UIImage(named: "error"))
        //Установим количество лайков
        self.likeCount = news.likesCount
    }
}
