//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by JPL-ST-SPRING2022 on 5/4/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text else { return  }
        guard let pwd = passwordTextfield.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: pwd) { authResult, error in
            if let e = error {
                // print dexcription I dont know hth is this but it looks useful
                print(e.localizedDescription)
            }else {
                //after success,jump to chat view
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
}
