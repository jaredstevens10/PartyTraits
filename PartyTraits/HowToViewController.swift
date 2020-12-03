//
//  HowToViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/8/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    
    var passcode = String()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ShowMeBTN: UIButton!
    let prefs:UserDefaults = UserDefaults.standard
    
    var HowToPages = 3
   // var pageTitles = [NSString]()
   // var pageNotes = [NSString]()
    
  //  var HowToPage : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShowMeBTN.layer.cornerRadius = 65
        ShowMeBTN.layer.borderWidth = 1
        ShowMeBTN.layer.borderColor = UIColor.lightGray.cgColor
        
        self.title = "How To Play"
        if let font = UIFont(name: "Noteworthy", size: 25.0) {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.black

    
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() {
       
            
           
            passcode = GetPassCode("guest")
        
             print("Got Passcode, it's \(passcode)")
            
        } else {
            
            passcode = "jaredadmin"
        }
        
        
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func SecretBTN(_ sender: Any) {
        
        let alertController = UIAlertController(title: "You've found the secret button...", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
          //  let secondTextField = alertController.textFields![1] as UITextField
            
            
            
            print("Passcode entered = \(firstTextField.text)")
            
            
            
            
            
                if firstTextField.text == "jaredadmin" || firstTextField.text == self.passcode || firstTextField.text == "jaredadminoff" || firstTextField.text == "kcco" || firstTextField.text == "KCCO"  {
                    
                    var unlockMessage = String()
                    
                    if firstTextField.text == "jaredadmin" {
                       
                        self.prefs.set(true, forKey: "AllTraitsPurchased")
                        self.prefs.set(true, forKey: "CreateTraitsPurchased")
                        self.prefs.set(true, forKey: "RemoveAdsPurchased")
                        self.prefs.set(true, forKey: "isJaredAdmin")
                        
                        unlockMessage = "Correct!  You've unlocked Admin access and All the Traits!"
                        
                    }
                    
                    if firstTextField.text == "jaredadminoff" {
                        
                       // self.prefs.set(true, forKey: "AllTraitsPurchased")
                       // self.prefs.set(true, forKey: "CreateTraitsPurchased")
                       // self.prefs.set(true, forKey: "RemoveAdsPurchased")
                        self.prefs.set(false, forKey: "isJaredAdmin")
                         unlockMessage = "Correct!  You've unlocked Admin access and All the Traits!"
                        
                    }
                    
                    if firstTextField.text == "kcco" || firstTextField.text == "KCCO" {
                        
                         self.prefs.set(true, forKey: "AllTraitsPurchased")
                        // self.prefs.set(true, forKey: "CreateTraitsPurchased")
                         self.prefs.set(true, forKey: "RemoveAdsPurchased")
                         unlockMessage = "Chive On!  All Traits are unlocked and the Ads have been removed!"
                        //self.prefs.set(false, forKey: "isJaredAdmin")
                        
                    }
                    
                    
                    
                    
                    
                    self.prefs.set(true, forKey: "UserHasAdminAcces")
                
                
                    let alertController2 = UIAlertController(title: unlockMessage, message: "", preferredStyle: .alert)
                    
                    let cancelAction2 = UIAlertAction(title: "OK", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                        self.prefs.set(true, forKey: "AllTraitsPurchased")
                        self.prefs.set(true, forKey: "CreateTraitsPurchased")
                        
                        
                    })
                    
                    alertController2.addAction(cancelAction2)
                
                    self.present(alertController2, animated: true, completion: nil)
                
                } else {
                    
                    let alertController2 = UIAlertController(title: "Sorry, that's not it.", message: "", preferredStyle: .alert)
                    
                    let cancelAction2 = UIAlertAction(title: "Ok", style: .default, handler: {
                        (action : UIAlertAction!) -> Void in
                        
                    })
                    
                    alertController2.addAction(cancelAction2)
                    
                    self.present(alertController2, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Secret Passcode?"
            
            
            
        }
        /*
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Second Name"
        }
 */
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
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
