//
//  SavedUsersCell.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 05/03/24.
//

import UIKit

class SavedUsersCell: UITableViewCell {
    
    let userAvatar = UIImageView()
    let userNameLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    func setupUI() {
        userAvatar.contentMode = .scaleAspectFit
        userAvatar.clipsToBounds = true
        userAvatar.layer.cornerRadius = 40
        contentView.addSubview(userAvatar)
        
        userNameLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(userNameLabel)
        
        let avatarSize: CGFloat = 80
        userAvatar.frame = CGRect(x: 16, y: 10, width: avatarSize, height: avatarSize)
        userNameLabel.frame = CGRect(x: userAvatar.frame.maxX + 16, y: userAvatar.frame.midY - 10, width: contentView.bounds.width - userAvatar.frame.maxX - 32, height: 20)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(url:String?, username:String?){
        if let avtarUrl = URL(string: url ?? "") {
            userAvatar.kf.setImage(with: avtarUrl)
        }
        userNameLabel.text = username ?? ""
    }
}
