//
//  GithubModel.swift
//  Github Rest APi
//
//  Created by Inderpreet Singh on 01/03/24.
//

import Foundation
import UIKit
import CoreData

struct GitHubUser: Codable {
    var name: String?
    var bio: String?
    var avatar_url: String?
    var email: String?
    var login: String?
    var followers: Int?
    var following:Int?
    var location:String?
    var public_repos:Int?
    var total_private_repos:Int?
}

class GithubModel:NSObject {
    // API
    func logIN(token: String, completionHandler: @escaping (_ isSucceeded: Bool, _ data: GitHubUser?, _ error: String?) -> ()) {
        
        Network.connectWithServer(url: APIConstant.API.SignInWithPassword.apiUrl(), httpRequest: .GET, token: token) { isSucceeded, data, error, statusCode  in
            if isSucceeded {
                if statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let usableData = try decoder.decode(GitHubUser.self, from: data!)
                        completionHandler(true, usableData, nil)
                    } catch {
                        if Debug.shared.is_DEBUG {
                            print(error.localizedDescription)
                        }
                        completionHandler(false, nil, error.localizedDescription)
                    }
                } else if statusCode == 403 {
                    completionHandler(false, nil, "Forbidden")
                } else {
                    completionHandler(false, nil, "Unknown status code recieved Error:\(statusCode ?? 0)")
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
    // CoreData
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Insert Object
    func insertDataObject(user: GitHubUser, token:String?) -> Result<Bool, Error> {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure("no context" as! Error)
        }
        
        let object = Github(context: context)
        object.token = token     // User token for auth, will be used for further api usecase
        
        // convert struct to data
        do {
            let userData = try JSONEncoder().encode(user)
            object.users = userData
        } catch {
            return .failure(error)
        }
        
        // save context
        do {
            try context.save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    // check if there are any stored users available and return the count of objects
    func getUsersCount() -> Int {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return 0
        }
        let fetchRequest: NSFetchRequest<Github> = Github.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return 0
        }
    }
    
    // fetch user Object returns array of users
    func fetchDataObject() -> [Github] {
        var gitubObject:[Github] = []
        if let context = appDelegate?.persistentContainer.viewContext {
            let users: NSFetchRequest<Github> = Github.fetchRequest()
            do {
                gitubObject = try context.fetch(users)
            } catch {
                print("Error fetching student object: \(error.localizedDescription)")
            }
        }
        return gitubObject
    }
}
