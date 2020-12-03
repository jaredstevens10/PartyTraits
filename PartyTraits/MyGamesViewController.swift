//
//  MyGamesViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/8/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit

class MyGamesViewController: UIViewController{
    
    var username = NSString()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    /*
    var GameSegue = "Select_Game"

    @IBOutlet weak var TableView: UITableView!
   
       
  
    
    
    var GameData = [NSArray]()
    
    
    var gnameArray = [NSString]()
    var GameIdArray = [NSString]()
    var Player1Array = [NSString]()
    var Player2Array = [NSString]()
    var Player3Array = [NSString]()
    var Player4Array = [NSString]()
    var Player5Array = [NSString]()
    var Player6Array = [NSString]()
    var Player7Array = [NSString]()
    var Player8Array = [NSString]()
    var Player9Array = [NSString]()
    var Player10Array = [NSString]()
    var Turn1Array = [NSString]()
    var Turn2Array = [NSString]()
    var Turn3Array = [NSString]()
    var Turn4Array = [NSString]()
    var Turn5Array = [NSString]()
    var Turn6Array = [NSString]()
    var Turn7Array = [NSString]()
    var Turn8Array = [NSString]()
    var Turn9Array = [NSString]()
    var Turn10Array = [NSString]()
    var TurnNumberArray = [NSString]()
    
    var GameIDInfo = [NSString]()

    var Player1Info  = [NSString]()

    var Player2Info = [NSString]()
    var Player3Info = [NSString]()
    var Player4Info = [NSString]()
    var Player5Info = [NSString]()
    var Player6Info = [NSString]()
    var Player7Info = [NSString]()
    var Player8Info = [NSString]()
    var Player9Info = [NSString]()
    var Player10Info = [NSString]()
    var Turn1Info = [NSString]()
    var Turn2Info = [NSString]()
    var Turn3Info = [NSString]()
    var Turn4Info = [NSString]()
    var Turn5Info = [NSString]()
    var Turn6Info = [NSString]()
    var Turn7Info = [NSString]()
    var Turn8Info = [NSString]()
    var Turn9Info = [NSString]()
    var Turn10Info = [NSString]()
    var TurnNumberInfo = [NSString]()

    
    
    var GameNameInfo = [NSString]()
   // var dateaptArray = [NSString]()
    

*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Games"
        if let font = UIFont(name: "Noteworthy", size: 25.0) {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.black

        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        

       // var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
       // view.addGestureRecognizer(tap)
        
        let prefs:UserDefaults = UserDefaults.standard
      //  username = prefs.valueForKey("USERNAME") as! NSString as String
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}
