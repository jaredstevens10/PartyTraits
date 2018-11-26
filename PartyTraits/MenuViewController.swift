//
//  MenuViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/2/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit
import Foundation

class MenuViewController: UIViewController {
    @IBOutlet weak var newGameBTN: UIButton!
     @IBOutlet weak var myGameBTN: UIButton!
     @IBOutlet weak var newTraitBTN: UIButton!
     @IBOutlet weak var howToBTN: UIButton!
    
    @IBOutlet weak var storeBTN: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameBTN.layer.cornerRadius = 50
        newGameBTN.layer.borderColor = UIColor.lightGray.cgColor
        newGameBTN.layer.borderWidth = 2
        
        myGameBTN.layer.cornerRadius = 50
        myGameBTN.layer.borderColor = UIColor.lightGray.cgColor
        myGameBTN.layer.borderWidth = 2
        
        newTraitBTN.layer.cornerRadius = 50
        newTraitBTN.layer.borderColor = UIColor.lightGray.cgColor
        newTraitBTN.layer.borderWidth = 2
        
        howToBTN.layer.cornerRadius = 50
        howToBTN.layer.borderColor = UIColor.lightGray.cgColor
        howToBTN.layer.borderWidth = 2
        
        storeBTN.layer.cornerRadius = 40
        storeBTN.layer.borderColor = UIColor.lightGray.cgColor
        storeBTN.layer.borderWidth = 2

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func privacyBTN(_ sender: Any) {
        
       
        
        if let url = URL(string: "http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/PrivacyPolicy.html"),  UIApplication.shared.openURL(url) {
            print("default browser was successfully opened")
        }
    }
    @IBAction func TermBTN(_ sender: Any) {
        
        if let url = URL(string: "http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TermsOfService.html"), UIApplication.shared.openURL(url) {
            print("default browser was successfully opened")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

