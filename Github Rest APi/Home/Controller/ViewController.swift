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
    let signInWithToken = UIButton(type: .system)
    let signInAsExistingUser = UIButton(type: .system)
    let userTableView = UITableView()
    let model = GithubModel()
    var emptyGithubObj: [Github] = [] // coreData entity
    var userData: [GitHubUser] = [] // Struct array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTutorialView()
        setupUI()
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
        signInWithToken.setTitle("Login with token", for: .normal)
        signInWithToken.addTarget(self, action: #selector(signInWithTokenButton), for: .touchUpInside)
        let signInWithTokenFrame = CGRect(x: 40, y: logoImageView.frame.maxY + 50 + 30, width: view.frame.width - 80, height: 40)
        signInWithToken.frame = signInWithTokenFrame
        signInWithToken.tintColor = .white
        signInWithToken.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        signInWithToken.layer.cornerRadius = 9.0
        signInWithToken.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        signInWithToken.layer.borderWidth = 2.0
        
        // Existing User Login
        signInAsExistingUser.setTitle("Login with token", for: .normal)
        signInAsExistingUser.addTarget(self, action: #selector(signInAsExistingUserAction), for: .touchUpInside)
        let signInAsExistingUserFrame = CGRect(x: 40, y: signInWithToken.frame.maxY + 50 + 30, width: view.frame.width - 80, height: 40)
        signInAsExistingUser.frame = signInAsExistingUserFrame
        signInAsExistingUser.tintColor = .white
        signInAsExistingUser.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        signInAsExistingUser.layer.cornerRadius = 9.0
        signInAsExistingUser.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        signInAsExistingUser.layer.borderWidth = 2.0
        
        // Add to the view
        view.addSubview(logoImageView)
        view.addSubview(signInWithToken)
        if model.getUsersCount() != 0 {
            view.addSubview(signInAsExistingUser)
        }
    }
    
    func setupTableView(){
        userTableView.frame = CGRect(x: 0, y: logoImageView.frame.maxY + 50, width: view.frame.width, height: view.frame.height - 50)
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "SavedUsersCell", bundle: .main), forCellReuseIdentifier: "savedUsers")
        userTableView.separatorStyle = .none
        
        // Default Hidden TableView
        userTableView.alpha = 0
        userTableView.isHidden = true
        
        // Add Header Button to hide TableView and bring SignIn Buttons
        let headerButton = UIButton(type: .system)
        headerButton.setTitle("Login with token", for: .normal)
        headerButton.addTarget(self, action: #selector(signInWithTokenButton), for: .touchUpInside)
        headerButton.frame = CGRect(x: 40, y: 0, width: userTableView.frame.width - 80, height: 44)
        headerButton.center.y = 22
        headerButton.tintColor = .white
        headerButton.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        headerButton.layer.cornerRadius = 9.0
        headerButton.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        headerButton.layer.borderWidth = 2.0
        
        // Add a Header View to get flexiblity to mod button
        let headerView = UIView()
        headerView.frame = CGRect(x: 40, y: 0, width: userTableView.frame.width, height: 50)
        headerView.addSubview(headerButton)
        
        userTableView.tableHeaderView = headerView
        
        // Add TableView to View
        view.addSubview(userTableView)
        
        addUser(count: model.getUsersCount())
    }
    
    // this function will add multiple ui Images based on count from Model when fetch user is done
    func addUser(count: Int) {
        for index in 0..<count {
            emptyGithubObj = model.fetchDataObject()
            guard let indexUserData = emptyGithubObj[index].users else { continue }
            if let decodeData = try? JSONDecoder().decode(GitHubUser.self, from: indexUserData) {
                userData.append(decodeData)
            }
        }
        userTableView.reloadData()
    }

    
    @objc func signInWithTokenButton() {
        let signInWithTokenView = SignInWithTokenViewController()
        navigationController?.pushViewController(signInWithTokenView, animated: true)
    }
    
    @objc func signInAsExistingUserAction(){
        UIView.animate(withDuration: 0.5) {
            self.setupTableView()
            self.userTableView.alpha = 1
            self.userTableView.isHidden = false
            
            // Hide SignIn buttons
            self.signInWithToken.alpha = 0
            self.signInAsExistingUser.alpha = 0
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedUsers", for: indexPath) as? SavedUsersCell else {
            return UITableViewCell()
        }
        
        let user = userData[indexPath.row]
        
        cell.setCellData(url: user.avatar_url ?? "", username: user.login)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileView = UserProfileViewController()
        userProfileView.userData = userData[indexPath.row]
        userProfileView.isLocal = true
        navigationController?.pushViewController(userProfileView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
