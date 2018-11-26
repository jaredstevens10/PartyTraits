//
//  GroupGameTraitsViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 12/3/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData
import AddressBookUI
import MessageUI
import GoogleMobileAds

class GroupGameTraitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    var PlayerRowSelected = Int()
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9759787683845878/9895698149"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var interstitial: GADInterstitial?
    
    var DidRemoveAds = Bool()
    
    var HidePlayerTraits = Bool()
    var GroupGameMaxRounds = Double()
    var GroupGameTraits = [Double]()
    var TraitsUsed = [Double]()
    var TotalTraits = [Double]()
    var ResumeGroupGame = Bool()
    var CurrentRoundTraits = [Double]()
    var NumberPlayersArray = [Int]()
    var StartingTraits = [Double]()
    
    @IBOutlet weak var nextRoundView: UIView!
    @IBOutlet weak var nextRoundBTN: UIButton!
    
    var CurrentGroupGameInfo: GroupGameInfoUpdate?
    
    var currentRound = Int()
    var PlayerNamesArray = [String]()
    var GroupGameMaxRoundsInt = Int()
    
    @IBOutlet weak var roundLBL: UILabel!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var nextRound: UIButton!
    
    var GameTotalTraitInfo = [TraitInventoryPlayer]()
    
    @IBOutlet weak var HaveTraitsLBL: UILabel!
    var myData: Array<AnyObject> = []
    
    let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    var TotalItems = Int()
    var SavedItemsInventory = [NSManagedObject]()
    
    var TotalTraitsInventoryArray = [TraitInventoryUsed]()
    
    let prefs:UserDefaults = UserDefaults.standard
    var username = NSString()
    //@IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var TableView: UITableView!
    
    var NumTraits = [Int]()
    var TraitsObject = [NSManagedObject]()
    var LocalTraits = [NSManagedObject]()
    var CurNum = Int()
    var CurNumTraits = Int()
    
    @IBOutlet weak var hideTraitLBL: UILabel!
    
    @IBOutlet weak var hideTraitBTN: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HidePlayerTraits = true
        self.hideTraitLBL.text = "Unhide Trait"
        
        self.hideTraitBTN.setOn(true, animated: false)
        
        
        self.nextRoundView.layer.cornerRadius = 20
        self.nextRoundView.clipsToBounds = true
        self.nextRoundView.layer.masksToBounds = true
        
        //self.prefs.set(true, forKey: "ViewedCurrentTraits")
        
        
        //print("GROUP GAME TRAITS: \(GroupGameTraits)")
        
        self.HaveTraitsLBL.isHidden = true
        //self.AddTraitBTN.clipsToBounds = true
        //self.AddTraitBTN.layer.cornerRadius = 20
        //self.AddTraitBTN.layer.masksToBounds = true
        
       // print("Current Traits = \(TraitsUsed)")
        
        
        
        
        
        
        
        if !ResumeGroupGame {
            
            currentRound = 1
            
            GroupGameMaxRoundsInt = self.prefs.integer(forKey: "GroupGameMaxRounds")
            self.roundLBL.text = "Round \(currentRound) of \(GroupGameMaxRoundsInt)"
            var Players = 0
            
        prefs.set(GroupGameTraits, forKey: "GROUPCURRENTGAMEIDSused")
            
        
        for PlayerTrait in GroupGameTraits {
            
            Players += 1
            
            let PlayerNumber = "\(Players)"
            
            let PlayerTraitInfo = RetrieveGamePlayerTraits(GameTrait: PlayerTrait, playerNum: PlayerNumber, PlayersFull: false)
            
            GameTotalTraitInfo.append(PlayerTraitInfo)
            
        }
            

            DispatchQueue.main.async(execute: {
                
                self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round: self.currentRound, NumPlayersArray: self.NumberPlayersArray, NumPlayers: self.NumberPlayersArray.count, TraitsAvailable: self.TotalTraits, TraitsUsed: self.TraitsUsed, CurrentRoundTraits: self.GroupGameTraits, maxRounds: self.GroupGameMaxRoundsInt, PlayerNames: self.PlayerNamesArray)
                
               //  self.CurrentGroupGameInfo = GroupGameInfoUpdate(dictionary: ["Round":"\(self.currentRound.description)" as AnyObject,"NumPlayersArray":"\(self.currentRound.description)" as AnyObject,"NumPlayers":"\(self.NumberPlayersArray.count)" as AnyObject,"TraitsAvailable":"\(self.TotalTraits.description)" as AnyObject,"TraitsUsed":"\(self.TraitsUsed.description)" as AnyObject,"CurrentRoundTraits":"\(self.GroupGameTraits.description)" as AnyObject,"maxRounds":"\(self.GroupGameMaxRoundsInt.description)" as AnyObject])
            
                //self.CurrentGroupGameInfo = GroupGameInfoUpdate(dictionary: ["Round":"\(self.currentRound.description)" as AnyObject,"NumPlayersArray":"\(self.currentRound.description)" as AnyObject,"NumPlayers":"\(self.NumberPlayersArray.count)" as AnyObject,"TraitsAvailable":"\(self.TotalTraits)" as AnyObject,"TraitsUsed":"\(self.TraitsUsed)" as AnyObject,"CurrentRoundTraits":"\(self.GroupGameTraits)" as AnyObject,"maxRounds":"\(self.GroupGameMaxRoundsInt)" as AnyObject])
                
                
               // let CurrentGroupGameInfoArray = [self.CurrentGroupGameInfo]
            
                
                let EncodedCurrentGroupGameInfo = self.CurrentGroupGameInfo?.encode()
                
                print("Encoded Group Game Info: \(EncodedCurrentGroupGameInfo)")
                //let CurrentGroupGameInfoArray = self.CurrentGroupGameInfo
              //  let EncodedCurrentGroupGameInfo = CurrentGroupGameInfoArray?.encode()
                
                
                
                //print("******Encoded Current Game Info: \(self.CurrentGroupGameInfo)")
               // NSUserDefaults.standardUserDefaults().setObject(encoded, forKey: "my-key")
               
                
               // self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                
                self.prefs.setValue(EncodedCurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                
               // self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                
               
                
                
            })
            
            
        } else {
            
            
           // CurrentGroupGameInfo = self.prefs.value(forKey: "CurrentGroupGameInfo") as? GroupGameInfo
            
            let CurrentGroupGameInfoDictionary = self.prefs.object(forKey: "CurrentGroupGameInfo") as! Dictionary<String, Any>
            
            
            print("Resume Game Dictionary: \(CurrentGroupGameInfoDictionary)")
            

            
            GroupGameTraits = CurrentGroupGameInfoDictionary["CurrentRoundTraits"] as! [Double]
            GroupGameMaxRoundsInt = CurrentGroupGameInfoDictionary["maxRounds"] as! Int
            TraitsUsed = CurrentGroupGameInfoDictionary["TraitsUsed"] as! [Double]
            
            TotalTraits = CurrentGroupGameInfoDictionary["TraitsAvailable"] as! [Double]
            currentRound = CurrentGroupGameInfoDictionary["Round"] as! Int
            CurrentRoundTraits = CurrentGroupGameInfoDictionary["CurrentRoundTraits"] as! [Double]
            NumberPlayersArray = CurrentGroupGameInfoDictionary["NumPlayersArray"] as! [Int]
            PlayerNamesArray = CurrentGroupGameInfoDictionary["PlayerNames"] as! [String]
            
            print("***PLAYER NAMES = \(PlayerNamesArray)")
            
            self.roundLBL.text = "Round \(currentRound) of \(GroupGameMaxRoundsInt)"
            
            var PlayersTemp = 0
            
            for PlayerTrait in GroupGameTraits {
                
                PlayersTemp += 1
                
                let PlayerNumber = "\(PlayersTemp)"
                
                let PlayerTraitInfo = RetrieveGamePlayerTraits(GameTrait: PlayerTrait, playerNum: PlayerNumber, PlayersFull: true)
                
                GameTotalTraitInfo.append(PlayerTraitInfo)
                
            }
            
        }
        
        /*
         self.title = "My Traits"
         if let font = UIFont(name: "Noteworthy", size: 25.0) {
         self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
         }
         
         navigationController!.navigationBar.barTintColor = UIColor.black
         
         
         
         if self.revealViewController() != nil {
         menuButton.target = self.revealViewController()
         menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
         self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         }
         
         */
        
        self.TableView.separatorStyle = UITableViewCellSeparatorStyle.none
        TableView.delegate = self
        TableView.dataSource = self
        self.TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        // view.addGestureRecognizer(tap)
        
        
        //  username = prefs.valueForKey("USERNAME") as! NSString as String
        
        
        DidRemoveAds = prefs.bool(forKey: "RemoveAdsPurchased")
        /*
        if !DidRemoveAds {
        
        adBannerView.load(GADRequest())
            
        }
        */
        
        if !DidRemoveAds {
            interstitial = createAndLoadInterstitial()
        }
        
       // adBannerView.load(GADRequest())
        
        // Display the intertitial ad
        
        
        print("Was remove Ads Purchased: \(DidRemoveAds)")
        
    }
    
    
    @IBAction func hideTraitsBTN(_ sender: Any) {
        
        print("switch button pushed")
        print("state: \(self.hideTraitBTN.isOn)")
        
        if hideTraitBTN.isOn {
            self.HidePlayerTraits = false
            self.hideTraitLBL.text = "Hide Traits"
            self.hideTraitBTN.setOn(false, animated: true)
            //self.hideTraitBTN.set(isOn: false, animated: true)
            self.TableView.reloadData()
        } else {
            
            self.hideTraitBTN.setOn(true, animated: true)
           self.hideTraitLBL.text = "Unhide Traits"
           self.HidePlayerTraits = true
            
            self.TableView.reloadData()
        }
        
    }
    
    
    @IBAction func unwindAction(_ sender: Any) {
        
        prefs.set(true, forKey: "UnwindFromGroupPlay")
        
        self.performSegue(withIdentifier: "unwindToStart", sender: self)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        print("view appeared")
        
        
        if !DidRemoveAds {
            if (self.interstitial?.isReady)! {
                
                print("***Should show Ad now***")
                
                self.interstitial?.present(fromRootViewController: self)
            }
        }
        
       // TotalTraitsInventoryArray = RetrieveLocalTraitInfo()
        
        
        
        
       // //self.TableView.reloadData()
        
        /*
        var Players = 0
        
        for PlayerTrait in GroupGameTraits {
            
            Players += 1
            
            let PlayerNumber = "\(Players)"
            
            let PlayerTraitInfo = RetrieveGamePlayerTraits(GameTrait: PlayerTrait, playerNum: PlayerNumber)
 
            GameTotalTraitInfo.append(PlayerTraitInfo)
            
        }
        */
        
        
        
        /*
         if TotalTraitsInventoryArray.count == 0 {
         
         self.HaveTraitsLBL.isHidden = false
         
         } else {
         self.HaveTraitsLBL.isHidden = true
         }
         */
          DispatchQueue.main.async(execute: {
            
            //print("GameTraits: \(self.GameTotalTraitInfo)")
        
         self.TableView.reloadData()

        
        })
        
        
    }
    
    func ViewTraitClicked(_ sender: UIButton!) {
        
        //let TempSelectedTrait = TraitInventory()
        
        var TheTrait = GameTotalTraitInfo[sender.tag]
        
        
        let theAlert = SCLAlertView()
        theAlert.addButton("Yes") {
            
            let TraitRowSelected = sender.tag
            print("the comment rowselected: \(sender.tag)")
            print("Should View Trait: \(TheTrait.traitname)")
            
            //  self.CommentIDSelected = self.idArrayInfo[CommentRowSelected]
            
            //  DeleteCommentData(self.CommentIDSelected)
            //  self.refreshData()
            
            
            
            let TraitNameOld = TheTrait.traitname
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
            
            
            let imageURLname = TheTrait.imageURL
            
            print("Trait click, imageURL: \(imageURLname)")
            
            /*
             
             let url = URL(fileURLWithPath: self.dirpath).appendingPathComponent("\(imageURLname).png")
             print("url for image = \(url)")
             let theImageData = try? Data(contentsOf: url)
             
             //TestImage = UIImage(data:theImageData!)!
             
             let image  = UIImage(data: theImageData!)!
             */
            
            /*
             cell.titleLBL.text = TraitNameFinal as String
             cell.traitImageView.image = image as UIImage
             cell.traitImageView.contentMode = .scaleAspectFit
             cell.descLBL.text = TheTrait.traitdescription as String
             */
            
            DispatchQueue.main.async(execute: {
                
                //let myTraitView:TraitView = UINib(nibName: "TraitView", bundle: nil).instantiate(withOwner: nil, options: ["imageURL":"\(imageURLname)"])[0] as! TraitView
                
                self.prefs.set(imageURLname, forKey: "GroupViewingPlayerTraitImageURL")
                
                let myTraitView:TraitView = UINib(nibName: "TraitView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TraitView
                
                
                myTraitView.traitTitle?.text = TraitNameFinal as String
                myTraitView.traitDesc?.text = TheTrait.traitdescription as String
                // myTraitView.TheTraitImage? = image as UIImage
                //myTraitView.TraitImageURL = imageURLname
                
                
                
                let DeviceH = self.view.frame.height
                //let halfH = DeviceH / 2;
                let DeviceW = self.view.frame.width
                //let WLess10 = DeviceW - 10;
                let startX = (DeviceW / 2) - 125;
                let startY = (DeviceH / 2) - 125;
                
                
                myTraitView.alpha = 0.0
                //myTraitView.theView.layer.cornerRadius = 10
                //myTraitView.theView.layer.masksToBounds = true
                //myTraitView.theView.clipsToBounds = true
                myTraitView.frame = UIScreen.main.bounds
                
                self.view.addSubview(myTraitView)
                
                
                UIView.animate(withDuration: 0.25, animations: {
                    myTraitView.alpha = 1.0
                })
                
                
            })
            
            
        }
        
        theAlert.addButton("Cancel") {
            print("Cancel pushed")
        }
        
       // theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "View Trait Info?", subTitle: "Are you sure you want to view this player's assigned trait?")
        
        theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "View Trait Info", subTitle: "Are you sure you want to view this player's assigned trait?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
        
        /*
         
         let actionSheetController: UIAlertController = UIAlertController(title: "Delete Comment?", message: "Are you sure you want to delete this comment?", preferredStyle: .Alert)
         
         //Create and an option action
         let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
         
         let CommentRowSelected = sender.tag
         print("the comment rowselected: \(sender.tag)")
         
         self.CommentIDSelected = self.idArrayInfo[CommentRowSelected]
         
         DeleteCommentData(self.CommentIDSelected)
         self.refreshData()
         
         }
         
         //Create and add the Cancel action
         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
         //Do some stuff
         }
         
         actionSheetController.addAction(nextAction)
         actionSheetController.addAction(cancelAction)
         
         self.presentViewController(actionSheetController, animated: true, completion: nil)
         
         
         */
        
        
    }
    
    func EditPlayerClicked(_ sender: UIButton!) {
        
        //let TempSelectedTrait = TraitInventory()
        
        self.PlayerRowSelected = sender.tag
        var TheTrait = GameTotalTraitInfo[sender.tag]
        
        
        
        /*
        let theAlert = SCLAlertView()
        theAlert.addButton("Yes") {
            
            let TraitRowSelected = sender.tag
            print("the comment rowselected: \(sender.tag)")
            print("Should View Trait: \(TheTrait.traitname)")
            
            //  self.CommentIDSelected = self.idArrayInfo[CommentRowSelected]
            
            //  DeleteCommentData(self.CommentIDSelected)
            //  self.refreshData()
            
            
            
            let TraitNameOld = TheTrait.traitname
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
            
            
            let imageURLname = TheTrait.imageURL
            
            print("Trait click, imageURL: \(imageURLname)")
            
            /*
             
             let url = URL(fileURLWithPath: self.dirpath).appendingPathComponent("\(imageURLname).png")
             print("url for image = \(url)")
             let theImageData = try? Data(contentsOf: url)
             
             //TestImage = UIImage(data:theImageData!)!
             
             let image  = UIImage(data: theImageData!)!
             */
            
            /*
             cell.titleLBL.text = TraitNameFinal as String
             cell.traitImageView.image = image as UIImage
             cell.traitImageView.contentMode = .scaleAspectFit
             cell.descLBL.text = TheTrait.traitdescription as String
             */
            
            DispatchQueue.main.async(execute: {
                
                //let myTraitView:TraitView = UINib(nibName: "TraitView", bundle: nil).instantiate(withOwner: nil, options: ["imageURL":"\(imageURLname)"])[0] as! TraitView
                
                self.prefs.set(imageURLname, forKey: "GroupViewingPlayerTraitImageURL")
                
                let myTraitView:TraitView = UINib(nibName: "TraitView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TraitView
                
                
                myTraitView.traitTitle?.text = TraitNameFinal as String
                myTraitView.traitDesc?.text = TheTrait.traitdescription as String
                // myTraitView.TheTraitImage? = image as UIImage
                //myTraitView.TraitImageURL = imageURLname
                
                
                
                let DeviceH = self.view.frame.height
                //let halfH = DeviceH / 2;
                let DeviceW = self.view.frame.width
                //let WLess10 = DeviceW - 10;
                let startX = (DeviceW / 2) - 125;
                let startY = (DeviceH / 2) - 125;
                
                
                myTraitView.alpha = 0.0
                //myTraitView.theView.layer.cornerRadius = 10
                //myTraitView.theView.layer.masksToBounds = true
                //myTraitView.theView.clipsToBounds = true
                myTraitView.frame = UIScreen.main.bounds
                
                self.view.addSubview(myTraitView)
                
                
                UIView.animate(withDuration: 0.25, animations: {
                    myTraitView.alpha = 1.0
                })
                
                
            })
            
            
        }
        
        theAlert.addButton("Cancel") {
            print("Cancel pushed")
        }
        
        theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "View Trait Info?", subTitle: "Are you sure you want to view this player's assigned trait?")
        
        */
       
        
        
  
    let SelectedPlayer = GameTotalTraitInfo[sender.tag].PlayerName
    
   // var PlayerCountTemp = PlayerCount[PlayerRowSelected]
    
   // UserSelected = "User\(String(PlayerCountTemp))" as NSString
   // UserSelectedID = "User\(String(PlayerCountTemp))ID" as NSString
    // UserSelected = "User\(String(describing: PlayerCount[PlayerRowSelected]))"
    //  UserSelectedID = "User\(String(describing: PlayerCount[PlayerRowSelected]))ID"
    
    print("Selected Player = \(SelectedPlayer)")
   // print("UserSelected = \(UserSelected)")
        
        
        let theAlert = SCLAlertView()
        
        let firstTextField = theAlert.addTextField("Player Name")
        firstTextField.textAlignment = .center
        
        /*
        theAlert.addButton("Select From Contacts") {
            
            self.ContactsClicked(self.PlayerRowSelected)
            
        }
        
        */
        
        theAlert.addButton("Save", action: {
            
            print("Saved Clicked")
            
            //let firstTextField = theAlert.te
            
            
            if firstTextField.text != "" {
                //if firstTextField.text != "" {
                
                
                
                
                let TempPlayerTraitInfo = self.GameTotalTraitInfo[self.PlayerRowSelected]
                
                let temptraitname = TempPlayerTraitInfo.traitname
                let temptraitimageURL = TempPlayerTraitInfo.imageURL
                let temptraitlevel = TempPlayerTraitInfo.traitlevel
                let temptraitid = TempPlayerTraitInfo.traitid
                let tempimagedata = TempPlayerTraitInfo.traitimagedata
                let tempdescription = TempPlayerTraitInfo.traitdescription
                let templocalTrait = TempPlayerTraitInfo.localTrait
                let tempPlayer = TempPlayerTraitInfo.Player
                let tempPlayerName = firstTextField.text
                
                
                let TempPlayerTraitInfoUpdated = TraitInventoryPlayer(traitname: temptraitname as NSString, imageURL: temptraitimageURL, traitlevel: temptraitlevel, traitid: temptraitid, traitimagedata: tempimagedata, traitdescription: tempdescription as NSString, localTrait: templocalTrait, Player: tempPlayer, PlayerName: tempPlayerName!)
                
                
                self.GameTotalTraitInfo.remove(at: self.PlayerRowSelected);
                self.GameTotalTraitInfo.insert(TempPlayerTraitInfoUpdated, at: self.PlayerRowSelected)
                self.PlayerNamesArray.remove(at: self.PlayerRowSelected);
                self.PlayerNamesArray.insert(tempPlayerName!, at: self.PlayerRowSelected)
                // self.PlayerIDs.remove(at: self.PlayerRowSelected);
                // self.PlayerIDs.insert("NONE", at: self.PlayerRowSelected)
                
                
                
                
                DispatchQueue.main.async(execute: {
                    
                    //self.GameTotalTraitInfo = GameTotalTraitInfoTemp
                    
                    
                    
                    print("Should have completed loading the next round")
                    print("****Next round traits: \(self.GameTotalTraitInfo)")
                    // self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round)
                    
                    /*
                     self.CurrentGroupGameInfo = GroupGameInfoUpdate(dictionary: ["Round":"\(self.currentRound)" as AnyObject,"NumPlayersArray":"\(self.currentRound)" as AnyObject,"NumPlayers":"\(self.NumberPlayersArray.count)" as AnyObject,"TraitsAvailable":"\(self.TotalTraits)" as AnyObject,"TraitsUsed":"\(self.TraitsUsed)" as AnyObject,"CurrentRoundTraits":"\(self.GroupGameTraits)" as AnyObject,"maxRounds":"\(self.GroupGameMaxRoundsInt)" as AnyObject])
                     
                     */
                    
                    //self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round: self.currentRound)
                    self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round: self.currentRound, NumPlayersArray: self.NumberPlayersArray, NumPlayers: self.NumberPlayersArray.count, TraitsAvailable: self.TotalTraits, TraitsUsed: self.TraitsUsed, CurrentRoundTraits: self.GroupGameTraits, maxRounds: self.GroupGameMaxRoundsInt, PlayerNames: self.PlayerNamesArray)
                    
                    //  self.CurrentGroupGameInfo = GroupGameInfoUpdate(
                    
                    //self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                    
                    
                    
                    //  let CurrentGroupGameInfoArray = [self.CurrentGroupGameInfo]
                    
                    
                    let EncodedCurrentGroupGameInfo = self.CurrentGroupGameInfo?.encode()
                    
                    print("Encoded Group Game Info: \(EncodedCurrentGroupGameInfo)")
                    
                    // self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                    self.prefs.set(EncodedCurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                    
                    
                    self.TableView.reloadData()
                    
                    
                    
                })
                
                
               // self.TableView.reloadData()
                
 
                
                
            } else {
                let alertController2 = UIAlertController(title: "Player Name?", message: "Please enter a players name or select a player from your contacts", preferredStyle: .alert)
                
                let cancelAction2 = UIAlertAction(title: "Ok", style: .default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                
                alertController2.addAction(cancelAction2)
                
                self.present(alertController2, animated: true, completion: nil)
            }
 
            
            
        })
        
        
        theAlert.addButton("Cancel") {
            
            print("Cancel clicked")
        }
    
    
        /*
    let actionSheetController: UIAlertController = UIAlertController(title: "Update \(SelectedPlayer)?", message: "", preferredStyle: .alert)
    
    
    //Create and an option action
    let ContactsAction: UIAlertAction = UIAlertAction(title: "Select From Contacts", style: .default) { action -> Void in
    
    self.ContactsClicked(self.PlayerRowSelected)
        
    }
    
    actionSheetController.addAction(ContactsAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
         let firstTextField = actionSheetController.textFields![0] as UITextField
            
           // let TextFieldString: NSString = firstTextField.text as NSString
            

            if firstTextField.text != "" {
            //if firstTextField.text != "" {
                
                
                
                
                let TempPlayerTraitInfo = self.GameTotalTraitInfo[self.PlayerRowSelected]
                
                let temptraitname = TempPlayerTraitInfo.traitname
                let temptraitimageURL = TempPlayerTraitInfo.imageURL
                let temptraitlevel = TempPlayerTraitInfo.traitlevel
                let temptraitid = TempPlayerTraitInfo.traitid
                let tempimagedata = TempPlayerTraitInfo.traitimagedata
                let tempdescription = TempPlayerTraitInfo.traitdescription
                let templocalTrait = TempPlayerTraitInfo.localTrait
                let tempPlayer = TempPlayerTraitInfo.Player
                let tempPlayerName = firstTextField.text
                
                
                let TempPlayerTraitInfoUpdated = TraitInventoryPlayer(traitname: temptraitname as NSString, imageURL: temptraitimageURL, traitlevel: temptraitlevel, traitid: temptraitid, traitimagedata: tempimagedata, traitdescription: tempdescription as NSString, localTrait: templocalTrait, Player: tempPlayer, PlayerName: tempPlayerName!)
                
                
                self.GameTotalTraitInfo.remove(at: self.PlayerRowSelected);
                self.GameTotalTraitInfo.insert(TempPlayerTraitInfoUpdated, at: self.PlayerRowSelected)
                self.PlayerNamesArray.remove(at: self.PlayerRowSelected);
                self.PlayerNamesArray.insert(tempPlayerName!, at: self.PlayerRowSelected)
                // self.PlayerIDs.remove(at: self.PlayerRowSelected);
                // self.PlayerIDs.insert("NONE", at: self.PlayerRowSelected)
                
                
                self.TableView.reloadData()

                
                
                
            } else {
                let alertController2 = UIAlertController(title: "Player Name?", message: "Please enter a players name or select a player from your contacts", preferredStyle: .alert)
                
                let cancelAction2 = UIAlertAction(title: "Ok", style: .default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                })
                
                alertController2.addAction(cancelAction2)
                
                self.present(alertController2, animated: true, completion: nil)
            }
            
        })
    
    actionSheetController.addAction(saveAction)
        
        actionSheetController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Player Name"
            textField.textAlignment = NSTextAlignment.center

        }
        
    let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
    
    //save to images
    
    }
    
    actionSheetController.addAction(CancelAction)
  
     
    self.present(actionSheetController, animated: true, completion: nil)
    */
        
      //  theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Update \(SelectedPlayer)?", subTitle: "")
        
       // theAlert.showCustomTitleText(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Update \(SelectedPlayer)?", subTitle: "", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1, textTitle: "Player Name")
        
       theAlert.showCustomOKText(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Update \(SelectedPlayer)?", subTitle: "", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1, textTitle: "Player Name")
        
        
      //  theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Game Over", subTitle: "This is the last round, would you like to start a new game?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
        
    
    }
    
    func SendTextClicked(_ sender: UIButton!) {
        
        //let TempSelectedTrait = TraitInventory()
        
        var TheTrait = GameTotalTraitInfo[sender.tag]
         let PlayerNameTemp = TheTrait.PlayerName
        
        let theAlert = SCLAlertView()
        theAlert.addButton("Yes") {
            
            //self.SendGameNotice(SelectedPlayer: "Test Username")
            
            
            let TraitNameOld = TheTrait.traitname
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
            //TheTrait.traitdescription as String
            
            let TraitTextInfo = "\(TraitNameFinal): \(TheTrait.traitdescription)"
            
           
            
            let imageURLname = TheTrait.imageURL
            
           // print("Trait click, imageURL: \(imageURLname)")
            
            /*
             
             let url = URL(fileURLWithPath: self.dirpath).appendingPathComponent("\(imageURLname).png")
             print("url for image = \(url)")
             let theImageData = try? Data(contentsOf: url)
             
             //TestImage = UIImage(data:theImageData!)!
             
             let image  = UIImage(data: theImageData!)!
             */

            
            let messageVC = MFMessageComposeViewController()
            //   var messageTo = "Jared"
            
            //  messageVC.body = "PQ://article/EmailInvite?gameid=\(self.GameID)&turn=\(self.UserSelected)&name=\(messageTo)";
            //  self.FBFriendID = FBFriendID2.stringByReplacingOccurrencesOfString(" //", withString: "")
            
            let SelectedPlayerC: NSString = "contact"
            
            // messageVC.body = "You're invited to play Pics & quotes.  Click the link to join.  http://www.clavensolutions.com/Apps/Pics&Quotes/GoToApp.php?gameid=\(self.GameID)&turn=\(self.UserSelected)&name=\(SelectedPlayerC)&id=\(self.UserSelectedID)&gamestyle=\(self.GameStyleInfo)"
            
            
            messageVC.body = TraitTextInfo
            //messageVC.recipients = [""]
            messageVC.messageComposeDelegate = self;
            //  messageVC.addAttachmentData(imageData!, typeIdentifier: "image/jpeg", filename: "GamePhoto.jpeg")
            
            self.present(messageVC, animated: false, completion: nil)
            
          
            
            
        }
        
        theAlert.addButton("Cancel") {
            print("Cancel pushed")
        }
        
        theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Text Message", subTitle: "Send \(PlayerNameTemp) a text with their Trait Info?")
        
        
        
      
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return TotalTraitsInventoryArray.count
        return GroupGameTraits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        
        
        cell.editPlayerBTN?.tag = (indexPath as NSIndexPath).row
   
        cell.editPlayerBTN?.addTarget(self, action: #selector(GroupGameTraitsViewController.EditPlayerClicked(_:)), for: .touchUpInside)
        
        cell.viewTraitBTN.layer.cornerRadius = 70
        cell.viewTraitBTN.layer.masksToBounds = true
        cell.viewTraitBTN.clipsToBounds = true
        cell.viewTraitBTN?.tag = (indexPath as NSIndexPath).row
        cell.viewTraitBTN?.addTarget(self, action: #selector(GroupGameTraitsViewController.ViewTraitClicked(_:)), for: .touchUpInside)
        
        cell.sendTextBTN.layer.cornerRadius = 15
        cell.sendTextBTN.layer.masksToBounds = true
        cell.sendTextBTN.clipsToBounds = true
        cell.sendTextBTN?.tag = (indexPath as NSIndexPath).row
        cell.sendTextBTN?.addTarget(self, action: #selector(GroupGameTraitsViewController.SendTextClicked(_:)), for: .touchUpInside)
        
        
        if HidePlayerTraits {
            
        let TheTrait = GameTotalTraitInfo[indexPath.row]
 
        cell.viewTraitBTN.isHidden = false
        cell.playerTurnLBL.text = "\(TheTrait.Player as String): \(TheTrait.PlayerName)"
        cell.playerNumberLBL.isHidden = true
        cell.titleLBL.isHidden = true
        //cell.titleLBL.isHidden = true
        cell.levelLBL.isHidden = true
        cell.descLBL.isHidden = true
        cell.traitImageView.isHidden = true
        cell.playerTurnLBL.isHidden = false
        cell.sendTextBTN.isHidden = false
            
        } else {
        cell.sendTextBTN.isHidden = true
            cell.titleLBL.isHidden = false
            cell.levelLBL.isHidden = false
            cell.descLBL.isHidden = false
        cell.playerNumberLBL.isHidden = false
        cell.traitImageView.isHidden = false
        cell.playerTurnLBL.isHidden = true
       
        let TheTrait = GameTotalTraitInfo[indexPath.row]
        let TraitNameOld = TheTrait.traitname
        
        let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        
        let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
        
        
        
        let imageURLname = TheTrait.imageURL
        
        let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(imageURLname).png")
        print("url for image = \(url)")
        let theImageData = try? Data(contentsOf: url)
        
        //TestImage = UIImage(data:theImageData!)!
        
        let image  = UIImage(data: theImageData!)!
        
        
        cell.titleLBL.text = TraitNameFinal as String
        cell.traitImageView.image = image as UIImage
        cell.traitImageView.contentMode = .scaleAspectFit
        cell.descLBL.text = TheTrait.traitdescription as String
        cell.playerNumberLBL.text = "\(TheTrait.Player as String): \(TheTrait.PlayerName)"
        cell.levelLBL.text = "Difficulty: \(TheTrait.traitlevel as String)"
        
        //cell.titleLBL.text = TheTrait.Player as String
        cell.viewTraitBTN.isHidden = true
            
        }
        
        
        
       // cell.titleLBL.text = GroupGameTraits[indexPath.row].description
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // cell.cellViewBG.layer.backgroundColor = UIColor.white.cgColor
        
        
        
        // cell.TurnByLBL.text = "Player: \(MyTurnData.playerName)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func RetrieveGamePlayerTraits(GameTrait: Double, playerNum: String, PlayersFull: Bool) -> TraitInventoryPlayer {
        
      
        
        var PlayerTraitInfo: TraitInventoryPlayer?
        
        var trait_ids_temp = [Double]()
        
        
        var TotalItemsTemp = Int()
        var localIndex = 0
        
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
               // TotalItemsTemp += 1
                
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
                
                let TraitDouble = Double(traitid)!
                
                myData.append(items)
                
                if TraitDouble == GameTrait {
                    
                    /*
                    var TurnNumber = Int()
                    
                    if let i = TraitsUsed.index(of: TraitDouble) {
                        print("Trait is at index \(i)")
                        TurnNumber = i + 1
                    } else {
                        print("Trait isn't in the array")
                    }
                    */
                    
                    
                    //myData.append(items)
                    
                    
                    var NameIndexStart = Int(playerNum)!
                    var NameIndex = NameIndexStart - 1
                   
                    
                    var PlayerNumber:String = "Player \(playerNum)"
                    
                    if !PlayersFull {
                    self.PlayerNamesArray.append("Player \(playerNum)")
                    
                    
                    PlayerTraitInfo = TraitInventoryPlayer(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait, Player: PlayerNumber, PlayerName: "Player \(playerNum)")
                        
                    } else {
                        
                     PlayerTraitInfo = TraitInventoryPlayer(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait, Player: PlayerNumber, PlayerName: PlayerNamesArray[NameIndex])
                        
                        
                    }
                    
                   // trait_ids_temp.append((traitid as NSString).doubleValue)
                    
                    
                }
                
               // localIndex += 1
            }
            
           // print("TotalItemsInventoryArray - PreSorted - \(TotalTraitsInventoryArray)")
            
            
            
            
            /*
            TotalTraitsInventoryArrayTemp.sort { (lhs: TraitInventoryUsed, rhs: TraitInventoryUsed) -> Bool in
                // you can have additional code here
                return lhs.TurnNumber < rhs.TurnNumber
            }
            
            */
            
            
            
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
        

        return PlayerTraitInfo!
        
    }
    
    func RetrieveLocalTraitInfo() -> [TraitInventory] {
        
        var TotalTraitsInventoryArrayTemp = [TraitInventory]()
        
        var trait_ids_temp = [Double]()
        
        var TotalItemsTemp = Int()
        
        var localIndex = 0
        
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
                
                let TraitDouble = Double(traitid)!
                
                myData.append(items)
                
                if TraitsUsed.contains(TraitDouble) {
                    
                    var TurnNumber = Int()
                    
                    if let i = TraitsUsed.index(of: TraitDouble) {
                        print("Trait is at index \(i)")
                        TurnNumber = i + 1
                    } else {
                        print("Trait isn't in the array")
                    }
                    
                    
                    
                    //myData.append(items)
                    
                    TotalTraitsInventoryArrayTemp.append(TraitInventory(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait))
                    
                    trait_ids_temp.append((traitid as NSString).doubleValue)
                    
                    
                }
                
                localIndex += 1
            }
            
            print("TotalItemsInventoryArray - PreSorted - \(TotalTraitsInventoryArray)")
            
            
            
            /*
            TotalTraitsInventoryArrayTemp.sort { (lhs: TraitInventoryUsed, rhs: TraitInventoryUsed) -> Bool in
                // you can have additional code here
                return lhs.TurnNumber < rhs.TurnNumber
            }
            */
            
            
            
            
            print("TotalItemsInventoryArray - Sorted - \(TotalTraitsInventoryArray)")
            
            
            // print("Current items IMAGE URL =\(TotalItemsArray)")
            
            
            
            if self.SavedItemsInventory.count > 0 {
                //  GroupInfoLBL.hidden = true
            } else {
                //  GroupInfoLBL.hidden = false
            }
            
            
        } catch {
            print(error)
        }
        
        return TotalTraitsInventoryArrayTemp
    }
    
    @IBAction func LoadNextRound(_ sender: Any) {
        
        
        if !DidRemoveAds {
            if (self.interstitial?.isReady)! {
                
                print("***Should show Ad now***")
                
                self.interstitial?.present(fromRootViewController: self)
            }
        }
        
        
        print("Trying to load next round traits")
        var newRound = currentRound + 1
        
        if newRound > GroupGameMaxRoundsInt {
            
            
            
            
            
            
            
            
            let theAlert = SCLAlertView()
            
            theAlert.addButton("Yes") {
             
                self.prefs.set(true, forKey: "UnwindFromGroupPlay")
                
                self.performSegue(withIdentifier: "unwindToStart", sender: self)
                
            }
            
            
            theAlert.addButton("Not yet") {
                

            }
            
            // theAlert.showCustomOK(UIImage(named: "SadPixie.png")!, color: UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0), title: "Submit", subTitle: "Are you sure you want to submit this \(QorA)?")
            
            theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Game Over", subTitle: "This is the last round, would you like to start a new game?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
            
            
            
            
            
            
            
            
        } else {
            
            
            let theAlert = SCLAlertView()
            
            theAlert.addButton("Yes") {
                
           
            
            
            
                let NextRoundCurrentGroupGameInfo = self.GetNextRoundTraits(GameMaxRoundTemp: self.GroupGameMaxRoundsInt, TraitsUsed: self.TraitsUsed, Traits: self.TotalTraits, NumberOfPlayersArrayTemp: self.NumberPlayersArray, currentRound: self.currentRound, PlayerNamesArray: self.PlayerNamesArray)
            
                
           print("NextRoundCurrentGroupGameInfo: \(NextRoundCurrentGroupGameInfo)")
            
            
            self.GroupGameTraits = NextRoundCurrentGroupGameInfo.CurrentRoundTraits
            self.GroupGameMaxRoundsInt = NextRoundCurrentGroupGameInfo.maxRounds
            self.TraitsUsed = NextRoundCurrentGroupGameInfo.TraitsUsed
            
            self.TotalTraits = NextRoundCurrentGroupGameInfo.TraitsAvailable
            self.currentRound = NextRoundCurrentGroupGameInfo.Round
            self.CurrentRoundTraits = NextRoundCurrentGroupGameInfo.CurrentRoundTraits
            self.NumberPlayersArray = NextRoundCurrentGroupGameInfo.NumPlayersArray
            self.PlayerNamesArray = NextRoundCurrentGroupGameInfo.PlayerNames
                
            self.roundLBL.text = "Round \(self.currentRound) of \(self.GroupGameMaxRoundsInt)"
            
             DispatchQueue.main.async(execute: {
                
                 print("Next Round Traits: \(self.GroupGameTraits)")
                
                
               // self.GameTotalTraitInfo = self.LoadNextRoundTraits(GroupGameTraitsTemp: NextRoundCurrentGroupGameInfo.CurrentRoundTraits)
            
                
                
               // var GroupGameTraitsTemp = [Double]()
             
                var PlayersTemp = 0
                
                var GameTotalTraitInfoTemp = [TraitInventoryPlayer]()
                
                for PlayerTrait in self.GroupGameTraits {
                    
                    PlayersTemp += 1
                    
                    
                    let PlayerNumber = "\(PlayersTemp)"
                    
                    let PlayerTraitInfo = self.RetrieveGamePlayerTraits(GameTrait: PlayerTrait, playerNum: PlayerNumber, PlayersFull: true)
                    
                    GameTotalTraitInfoTemp.append(PlayerTraitInfo)
                    
                }
                
                
                
                
            
            DispatchQueue.main.async(execute: {
                
                self.GameTotalTraitInfo = GameTotalTraitInfoTemp
                
                print("Should have completed loading the next round")
                print("****Next round traits: \(self.GameTotalTraitInfo)")
               // self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round)
                
                /*
                self.CurrentGroupGameInfo = GroupGameInfoUpdate(dictionary: ["Round":"\(self.currentRound)" as AnyObject,"NumPlayersArray":"\(self.currentRound)" as AnyObject,"NumPlayers":"\(self.NumberPlayersArray.count)" as AnyObject,"TraitsAvailable":"\(self.TotalTraits)" as AnyObject,"TraitsUsed":"\(self.TraitsUsed)" as AnyObject,"CurrentRoundTraits":"\(self.GroupGameTraits)" as AnyObject,"maxRounds":"\(self.GroupGameMaxRoundsInt)" as AnyObject])
                
                */
                
                //self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round: self.currentRound)
                self.CurrentGroupGameInfo = GroupGameInfoUpdate(Round: self.currentRound, NumPlayersArray: self.NumberPlayersArray, NumPlayers: self.NumberPlayersArray.count, TraitsAvailable: self.TotalTraits, TraitsUsed: self.TraitsUsed, CurrentRoundTraits: self.GroupGameTraits, maxRounds: self.GroupGameMaxRoundsInt, PlayerNames: self.PlayerNamesArray)
                
              //  self.CurrentGroupGameInfo = GroupGameInfoUpdate(
                
                //self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                
                
                
              //  let CurrentGroupGameInfoArray = [self.CurrentGroupGameInfo]
                
                
                let EncodedCurrentGroupGameInfo = self.CurrentGroupGameInfo?.encode()
                
                 print("Encoded Group Game Info: \(EncodedCurrentGroupGameInfo)")
                
               // self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                self.prefs.set(EncodedCurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")
                
                
                self.TableView.reloadData()
                
                
                
            })
                
            })
                
            }
            
            
            theAlert.addButton("Not yet") {
                
                
            }
            
            // theAlert.showCustomOK(UIImage(named: "SadPixie.png")!, color: UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0), title: "Submit", subTitle: "Are you sure you want to submit this \(QorA)?")
            
            theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Next Round", subTitle: "Begin the Next Round of Traits?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
            
            
        }
        
        
        
    }
    
    
    func GetNextRoundTraits(GameMaxRoundTemp: Int, TraitsUsed: [Double], Traits: [Double], NumberOfPlayersArrayTemp:[Int], currentRound: Int, PlayerNamesArray: [String]) -> GroupGameInfoUpdate {
        
        print("*****GET NEXT ROUND TRAITS***")
        var recentTraitUsed = Double()
        var ShownTrait_ID = Int()
        var ImageData = [NSString]()
        var Image_ID = Int()
        var ImageURLData = Data()
        var AvailableTraits = Traits
        
        var CurrentRoundTraits = [Double]()
        var TotalGameTraitsUsed = [Double]()
        
        TotalGameTraitsUsed = TraitsUsed
        
         //var GameTotalTraitInfoTemp = [TraitInventoryPlayer]()
        var CurrentGroupGameInfoTemp: GroupGameInfoUpdate!
       
        var newRound = currentRound + 1
       // self.CurrentGroupGameInfo = GroupGameInfo(Round: self.currentRound, NumPlayersArray: self.NumberPlayersArray, NumPlayers: self.NumberPlayersArray.count, TraitsAvailable: self.TotalTraits, TraitsUsed: self.TraitsUsed, CurrentRoundTraits: self.GroupGameTraits, maxRounds: self.GroupGameMaxRoundsInt)
        
        
      //  self.prefs.set(self.CurrentGroupGameInfo, forKey: "CurrentGroupGameInfo")

      // GroupGameMaxRoundsInt = self.prefs.integer(forKey: "GroupGameMaxRounds")
        
        
      //  self.roundLBL.text = "Round \(newRound) of \(GameMaxRoundTemp)"
            
            
        var Players = 0
        var playerTemp = 0
       // prefs.set(GroupGameTraits, forKey: "GROUPCURRENTGAMEIDSused")
            
        
        
        print("Getting Next Round, Current Available Traits = \(AvailableTraits)")
        print("Number of players = \(NumberOfPlayersArrayTemp)")
            
        
            for player in NumberOfPlayersArrayTemp {
                
                playerTemp += 1
                
                
                if (AvailableTraits.isEmpty == false) {
                    
                    ShownTrait_ID = GetTraitID(AvailableTraits)
                    
                    // print("****getting this is the trait id*** = \(ShownTrait_ID)")
                    
                    //get Image ID
                    Image_ID = Int(AvailableTraits[ShownTrait_ID])
                    recentTraitUsed = AvailableTraits[ShownTrait_ID]
                    
                   // print("Player \(playerTemp): \(recentTraitUsed)")
                    
                    // let newTrait = Double()
                    

                    if (AvailableTraits.count > 1) {
                        AvailableTraits.remove(at: ShownTrait_ID)
                        TotalGameTraitsUsed.append(recentTraitUsed)
                        CurrentRoundTraits.append(recentTraitUsed)
                        //print("Trait Added to Traits used.  Now = \(TraitsUsed)")
                        
                    } else {
                        
                        AvailableTraits.remove(at: 0)
                        TotalGameTraitsUsed.append(recentTraitUsed)
                        CurrentRoundTraits.append(recentTraitUsed)
                        
                    }
                    
                } else {
                    
                    
                }
                
            }
        
        print("New current round traits: \(CurrentRoundTraits)")
           
        
     //   DispatchQueue.main.async(execute: {
        
        CurrentGroupGameInfoTemp = GroupGameInfoUpdate(Round: newRound, NumPlayersArray: NumberOfPlayersArrayTemp, NumPlayers: NumberOfPlayersArrayTemp.count, TraitsAvailable: AvailableTraits, TraitsUsed: TotalGameTraitsUsed, CurrentRoundTraits: CurrentRoundTraits, maxRounds: GameMaxRoundTemp, PlayerNames: PlayerNamesArray)

        
        print("CurrentGroupGame Info Temp: \(CurrentGroupGameInfoTemp)")
         
       // }
        
       //  })
        
        return CurrentGroupGameInfoTemp
            
        
        
    }
    
    
    func LoadNextRoundTraits(GroupGameTraitsTemp: [Double]) -> [TraitInventoryPlayer] {
        
        var PlayersTemp = 0
        
        var GameTotalTraitInfoTemp = [TraitInventoryPlayer]()
        
        for PlayerTrait in GroupGameTraitsTemp {
            
            PlayersTemp += 1
            
            let PlayerNumber = "\(PlayersTemp)"
            
            let PlayerTraitInfo = RetrieveGamePlayerTraits(GameTrait: PlayerTrait, playerNum: PlayerNumber, PlayersFull: true)
           
            
            GameTotalTraitInfoTemp.append(PlayerTraitInfo)
            
        }
        
        //currentRound = 1
        
        return GameTotalTraitInfoTemp
        
    }
    
    func GetTraitID(_ Traits: [Double]) -> Int {
        let UsedTrait = Int(arc4random_uniform(UInt32(Traits.count)))
        return UsedTrait
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            self.dismiss(animated: true, completion:nil)
        case MessageComposeResult.failed.rawValue:
            self.dismiss(animated: true, completion: nil)
            
        case MessageComposeResult.sent.rawValue:
            self.dismiss(animated: true, completion: nil)
            
        default:
            break;
        }
        
    }
    
    
    func SendGameNotice(SelectedPlayer: String) {
        
        //let SelectedPlayer = "TestPlayer"
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Send \(SelectedPlayer) a Game Notice?", message: "", preferredStyle: .alert)
        
        let textAction: UIAlertAction = UIAlertAction(title: "Send Text Message", style: .default) { action -> Void in
            
            // let library = ALAssetsLibrary()
            // let imageToSave = filter.outputImage
            // var orientation = theimage.imageOrientation
            //  var imageData = UIImageJPEGRepresentation(theimage, 1.0)
            //  var compressedJPGImage = UIImage(data: imageData)
            
            let messageVC = MFMessageComposeViewController()
            //   var messageTo = "Jared"
            
            //  messageVC.body = "PQ://article/EmailInvite?gameid=\(self.GameID)&turn=\(self.UserSelected)&name=\(messageTo)";
            //  self.FBFriendID = FBFriendID2.stringByReplacingOccurrencesOfString(" //", withString: "")
            
            let SelectedPlayerC: NSString = "contact"
            
           // messageVC.body = "You're invited to play Pics & quotes.  Click the link to join.  http://www.clavensolutions.com/Apps/Pics&Quotes/GoToApp.php?gameid=\(self.GameID)&turn=\(self.UserSelected)&name=\(SelectedPlayerC)&id=\(self.UserSelectedID)&gamestyle=\(self.GameStyleInfo)"
            
            
            messageVC.body = "Test Text Message"
            //messageVC.recipients = [""]
            messageVC.messageComposeDelegate = self;
            //  messageVC.addAttachmentData(imageData!, typeIdentifier: "image/jpeg", filename: "GamePhoto.jpeg")
            
            self.present(messageVC, animated: false, completion: nil)
            
            
        }
        actionSheetController.addAction(textAction)
        
        
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            //save to images
            
        }
        
        actionSheetController.addAction(CancelAction)
        
        //CHANGE ERROR
        /*
         var subView = actionSheetController.view.subviews.first as! UIView
         var contentView = subView.subviews.first as! UIView
         var contentView2 = subView.subviews.last as! UIView
         
         
         
         contentView.backgroundColor = UIColor(red: 0.249, green: 0.549, blue: 0.674, alpha: 0.5)
         contentView.tintColor = UIColor(red: 0.572, green: 0.882, blue: 0.949, alpha: 1.0)
         // contentView.
         contentView2.tintColor = UIColor(red: 0.572, green: 0.882, blue: 0.949, alpha: 1.0)
         */
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    func SelectEmail() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        
        //  picker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        
        //  picker.displayedProperties = [NSNumber(int: kABPersonFirstNameProperty)]
        
        if picker.responds(to: #selector(getter: ABPeoplePickerNavigationController.predicateForEnablingPerson)) {
            //   picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func ContactsClicked(_ sender: Int) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        print("EDITING PLAYER WITH NEW CONTACT")
        
        //picker.displayedProperties = [NSNumber(int: kABPersonEmailProperty)]
        //picker.displayedProperties = [NSNumber(int: kABPersonPhoneMainLabel)]
        
        if picker.responds(to: #selector(getter: ABPeoplePickerNavigationController.predicateForEnablingPerson)) {
            //  picker.predicateForEnablingPerson = NSPredicate(format: "emailAddresses.@count > 0")
            // picker.predicateForEnablingPerson = NSPredicate
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
        peoplePickerNavigationController(peoplePicker, shouldContinueAfterSelectingPerson: person, property: property, identifier: identifier)
        peoplePicker.dismiss(animated: true, completion: nil)
        return false;
    }
    
    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        peoplePicker.dismiss(animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
        print("Contacts Picked - Row Selected = \(PlayerRowSelected)")
        
        let multivalue: ABMultiValue = ABRecordCopyValue(person, property).takeRetainedValue()
        let index = ABMultiValueGetIndexForIdentifier(multivalue, identifier)
        let email = ABMultiValueCopyValueAtIndex(multivalue, index).takeRetainedValue() as! String
        let fullnameString : CFString = ABRecordCopyCompositeName(person).takeRetainedValue()
        let fullname : NSString = fullnameString as NSString
        
        //   savename(fullname, emailaddress: email, group: groupName)
        
      //  print("new user MultiValue: \(multivalue)")
      //  print("new user Email: \(email)")
        print("new user Name: \(fullname)")
        
        /*
        let emailParse1 = email.replacingOccurrences(of: "(", with: "")
        let emailParse2 = emailParse1.replacingOccurrences(of: ")", with: "")
        let emailParse3 = emailParse2.replacingOccurrences(of: " ", with: "")
        let emailParse4 = emailParse3.replacingOccurrences(of: "+", with: "")
        print("PARSED CONTACT: \(emailParse4)")
        */
        
        //  EmailInfo.append(emailParse4)
        //  NameInfo.append(fullname)
        
       // Replaced_New_Name = fullname
       // Replaced_New_Contact = emailParse4 as NSString
      
        
        let TempPlayerTraitInfo = self.GameTotalTraitInfo[PlayerRowSelected]
        
        let temptraitname = TempPlayerTraitInfo.traitname
        let temptraitimageURL = TempPlayerTraitInfo.imageURL
        let temptraitlevel = TempPlayerTraitInfo.traitlevel
        let temptraitid = TempPlayerTraitInfo.traitid
        let tempimagedata = TempPlayerTraitInfo.traitimagedata
        let tempdescription = TempPlayerTraitInfo.traitdescription
        let templocalTrait = TempPlayerTraitInfo.localTrait
        let tempPlayer = TempPlayerTraitInfo.Player
        let tempPlayerName = fullname
        
        
         let TempPlayerTraitInfoUpdated = TraitInventoryPlayer(traitname: temptraitname as NSString, imageURL: temptraitimageURL, traitlevel: temptraitlevel, traitid: temptraitid, traitimagedata: tempimagedata, traitdescription: tempdescription as NSString, localTrait: templocalTrait, Player: tempPlayer, PlayerName: tempPlayerName as String)
        
        
        self.GameTotalTraitInfo.remove(at: self.PlayerRowSelected);
        self.GameTotalTraitInfo.insert(TempPlayerTraitInfoUpdated, at: self.PlayerRowSelected)
        self.PlayerNamesArray.remove(at: self.PlayerRowSelected);
        self.PlayerNamesArray.insert(tempPlayerName as String, at: self.PlayerRowSelected)
        
       // self.PlayerIDs.remove(at: self.PlayerRowSelected);
       // self.PlayerIDs.insert("NONE", at: self.PlayerRowSelected)
        
        
        self.TableView.reloadData()
    }
   
    /*
     @IBAction func editTableView(_ sender: AnyObject) {
     
     
     let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
     // 2
     let blurView = UIVisualEffectView(effect: darkBlur)
     blurView.frame = self.view.bounds
     // 3
     // cell.Turn1Image?.addSubview(blurView)
     
     
     if TableView.isEditing{
     TableView.setEditing(false, animated: false)
     // self.view.addSubview(blurView)
     //editBTN.style = UIBarButtonItemStyle.Plain;
     //editBTN.title = "Delete Game";
     TableView.reloadData()
     } else {
     //   blurView.removeFromSuperview()
     TableView.setEditing(true, animated: true)
     //editBTN.title = "Done";
     //editBTN.style = UIBarButtonItemStyle.Done;
     TableView.reloadData()
     }
     
     
     }
     */
    
    /*
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        return true
    }
    
    */
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
        
        //        UIView.animate(withDuration: 0.5) {
        //            self.tableView.tableHeaderView?.frame = bannerView.frame
        //            bannerView.transform = CGAffineTransform.identity
        //            self.tableView.tableHeaderView = bannerView
        //        }
        
    }
    
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("Fail to receive ads")
        print(error)
        
    }
    
    // MARK: - Help methods
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9759787683845878/9895698149")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial!) {
        print("Fail to receive interstitial")
    }
 
   // }
    
}
