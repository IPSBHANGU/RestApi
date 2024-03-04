//
//  UserProfileViewController.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 01/03/24.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    let profileImageView = UIImageView()
    let userLabel = UILabel()
    let userName = UILabel()
    let bioLabel = UILabel()
    let emailLable = UILabel()
    let followers = UILabel()
    let following = UILabel()
    let location = UILabel()
    let reposCount = UILabel()
    
    var userData:GitHubUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserProfile()
        setupUI()
    }
    
    func updateUserProfile() {
        profileImageView.downloaded(from: userData?.avatar_url ?? "") { image in
            self.profileImageView.image = image
        }
        userLabel.text = userData?.name
        userName.text = userData?.login
        bioLabel.text = userData?.bio
        emailLable.text = userData?.email
        followers.text = "\(userData?.followers ?? 0)"
        following.text = "\(userData?.following ?? 0)"
        location.text = userData?.location
        reposCount.text = "\((userData?.public_repos ?? 0) + (userData?.total_private_repos ?? 0))"
    }
    
    func setupUI() {
        // Profile Image
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.frame = CGRect(x: (view.frame.width - 120) / 2, y: 100, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 60

        // UserFName
        userLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userLabel.numberOfLines = 5
        userLabel.frame = CGRect(x: 20, y: profileImageView.frame.maxY + 20, width: view.frame.width - 40, height: 30)
        
        // UserName
        userName.font = UIFont.systemFont(ofSize: 16)
        userName.textColor = .gray
        userName.frame = CGRect(x: 20, y: userLabel.frame.maxY, width: view.frame.width - 40, height: 30)
        
        // UserBio
        bioLabel.font = UIFont.systemFont(ofSize: 16)
        bioLabel.numberOfLines = 0
        let bioText = userData?.bio ?? ""
        let bioHeight = heightForView(text: bioText, font: bioLabel.font, width: view.frame.width - 40)
        bioLabel.frame = CGRect(x: 20, y: userName.frame.maxY + 10, width: view.frame.width - 40, height: bioHeight)
        
        // UserEmail
        emailLable.font = UIFont.systemFont(ofSize: 16)
        emailLable.numberOfLines = 5
        emailLable.frame = CGRect(x: 20, y: bioLabel.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // UserFollowers
        followers.font = UIFont.boldSystemFont(ofSize: 16)
        followers.numberOfLines = 5
        followers.frame = CGRect(x: 20, y: emailLable.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        
        // Userfollowing
        following.font = UIFont.boldSystemFont(ofSize: 16)
        following.numberOfLines = 5
        following.frame = CGRect(x: 20, y: followers.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // UserLocation
        location.font = UIFont.systemFont(ofSize: 16)
        location.numberOfLines = 5
        location.frame = CGRect(x: 20, y: following.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // UserRepos
        reposCount.font = UIFont.systemFont(ofSize: 16)
        reposCount.numberOfLines = 5
        reposCount.frame = CGRect(x: 20, y: location.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // add to View
        view.addSubview(profileImageView)
        view.addSubview(userLabel)
        view.addSubview(userName)
        view.addSubview(bioLabel)
        view.addSubview(emailLable)
        view.addSubview(followers)
        view.addSubview(following)
        view.addSubview(location)
        view.addSubview(reposCount)
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

