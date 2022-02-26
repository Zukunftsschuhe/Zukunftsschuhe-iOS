//
//  NeuerSchuhViewController.swift
//  Schuhe-der-Zukunft
//
//  Created by Julius Schmid on 13.02.22.
//
import Foundation
import UIKit

class NeuerSchuhViewController: UIViewController {
  
    @IBOutlet weak var einrichtungButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
 override func viewDidLoad() {
        super.viewDidLoad()
setUpElements()
           image.layer.borderWidth = 1
           image.layer.masksToBounds = false
           image.layer.borderColor = UIColor.black.cgColor
           image.layer.cornerRadius = 50
           image.clipsToBounds = true
     image.backgroundColor = .lightGray
 }
    
    func setUpElements() {
        Utilities.styleFilledButton(einrichtungButton)
        
    }
   
    
    

}
