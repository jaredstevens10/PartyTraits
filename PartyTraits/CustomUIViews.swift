//
//  CustomUIViews.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 7/25/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import Foundation
import UIKit

class TimerMenu: UIView {
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var isOpen = Bool()
    
    var TimerCount = Int()
    
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var lblView: UIView!
    
    @IBOutlet weak var hideBTN: UIButton!
    @IBOutlet weak var BGView: UIView!
    
    var TimeAmount = String()
    
    var pickerDataSource = ["1 Minute", "2 Minutes", "3 Minutes", "4 Minutes", "5 Minutes", "6 Minutes", "7 Minutes", "8 Minutes", "9 Minutes", "10 Minutes", "11 Minutes", "12 Minutes", "13 Minutes", "14 Minutes", "15 Minutes", "16 Minutes", "17 Minutes", "18 Minutes", "19 Minutes", "20 Minutes"];
    
    var NumberPlayers = Int()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var NumColors = [UIColor]()
    
    
    
    
    
    
    
    var buttonClicked = Bool()
    override func awakeFromNib() {
        
        NumColors.append(UIColor.red)
        NumColors.append(UIColor.blue)
        NumColors.append(UIColor.green)
        NumColors.append(UIColor.purple)
        NumColors.append(UIColor.yellow)
        NumColors.append(UIColor.orange)
        NumColors.append(UIColor.cyan)
        NumColors.append(UIColor.magenta)
        
        
        let randomIndex = Int(arc4random_uniform(UInt32(NumColors.count)))
        
        
        self.lblView.layer.cornerRadius = 10
        self.pickerView.layer.cornerRadius = 10
        
        self.lblView.layer.borderWidth = 2
        self.pickerView.layer.borderWidth = 2
        self.lblView.layer.borderColor = NumColors[randomIndex].cgColor
        self.pickerView.layer.borderColor = NumColors[randomIndex].cgColor
        // self.pickerView.dataSource = self;
        // self.pickerView.delegate = self;
        
        
        
        //Do something here when it wakes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = bounds
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        TimerCount = row + 1
        
        prefs.setValue(TimerCount, forKey: "GameTimerCount")
        
        self.NumberPlayers = row + 1
        
        print("Number of Players = \(self.NumberPlayers)")
        
        switch pickerDataSource[row] {
            
        case "1 Minute":
            TimeAmount = "1m"
            
            
        case "2 Minutes":
            TimeAmount = "2m"
        case "3 Minutes":
            TimeAmount = "3m"
        case "4 Minutes":
            TimeAmount = "4m"
        case "5 Minutes":
            TimeAmount = "5m"
        case "6 Minutes":
            TimeAmount = "6m"
        case "7 Minutes":
            TimeAmount = "7m"
        case "8 Minutes":
            TimeAmount = "8m"
        case "9 Minutes":
            TimeAmount = "9m"
        case "10 Minutes":
            TimeAmount = "10m"
        case "11 Minutes":
            TimeAmount = "11m"
        case "12 Minutes":
            TimeAmount = "12m"
        case "13 Minutes":
            TimeAmount = "13m"
        case "14 Minutes":
            TimeAmount = "14m"
        case "15 Minutes":
            TimeAmount = "15m"
        case "16 Minutes":
            TimeAmount = "16m"
        case "17 Minutes":
            TimeAmount = "17m"
        case "18 Minutes":
            TimeAmount = "18m"
        case "19 Minutes":
            TimeAmount = "19m"
        case "20 Minutes":
            TimeAmount = "20m"
            
        default:
            break
        }
        
        /*
         if(row == 0)
         {
         self.view.backgroundColor = UIColor.whiteColor();
         }
         else if(row == 1)
         {
         self.view.backgroundColor = UIColor.redColor();
         }
         else if(row == 2)
         {
         self.view.backgroundColor =  UIColor.greenColor();
         }
         else
         {
         self.view.backgroundColor = UIColor.blueColor();
         }
         
         */
    }
    
    
    /*
     override init (frame : CGRect) {
     super.init(frame : frame)
     addBehavior()
     }
     
     convenience init () {
     self.init(frame:CGRect.zero)
     }
     
     required init(coder aDecoder: NSCoder) {
     fatalError("This class does not support NSCoding")
     }
     
     func addBehavior (){
     print("Add all the behavior here")
     }
     
     */
    @IBAction func hideBTN(_ sender: AnyObject) {
        
        //let TimeAmount = "1m"
        
        prefs.setValue(self.TimeAmount, forKey: "TimerGameTimeLBL")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateTimerLBL"), object: self)
        
        self.isHidden = true
        
        //self.removeFromSuperview()
    }
    
    
    
    @IBAction func theButton(_ sender: AnyObject) {
        if buttonClicked {
            self.Off()
            buttonClicked = false
        } else {
            self.On()
            buttonClicked = true
        }
        
    }
    
    
    class func instanceFromNib() -> UIView {
        let bounds = UIScreen.main.bounds
        var Nib = UIView()
        
        let theFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        Nib = UINib(nibName: "TimerMenu", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        Nib.bounds = bounds
        return Nib
        
        //return UINib(nibName: "blurMenu", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    
    func On() {
        
        /*
         view4LBL.text = "Settings"
         view5LBL.text = "Share"
         view3LBL.text = "My Team"
         
         */
        
        /*
         self.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
         
         buttonViewBOTTOM.constant = 87
         buttonViewRIGHT.constant = 20
         */
        // theButton.setImage(UIImage(named: "plusIcon2.png"), forState: .Normal)
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.BGView.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).cgColor
            
            /*
             
             print("view 5 y on= \(self.view5.center.y)")
             
             self.view5.center.y = self.view5.center.y - 100
             self.view5B.constant = 40
             self.view5H.constant = 60
             self.view5W.constant = 40
             
             
             self.view4.center.y = self.view4.center.y - 73
             self.view4.center.x = self.view4.center.x - 70
             self.view4R.constant = 30
             self.view4B.constant = 13 //23
             self.view4H.constant = 60
             self.view4W.constant = 40
             
             
             // self.view4.center.y = self.view4.center.y - 73
             self.view3.center.x = self.view3.center.x - 100
             self.view3R.constant = 60
             self.view3B.constant = -60 //23
             self.view3H.constant = 60
             self.view3W.constant = 40
             
             */
            
            
        }, completion: { (Bool) -> Void in
        })
    }
    
    func Off() {
        
        /*
         
         BGView.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
         
         
         //        theButton.setImage(UIImage(named: "plusIcon1.png"), forState: .Normal)
         
         /*
         buttonViewBOTTOM.constant = 0
         buttonViewRIGHT.constant = 0
         self.bounds = CGRect(x: (buttonViewRIGHT.constant + buttonViewW.constant), y: (buttonViewBOTTOM.constant + buttonViewH.constant), width: buttonViewW.constant, height: buttonViewH.constant)
         */
         //self.view5B.constant = 46
         
         UIView.animateWithDuration(0.5, animations: { () -> Void in
         
         print("view 5 y off = \(self.view5.center.y)")
         
         self.view5.center.y = self.view5.center.y + 100
         print("view 5 y off 2 = \(self.view5.center.y)")
         
         //self.view5B.constant = -60
         // self.view5H.constant = 0
         // self.view5W.constant = 0
         
         self.view4.center.y = self.view4.center.y + 73
         self.view4.center.x = self.view4.center.x + 70
         
         
         self.view3.center.x = self.view3.center.x + 100
         
         
         
         //self.view4R.constant = -40
         //   self.view4B.constant = -60
         //  self.view4H.constant = 0
         //   self.view4W.constant = 0
         
         }, completion: { (Bool) -> Void in
         })
         
         view4LBL.text = ""
         view5LBL.text = ""
         view4LBL.text = ""
         
         */
        
    }
}

class TraitView: UIView {
    
    let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var isOpen = Bool()
    var TimerCount = Int()
    
    @IBOutlet weak var traitImage: UIImageView!
    @IBOutlet weak var traitTitle: UILabel!
    @IBOutlet weak var traitDesc: UILabel!
    @IBOutlet weak var TraitHolderView: UIView!
    
    @IBOutlet weak var hideBTN: UIButton!
    @IBOutlet weak var BGView: UIView!
    
    var TimeAmount = String()
    
    
    var traitTextTitle: String? {
        didSet {
            traitTitle.text = traitTextTitle
        }
    }
    
    var traitTextDesc: String? {
        didSet {
            traitDesc.text = traitTextDesc
        }
    }
    
    /*
     var TheTraitImage: UIImage? {
     didSet {
     traitImage.image = TheTraitImage
     }
     }
     
     */
    
    var TraitImageURLTemp = String()
    
    //var imageURLname: String?
    var TraitImageURL: String? {
        didSet {
            TraitImageURLTemp = TraitImageURL!
        }
    }
    
    /*{
     didSet {
     
     }
     }
     */
    
    //var pickerDataSource = ["1 Minute", "2 Minutes", "3 Minutes", "4 Minutes", "5 Minutes", "6 Minutes", "7 Minutes", "8 Minutes", "9 Minutes", "10 Minutes", "11 Minutes", "12 Minutes", "13 Minutes", "14 Minutes", "15 Minutes", "16 Minutes", "17 Minutes", "18 Minutes", "19 Minutes", "20 Minutes"];
    
    // var NumberPlayers = Int()
    
    //  @IBOutlet weak var pickerView: UIPickerView!
    
    //  var NumColors = [UIColor]()
    
    
    
    
    
    
    
    var buttonClicked = Bool()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
        self.TraitHolderView.layer.cornerRadius = 10
        self.TraitHolderView.layer.masksToBounds = true
        self.TraitHolderView.clipsToBounds = true
        
        
        
        TraitImageURLTemp = prefs.value(forKey: "GroupViewingPlayerTraitImageURL") as! String
        
        print("Trait View Image URL: \(TraitImageURLTemp)")
        
        let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(TraitImageURLTemp).png")
        print("Trait View url for image = \(url)")
        let theImageData = try? Data(contentsOf: url)
        
        //TestImage = UIImage(data:theImageData!)!
        
        let image  = UIImage(data: theImageData!)!
        
        
        self.traitImage.image = image
        self.traitImage.contentMode = .scaleAspectFit
        
        /*
         let randomIndex = Int(arc4random_uniform(UInt32(NumColors.count)))
         
         
         self.lblView.layer.cornerRadius = 10
         self.pickerView.layer.cornerRadius = 10
         
         self.lblView.layer.borderWidth = 2
         self.pickerView.layer.borderWidth = 2
         self.lblView.layer.borderColor = NumColors[randomIndex].cgColor
         self.pickerView.layer.borderColor = NumColors[randomIndex].cgColor
         */
        // self.pickerView.dataSource = self;
        // self.pickerView.delegate = self;
        
        //Do something here when it wakes
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = bounds
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    @IBAction func reportContent(_ sender: Any) {
        
        let theAlert = SCLAlertView()
        
        theAlert.addButton("Yes") {
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Content Reported", subTitle: "Thanks for reporting this, we will review.", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
        }
        
        theAlert.addButton("No") {
            
            //OkToCreate = false
        }
        
         theAlert.showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Report Content", subTitle: "Are you sure you want to report this content as inappropriate?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
        
        /*
        
        let alertController = UIAlertController(title: "Report Content?", message: "Are you sure you want to report this content as inappropriate?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
            // println("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            
            
            
            let alertController2 = UIAlertController(title: "Content Report", message: "Thank you.  This content has been reported and will be reviewed", preferredStyle: .alert)
            
            let cancelAction2 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                // println("you have pressed the Cancel button");
            }
            alertController2.addAction(cancelAction2)
            
            /*
             let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
             
             
             
             }
             */
            //alertController2.addAction(OKAction)
           // self.present
            
          //  alertController2.present(
            present(alertController2, animated: true, completion:nil)
            
            
            
            
            
            
            
            
        }
        alertController.addAction(OKAction)
        self
        present(alertController, animated: true, completion:nil)
        */
        
    }
    
    
    
    /*
     func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
     return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return pickerDataSource.count;
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
     return pickerDataSource[row]
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     {
     TimerCount = row + 1
     
     prefs.setValue(TimerCount, forKey: "GameTimerCount")
     
     self.NumberPlayers = row + 1
     
     print("Number of Players = \(self.NumberPlayers)")
     
     switch pickerDataSource[row] {
     
     case "1 Minute":
     TimeAmount = "1m"
     
     
     case "2 Minutes":
     TimeAmount = "2m"
     case "3 Minutes":
     TimeAmount = "3m"
     case "4 Minutes":
     TimeAmount = "4m"
     case "5 Minutes":
     TimeAmount = "5m"
     case "6 Minutes":
     TimeAmount = "6m"
     case "7 Minutes":
     TimeAmount = "7m"
     case "8 Minutes":
     TimeAmount = "8m"
     case "9 Minutes":
     TimeAmount = "9m"
     case "10 Minutes":
     TimeAmount = "10m"
     case "11 Minutes":
     TimeAmount = "11m"
     case "12 Minutes":
     TimeAmount = "12m"
     case "13 Minutes":
     TimeAmount = "13m"
     case "14 Minutes":
     TimeAmount = "14m"
     case "15 Minutes":
     TimeAmount = "15m"
     case "16 Minutes":
     TimeAmount = "16m"
     case "17 Minutes":
     TimeAmount = "17m"
     case "18 Minutes":
     TimeAmount = "18m"
     case "19 Minutes":
     TimeAmount = "19m"
     case "20 Minutes":
     TimeAmount = "20m"
     
     default:
     break
     }
     
     /*
     if(row == 0)
     {
     self.view.backgroundColor = UIColor.whiteColor();
     }
     else if(row == 1)
     {
     self.view.backgroundColor = UIColor.redColor();
     }
     else if(row == 2)
     {
     self.view.backgroundColor =  UIColor.greenColor();
     }
     else
     {
     self.view.backgroundColor = UIColor.blueColor();
     }
     
     */
     }
     
     */
    
    
    /*
     override init (frame : CGRect) {
     super.init(frame : frame)
     addBehavior()
     }
     
     convenience init () {
     self.init(frame:CGRect.zero)
     }
     
     required init(coder aDecoder: NSCoder) {
     fatalError("This class does not support NSCoding")
     }
     
     func addBehavior (){
     print("Add all the behavior here")
     }
     
     */
    @IBAction func hideBTN(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.75, animations: {
            self.alpha = 0.0
        })
        
        //let TimeAmount = "1m"
        
        // prefs.setValue(self.TimeAmount, forKey: "TimerGameTimeLBL")
        
        //  NotificationCenter.default.post(name: Notification.Name(rawValue: "updateTimerLBL"), object: self)
        
        self.isHidden = true
        
        //self.removeFromSuperview()
    }
    
    
    
    @IBAction func theButton(_ sender: AnyObject) {
        if buttonClicked {
            self.Off()
            buttonClicked = false
        } else {
            self.On()
            buttonClicked = true
        }
        
    }
    
    
    class func instanceFromNib() -> UIView {
        let bounds = UIScreen.main.bounds
        var Nib = UIView()
        
        let theFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        Nib = UINib(nibName: "TraitView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        Nib.bounds = bounds
        
        //let ImageURL = Nib.options
        
        //let data = (Nib. as NSNotification).userInfo
        //let googleImageData2 = data!["data"] as! Data
        
        
        
        return Nib
        
        //return UINib(nibName: "blurMenu", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    
    func On() {
        
        /*
         view4LBL.text = "Settings"
         view5LBL.text = "Share"
         view3LBL.text = "My Team"
         
         */
        
        /*
         self.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
         
         buttonViewBOTTOM.constant = 87
         buttonViewRIGHT.constant = 20
         */
        // theButton.setImage(UIImage(named: "plusIcon2.png"), forState: .Normal)
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.BGView.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).cgColor
            
            /*
             
             print("view 5 y on= \(self.view5.center.y)")
             
             self.view5.center.y = self.view5.center.y - 100
             self.view5B.constant = 40
             self.view5H.constant = 60
             self.view5W.constant = 40
             
             
             self.view4.center.y = self.view4.center.y - 73
             self.view4.center.x = self.view4.center.x - 70
             self.view4R.constant = 30
             self.view4B.constant = 13 //23
             self.view4H.constant = 60
             self.view4W.constant = 40
             
             
             // self.view4.center.y = self.view4.center.y - 73
             self.view3.center.x = self.view3.center.x - 100
             self.view3R.constant = 60
             self.view3B.constant = -60 //23
             self.view3H.constant = 60
             self.view3W.constant = 40
             
             */
            
            
        }, completion: { (Bool) -> Void in
        })
    }
    
    func Off() {
        
        /*
         
         BGView.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
         
         
         //        theButton.setImage(UIImage(named: "plusIcon1.png"), forState: .Normal)
         
         /*
         buttonViewBOTTOM.constant = 0
         buttonViewRIGHT.constant = 0
         self.bounds = CGRect(x: (buttonViewRIGHT.constant + buttonViewW.constant), y: (buttonViewBOTTOM.constant + buttonViewH.constant), width: buttonViewW.constant, height: buttonViewH.constant)
         */
         //self.view5B.constant = 46
         
         UIView.animateWithDuration(0.5, animations: { () -> Void in
         
         print("view 5 y off = \(self.view5.center.y)")
         
         self.view5.center.y = self.view5.center.y + 100
         print("view 5 y off 2 = \(self.view5.center.y)")
         
         //self.view5B.constant = -60
         // self.view5H.constant = 0
         // self.view5W.constant = 0
         
         self.view4.center.y = self.view4.center.y + 73
         self.view4.center.x = self.view4.center.x + 70
         
         
         self.view3.center.x = self.view3.center.x + 100
         
         
         
         //self.view4R.constant = -40
         //   self.view4B.constant = -60
         //  self.view4H.constant = 0
         //   self.view4W.constant = 0
         
         }, completion: { (Bool) -> Void in
         })
         
         view4LBL.text = ""
         view5LBL.text = ""
         view4LBL.text = ""
         
         */
        
    }
}


class FirstView: UIView {
    
     let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var isOpen = Bool()
    var TimerCount = Int()

    @IBOutlet weak var traitImage: UIImageView!
    @IBOutlet weak var introLBL: UILabel!

    @IBOutlet weak var HolderView: UIView!
    
    @IBOutlet weak var hideBTN: UIButton!
    @IBOutlet weak var BGView: UIView!
    

  
    

    
    var buttonClicked = Bool()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        
    self.hideBTN.layer.cornerRadius = 40
    self.hideBTN.layer.masksToBounds = true
    self.hideBTN.clipsToBounds = true
    self.hideBTN.layer.borderWidth = 1
    self.hideBTN.layer.borderColor = UIColor.white.cgColor
    self.traitImage.layer.cornerRadius = 60
    self.traitImage.layer.masksToBounds = true
    self.traitImage.clipsToBounds = true
    self.traitImage.layer.borderWidth = 1
    self.traitImage.layer.borderColor = UIColor.white.cgColor
        
 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = bounds
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    
       @IBAction func hideBTN(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.75, animations: {
            self.alpha = 0.0
        })
        

        
        self.isHidden = true
        
        //self.removeFromSuperview()
    }


    
    @IBAction func theButton(_ sender: AnyObject) {
        if buttonClicked {
            self.Off()
            buttonClicked = false
        } else {
            self.On()
            buttonClicked = true
        }
        
    }
    
    
    class func instanceFromNib() -> UIView {
        let bounds = UIScreen.main.bounds
        var Nib = UIView()
        
        let theFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        Nib = UINib(nibName: "FirstView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        Nib.bounds = bounds
        
        //let ImageURL = Nib.options
        
        //let data = (Nib. as NSNotification).userInfo
        //let googleImageData2 = data!["data"] as! Data
        
        
        
        return Nib
        
        //return UINib(nibName: "blurMenu", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    
    func On() {
        
     
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.BGView.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).cgColor
            
        
            
            
            }, completion: { (Bool) -> Void in
        })
    }
    
    func Off() {
        
        
    }
}




func JSController(_ MyTitle: String, MyMessage: String, Color: String) -> UIAlertController {
    
    let alertController = UIAlertController(title: MyTitle, message: MyMessage, preferredStyle: .alert)
    let OkAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        print("OK button pressed")
    }
    
    alertController.addAction(OkAction);
    
    alertController.view.tintColor = UIColor.black;
    //alertController.view.backgroundColor = UIColor(red: 0.4, green: 1, blue: 0.69, alpha: 1.0)
    /*
     var subView = alertController.view.subviews.first as! UIView
     var contentView = subView.subviews.first as! UIView
     var contentView2 = subView.subviews.last as! UIView
     
     switch Color {
     case "Red":
     
     contentView.backgroundColor = UIColor(red: 0.807, green: 0.576, blue: 0.58, alpha: 1.0)
     contentView.tintColor = UIColor(red: 0.929, green: 0.113, blue: 0.145, alpha: 1.0)
     // contentView.
     contentView2.tintColor = UIColor(red: 0.929, green: 0.113, blue: 0.145, alpha: 1.0)
     
     case "Blue":
     contentView.backgroundColor = UIColor(red: 0.249, green: 0.549, blue: 0.674, alpha: 0.5)
     contentView.tintColor = UIColor(red: 0.572, green: 0.882, blue: 0.949, alpha: 1.0)
     // contentView.
     contentView2.tintColor = UIColor(red: 0.572, green: 0.882, blue: 0.949, alpha: 1.0)
     
     case "Green":
     contentView.backgroundColor = UIColor(red: 0.4, green: 1, blue: 0.69, alpha: 1.0)
     contentView.tintColor = UIColor(red: 0.0, green: 0.4, blue: 0.2, alpha: 1.0)
     // contentView.
     contentView2.tintColor = UIColor(red: 0.0, green: 0.4, blue: 0.2, alpha: 1.0)
     
     
     default:
     print("Default Color")
     
     }
     */
    
    return alertController
    //    let alertController = JSController(MyTitle: String, MyMessage: String, Color: String)
    // self.presentViewController(alertController, animated: true, completion: nil)
    
}
