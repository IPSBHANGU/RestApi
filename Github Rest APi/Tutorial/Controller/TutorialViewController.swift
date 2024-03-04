//
//  TutorialViewController.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 04/03/24.
//

import UIKit

class TutorialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 50))
        titleLabel.text = "Github Rest Api"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: view.frame.width - 40, height: 100))
        descriptionLabel.text = "This is a dummy app working on Gitub's restAPI!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
        let startButton = UIButton(frame: CGRect(x: 20, y: descriptionLabel.frame.maxY + 50, width: view.frame.width - 40, height: 50))
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .blue
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startTutorial), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(startButton)
    }
    
    @objc func startTutorial(){
        UserDefaultsConstants.shareInstance.isTutorialDone()
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
