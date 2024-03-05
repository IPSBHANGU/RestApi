//
//  ViewController.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 01/03/24.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let signInWithPassword = UIButton(type: .system)
    let model = GithubModel()
    var emptyGithubObj: [Github] = [] // coreData entity
    var userData: [GitHubUser] = [] // Struct array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTutorialView()
        setupUI()
        addUser(imageCount: model.getUsersCount())
    }
    
    func showTutorialView() {
        if !UserDefaults.standard.bool(forKey: "isTutorial") {
            let tutorialView = TutorialViewController()
            if let navigationController = navigationController {
                navigationController.pushViewController(tutorialView, animated: true)
            }
        }
    }

    func setupUI() {
        // logoImageView
        logoImageView.image = UIImage(named: "github")
        logoImageView.contentMode = .scaleAspectFill
        let logoSize = CGSize(width: 120, height: 120)
        let logoOrigin = CGPoint(x: (view.frame.width - logoSize.width) / 2, y: 100)
        logoImageView.frame = CGRect(origin: logoOrigin, size: logoSize)
        
        // loginButton
        signInWithPassword.setTitle("Login with token", for: .normal)
        signInWithPassword.addTarget(self, action: #selector(signInWithPasswordButton), for: .touchUpInside)
        let signInWithPasswordFrame = CGRect(x: 40, y: logoImageView.frame.maxY + 50 + 30, width: view.frame.width - 80, height: 40)
        signInWithPassword.frame = signInWithPasswordFrame
        signInWithPassword.tintColor = .white
        signInWithPassword.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        signInWithPassword.layer.cornerRadius = 9.0
        signInWithPassword.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        signInWithPassword.layer.borderWidth = 2.0
        
        // Add to the view
        view.addSubview(logoImageView)
        view.addSubview(signInWithPassword)
    }
    
    // this function will add multiple ui Images based on count from Model when fetch user is done
    func addUser(imageCount: Int) {
        let userImageSize = CGSize(width: 120, height: 120)
        let startY = signInWithPassword.frame.maxY + 50
        let padding: CGFloat = 20

        // Create a UIScrollView instance
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: startY, width: view.frame.width, height: view.frame.height - startY)
        scrollView.showsVerticalScrollIndicator = false
        
        // Create a subView in Scroll View
        let subView = UIView()
        subView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: CGFloat(imageCount) * (userImageSize.height + padding))

        for index in 0..<imageCount {
            let userImageView = UIImageView()
            userImageView.contentMode = .scaleAspectFill
            let userImageOrigin = CGPoint(x: (view.frame.width - userImageSize.width) / 2, y: CGFloat(index) * (userImageSize.height + padding))
            userImageView.frame = CGRect(origin: userImageOrigin, size: userImageSize)
            userImageView.layer.cornerRadius = 60
            userImageView.tag = index
            userImageView.clipsToBounds = true

            // Fetch user Objects
            emptyGithubObj = model.fetchDataObject()
            guard let indexUserData = emptyGithubObj[index].users else { return }

            if let decodeData = try? JSONDecoder().decode(GitHubUser.self, from: indexUserData) {
                userData.append(decodeData)
                if let url = URL(string: decodeData.avatar_url ?? "") {
                    userImageView.kf.setImage(with: url)
                }
            }

            // Add tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            userImageView.isUserInteractionEnabled = true
            userImageView.addGestureRecognizer(tapGesture)

            subView.addSubview(userImageView)
        }

        // Add subView to scrollView
        scrollView.addSubview(subView)

        // Set content size of scrollView
        scrollView.contentSize = subView.frame.size
        
        // Adjust content inset to add space at the bottom
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

        // Add the UIScrollView to your view hierarchy
        view.addSubview(scrollView)
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        let tappedImageIndex = imageView.tag
        
        let userProfileView = UserProfileViewController()
        userProfileView.userData = userData[tappedImageIndex]
        userProfileView.isLocal = true
        self.navigationController?.pushViewController(userProfileView, animated: true)
    }

    
    @objc func signInWithPasswordButton() {
        let signInWithTokenView = SignInWithTokenViewController()
        navigationController?.pushViewController(signInWithTokenView, animated: true)
    }
}
