//
//  LoginViewController.swift
//  BikeLift
//
//  Created by Julius Schmid on 29.08.21.
//

import UIKit
import Firebase
import FirebaseAuth
import SPIndicator

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        
        
        
        setUpElements()
    }
    
    
    
    
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
        
    }
    
    
    // Ich verstecke das Error Label und style die Textfelder und butttons
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(loginButton)
    }
    
    
    @IBAction func loginButton_Tapped(_ sender: UIButton) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil {
                
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 0
                SPIndicator.present(title: "Fehler", message: "Versuche es nocheinmal", preset: .error)
                loggedIn = false
            } else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                loggedIn = true
                
                SPIndicator.present(title: "Erfolgreich", message: "Jetzt die App erkunden", preset: .done)
                
                
                
                
                
            }
            
            
        }
        
        
    }
    
    
}
