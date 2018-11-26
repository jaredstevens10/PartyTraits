//
//  StartMainViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 2/12/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData

class StartMainViewController: UIViewController {
    
    
    var LocalSavedTraits = [String]()
    var UnSyncedTraits = [String]()
    
    
    @IBOutlet weak var messageToUserLBL: UILabel!
    
    var messageToUser = String()
    var messageToUserArray = ["Oh Snap! It's about to get crazy up in here.","Wow, you look really nice today, I mean it...seriously","You're not going to wear that shirt today are you? Uh...","Let me out of here!","Ok, so this might not be the best decision you've made today...","Can you keep a secret...","Everyone is staring at you...don't screw it up.","Let's do this! -L Jenkins","Here's 20 free points...(the points mean nothing)"]

    let prefs:UserDefaults = UserDefaults.standard
    
    var SavedItemsInventory = [NSManagedObject]()
    var TotalItems = Int()
    
    @IBOutlet weak var logoIMG: UIImageView!
    
    @IBOutlet weak var logoIMGw: NSLayoutConstraint!
    @IBOutlet weak var logoIMGh: NSLayoutConstraint!
    
    var TotalTraitsArray = [NSString]()
    
    var TraitInventoryInfo = [TraitInventory]()
    var NewTraitInventoryInfo = [TraitInventory]()
    
    let ServerURL = "http://\(ServerInfo.sharedInstance)/Apps/BattleField/Items/"
    
    let username: NSString = "guest"
    
    
    @IBOutlet weak var LoadProgressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FirstTimeLoading()
        
        let randomIndex = Int(arc4random_uniform(UInt32(messageToUserArray.count)))
        
        messageToUser = messageToUserArray[randomIndex]
        messageToUserLBL.text = messageToUser
        
        
        self.logoIMGw.constant = 0
        self.logoIMGh.constant = 0
        self.logoIMG.alpha = 0.0
        
        let seconds = 4.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)

        
        RetrieveTraits()
        
        
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(StartMainViewController.UpdateDownloadProgress), name: NSNotification.Name(rawValue: "googleImageNVC"), object: nil)
        
     
        
        /*
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            print("waiting 4 seconds to start")
            self.performSegue(withIdentifier: "startApp", sender: self)
            // here code perfomed with delay
            
        })
        */
        
        // Do any additional setup after loading the view.
    }
    
    
    func FirstTimeLoading() {
        
        let NotFirstTimePlaying = prefs.bool(forKey: "FirstTimePlaying")
        
        if NotFirstTimePlaying {
            
        } else {
        
        prefs.set(0, forKey: "CreateTraitsCount")
            
            
        //prefs.set(true, forKey: "FirstTimePlaying")
            
            
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
        
        

        self.logoIMG.alpha = 0.0
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            
            print("Logo Moving")
            self.logoIMGw.constant = 100
            self.logoIMGh.constant = 100
            self.logoIMG.alpha = 1.0
            

        })
        
        //RetrieveTraits()

        let seconds = 4.0
        let secondsLoad = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        let secondsQuick = 3.0
        let delayQuick = secondsQuick * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTimeQuick = DispatchTime.now() + Double(Int64(delayQuick)) / Double(NSEC_PER_SEC)
        
        
        
        
        
        var UpdatedTraits = Bool()
       // let UpdatedTraits = false
        
        
        
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
        
        
        let NumberOfSavedTraits = LocalSavedTraits.count
        
        
        
        
        
        let CurrentSavedTraits = prefs.value(forKey: "SavedServerTraits") as! Int
        
        var CurrentServerTraitCount = Int()
        var CurrentServerTraitIDs = [String]()
        
        (CurrentServerTraitCount, CurrentServerTraitIDs) = GetServerTraitCount(self.username)
        
        
        
        
        
        print("LocalSavedTraits: \(LocalSavedTraits), CurrentServerTraitIDs: \(CurrentServerTraitIDs)")
        
        
        
        for serverTraitID in CurrentServerTraitIDs {
            
            
            if LocalSavedTraits.contains(serverTraitID) {
                
            } else {
                UnSyncedTraits.append(serverTraitID)
            }
            
            
        }
        
        
        
        print("These are the traits not downloaded: \(UnSyncedTraits)")
        
        
        print("Current server traits: \(CurrentServerTraitCount)")
        print("Current saved traits: \(CurrentSavedTraits)")
        
        if CurrentServerTraitCount > CurrentSavedTraits {
            
            UpdatedTraits = false
            
        } else {
            UpdatedTraits = true
        }
        
        DispatchQueue.main.async(execute: {
            print("updating traits")
            
    self.LoadProgressView.setProgress(0.5, animated: true)
            
    if Reachability.isConnectedToNetwork() {
        print("is connected")
        if !UpdatedTraits {
            
            print("Traits are not synced")
            self.prefs.set(false, forKey: "FinishedSavingAllTraits")
            
            
            
            
            
            
            //  DispatchQueue.main.async(execute: {
            // print("Item Inventory Info = \(self.ItemInventoryInfo)")
            
            
           
            
            
            //  backgroundThread(background: {
            
                
                let UnSyncedTraitsCount = self.UnSyncedTraits.count
                
                var TraitsSuccessfullyDownloaded = 0
            
            
            var ExceededMaxLimit = Bool()
                
                
              //  for unSyncedTrait in self.UnSyncedTraits {
                    
            backgroundThread(background: {
                
                
                
                
                
                
            for unSyncedTrait in self.UnSyncedTraits {
                
                
               
                
                        
                    
                TraitsSuccessfullyDownloaded += 1
                let TraitAllowedCount = NumberOfSavedTraits + TraitsSuccessfullyDownloaded
                
                if TraitAllowedCount < MaxTraitsAllowed {
                    
                
                    print("Number of Saved Traits: \(NumberOfSavedTraits)")
                    print("TraitsSuccessfullyDownloaded: \(TraitsSuccessfullyDownloaded)")
                    print("MaxTraitsAllowed: \(MaxTraitsAllowed)")
                    
                
                var TempUnsyncedTraits = [String]()
                    
                    TempUnsyncedTraits.append(unSyncedTrait)
            //let URLDataItems = RefreshTraitInventory(self.username, UnsyncedTraits: self.UnSyncedTraits)
                    
            let URLDataItems = RefreshTraitInventory(self.username, UnsyncedTraits: TempUnsyncedTraits)

            // let URLDataItems = RefreshTraitInventoryLite(self.username)
            
            self.TraitInventoryInfo = self.FilterTraitData(URLDataItems)
            
            
            
            // var name = prefs.valueForKey("USERNAME") as! NSString as String
            
            //  self.usernameLabel.text = "Welcome Back \(name)"
   
                
              //  backgroundThread(background: {
                    //self.GetPublicTurns()
                    //  print("BACKGROUND THREAD - Updating Users' location")
                    
                    //     print("Saving Images now")
                    
                    //for items in self.TraitInventoryInfo {
                    for items in self.NewTraitInventoryInfo {
                        //   print("Saving \(items.name)")
                        
                       // let theImageURL = "\(self.ServerURL)\(items.imageURL).png"
                       // let theImageURL100 = "\(self.ServerURL)\(items.imageURL100).png"
                        
                       // SaveFile(theImageURL, name: "/\(items.imageURL).png")
                        
                        let TraitImageName = "\(items.traitname)_\(items.traitid)"
                        
                        
                        
                        
                        print("Saving File: \(items.traitname) now")
                        
                       
                        SaveFileNSData(items.traitimagedata, name: "/\(TraitImageName).png")
                        
                        
                        
                        
                        /*
                        if items.imageURL100 != "" {
                            SaveFile(theImageURL100, name: "/\(items.imageURL100).png")
                        }
                        */
                    }
                
                
                
                DispatchQueue.main.async(execute: {
                
                
                print("Unsynced Trait Count: \(UnSyncedTraitsCount)")
                print("Traits still needed to be Downloaded: \(TraitsSuccessfullyDownloaded)")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsSuccessfullyDownloaded)"])
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress2"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsSuccessfullyDownloaded)"])
                
                print("Trait \(unSyncedTrait) has been saved locally")
                
                print("COMPLETION: total count = \(UnSyncedTraitsCount), onces downloaded: \(TraitsSuccessfullyDownloaded)")
                
                if UnSyncedTraitsCount == TraitsSuccessfullyDownloaded {
                    print("should update that all traits have bene updated")
                    self.prefs.set(true, forKey: "TRAITSUPDATED")
                }
                
                })
                
                
                } else {
                    
                    ExceededMaxLimit = true
                    
                    
                    if UnSyncedTraitsCount == 0 || ExceededMaxLimit {
                        
                        print("FINISHED SAVED ALL TRAITS")
                        self.prefs.set(true, forKey: "FinishedSavingAllTraits")
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress"), object: nil, userInfo: ["totalProgress":"1", "currentProgress":"1"])
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress2"), object: nil, userInfo: ["totalProgress":"1", "currentProgress":"1"])
                        
                    }
                    
                }
                
                
                    }
                
                
                print("UnSyncedTraitsCount: \(UnSyncedTraitsCount)")
                        
                        
                if UnSyncedTraitsCount == 0 || ExceededMaxLimit {
                    
                    print("FINISHED SAVED ALL TRAITS")
                    self.prefs.set(true, forKey: "FinishedSavingAllTraits")
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress"), object: nil, userInfo: ["totalProgress":"1", "currentProgress":"1"])
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress2"), object: nil, userInfo: ["totalProgress":"1", "currentProgress":"1"])
                    
                }
                    
                
                        
                       
                    
                      }, completion: {
                        
                        
//                        print("Unsynced Trait Count: \(UnSyncedTraitsCount)")
//                        print("Traits still needed to be Downloaded: \(TraitsSuccessfullyDownloaded)")
//                        
//                        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsSuccessfullyDownloaded)"])
//                        
//                        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress2"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsSuccessfullyDownloaded)"])
//                        
//                        print("Trait \(unSyncedTrait) has been saved locally")
//                        
//                        print("COMPLETION: total count = \(UnSyncedTraitsCount), onces downloaded: \(TraitsSuccessfullyDownloaded)")
//                        
//                        if UnSyncedTraitsCount == TraitsSuccessfullyDownloaded {
//                            print("should update that all traits have bene updated")
//                            self.prefs.set(true, forKey: "TRAITSUPDATED")
//                        }
                        
                      })
                    //temp
                   // self.LoadProgressView.setProgress(0.7, animated: true)
                    
                    
                    /*
                    print("Unsynced Trait Count: \(UnSyncedTraitsCount)")
                    print("Traits still needed to be Downloaded: \(TraitsLeftToDownload)")
                    
                  NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsLeftToDownload)"])
                    
                     NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateDownloadProgress2"), object: nil, userInfo: ["totalProgress":"\(UnSyncedTraitsCount)", "currentProgress":"\(TraitsLeftToDownload)"])
                
                print("Trait \(unSyncedTrait) has been saved locally")
                    */
                
        //    }
            
            /*
            
                }, completion: {
                    
                    
                    self.prefs.set(true, forKey: "TRAITSUPDATED")
                    
                    DispatchQueue.main.async(execute: {
                        
                        //temp
                       // self.LoadProgressView.setProgress(1.0, animated: true)
                        
                        print("FINISHED SAVING ALL TRAITS")
                        
                        self.prefs.set(true, forKey: "FinishedSavingAllTraits")
                        
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                            //     print("waiting 4 seconds to start")
                            
                           // self.performSegue(withIdentifier: "GoToMap", sender: self)
                            
                            //temp
                            //self.performSegue(withIdentifier: "startApp", sender: self)
                            
                            
                            /*
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                print("waiting 4 seconds to start")
                                self.performSegue(withIdentifier: "startApp", sender: self)
                                // here code perfomed with delay
                                
                            })
                            */
                            
                        })
                        
                        //self.GetMyHUD.removeFromSuperview()
                        //  self.tableView.reloadData()
                        // print("DISPATCH ASYNC - Finished Updating the users' location")
                    })
                    // print("Done Getting Steal Turns")
                    //   self.kolodaView.resetCurrentCardNumber()
                })
                
                */
                
            
            
            
            self.LoadProgressView.setProgress(1.0, animated: true)
            //self.performSegue(withIdentifier: "startApp", sender: self)
            
            
            DispatchQueue.main.asyncAfter(deadline: dispatchTimeQuick, execute: {
                print("waiting 4 seconds to start")
                self.performSegue(withIdentifier: "startApp", sender: self)
                // here code perfomed with delay
                
            })
            
            
                
                
                
        //    })
            
            print("should segue now")
            
            
//            self.LoadProgressView.setProgress(1.0, animated: true)
//            
//            
//            
//            self.performSegue(withIdentifier: "startApp", sender: self)
            
            
        } else {
            
            self.LoadProgressView.setProgress(1.0, animated: true)
            
            
            DispatchQueue.main.asyncAfter(deadline: dispatchTimeQuick, execute: {
                print("waiting 4 seconds to start")
                self.performSegue(withIdentifier: "startApp", sender: self)
                // here code perfomed with delay
                
            })
            
            }
            
        } else {
                
                SCLAlertView().showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Oops Network Error", subTitle: "Please Confirm Your Network Settings", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
                
            }
        
    })
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func RetrieveTraits() {
        
        LocalSavedTraits.removeAll()
        
        
        
        var SavedServerTraits = 0
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContextGroups = appDelegate.managedObjectContext
        let fetchGroups = NSFetchRequest<NSFetchRequestResult>(entityName: "TraitInfo")
        let errorGroups: NSError?
        
        self.LoadProgressView.setProgress(0.1, animated: true)
        
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
                SavedServerTraits += 1
                LocalSavedTraits.append(TraitID)
                
            }
            
            print("Local saved traits: \(LocalSavedTraits)")
            
            
            //  print("Current items IMAGE URL =\(TotalItemsArray)")
            prefs.set(SavedServerTraits, forKey: "SavedServerTraits")
            print("Saved Server Traits: \(SavedServerTraits)")
            
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
        
        
        //TEMP
        NewTraitInventoryInfo.removeAll()
        
        
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
                    
                    NewTraitInventoryInfo.append(TraitInventory(traitname: traitname as NSString, imageURL: imageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription, localTrait: false))
                    
                    
                    
                    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

struct TraitInventory {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    //var imageData: Data
    
}

struct TraitInventoryAdmin {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    var approvedStatus: String
    //var imageData: Data
    
}

struct TraitInventorySorted {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
}

struct TraitInventoryLimited {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    var index: Int
}

struct TraitInventoryLimitedHidden {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    var index: Int
    var Hidden: Bool
}


struct TraitInventoryUsed {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    var index: Int
    var TurnNumber: Int
}

struct TraitInventoryPlayer {
    
    var traitname: NSString
    var imageURL: String
    var traitlevel: String
    var traitid: String
    var traitimagedata: String
    var traitdescription: NSString
    var localTrait: Bool
    var Player: String
    var PlayerName: String
}

struct GroupGameInfo {
    
    var Round: Int
    var NumPlayersArray: [Int]
    var NumPlayers: Int
    var TraitsAvailable: [Double]
    var TraitsUsed: [Double]
    var CurrentRoundTraits: [Double]
    var maxRounds: Int
    

}


struct GroupGameInfoUpdate {
    
  
    
    
    var Round: Int!
    var NumPlayersArray: [Int]!
    var NumPlayers: Int!
    var TraitsAvailable: [Double]!
    var TraitsUsed: [Double]!
    var CurrentRoundTraits: [Double]!
    var maxRounds: Int!
    var PlayerNames: [String]
    
    
}

extension GroupGameInfoUpdate {
    
    init(_ groupGameInfo: GroupGameInfoUpdate) {
        Round = groupGameInfo.Round
        NumPlayersArray = groupGameInfo.NumPlayersArray
        NumPlayers = groupGameInfo.NumPlayers
        TraitsAvailable = groupGameInfo.TraitsAvailable
        TraitsUsed = groupGameInfo.TraitsUsed
        CurrentRoundTraits = groupGameInfo.CurrentRoundTraits
        maxRounds = groupGameInfo.maxRounds
        PlayerNames = groupGameInfo.PlayerNames
    }

 
    
    /*
    public var Round: String!
    public var NumPlayersArray: String!
    public var NumPlayers: String!
    public var TraitsAvailable: String!
    public var TraitsUsed: String!
    public var CurrentRoundTraits: String!
    public var maxRounds: String!
    */
    
    //let fullNameArr = fullName.components(separatedBy: " ")
    
    /*
    public init() {
        
        
        var Round: Int!
        var NumPlayersArray: [Int]!
        var NumPlayers: Int!
        var TraitsAvailable: [Double]!
        var TraitsUsed: [Double]!
        var CurrentRoundTraits: [Double]!
        var maxRounds: Int!
        
        init(_ groupGameInfo: GroupGameInfoUpdate) {
            Round = groupGameInfo.Round
            NumPlayersArray = groupGameInfo.NumPlayersArray
            NumPlayers = groupGameInfo.NumPlayers
            TraitsAvailable = groupGameInfo.TraitsAvailable
            TraitsUsed = groupGameInfo.TraitsUsed
            CurrentRoundTraits = groupGameInfo.CurrentRoundTraits
            maxRounds = groupGameInfo.maxRounds
        }
        
        
        
    }
    */
 
    
    // Decode
    
    /*
    public init(dictionary: Dictionary<String, AnyObject>){
        
        
        /*
        Round = Int((dictionary["Round"]?.description)!)
        
        print("Num Traits String: \(dictionary["TraitsAvailable"])")
        
        NumPlayersArray = (dictionary["NumPlayersArray"]?.description) as? [Int]!
        NumPlayers = Int((dictionary["NumPlayers"]?.description)!)
        TraitsAvailable = (dictionary["TraitsAvailable"]?.description) as? [Double]!
        TraitsUsed = (dictionary["TraitsUsed"] as? [Double])!
        CurrentRoundTraits = (dictionary["CurrentRoundTraits"] as? [Double])!
        maxRounds = Int((dictionary["maxRounds"]?.description)!)
        */
        
        Round = (dictionary["Round"]?.description)!
        // print("Num Traits String: \(dictionary["TraitsAvailable"])")
        
        NumPlayersArray = (dictionary["NumPlayersArray"]?.description)!
        NumPlayers = (dictionary["NumPlayers"]?.description)!
        TraitsAvailable = (dictionary["TraitsAvailable"]?.description)!
        TraitsUsed = (dictionary["TraitsUsed"]?.description)!
        CurrentRoundTraits = (dictionary["CurrentRoundTraits"]?.description)!
        maxRounds = (dictionary["maxRounds"]?.description)!
    }
    
    */
    
    //public func decode() ->
    
    // Encode
    public func encode() -> Dictionary<String, AnyObject> {
        
        var dictionary : Dictionary = Dictionary<String, AnyObject>()
        dictionary["Round"] = Round as AnyObject?
        dictionary["NumPlayersArray"] = NumPlayersArray as AnyObject?
        dictionary["NumPlayers"] = NumPlayers as AnyObject?
        dictionary["TraitsAvailable"] = TraitsAvailable as AnyObject?
        dictionary["TraitsUsed"] = TraitsUsed as AnyObject?
        dictionary["CurrentRoundTraits"] = CurrentRoundTraits as AnyObject?
        dictionary["maxRounds"] = maxRounds as AnyObject?
        dictionary["PlayerNames"] = PlayerNames as AnyObject?
        return dictionary
    }
    
}




/*
extension GroupGameInfo {
    init?(data: NSData) {
        if let coding = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Encoding {
            Round = coding.Round as Int
            NumPlayersArray = coding.NumPlayersArray 
            NumPlayers = coding.NumPlayers as Int
            TraitsAvailable = coding.TraitsAvailable as [Double]
            TraitsUsed = coding.TraitsUsed as [Double]
            CurrentRoundTraits = coding.CurrentRoundTraits as [Double]
            maxRounds = coding.maxRounds as Int
        } else {
            return nil
        }
    }
    
    func encode() -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: Encoding(self)) as NSData
    }
    
    private class Encoding: NSObject, NSCoding {
       // let a : NSString
       // let b : NSString?
        
        var Round : Int
        var NumPlayersArray : [UInt64] = []
        var NumPlayers : Int
        var TraitsAvailable : [Double]
        var TraitsUsed : [Double]
        var CurrentRoundTraits : [Double]
        var maxRounds : Int
        
        init(_ groupGameInfo: GroupGameInfo) {
            Round = groupGameInfo.Round
            NumPlayersArray = groupGameInfo.NumPlayersArray 
            NumPlayers = groupGameInfo.NumPlayers
            TraitsAvailable = groupGameInfo.TraitsAvailable
            TraitsUsed = groupGameInfo.TraitsUsed
            CurrentRoundTraits = groupGameInfo.CurrentRoundTraits
            maxRounds = groupGameInfo.maxRounds
        }
        
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
           //  super.init()
            /*
            if let Round = aDecoder.decodeObject(forKey: "Round") as? Int {
                self.Round = Round
            } else {
                return nil
            }
            */
 
           // let RoundTemp = (aDecoder.decodeObject(forKey: "Round") as? String)!
            
           // print("Round Decoded: \(RoundTemp)")
            Round = aDecoder.decodeInteger(forKey: "Round")
           // Round = (aDecoder.decodeObject(forKey: "Round") as? Int)!
           // NumPlayersArray = aDecoder.deco
            
            var NumPlayersArraycount = 0
            if let NumPlayersArray_ptr = aDecoder.decodeBytes(forKey: "NumPlayersArray", returnedLength: &NumPlayersArraycount) {
                // If we convert it to a buffer pointer of the appropriate type and count ...
                let numValues = NumPlayersArraycount / MemoryLayout<UInt64>.stride
                NumPlayersArray_ptr.withMemoryRebound(to: UInt64.self, capacity: numValues) {
                    let NumPlayersArray_buf = UnsafeBufferPointer<UInt64>(start: UnsafePointer($0), count: numValues)
                    // ... then the Array creation becomes easy.
                   // let TempPlayersInt = Int(NumPlayersArray_buf)
                    
                    NumPlayersArray = Array(NumPlayersArray_buf)
                }
            }
            
            
            
           // NumPlayersArray = aDecoder.decodeObject(forKey: "NumPlayersArray") as! [Int]
            NumPlayers = (aDecoder.decodeObject(forKey: "NumPlayers") as? Int)!
            TraitsAvailable = (aDecoder.decodeObject(forKey: "TraitsAvailable") as? [Double])!
            TraitsUsed = (aDecoder.decodeObject(forKey: "TraitsUsed") as? [Double])!
            CurrentRoundTraits = (aDecoder.decodeObject(forKey: "CurrentRoundTraits") as? [Double])!
            maxRounds = (aDecoder.decodeObject(forKey: "maxRounds") as? Int)!
        }
        func encode(with aCoder: NSCoder) {
           // aCoder.encode(Round, forKey: "Round")
            //aCoder.encode(Round, forKey: "Round")
            aCoder.encode(Round, forKey: "Round")
           // print("Encoded Round: \(")
            
            let NumPlayersArray_numBytes = NumPlayersArray.count * MemoryLayout<UInt64>.stride
            NumPlayersArray.withUnsafeBufferPointer {
                $0.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: NumPlayersArray_numBytes) {
                    aCoder.encodeBytes($0, length: NumPlayersArray_numBytes, forKey: "NumPlayersArray")
                }
            }
            
            
            aCoder.encode(NumPlayersArray, forKey: "NumPlayersArray")
            aCoder.encode(NumPlayers, forKey: "NumPlayers")
            aCoder.encode(TraitsAvailable, forKey: "TraitsAvailable")
            aCoder.encode(TraitsUsed, forKey: "TraitsUsed")
            aCoder.encode(CurrentRoundTraits, forKey: "CurrentRoundTraits")
            aCoder.encode(maxRounds, forKey: "maxRounds")
        }
        
    }
}
 
 */

