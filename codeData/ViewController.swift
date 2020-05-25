//
//  ViewController.swift
//  codeData
//
//  Created by Beto Salcido on 25/05/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var counter = 0
    private let manager = CoreDataManager.shared
    
    @IBOutlet weak var sumarryLabel: UILabel! {
        didSet {
            sumarryLabel.text = "Intento: \(counter) \r \nRegistros en la base: \(0)\r\nUltimo registro: nil"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        manager.fetchUserByName(name: "Beto")
        
    }
    
    func updateUI() {
        counter = counter + 1
        let users = manager.fetchUsers()
        sumarryLabel.text = "Intento: \(counter) \r \nRegistros en la base: \(users.count)\r\nUltimo registro: \(users.last?.name ?? "")"
        print("Intento: \(counter) \r \nRegistros en la base: \(users.count)\r\nUltimo registro: \(users.last?.name ?? "")")
    }
    
    
    @IBAction func createRecords(_ sender: Any) {
        let user = UserModel(name: "Beto", lastName: "Salcido", email: "diana@salcido.com", initialAmount: 5000.00, age: 28)
        manager.createUser(data: user) { [weak self ] in
            self?.updateUI()
        }
    }
    
    @IBAction func deleteRecords(_ sender: Any) {
        manager.deleteUsers()
        updateUI()
    }



}

