//
//  SignInWithPasswordViewController.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 01/03/24.
//

import UIKit

class SignInWithTokenViewController: UIViewController {

    let logoImageView = UIImageView()
    let tokenTextField = UITextField()
    let loginButton = UIButton(type: .system)
    
    // call Model
    let model = GithubModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // logoImageView
        logoImageView.image = UIImage(named: "github")
        logoImageView.contentMode = .scaleAspectFill
        let logoSize = CGSize(width: 120, height: 120)
        let logoOrigin = CGPoint(x: (view.frame.width - logoSize.width) / 2, y: 100)
        logoImageView.frame = CGRect(origin: logoOrigin, size: logoSize)
        
        // usernameTextField
        tokenTextField.placeholder = "Enter User Token"
        tokenTextField.borderStyle = .roundedRect
        let textFieldWidth = view.frame.width - 80
        let tokenTextFieldFrame = CGRect(x: 40, y: logoImageView.frame.maxY + 50, width: textFieldWidth, height: 40)
        tokenTextField.frame = tokenTextFieldFrame
        tokenTextField.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        tokenTextField.layer.borderWidth = 1.0
        tokenTextField.layer.cornerRadius = 9.0
        
        // loginButton
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        let loginButtonFrame = CGRect(x: 40, y: tokenTextField.frame.maxY + 30, width: textFieldWidth, height: 40)
        loginButton.frame = loginButtonFrame
        loginButton.tintColor = .white
        loginButton.backgroundColor = UIColorHex().hexStringToUIColor(hex: "#2b3137")
        loginButton.layer.cornerRadius = 9.0
        loginButton.layer.borderColor = UIColorHex().hexStringToUIColor(hex: "#24292e").cgColor
        loginButton.layer.borderWidth = 2.0
        
        // Add to the view
        view.addSubview(logoImageView)
        view.addSubview(tokenTextField)
        view.addSubview(loginButton)
    }
    
    func textFieldDelegate(){
        tokenTextField.delegate = self
    }
    
    @objc func loginButtonTapped() {
        model.logIN(token: tokenTextField.text ?? "") { isSucceeded, data, error in
            if isSucceeded {
                DispatchQueue.main.async {
                    let userProfileView = UserProfileViewController()
                    userProfileView.userData = data
                    self.navigationController?.pushViewController(userProfileView, animated: true)
                }
            } else  {
                DispatchQueue.main.async {
                    AlerUser.alertUser(viewController: self, title: "Fail to Login", message: "Failed to login Error: \(error ?? "")")
                }

            }
        }
    }
}

extension SignInWithTokenViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
