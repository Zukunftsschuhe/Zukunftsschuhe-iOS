//
//  ViewController.swift
//  Schuh der Zukunft
//
//  Created by JS on 02.10.21.
//
import AuthenticationServices
import UIKit
import MapboxDirections

class ViewController : UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    private let signInButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        setUpElements()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        loadData()
    }
    
  override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 334, height: 50)
        signInButton.center = view.center
     
    }

    

    
    
    @objc func didTapSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests : [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

  
    func transitionToHome() {
               
               let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
               
               view.window?.rootViewController = homeViewController
               view.window?.makeKeyAndVisible()
               loggedIn = true
        userDefault.set(loggedIn, forKey: "status")
           }
    
    
    func loadData() {
     var status = userDefault.bool(forKey: "status")
        
        if status == true {
            transitionToHome()
            
        } else {
            print("User ist nicht eingelogt!")
        }
    }
    
    
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
  }
}


extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error beim anmelden mit Apple")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
       
        case let credentials as ASAuthorizationAppleIDCredential:
              
            let firstName = credentials.fullName?.givenName
            let lastname = credentials.fullName?.familyName
            let email = credentials.email
            
            break
        default:
            break
        }
   transitionToHome()
    
       
    }
    
}


extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}
