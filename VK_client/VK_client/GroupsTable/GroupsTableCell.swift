//
//  GroupsTableCell.swift
//  VK_client
//
//  Created by Зинде Иван on 7/10/20.
//  Copyright © 2020 zindeivan. All rights reserved.
//

import UIKit

//Класс ячейки списка групп пользователя
class GroupsTableCell : UITableViewCell {
    //Иконка группы
    @IBOutlet private weak var groupIconView : UIImageView!
    //Название группы
    @IBOutlet private weak var groupNameLabel : UILabel!
    //Привяка высоты иконки
    @IBOutlet private weak var groupIconHeightConstraint: NSLayoutConstraint!
    //Привязка ширины иконки
    @IBOutlet private weak var groupIconWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Зарегистрируем обработчик нажатия на иконку
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconImageTapped(tapGestureRecognizer:)))
        groupIconView.isUserInteractionEnabled = true
        groupIconView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Метод обработки нажатия на иконку
    @objc func iconImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //Запомним данные привязок
        let groupIconHeightConstraintConstant = self.groupIconHeightConstraint.constant
        let groupIconWidthConstraintConstant = self.groupIconWidthConstraint.constant
        //Зададим коэффициент сжатия
        let resizeConstant : CGFloat = 1.08
        //Зададим пружинную анимацию
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.groupIconHeightConstraint.constant = self.groupIconHeightConstraint.constant / resizeConstant
                        self.groupIconWidthConstraint.constant = self.groupIconWidthConstraint.constant / resizeConstant
                        self.layoutIfNeeded()
        }) {(result) in
            //Возвращаем значение привязок
            UIView.animate(withDuration: 0.4) {
                self.groupIconHeightConstraint.constant = groupIconHeightConstraintConstant
                self.groupIconWidthConstraint.constant = groupIconWidthConstraintConstant
            }
            
        }
    }
    
    //Метод конфигурирования ячейки
    func configure(name: String, iconURL: String?){
        self.groupNameLabel.text = name
        self.groupIconView.sd_setImage(with: URL(string: iconURL ?? ""), placeholderImage: UIImage(named: "error"))
    }
}
