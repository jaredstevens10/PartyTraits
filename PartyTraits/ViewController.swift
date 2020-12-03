//
//  ViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/2/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet var traitDownloadProgressView: UIProgressView!
    
    
    @IBOutlet var updateProgressLBL: UILabel!
    
    var LocalSavedTraits = [String]()
    var UnSyncedTraits = [String]()
    
    var TotalTraitsArray = [NSString]()
    var products = [SKProduct]()
    var product: SKProduct?
    var product_id_ads: NSString?;
    
    var productsArray = Array<SKProduct>()
    
    @IBOutlet weak var theTraitsBTN: UIButton!
    
    
    let productIdentifiers = Set(["com.JaredStevens.PartyTraits.AllTraits"])
    
    var TotalItems = Int()
    var SavedItemsInventory = [NSManagedObject]()
    
    var TotalTraitsInventoryArray = [TraitInventorySorted]()
    
    @IBOutlet weak var DifComment: UILabel!
    @IBOutlet weak var segmentControl: ADVSegmentedControl!
    
    @IBOutlet weak var segmentControlType: ADVSegmentedControl!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var DifLevelBTN: UIButton!
    @IBOutlet weak var DifView: UIView!
    
    let prefs:UserDefaults = UserDefaults.standard
    
    var level = NSString()
    var leveldata = NSString()
    var trait_ids = [Double]()
    var trait_ids_used = [Double]()
    var ViewDifView = Bool()
    
    var gameType = NSString()
    
    var DifDropData: [String] = ["Easy", "Medium", "Hard"]
    
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var DifMenu: UITableView!
    
    @IBOutlet weak var testlevel: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let GameInProgress = prefs.bool(forKey: "GameInProgress")
        
        print("Is there a game in progress...\(GameInProgress)")
        
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         self.title = "New Game"
        level = "Medium"
       // leveldata = "Medium"
        if let font = UIFont(name: "Noteworthy", size: 25.0) {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        
        segmentControl.items = ["Easy", "Medium", "Hard"]
        segmentControl.font = UIFont(name: "Noteworthy", size: 12)
        segmentControl.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmentControl.selectedIndex = 1
        segmentControl.thumbColor = UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0)
        segmentControl.selectedLabelColor = UIColor.white
        segmentControl.addTarget(self, action: #selector(ViewController.segmentValueChanged(_:)), for: .valueChanged)
        
        
        //segmentControlType.items = ["Free Play", "Group Play", "Timer Play"]
        segmentControlType.items = ["Free Play", "Group Play"]
        segmentControlType.font = UIFont(name: "Noteworthy", size: 12)
        segmentControlType.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmentControlType.selectedIndex = 0
        segmentControlType.thumbColor = UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0)
            //UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0)
        segmentControlType.selectedLabelColor = UIColor.white
        segmentControlType.addTarget(self, action: #selector(ViewController.segmentValueChangedType(_:)), for: .valueChanged)
        
        gameType = "FreePlay"
        
        ViewDifView = false
        
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        SwipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(SwipeDown)

        
        DifLevelBTN.layer.cornerRadius = 10
        DifLevelBTN.layer.borderWidth = 2
        DifLevelBTN.layer.borderColor = UIColor.lightGray.cgColor
        
        startGameButton.layer.cornerRadius = 65
        startGameButton.layer.borderWidth = 1
        startGameButton.layer.borderColor = UIColor.lightGray.cgColor
        
        theTraitsBTN.layer.cornerRadius = 35
        theTraitsBTN.layer.borderWidth = 1
        theTraitsBTN.layer.borderColor = UIColor.lightGray.cgColor
        
        DifView.layer.cornerRadius = 10
     //   self.revealViewController().rearViewRevealWidth = 62
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
                
        testlevel.delegate = self
        pickerView.delegate = self
        
       // pickerView.hidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
        leveldata = DifDropData[1] as NSString
   
        SKPaymentQueue.default().add(self)
        
        requestProductData()
        
       // traitDownloadProgressView.setProgress(0, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.UpdateDownloadProgress2), name: NSNotification.Name(rawValue: "UpdateDownloadProgress2"), object: nil)
        
        if  prefs.bool(forKey: "FinishedSavingAllTraits") {
            
            traitDownloadProgressView.isHidden = true
            updateProgressLBL.isHidden = true
            
        }
        
    }
    
    
    @objc func UpdateDownloadProgress2(_ notification:Notification) {
        
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
        
        print("*****updating download progress: \(currentProgressInt) of \(totalProgressInt)")
        
        let EachTraitProgress: Double = 1 / totalProgressDouble
        
        print("Each download is worth \(EachTraitProgress) of progress")
        
        let CurrentProgressFinalTemp = EachTraitProgress * currentProgressDouble
        
        print("Current Progress Final Temp = \(CurrentProgressFinalTemp)")
        let CurrentProgressFinal2 = Double(round(100*CurrentProgressFinalTemp)/100)
        let CurrentProgressFinal = Float(CurrentProgressFinal2)
        
        print("Should update trait download progress here, current float progress = \(CurrentProgressFinal)")
        
        traitDownloadProgressView.setProgress(CurrentProgressFinal, animated: true)
        
        print("Total progress: \(totalProgress)")
        print("currentProgress: \(currentProgress)")
        
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
    
    
    @IBAction func DifLevelBTN(_ sender: AnyObject) {
        
        //print("clicked dif level button")
        
        if !ViewDifView {
        print("should show dif view")
        UIView.animate(withDuration: 0.3, animations: {
            self.DifView.center.y = (self.DifView.center.y - 500)
        })
        ViewDifView = true
            
        }
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if ViewDifView {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                    
                case UISwipeGestureRecognizerDirection.down:
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.DifView.center.y = (self.DifView.center.y + 500)
                    })
                    ViewDifView = false
                    
                default:
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func NewGameBTN(_ sender: UIButton) {
        
        
        /*
      //  if ( leveldata.text != "" ){
        
        level = leveldata
       
        
        var urlData: NSData = CreateGameArray(level)
        
       // println(urlData)
        
        trait_ids = FilterTraitData(urlData)
        
       // prefs.setValue(trait_ids, forKey: "CURRENTGAMEIDS")
     //   prefs.setBool(true, forKey: "GameInProgress")
        print(trait_ids)

   // performSegueWithIdentifier("Select_NewGame", sender: self)
            
     //   }
        
        */
        
    }
    
    func StartGameNow() {
    
    if gameType == "FreePlay" {
    
    print("START NEW GAME PRESSED")
    
    let FreeGameInProgress = prefs.bool(forKey: "FreeGameInProgress")
    
    print("Is there a Free Play game in progress...\(FreeGameInProgress)")
    
    if FreeGameInProgress {
    print("A Game is in progress")
    
    
    
    let theAlert = SCLAlertView()
    theAlert.addButton("Yes") {
    
    print("RESUMING GAME")
        
      // self.prefs.set(0.0, forKey: "FREECURRENTGAMEIDSused")
    self.trait_ids = self.prefs.value(forKey: "FREECURRENTGAMEIDS") as! [Double]
        
        if self.prefs.value(forKey: "FREECURRENTGAMEIDSused") == nil {
         self.trait_ids_used = []
            self.prefs.set([], forKey: "FREECURRENTGAMEIDSused")
        } else {
    self.trait_ids_used = self.prefs.value(forKey: "FREECURRENTGAMEIDSused") as! [Double]
    
        }
            
    print("Yes continue game, number of traits = \(self.trait_ids.count)")
    
    self.prefs.set(true, forKey: "FreeGameInProgress")
    //self.prefs.boolForKey("ResumingGame")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    
    
    }
    
    theAlert.addButton("No") {
    
    let theAlert2 = SCLAlertView()
    theAlert2.addButton("Yes") {
    
    print("GAME IN PROGRESS BUT STARTING NEW GAME")
    
    self.prefs.set(false, forKey: "FreeGameInProgress")
    self.prefs.set(false, forKey: "ViewedCurrentTraits")
    
    
    print("Level = \(self.level)")
    
    
    self.level = self.leveldata
    
    print("Level Data = \(self.leveldata)")
    
    self.prefs.setValue(self.level, forKey: "FreeResumeDifLevel")
    
    
    
    
    
    /*
     let urlData: Data = CreateGameArray(self.level)
     self.trait_ids = FilterTraitData(urlData)
     */
    
    self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
    
    self.prefs.setValue(self.trait_ids, forKey: "FREECURRENTGAMEIDS")
    //   prefs.setBool(true, forKey: "GameInProgress")
    // print(self.trait_ids)
    
    let tempFG = self.prefs.bool(forKey: "FreeGameInProgress")
    
    print("Is Free Game IN progress: \(tempFG)")
    
    // prefs.setBool(true, forKey: "GameInProgress")
    
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    
    
    
    
    }
    
    /*
     theAlert2.addButton("No") {
     
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     }
     */
    
    // theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.")
    
    
    theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.", duration: nil, completeText: "No", style: .custom, colorStyle: 1, colorTextButton: 1)
    
    }
    
    //theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Free Play Game In Progress", subTitle: "Do you want to continue your current game?")
    
    theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Game In Progress", subTitle: "Do you want to continue your current Free Play game?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
    
    
    
    /*
     
     let actionSheetController: UIAlertController = UIAlertController(title: "Game In Progress", message: "Do you want to continue your current game?", preferredStyle: .alert)
     
     
     
     
     let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("RESUMING GAME")
     self.trait_ids = self.prefs.value(forKey: "FREECURRENTGAMEIDS") as! [Double]
     self.trait_ids_used = self.prefs.value(forKey: "FREECURRENTGAMEIDSused") as! [Double]
     
     print("Yes continue game, number of traits = \(self.trait_ids.count)")
     
     self.prefs.set(true, forKey: "FreeGameInProgress")
     //self.prefs.boolForKey("ResumingGame")
     DispatchQueue.main.async(execute: {
     self.performSegue(withIdentifier: "ResumeGame", sender: self)
     })
     
     
     //Do some other stuff
     }
     actionSheetController.addAction(nextAction)
     
     
     //Create and add the Cancel action
     let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     
     
     let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Are you sure?", message: "This will erase the game in progress?", preferredStyle: .alert)
     
     //Create and add the Cancel action
     let cancelActionNew: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     
     }
     actionSheetControllerNew.addAction(cancelActionNew)
     //Create and an option action
     let nextActionNew: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("GAME IN PROGRESS BUT STARTING NEW GAME")
     
     self.prefs.set(false, forKey: "FreeGameInProgress")
     self.prefs.set(false, forKey: "ViewedCurrentTraits")
     
     
     print("Level = \(self.level)")
     
     
     self.level = self.leveldata
     
     print("Level Data = \(self.leveldata)")
     
     self.prefs.setValue(self.level, forKey: "FreeResumeDifLevel")
     
     
     
     
     
     /*
     let urlData: Data = CreateGameArray(self.level)
     self.trait_ids = FilterTraitData(urlData)
     */
     
     self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
     
     self.prefs.setValue(self.trait_ids, forKey: "FREECURRENTGAMEIDS")
     //   prefs.setBool(true, forKey: "GameInProgress")
     // print(self.trait_ids)
     
     let tempFG = self.prefs.bool(forKey: "FreeGameInProgress")
     
     print("Is Free Game IN progress: \(tempFG)")
     
     // prefs.setBool(true, forKey: "GameInProgress")
     
     DispatchQueue.main.async(execute: {
     self.performSegue(withIdentifier: "ResumeGame", sender: self)
     })
     
     //self.performSegueWithIdentifier("ResumeGame", sender: self)
     
     //Do some other stuff
     }
     actionSheetControllerNew.addAction(nextActionNew)
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.present(actionSheetControllerNew, animated: true, completion: nil)
     
     
     
     }
     actionSheetController.addAction(cancelAction)
     //Create and an option action
     
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.present(actionSheetController, animated: true, completion: nil)
     
     */
    
    } else {
    
    
    
    level = leveldata
    
    prefs.setValue(level, forKey: "FreeResumeDifLevel")
    
    /*
     let urlData: Data = CreateGameArray(level)
     trait_ids = FilterTraitData(urlData)
     */
    
    self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
    
    prefs.setValue(trait_ids, forKey: "FREECURRENTGAMEIDS")
    //   prefs.setBool(true, forKey: "GameInProgress")
    print(trait_ids)
    
    self.prefs.set(false, forKey: "FreeGameInProgress")
    self.prefs.set(false, forKey: "ViewedCurrentTraits")
    
    print("NO GAME IN PROGRESS, STARTING NEW GAME")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    }
    
    
    } else if gameType == "TimerPlay" {
    
    print("START NEW GAME PRESSED")
    
    // let GameInProgress = prefs.boolForKey("GameInProgress")
    let TimerGameInProgress = prefs.bool(forKey: "TimerGameInProgress")
    print("Is there a Timer game in progress...\(TimerGameInProgress)")
    
    
    
    if TimerGameInProgress {
    print("A Game is in progress")
    
    
    
    
    let theAlert = SCLAlertView()
    theAlert.addButton("Yes") {
    
    print("RESUMING GAME")
    self.trait_ids = self.prefs.value(forKey: "TIMERCURRENTGAMEIDS") as! [Double]
    self.trait_ids_used = self.prefs.value(forKey: "TIMERCURRENTGAMEIDSused") as! [Double]
    
    print("Yes continue game, number of traits = \(self.trait_ids.count)")
    
    self.prefs.set(true, forKey: "TimerGameInProgress")
    //self.prefs.boolForKey("ResumingGame")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    
    
    }
    
    theAlert.addButton("No") {
    
    let theAlert2 = SCLAlertView()
    theAlert2.addButton("Yes") {
    
    print("RESUMING GAME")
    self.trait_ids = self.prefs.value(forKey: "TIMERCURRENTGAMEIDS") as! [Double]
    self.trait_ids_used = self.prefs.value(forKey: "TIMERCURRENTGAMEIDSused") as! [Double]
    
    print("Yes continue game, number of traits = \(self.trait_ids.count)")
    
    self.prefs.set(true, forKey: "TimerGameInProgress")
    //self.prefs.boolForKey("ResumingGame")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    
    
    }
    /*
     theAlert2.addButton("No") {
     
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     }
     */
    // theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.")
    
    theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.", duration: nil, completeText: "No", style: .custom, colorStyle: 1, colorTextButton: 1)
    }
    
    // theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Timer Game In Progress", subTitle: "Do you want to continue your current game?")
    
    theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Game In Progress", subTitle: "Do you want to continue your current Timer game?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
    
    
    /*
     
     let actionSheetController: UIAlertController = UIAlertController(title: "Timer Game In Progress", message: "Do you want to continue your current game?", preferredStyle: .alert)
     
     let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("RESUMING GAME")
     self.trait_ids = self.prefs.value(forKey: "TIMERCURRENTGAMEIDS") as! [Double]
     self.trait_ids_used = self.prefs.value(forKey: "TIMERCURRENTGAMEIDSused") as! [Double]
     
     print("Yes continue game, number of traits = \(self.trait_ids.count)")
     
     self.prefs.set(true, forKey: "TimerGameInProgress")
     //self.prefs.boolForKey("ResumingGame")
     DispatchQueue.main.async(execute: {
     self.performSegue(withIdentifier: "ResumeGame", sender: self)
     })
     
     //Do some other stuff
     }
     actionSheetController.addAction(nextAction)
     
     
     //Create and add the Cancel action
     let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     
     
     let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Are you sure?", message: "This will erase the game in progress.", preferredStyle: .alert)
     
     //Create and add the Cancel action
     let cancelActionNew: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     
     }
     actionSheetControllerNew.addAction(cancelActionNew)
     //Create and an option action
     let nextActionNew: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("GAME IN PROGRESS BUT STARTING NEW GAME")
     
     self.prefs.set(false, forKey: "TimerGameInProgress")
     self.prefs.set(false, forKey: "ViewedCurrentTraits")
     
     self.prefs.setValue(self.level, forKey: "TimerResumeDifLevel")
     
     self.level = self.leveldata
     
     
     // let urlData: Data = CreateGameArray(self.level)
     
     // println(urlData)
     
     // self.trait_ids = FilterTraitData(urlData)
     
     self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
     
     self.prefs.setValue(self.trait_ids, forKey: "TIMERCURRENTGAMEIDS")
     //   prefs.setBool(true, forKey: "GameInProgress")
     // print(self.trait_ids)
     
     
     // prefs.setBool(true, forKey: "GameInProgress")
     DispatchQueue.main.async(execute: {
     self.performSegue(withIdentifier: "Select_NewGame", sender: self)
     })
     
     //self.performSegueWithIdentifier("ResumeGame", sender: self)
     
     //Do some other stuff
     }
     actionSheetControllerNew.addAction(nextActionNew)
     
     self.present(actionSheetControllerNew, animated: true, completion: nil)
     
     
     
     }
     actionSheetController.addAction(cancelAction)
     //Create and an option action
     
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.present(actionSheetController, animated: true, completion: nil)
     
     */
    
    } else {
    
    
    
    level = leveldata
    
    prefs.setValue(level, forKey: "TimerResumeDifLevel")
    
    
    // let urlData: Data = CreateGameArray(level)
    
    // println(urlData)
    
    //  trait_ids = FilterTraitData(urlData)
    trait_ids = RetrieveImages(theDifLevelTemp: level as String)
    
    prefs.setValue(trait_ids, forKey: "TIMERCURRENTGAMEIDS")
    //   prefs.setBool(true, forKey: "GameInProgress")
    print(trait_ids)
    
    self.prefs.set(false, forKey: "TimerGameInProgress")
    self.prefs.set(false, forKey: "ViewedCurrentTraits")
    
    print("NO GAME IN PROGRESS, STARTING NEW GAME")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "Select_NewGame", sender: self)
    })
    
    }
    
    
    } else if gameType == "GroupPlay" {
    
    print("START NEW GAME PRESSED for Group Play")
    
    // let GameInProgress = prefs.boolForKey("GameInProgress")
    let GroupGameInProgress = prefs.bool(forKey: "GroupGameInProgress")
    print("Is there a Group game in progress...\(GroupGameInProgress)")
    
    if GroupGameInProgress {
    print("A Game is in progress")
    
    
    let theAlert = SCLAlertView()
    theAlert.addButton("Yes") {
    
    print("RESUMING GROUP GAME")
    self.trait_ids = self.prefs.value(forKey: "GROUPCURRENTGAMEIDS") as! [Double]
    self.trait_ids_used = self.prefs.value(forKey: "GROUPCURRENTGAMEIDSused") as! [Double]
    
    print("Yes continue game, number of traits = \(self.trait_ids.count)")
    
    self.prefs.set(true, forKey: "GroupGameInProgress")
    //self.prefs.boolForKey("ResumingGame")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "ResumeGame", sender: self)
    })
    
    
    
    }
    
    theAlert.addButton("No") {
    
    let theAlert2 = SCLAlertView()
    theAlert2.addButton("Yes") {
    
    print("GAME IN PROGRESS BUT STARTING NEW GAME")
    
    self.prefs.set(false, forKey: "GroupGameInProgress")
    self.prefs.set(false, forKey: "ViewedCurrentTraits")
    
    self.prefs.setValue(self.level, forKey: "GroupResumeDifLevel")
    
    self.level = self.leveldata
    
    
    
    self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
    
    self.prefs.setValue(self.trait_ids, forKey: "GroupCURRENTGAMEIDS")
    //   prefs.setBool(true, forKey: "GameInProgress")
    // print(self.trait_ids)
    
    
    // prefs.setBool(true, forKey: "GameInProgress")
    DispatchQueue.main.async(execute: {
    
    // print("Trait IDs Group Starting = \(self.trait_ids)")
    
    self.performSegue(withIdentifier: "Select_NewGame", sender: self)
    })
    
    
    
    
    }
    
    /*
     theAlert2.addButton("No") {
     
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     }
     */
    
    // theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.")
    
    theAlert2.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Are you sure?", subTitle: "This will erase the current game in progress.", duration: nil, completeText: "No", style: .custom, colorStyle: 1, colorTextButton: 1)
    }
    
    // theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Group Game In Progress", subTitle: "Do you want to continue your current game?")
    
    theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Game In Progress", subTitle: "Do you want to continue your current Group game?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
    
    /*
     
     let actionSheetController: UIAlertController = UIAlertController(title: "Group Game In Progress", message: "Do you want to continue your current game?", preferredStyle: .alert)
     
     
     
     
     let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("RESUMING GROUP GAME")
     self.trait_ids = self.prefs.value(forKey: "GROUPCURRENTGAMEIDS") as! [Double]
     self.trait_ids_used = self.prefs.value(forKey: "GROUPCURRENTGAMEIDSused") as! [Double]
     
     print("Yes continue game, number of traits = \(self.trait_ids.count)")
     
     self.prefs.set(true, forKey: "GroupGameInProgress")
     //self.prefs.boolForKey("ResumingGame")
     DispatchQueue.main.async(execute: {
     self.performSegue(withIdentifier: "ResumeGame", sender: self)
     })
     
     //Do some other stuff
     }
     actionSheetController.addAction(nextAction)
     
     
     //Create and add the Cancel action
     let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     
     
     let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Are you sure?", message: "This will erase the game in progress?", preferredStyle: .alert)
     
     //Create and add the Cancel action
     let cancelActionNew: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     print("GAME IN PROGRESS, CANCEL NEW GAME")
     
     
     }
     actionSheetControllerNew.addAction(cancelActionNew)
     //Create and an option action
     let nextActionNew: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
     
     print("GAME IN PROGRESS BUT STARTING NEW GAME")
     
     self.prefs.set(false, forKey: "GroupGameInProgress")
     self.prefs.set(false, forKey: "ViewedCurrentTraits")
     
     self.prefs.setValue(self.level, forKey: "GroupResumeDifLevel")
     
     self.level = self.leveldata
     
     
     
     self.trait_ids = self.RetrieveImages(theDifLevelTemp: self.level as String)
     
     self.prefs.setValue(self.trait_ids, forKey: "GroupCURRENTGAMEIDS")
     //   prefs.setBool(true, forKey: "GameInProgress")
     // print(self.trait_ids)
     
     
     // prefs.setBool(true, forKey: "GameInProgress")
     DispatchQueue.main.async(execute: {
     
     // print("Trait IDs Group Starting = \(self.trait_ids)")
     
     self.performSegue(withIdentifier: "Select_NewGame", sender: self)
     })
     
     //self.performSegueWithIdentifier("ResumeGame", sender: self)
     
     //Do some other stuff
     }
     actionSheetControllerNew.addAction(nextActionNew)
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.present(actionSheetControllerNew, animated: true, completion: nil)
     
     
     
     }
     actionSheetController.addAction(cancelAction)
     //Create and an option action
     
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.present(actionSheetController, animated: true, completion: nil)
     
     */
    
    } else {
    
    
    
    level = leveldata
    
    prefs.setValue(level, forKey: "GroupResumeDifLevel")
    
    
    // let urlData: Data = CreateGameArray(level)
    
    // println(urlData)
    
    //  trait_ids = FilterTraitData(urlData)
    trait_ids = RetrieveImages(theDifLevelTemp: level as String)
    
    prefs.setValue(trait_ids, forKey: "GROUPCURRENTGAMEIDS")
    //   prefs.setBool(true, forKey: "GameInProgress")
    print(trait_ids)
    
    self.prefs.set(false, forKey: "GroupGameInProgress")
    self.prefs.set(false, forKey: "ViewedCurrentTraits")
    
    print("NO GAME IN PROGRESS, STARTING NEW GAME")
    DispatchQueue.main.async(execute: {
    self.performSegue(withIdentifier: "Select_NewGame", sender: self)
    })
    
    }
    
    
    } else {
    
    
    /*
     
     let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Timer Play!", message: "Coming Soon", preferredStyle: .Alert)
     
     //Create and add the Cancel action
     let cancelActionNew: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
     //Do some stuff
     // self.performSegueWithIdentifier("Select_NewGame", sender: self)
     
     
     // self.segmentControlType.selectedIndex == 0
     // self.segmentControlType.sendActionsForControlEvents(UIControlEvents.ValueChanged)
     // self.segmentValueChanged(self)
     
     }
     actionSheetControllerNew.addAction(cancelActionNew)
     //Create and an option action
     
     //Add a text field
     
     /*
     actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
     //TextField configuration
     textField.textColor = UIColor.blueColor()
     }
     */
     
     //Present the AlertController
     self.presentViewController(actionSheetControllerNew, animated: true, completion: nil)
     
     self.segmentControlType.selectedIndex == 0
     self.segmentControlType.sendActionsForControlEvents(UIControlEvents.ValueChanged)
     self.segmentControlType.displayNewSelectedIndex()
     
     
     
     }
     
     */
    
    }
    
    }
    
    
    @IBAction func StartNewGame(_ sender: AnyObject) {
        
        
        let TraitsSynced = prefs.bool(forKey: "FinishedSavingAllTraits")
        
        if TraitsSynced {
        
        
        
        let AllTraitsPurchased = prefs.bool(forKey: "AllTraitsPurchased")
        
        let theAlertTraits = SCLAlertView()
       
        if AllTraitsPurchased {

           self.StartGameNow()
            
        } else {
            
            theAlertTraits.addButton("Upgrade Now") {
            
                self.requestProductData()
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.buyProduct()
                    
                })
                
                
            }
           
            theAlertTraits.addButton("Later") {
                
                self.StartGameNow()
                
            }
            
            
            theAlertTraits.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Limited Traits", subTitle: "You're playing with only 10 Traits, for only $0.99 you can get all the traits...hundreds.", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
            
        }
        
            
            
        } else {
            
            
             let theAlertTraits = SCLAlertView()
            
            theAlertTraits.addButton("Ok") {
                
               
                
            }
            
            theAlertTraits.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Traits Loading", subTitle: "We are updating your traits, you're missing some new ones, this will only take a moment.", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
            
        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select_NewGame" {
           // let viewController = segue.destinationViewController as! NewGameViewController
             let viewController = segue.destination as! NewGameSettingsViewController
            //viewController.Traits = leveldata
           viewController.trait_ids = self.trait_ids
           viewController.gameType = self.gameType
           viewController.trait_ids_used = self.trait_ids_used
            
           // let Traits = trait_ids
        }
        
        if segue.identifier == "ResumeGame" {
             let viewController = segue.destination as! NewGameViewController
            //let viewController = segue.destinationViewController as! NewGameSettingsViewController
            //viewController.Traits = leveldata
            viewController.Traits = trait_ids
            viewController.TraitsUsed = trait_ids_used
            viewController.GameType = self.gameType
            
            
            // let Traits = trait_ids
        }
        
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DifDropData.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return DifDropData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       testlevel.text = DifDropData[row]
                leveldata = DifDropData[row] as NSString
        ViewDifView = false
        
        /*
        switch DifDropData[row]{
            case "Easy":
            DifComment.text = "Easy, taking it easy huh"
         
            case "Medium":
            DifComment.text = "Medium...nice and smooth"
         
            case "Hard":
            DifComment.text = "Hard...feeling adventerous I see."
         
        default:
            DifComment.text = "Select difficulty level, then tap Start Game"
        }
        */
        
        //pickerView.hidden = true;
        
        
        
    /*
        if(row == 0)
        {
            self.view.backgroundColor = UIColor.whiteColor()
        }
        else if(row == 1)
        {self.view.backgroundColor = UIColor.redColor()
        }
        else if(row == 3)
        {self.view.backgroundColor = UIColor.greenColor()    }
*/
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.isHidden = false
        return false
    }
    
    
    
    @objc func segmentValueChanged(_ sender: AnyObject?){
        
        if segmentControl.selectedIndex == 0 {
            leveldata = "Easy"
                        // })
            //salesValue.text = "$23,399"
            DifComment.text = "Easy, taking it easy huh"
            DispatchQueue.main.async(execute: {
             
            })
            
            //filterContentForSearchText("", scope: "All")
            
        } else if segmentControl.selectedIndex == 1{
            leveldata = "Medium"
                      //  })
            DifComment.text = "Medium...nice and smooth"
            DispatchQueue.main.async(execute: {
                
            })
            //filterContentForSearchText("", scope: "Complete")
            //salesValue.text = "$81,295"
        } else {
            leveldata = "Hard"
            
            DifComment.text = "Hard...feeling adventerous I see."
            DispatchQueue.main.async(execute: {
               
            })
            //   })
            // filterContentForSearchText("", scope: "In Process")
            //salesValue.text = "$199,392"
        }
    }
    
    @objc func segmentValueChangedType(_ sender: AnyObject?){
        
        if segmentControlType.selectedIndex == 0 {
            gameType = "FreePlay"
            // })
            //salesValue.text = "$23,399"
           // DifComment.text = "Easy, taking it easy huh"
            DispatchQueue.main.async(execute: {
                
            })
            
            //filterContentForSearchText("", scope: "All")
            
        } else if segmentControlType.selectedIndex == 1{
            gameType = "GroupPlay"
            //  })
          //  DifComment.text = "Medium...nice and smooth"
            DispatchQueue.main.async(execute: {
                
            })
            //filterContentForSearchText("", scope: "Complete")
            //salesValue.text = "$81,295"
        } else if segmentControlType.selectedIndex == 2{
            gameType = "TimerPlay"
            //  })
            //  DifComment.text = "Medium...nice and smooth"
            DispatchQueue.main.async(execute: {
                
            })
            //filterContentForSearchText("", scope: "Complete")
            //salesValue.text = "$81,295"
        }
        
        /*else {
            leveldata = "Hard"
         
            DifComment.text = "Hard...feeling adventerous I see."
            dispatch_async(dispatch_get_main_queue(), {
         
            })
            //   })
            // filterContentForSearchText("", scope: "In Process")
            //salesValue.text = "$199,392"
        }
 
 */
    }
    
    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DifDropData.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.DifMenu.dequeueReusableCellWithIdentifier("BasicCell") as! UITableViewCell
        cell.textLabel?.text = self.DifDropData[indexPath.row]
        return cell}*/
    
    @IBAction func addplayersButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "add_players", sender: self)
    
    }
    
    @IBAction func InfoDifLevel(_ sender: AnyObject) {
        
        let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Difficulty Level?", message: "Select a difficulty level...the Harder the level the more 'uncomfortable' the Traits could be.", preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelActionNew: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            
            
        }
        actionSheetControllerNew.addAction(cancelActionNew)
      
        self.present(actionSheetControllerNew, animated: true, completion: nil)
        
    }
    
    @IBAction func InfoGameType(_ sender: AnyObject) {
        
        let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Game Type?", message: "You can choose one of the Game Types below. Free play allows you to go through the traits one by one.  In Group Play you can select the number of people playing and everyone will get a Trait at once.", preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelActionNew: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
           
            
        }
        actionSheetControllerNew.addAction(cancelActionNew)
      
        self.present(actionSheetControllerNew, animated: true, completion: nil)
    }
    
    
    
    func RetrieveImages(theDifLevelTemp: String) -> [Double] {
        
        var trait_ids_temp = [Double]()
        
        var TotalItemsTemp = Int()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContextGroups = appDelegate.managedObjectContext
        let fetchGroups = NSFetchRequest<NSFetchRequestResult>(entityName: "TraitInfo")
        let errorGroups: NSError?
        
        do {
            let fetchedResultsGroups =  try managedContextGroups!.fetch(fetchGroups) as? [NSManagedObject]
            
            if let resultsGroups = fetchedResultsGroups {
                SavedItemsInventory = resultsGroups
               // print("Saved items = \(SavedItemsInventory)")
            } else {
                //   print("Could not fetch\(errorGroups), \(errorGroups!.userInfo)")
            }
            
            for items in SavedItemsInventory as [NSManagedObject] {
               // TotalItems += 1
                TotalItemsTemp += 1
                // ItemsInventoryArray.append(CurNumGroups)
                
                // let traitImageURL = items.value(forKey: "imageURL") as! String
                //let ItemCategory = items.value(forKey: "category") as! String
                //let ItemOrder = items.value(forKey: "itemOrder") as! String
                
                
                let traitname = items.value(forKey: "traitname") as! String
                let traitimagedata = items.value(forKey: "traitimagedata") as! String
                let traitlevel = items.value(forKey: "traitlevel") as! String
                let traitdescription = items.value(forKey: "traitdescription") as! String
                let traitid = items.value(forKey: "traitid") as! String
                let localTrait = items.value(forKey: "localTrait") as! Bool
                
               // trait_ids_temp.app
                
                let traitImageURL = items.value(forKey: "imageURL") as! String
                
                // if (traitlevel == "\(theDifLevel)") && (itemOrder != "0") {
                
                
                switch theDifLevelTemp {
                    
                    
                case "Easy":
                    
                    
                    if (traitlevel == "\(theDifLevelTemp)") {
                        
                        // TotalTraitsInventoryArray.append(ItemInventorySorted(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, itemOrderNum: Int(itemOrder)!, health: health, stamina: stamina, viewRange: viewRange, subCategory: subCategory))
                        
                        TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait))
                        
                        trait_ids_temp.append((traitid as NSString).doubleValue)
                        
                        
                    }
                    
                case "Medium":
                    
               
                    if (traitlevel == "\(theDifLevelTemp)") || (traitlevel == "Easy") {
                        
                        
                        // TotalTraitsInventoryArray.append(ItemInventorySorted(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, itemOrderNum: Int(itemOrder)!, health: health, stamina: stamina, viewRange: viewRange, subCategory: subCategory))
                        
                        TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait))
                        
                         trait_ids_temp.append((traitid as NSString).doubleValue)
                        
                    }
                    
                case "Hard":
                    
                    
                    TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait))
                    
                     trait_ids_temp.append((traitid as NSString).doubleValue)
                    
                    
                    
                default:
                    break
                }
                
                
            }
            
            //    print("TotalItemsInventoryArray - PreSorted - \(TotalItemsInventoryArray)")
            
            
            
            TotalTraitsInventoryArray.sort { (lhs: TraitInventorySorted, rhs: TraitInventorySorted) -> Bool in
                // you can have additional code here
                return lhs.traitid < rhs.traitid
            }
            
            
            
           // print("TotalItemsInventoryArray - Sorted - \(TotalTraitsInventoryArray)")
            
            
            // print("Current items IMAGE URL =\(TotalItemsArray)")
            
            
            
            if self.SavedItemsInventory.count > 0 {
                //  GroupInfoLBL.hidden = true
            } else {
                //  GroupInfoLBL.hidden = false
            }
            
            
        } catch {
            print(error)
        }
        
      return trait_ids_temp
    }
    
    
    
    @IBAction func unwindToStartNewGame(_ unwindSegue: UIStoryboardSegue) {
        if let GroupGameController = unwindSegue.source as? GroupGameTraitsViewController {
            print("Coming from Group Game Controller")
        }
        else if let freePlayController = unwindSegue.source as? NewGameViewController {
            print("Coming from New Game Controller")
        }
            /*
        else if let CompleteViewController = unwindSegue.source as? PageIntroViewController {
            print("Coming from Completed")
        }
        else if let theGameViewController = unwindSegue.source as? GameViewController {
            print("Coming GameViewController")
        }
        */
        
    }
    
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            
            print("Can Make Payments")
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers as Set<String>)
            request.delegate = self
            request.start()
            
            print("Product Arrays = \(productsArray)")
            
            
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: URL? = URL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            for i in 0 ..< products.count
            {
                self.product = products[i] as? SKProduct
                print("product found \(self.product?.localizedDescription)")
                print("product found \(self.product?.localizedTitle)")
                
                self.productsArray.append(product!)
            }
            
        } else {
            print("No products found")
        }
        
        //  products = response.invalidProductIdentifiers
        
        for product in products
        {
            print("Product not found: \(product)")
        }
    }
    
    func buyProduct() {
        
        print("Products Array: \(productsArray)")
        let payment = SKPayment(product: productsArray[0])
        //sender.tag
        print("buying product = payment = \(payment)")
        
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
                
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits"
            
            /* if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.RemoveAds"
             */
        {
            print("Non-Consumable Product Purchased")
            
            if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AlTraits" {
                
                prefs.set(true, forKey: "AllTraitsPurchased")
                
                RetrieveTraits()
                
                    DispatchQueue.main.async(execute: {
                    print("updating traits")
                    
                   // let UpdatedTraits = false
                    let username = "guest"
                    
                    let seconds = 4.0
                    let secondsLoad = 2.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    
                    
                    let secondsQuick = 3.0
                    let delayQuick = secondsQuick * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTimeQuick = DispatchTime.now() + Double(Int64(delayQuick)) / Double(NSEC_PER_SEC)
                    
                    var TraitInventoryInfo = [TraitInventory]()
                        
                        
                        
                    
                        var UpdatedTraits = Bool()
                        // let UpdatedTraits = false
                        
                        
                        
                        let CurrentSavedTraits = self.prefs.value(forKey: "SavedServerTraits") as! Int
                        
                        var CurrentServerTraitCount = Int()
                        var CurrentServerTraitIDs = [String]()
                        
                        (CurrentServerTraitCount, CurrentServerTraitIDs) = GetServerTraitCount(username as NSString)
                        
                        
                        
                        
                        
                        print("CurrentSavedTraits: \(CurrentSavedTraits), CurrentServerTraits: \(CurrentServerTraitCount)")
                        
                        
                        
                        for serverTraitID in CurrentServerTraitIDs {
                            
                            
                            if self.LocalSavedTraits.contains(serverTraitID) {
                                
                            } else {
                                self.UnSyncedTraits.append(serverTraitID)
                            }
                            
                            
                        }
                        
                        
                        
                        print("These are the traits not downloaded: \(self.UnSyncedTraits)")
                        
                        
                        
                        if CurrentServerTraitCount > CurrentSavedTraits {
                            
                            UpdatedTraits = false
                            
                        } else {
                            UpdatedTraits = true
                        }

                        
                        
                        
                        
                        
                    
                    if Reachability.isConnectedToNetwork() {
                        
                        if !UpdatedTraits {
                            
                           
                            
                           // DispatchQueue.main.async(execute: {
                                backgroundThread(background: {
                                    
                                    
                                    
                                    let URLDataItems = RefreshTraitInventory(username as NSString, UnsyncedTraits: self.UnSyncedTraits)
                                    TraitInventoryInfo = self.FilterTraitData(URLDataItems)
                                    
                                    
                                    
                                    for items in TraitInventoryInfo {
                                        let TraitImageName = "\(items.traitname)_\(items.traitid)"
                                        SaveFileNSData(items.traitimagedata, name: "/\(TraitImageName).png")
                                    }
                                    
                                    //self.LoadProgressView.setProgress(0.7, animated: true)

                                }, completion: {
                                    
                                    
                                    self.prefs.set(true, forKey: "TRAITSUPDATED")
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        // self.LoadProgressView.setProgress(1.0, animated: true)
                                        
                                        print("FINISHED UPDATING ALL THE TRAITS")
                                        
                                        
                                        self.dismiss(animated: true, completion: nil)

                                    })
                  
                                })

                          //  })
                            
                        } else {
                            
                            //  self.LoadProgressView.setProgress(1.0, animated: true)

                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    } else {
                        
                        SCLAlertView().showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Oops, Network Error", subTitle: "Please Confirm Your Network Settings", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
                        
                    }
                    
                })
                
                
                
            }
            /*
             
             if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits" {
             
             prefs.set(true, forKey: "AllTraitsPurchased")
             
             }
             
             if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.RemoveAds" {
             
             prefs.set(true, forKey: "RemoveAdsPurchased")
             
             }
             */
            // Unlock Feature
        }
    }
    
    func restorePurchases(_ sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions Restored")
        
        // var purchasedItemIDS = []
        for transaction:SKPaymentTransaction in queue.transactions {
            
            if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits"
                /*
                 if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.RemoveAds"
                 */
            {
                print("Non-Consumable Product Purchased")
                // Unlock Feature
            }
            /*
             if transaction.payment.productIdentifier == "com.ClavenSolutions.TelePictionary.pcamera" || transaction.payment.productIdentifier == "com.ClavenSolutions.TelePictionary.paudio" || transaction.payment.productIdentifier == "com.ClavenSolutions.TelePictionary.allpurchase"
             {
             print("Non-Consumable Product Purchased")
             // Unlock Feature
             }
             
             */
        }
        
        let alert = UIAlertView(title: "Thank You", message: "Your purchase(s) were restored.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    
    func RetrieveTraits() {
        
        LocalSavedTraits.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContextGroups = appDelegate.managedObjectContext
        let fetchGroups = NSFetchRequest<NSFetchRequestResult>(entityName: "TraitInfo")
        let errorGroups: NSError?
        
        // self.LoadProgressView.setProgress(0.1, animated: true)
        
        do {
            let fetchedResultsGroups =  try managedContextGroups!.fetch(fetchGroups) as? [NSManagedObject]
            
            if let resultsGroups = fetchedResultsGroups {
                SavedItemsInventory = resultsGroups
                //  print("Saved items = \(SavedItemsInventory)")
            } else {
                //   print("Could not fetch\(errorGroups), \(errorGroups!.userInfo)")
            }
            
            for items in SavedItemsInventory as [NSManagedObject] {
                TotalItems += 1
                // ItemsInventoryArray.append(CurNumGroups)
                
                let ItemNameURL = items.value(forKey: "imageURL") as! String
                let TraitID = items.value(forKey: "traitid") as! String
                
                
                TotalTraitsArray.append(ItemNameURL as NSString)
                LocalSavedTraits.append(TraitID)
            }
            
            
            //  print("Current items IMAGE URL =\(TotalItemsArray)")
            
            
            
            if self.SavedItemsInventory.count > 0 {
                //  GroupInfoLBL.hidden = true
            } else {
                //  GroupInfoLBL.hidden = false
            }
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    func FilterTraitData(_ urlData: Data) -> [TraitInventory] {
        print("NEED TO UPDATE ITEM INFO/IMAGES, DOING THAT NOW")
        
        var ItemData = [TraitInventory]()
        
        let AllTraitsPurchased = prefs.bool(forKey: "AllTraitsPurchased")
        var MaxTraitsAllowed = Int()
        var NumberTraitsAdded = 0
        if AllTraitsPurchased {
            print("***GETTING ALL TRAITS, NO MAX")
            MaxTraitsAllowed = 1000000
        } else {
            print("***GETTING 10 TRAITS, LIMITED")
            MaxTraitsAllowed = 10
        }
        
        
        
        
        var traits = [NSString]()
        
        let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
        
        var json = JSON(jsonData)
        
        
        
        for result in json["Items"].arrayValue {
            
            if ( result["traitid"] != "0") {
                
                if NumberTraitsAdded <= MaxTraitsAllowed {
                    NumberTraitsAdded += 1
                    
                    print("Number of Traits Added = \(NumberTraitsAdded), Max Allowed Traits = \(MaxTraitsAllowed)")
                    
                    let traitname = result["traitname"].stringValue
                    //let imageURL = result["imageURL"].stringValue
                    
                    let traitlevel = result["traitlevel"].stringValue
                    let traitid = result["traitid"].stringValue
                    let traitimagedata = result["traitimagedata"].stringValue
                    let TraitDescOld = result["traitdescription"].stringValue
                    
                    
                    /*
                     let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                     let traitname = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
                     */
                    
                    let TraitDescNSData = Data(base64Encoded: TraitDescOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    
                    let traitdescription = NSString(data: TraitDescNSData, encoding: String.Encoding.utf8.rawValue)!
                    
                    
                    let imageURL = "\(traitname)_\(traitid)"
                    
                    // if uniqueitem == "yes" {
                    
                    // ItemData.append(TraitInventory(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, viewRange: viewRange, subCategory: subCategory))
                    
                    ItemData.append(TraitInventory(traitname: traitname as NSString, imageURL: imageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription, localTrait: false))
                    
                    //  }
                    
                    //  if uniqueitem == "yes" {
                    
                    if !TotalTraitsArray.contains(imageURL as NSString) {
                        
                        print("ITEMS: Name=\(traitname) id=\(traitid)  has not been saved yet, saving now")
                        
                        //  SaveNewItem(itemname, imageurltemp: imageURL, powertemp: power, rangetemp: range, speedtemp: speed, categorytemp: category, imageurl100temp: imageURL100, itemordertemp: itemOrder, healthtemp: health, staminatemp: stamina, viewRangetemp: viewRange, subCategory: subCategory)
                        
                        SaveNewItem(traitname as NSString, imageurltemp: imageURL, leveltemp: traitlevel, idtemp: traitid, imagedatatemp: traitimagedata, descriptiontemp: traitdescription,  localTrait: false)
                        
                        
                        //  }
                        
                        /*
                         if !TotalImagesArray.contains(imageURL) {
                         print("IMAGES: \(itemname) has not been saved yet, saving now")
                         
                         SaveNewImage(itemname, imageurltemp: imageURL, categorytemp: category)
                         }
                         */
                        
                    }
                }
            }
            
        }
        
        // print("ItemData from Filter \(ItemData)")
        
        return ItemData
    }
    
    @IBAction func ViewAllTraits(_ sender: Any) {
        
        
        
        let TraitsSynced = prefs.bool(forKey: "FinishedSavingAllTraits")
        
        if TraitsSynced {
        
        self.performSegue(withIdentifier: "ViewTheTraits", sender: self)
        } else {
            let theAlertTraits = SCLAlertView()
            
            theAlertTraits.addButton("Ok") {
                
                
                
            }
            
            theAlertTraits.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Traits Loading", subTitle: "We are updating your traits, you're missing some new ones, this will only take a moment.", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
        }
    }
    
}

