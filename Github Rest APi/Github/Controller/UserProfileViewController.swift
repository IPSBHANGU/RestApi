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
    let emailLabel = UILabel()
    let followers = UILabel()
    let following = UILabel()
    let location = UILabel()
    let reposCount = UILabel()
    
    let saveUser = UIButton()
    
    var userData: GitHubUser?
    var userToken: String = "" // we need to save this will be used for other api's
    
    // variable for hiding save button
    var isLocal:Bool = false
    
    // call Model
    let model = GithubModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserProfile()
        setupUI()
    }
    
    func updateUserProfile() {
        if let url = URL(string: userData?.avatar_url ?? "") {
            profileImageView.kf.setImage(with: url)
        }
        userLabel.text = userData?.name
        userName.text = userData?.login
        
        // Common Atrributes for Key Titles
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        // UserBio
        let bioAttributedString = NSMutableAttributedString(string: "Bio: ", attributes: attributes)
        bioAttributedString.append(NSAttributedString(string: "\n"))
        bioAttributedString.append(NSAttributedString(string: "\(userData?.bio ?? "")\n"))
        bioLabel.attributedText = bioAttributedString
        
        // UserEmail
        let emailAttributedString = NSMutableAttributedString(string: "Email: ", attributes: attributes)
        emailAttributedString.append(NSAttributedString(string: "\(userData?.email ?? "")"))
        emailLabel.attributedText = emailAttributedString
        
        // User Following/Followers
        followers.text = "Followers: \(userData?.followers ?? 0)"
        following.text = "Following: \(userData?.following ?? 0)"
        
        // User Location
        let locationAttributedString = NSMutableAttributedString(string: "Location: ", attributes: attributes)
        if let userLocation = userData?.location {
            locationAttributedString.append(NSAttributedString(string: userLocation))
        }
        location.attributedText = locationAttributedString
        
        // Total Repository
        let repositoriesAttributedString = NSMutableAttributedString(string: "Repositories: ", attributes: attributes)
        let totalRepos = "\((userData?.public_repos ?? 0) + (userData?.total_private_repos ?? 0))"
        repositoriesAttributedString.append(NSAttributedString(string: totalRepos))
        reposCount.attributedText = repositoriesAttributedString
    }
    
    func setupUI() {
        // Profile Image
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.frame = CGRect(x: (view.frame.width - 120) / 2, y: 100, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 60
        
        // User Label
        userLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userLabel.numberOfLines = 5
        userLabel.frame = CGRect(x: 20, y: profileImageView.frame.maxY + 20, width: view.frame.width - 40, height: 30)
        
        // User Name
        userName.font = UIFont.systemFont(ofSize: 16)
        userName.textColor = .gray
        userName.frame = CGRect(x: 20, y: userLabel.frame.maxY, width: view.frame.width - 40, height: 30)
        
        // User Bio
        bioLabel.numberOfLines = 0
        let bioText = userData?.bio ?? ""
        let bioHeight = heightForView(text: bioText, font: bioLabel.font, width: view.frame.width - 40)
        bioLabel.frame = CGRect(x: 20, y: userName.frame.maxY + 10, width: view.frame.width - 40, height: bioHeight + 50) // add 20 to accomodate Atrributed Title and space "/n"
        
        // User Email
        emailLabel.numberOfLines = 0
        let emailText = userData?.email ?? ""
        let emailHeight = heightForView(text: emailText, font: emailLabel.font, width: view.frame.width - 40)
        emailLabel.frame = CGRect(x: 20, y: bioLabel.frame.maxY, width: view.frame.width - 40, height: emailHeight)
        
        // User Followers
        followers.font = UIFont.boldSystemFont(ofSize: 16)
        followers.numberOfLines = 5
        followers.frame = CGRect(x: 20, y: emailLabel.frame.maxY + 10, width: (view.frame.width - 40) / 2 - 10, height: 20)

        // User Following
        following.font = UIFont.boldSystemFont(ofSize: 16)
        following.numberOfLines = 5
        following.frame = CGRect(x: followers.frame.maxX + 20, y: emailLabel.frame.maxY + 10, width: (view.frame.width - 40) / 2 - 10, height: 20)

        // User Location
        location.numberOfLines = 5
        location.frame = CGRect(x: 20, y: following.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // User Repositories
        reposCount.numberOfLines = 5
        reposCount.frame = CGRect(x: 20, y: location.frame.maxY + 10, width: view.frame.width - 40, height: 20)
        
        // save User
        saveUser.frame = CGRect(x: 20, y: view.frame.maxY - 10, width: view.frame.width - 40, height: 40)
        saveUser.setTitle("Save User Profile", for: .normal)
        saveUser.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveUser.setTitleColor(.white, for: .normal)
        saveUser.tintColor = .white
        saveUser.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        saveUser.layer.cornerRadius = 9.0
        saveUser.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        saveUser.layer.borderWidth = 2.0
        saveUser.addTarget(self, action: #selector(saveUserAction), for: .touchUpInside)
        
        // Add subviews to the view
        view.addSubview(profileImageView)
        view.addSubview(userLabel)
        view.addSubview(userName)
        view.addSubview(bioLabel)
        view.addSubview(emailLabel)
        view.addSubview(followers)
        view.addSubview(following)
        view.addSubview(location)
        view.addSubview(reposCount)
        
        if !isLocal == true {
            view.addSubview(saveUser)
        }
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func saveUserAction(){
        if let userData = userData {
            let saveUserDetails = model.insertDataObject(user: userData, token: userToken)
            let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            switch saveUserDetails {
            case .success(_):
                AlerUser.alertUser(viewController: self, title: "User Profile Saved", message: "Successfully saved user Profile!", action: okAction)
            case .failure(let error):
                AlerUser.alertUser(viewController: self, title: "Failed to Store User Profile", message: "There was error while storing user profile ERROR = \(error.localizedDescription)")
            }
        }
    }
}
