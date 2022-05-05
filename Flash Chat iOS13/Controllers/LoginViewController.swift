//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by JPL-ST-SPRING2022 on 5/4/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let pwd = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
                if let e = error {
                    // same trick here
                    print(e.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
