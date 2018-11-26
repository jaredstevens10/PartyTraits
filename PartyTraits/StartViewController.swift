//
//  StartViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/8/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    
    @IBOutlet var traitDownloadProgressView: UIProgressView!
    
    
    @IBOutlet var updateProgressLBL: UILabel!
    
    @IBOutlet weak var rightLogo: UIImageView!
    
    @IBOutlet weak var leftLogo: UIImageView!
    
    @IBOutlet weak var newgameButton: UIButton!
    
    @IBOutlet weak var howtoplayButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    let prefs:UserDefaults = UserDefaults.standard
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let NotFirstTimePlaying = prefs.bool(forKey: "FirstTimePlaying")
        
        if NotFirstTimePlaying {
            
        } else {

        let myTraitView:FirstView = UINib(nibName: "FirstView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FirstView
        /*
         let DeviceH = self.view.frame.height
         //let halfH = DeviceH / 2;
         let DeviceW = self.view.frame.width
         //let WLess10 = DeviceW - 10;
         let startX = (DeviceW / 2) - 125;
         let startY = (DeviceH / 2) - 125;
         */
        
        myTraitView.alpha = 0.0
        myTraitView.frame = UIScreen.main.bounds
        
        self.view.addSubview(myTraitView)
        
        UIView.animate(withDuration: 0.25, animations: {
            myTraitView.alpha = 1.0
        })
            
            
        prefs.set(true, forKey: "FirstTimePlaying")
        
    }
    
/*
        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseOut, animations: {
         
            var newCenter = self.leftLogo.center
            newCenter.x -= 120
            var newCenterR = self.rightLogo.center
            newCenterR.x -= -200
            
            self.leftLogo.center = newCenter
            self.rightLogo.center = newCenterR
         
            /*
            self.leftLogo.frame = CGRect(x: -150, y: 64, width: 243, height: 504)
            self.rightLogo.frame = CGRect(x: 220, y: 64, width: 184, height: 504)
            
*/
            }, completion: {finish in println("do animateion!")
        })

*/
        
    }
    
    func moveLogo () {
        
               //self.leftLogo.center = newCenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Party Traits"
        
        if let font = UIFont(name: "Noteworthy", size: 25.0) {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
        }
        navigationController!.navigationBar.barTintColor = UIColor.black
            
            //UIColor(red: 0.2352, green: 0.62745, blue: 0.8196, alpha: 1.0)
        
        newgameButton.layer.cornerRadius = 50
        
        howtoplayButton.layer.cornerRadius = 50
        
        howtoplayButton.layer.borderWidth = 1
        newgameButton.layer.borderWidth = 1
        
        newgameButton.layer.borderColor = UIColor.white.cgColor
        
        
        howtoplayButton.layer.borderColor = UIColor.white.cgColor
        
        

        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
       // traitDownloadProgressView.setProgress(0, animated: false)
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(StartViewController.UpdateDownloadProgress), name: NSNotification.Name(rawValue: "UpdateDownloadProgress"), object: nil)
        
        
        if  prefs.bool(forKey: "FinishedSavingAllTraits") {
            
            traitDownloadProgressView.isHidden = true
            updateProgressLBL.isHidden = true
            
        }

        // Do any additional setup after loading the view.
    }
    
 
    func UpdateDownloadProgress(_ notification:Notification) {
        
       print("updating download progress")
        
        let userInfo:Dictionary<String,String?> = (notification as NSNotification).userInfo as! Dictionary<String,String?>
        
        var jsonAlert = JSON(userInfo)
        print("JSON ALERT \(jsonAlert)")
        //   println("JSON ALERT \(jsonAlert)")
        let totalProgress = jsonAlert["totalProgress"].stringValue
        let totalProgressInt = Int(totalProgress)
        let totalProgressDouble = Double(totalProgressInt!)
        
        
        let currentProgress = jsonAlert["currentProgress"].stringValue
        let currentProgressInt = Int(currentProgress)
        let currentProgressDouble = Double(currentProgressInt!)
        
        print("Current Progress Double: \(currentProgressDouble)")
        
        //let ProgressComplete: Double = 1
        
        let EachTraitProgress: Double = 1 / totalProgressDouble
        
        let CurrentProgressFinalTemp = EachTraitProgress * currentProgressDouble
        let CurrentProgressFinal2 = Double(round(100*CurrentProgressFinalTemp)/100)
        let CurrentProgressFinal = Float(CurrentProgressFinal2)
        
        print("Should update trait download progress here, current float progress = \(CurrentProgressFinal)")
        
        traitDownloadProgressView.setProgress(CurrentProgressFinal, animated: true)
        
        if totalProgress <= currentProgress {
            self.prefs.set(true, forKey: "TRAITSUPDATED")
            self.prefs.set(true, forKey: "FinishedSavingAllTraits")
            traitDownloadProgressView.isHidden = true
            updateProgressLBL.isHidden = true
            
        } else {
            traitDownloadProgressView.isHidden = false
            updateProgressLBL.isHidden = false
            
        }
        
       
    
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
