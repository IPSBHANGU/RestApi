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
    let userTableView = UITableView()
    let model = GithubModel()
    var emptyGithubObj: [Github] = [] // coreData entity
    var userData: [GitHubUser] = [] // Struct array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTutorialView()
        setupUI()
        setupTableView()
        addUser(count: model.getUsersCount())
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
    
    func setupTableView(){
        userTableView.frame = CGRect(x: 0, y: signInWithPassword.frame.maxY + 50, width: view.frame.width, height: view.frame.height - 50)
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "SavedUsersCell", bundle: .main), forCellReuseIdentifier: "savedUsers")
        userTableView.separatorStyle = .none
        view.addSubview(userTableView)
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

    
    @objc func signInWithPasswordButton() {
        let signInWithTokenView = SignInWithTokenViewController()
        navigationController?.pushViewController(signInWithTokenView, animated: true)
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
