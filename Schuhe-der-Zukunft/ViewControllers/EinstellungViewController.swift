//
//  EinstellungViewController.swift
//  Schuhe-der-Zukunft
//
//  Created by Julius Schmid on 13.02.22.
//

import UIKit

class EinstellungViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(logoutButton)
        
    }


}
