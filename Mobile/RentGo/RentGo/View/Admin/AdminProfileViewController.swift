//
//  AdminProfileViewController.swift
//  RentGo
//
//  Created by Eray İnal on 8.05.2025.
//

import UIKit

class AdminProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        performSegue(withIdentifier: "toSignInFromAdminProfile", sender: nil)
    }
    
    
    

}
