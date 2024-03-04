//
//  ViewController.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 01/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let signInWithPassword = UIButton(type: .system)
    
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
    
    @objc func signInWithPasswordButton() {
        let signInWithTokenView = SignInWithTokenViewController()
        navigationController?.pushViewController(signInWithTokenView, animated: true)
    }
}

