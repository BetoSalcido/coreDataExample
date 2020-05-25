//
//  DataBaseManager.swift
//  CoreData
//
//  Created by Beto Salcido on 25/05/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let container: NSPersistentContainer!
    
    private init() {
        //Name of the model
        container = NSPersistentContainer(name: "Banking")
        setupDatabase()
    }
    
    private func setupDatabase() {
        //Implement the Core data stack
        container?.loadPersistentStores(completionHandler: { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) - \(error)")
                return
            }
            
            print("Database ready!")
        })
    }
    
    //Method to save one user
    func createUser(data: UserModel, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        
        let user = User(context: context)
        user.name = data.name
        user.lastname = data.lastName
        user.email = data.email
        user.age = data.age
        
        let account = Account(context: context)
        account.name =  "Cuenta de \(data.name)"
        account.amount = data.initialAmount
        account.openingDate = Date()
        account.belongsTo = user
        
        
        do {
            try context.save()
            context.reset()
            print("User \(data.name) saved")
            completion()
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
    
    //Method to save a lot of users
    func createUsers(data: UserModel, completion: @escaping() -> Void) {
        
        container.performBackgroundTask { (context) in
            for _ in 0...100000 {
                let user = User(context: context)
                user.name = data.name
                user.lastname = data.lastName
                user.email = data.email
                user.age = data.age
                
                
                let account = Account(context: context)
                account.name =  "Cuenta de \(data.name)"
                account.amount = data.initialAmount
                account.openingDate = Date()
                account.belongsTo = user
            }
            
            do {
                try context.save()
                context.reset()
                print("User \(data.name) saved")
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error saving user: \(error.localizedDescription)")
            }
        }
    
    }
    
    func deleteUsers() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(deleteBatch)
            print("User deleted successfully")
        } catch {
            print("Error deleting user data: \(error.localizedDescription)")
        }
    }
    
    func fetchUsers() -> [User] {
        //Model type to get
        let fecthRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let result = try container.viewContext.fetch(fecthRequest)
            return result
        } catch  {
            print("Error fetching user data: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUserByName(name: String) -> [User] {
        //Model type to get
        let fecthRequest: NSFetchRequest<User> = User.fetchRequest()
        fecthRequest.predicate = NSPredicate(format: "name = %@", name)
        fecthRequest.returnsObjectsAsFaults = false
               
        do {
            let result = try container.viewContext.fetch(fecthRequest)
            return result
        } catch  {
            print("Error fetching user data: \(error.localizedDescription)")
            return []
        }
    }
    
}


