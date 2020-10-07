//
//  FriendsTableCell.swift
//  VK_client
//
//  Created by Зинде Иван on 7/8/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import UIKit

//Класс ячейки списка друзей пользователя
class FriendsTableCell : UITableViewCell {
    //Надпись имени друга
    @IBOutlet private weak var friendNameLabel : UILabel!
    //Тень иконки аватарки друга
    @IBOutlet private weak var iconShadowView : IconShadowView!
    //Округление иконки аватарки друга
    @IBOutlet private weak var iconImageView : IconView!
    //Привяка высоты иконки
    @IBOutlet private weak var iconImageHeightConstraint: NSLayoutConstraint!
    //Привязка ширины иконки
    @IBOutlet private weak var iconImageWidthConstraint: NSLayoutConstraint!
    //Привяка высоты тени иконки
    @IBOutlet private weak var iconShadowHeightConstraint: NSLayoutConstraint!
    //Привязка ширины тени иконки
    @IBOutlet private weak var iconShadowWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Зарегистрируем обработчик нажатия на иконку
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconImageTapped(tapGestureRecognizer:)))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Метод обработки нажатия на иконку
    @objc func iconImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //Запомним данные привязок
        let iconImageHeightConstraintConstant = self.iconImageHeightConstraint.constant
        let iconImageWidthConstraintConstant = self.iconImageWidthConstraint.constant
        let iconShadowHeightConstraintConstant = self.iconShadowHeightConstraint.constant
        let iconShadowWidthConstraintConstant = self.iconShadowWidthConstraint.constant
        //Зададим коэффициент сжатия
        let resizeConstant : CGFloat = 1.08
        //Зададим пружинную анимацию
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.iconImageHeightConstraint.constant = self.iconImageHeightConstraint.constant / resizeConstant
                        self.iconImageWidthConstraint.constant = self.iconImageWidthConstraint.constant / resizeConstant
                        self.iconShadowHeightConstraint.constant = self.iconShadowHeightConstraint.constant / resizeConstant
                        self.iconShadowWidthConstraint.constant = self.iconShadowWidthConstraint.constant / resizeConstant
                        self.layoutIfNeeded()
        }) {(result) in
            //Возвращаем значение привязок
            UIView.animate(withDuration: 0.4) {
                self.iconImageHeightConstraint.constant = iconImageHeightConstraintConstant
                self.iconImageWidthConstraint.constant = iconImageWidthConstraintConstant
                self.iconShadowHeightConstraint.constant = iconShadowHeightConstraintConstant
                self.iconShadowWidthConstraint.constant = iconShadowWidthConstraintConstant
            }
            
        }
    }
    
    //Метод конфигурирования ячейки
    func configure(name: String, iconURL: String?){
        self.friendNameLabel.text = name
        self.iconImageView.sd_setImage(with: URL(string: iconURL ?? ""), placeholderImage: UIImage(named: "error"))
        self.iconShadowView.configureLayer()
        self.iconImageView.configureLayer()
    }
}
