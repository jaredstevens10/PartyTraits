//
//  NewGameViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/4/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

//class NewGameViewController: UIViewController {
 class NewGameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var reportContentBTN: UIButton!
    @IBOutlet weak var currentGameTraitsBTN: UIButton!
    var PlayedAd = Bool()
    var DidRemoveAds = Bool()
    var NumberPlayersArray = [Int]()
    var GroupGameTraits = [Double]()
    var GroupGameMaxRounds = Double()
    var ResumeGroupGame = Bool()
    var StartingTraits = [Double]()
    
    @IBOutlet weak var ActIndGroup: UIActivityIndicatorView!
    
    
    @IBOutlet weak var TraitViewHolder: UIView!
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9759787683845878/9895698149"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    var interstitial: GADInterstitial?
    
    
    let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    var theDifLevel = String()
    var TotalItems = Int()
    var SavedItemsInventory = [NSManagedObject]()
    
    var TotalTraitsInventoryArray = [TraitInventorySorted]()
    
    let prefs:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var difLabel: UILabel!
    @IBOutlet weak var nextTraitView: UIView!
    var Traits = [Double]()
    var TraitsUsed = [Double]()
    var recentTraitUsed = Double()
    var ShownTrait_ID = Int()
    var ImageData = [NSString]()
    var Image_ID = Int()
    var ImageURLData = Data()
    var ImageArrayData = [NSString]()
    
    var GameType = NSString()
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    
    @IBOutlet weak var introLBL: UILabel!
    
    @IBOutlet weak var TraitNameLabel: UILabel!
    @IBOutlet weak var TraitDescLabel: UILabel!
    
    @IBOutlet weak var TraitImage: UIImageView!
    
    @IBOutlet weak var backBTN: UIButton!
    
    @IBOutlet weak var nextTraitButton: UIButton!
    
   
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.reportContentBTN.isHidden = true
     //  actInd.hidden = true
            actInd.stopAnimating()
        print("Game Started: Game Type = \(GameType)")
        print("Number of players array: \(NumberPlayersArray)")
        
        
        self.TraitNameLabel.isHidden = true
        self.currentGameTraitsBTN.isHidden = true
        
        switch GameType {
            
            
        case "FreePlay":
            theDifLevel = prefs.value(forKey: "FreeResumeDifLevel") as! String
            self.ActIndGroup.isHidden = true
            self.TraitNameLabel.isHidden = false
            self.currentGameTraitsBTN.isHidden = false
            
        case "TimerPlay":
            theDifLevel = prefs.value(forKey: "TimerResumeDifLevel") as! String
            self.ActIndGroup.isHidden = true
            self.TraitNameLabel.isHidden = false
            self.currentGameTraitsBTN.isHidden = false
            
        case "GroupPlay":
           theDifLevel = prefs.value(forKey: "GroupResumeDifLevel") as! String
            self.ActIndGroup.isHidden = false
            self.TraitNameLabel.isHidden = true
            self.currentGameTraitsBTN.isHidden = true
            
        default:
            break
            
        }

        
       
        
        print("Viewdidload: The Dif Level: \(theDifLevel)")
        
        difLabel.text = "Difficulty: \(theDifLevel)"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewGameViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
       // print("Viewdidload Traits:"\(Traits)")

        if let index = Traits.index(of: 0.0) {
            print("index: \(index)")
            Traits.remove(at: index)
        }
        
       // nextTraitButton.layer.cornerRadius = 65
        nextTraitView.layer.cornerRadius = 50
        nextTraitView.clipsToBounds = true
        nextTraitView.layer.masksToBounds = true
        nextTraitView.layer.borderWidth = 2
        nextTraitView.layer.borderColor = UIColor.white.cgColor
        currentGameTraitsBTN.layer.cornerRadius = 5
        currentGameTraitsBTN.clipsToBounds = true
        currentGameTraitsBTN.layer.masksToBounds = true
        
        if TraitsUsed.count < 1 {
            self.currentGameTraitsBTN.isHidden = true
        }
        
        adBannerView.load(GADRequest())
        
        // Display the intertitial ad
        
        DidRemoveAds = prefs.bool(forKey: "RemoveAdsPurchased")
        print("Was remove Ads Purchased: \(DidRemoveAds)")
        if !DidRemoveAds {
        interstitial = createAndLoadInterstitial()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var ResumingGame = Bool()
        let IsUnwinding = prefs.bool(forKey: "UnwindFromGroupPlay")
        
        switch GameType {
            
            
        case "FreePlay":
            ResumingGame = self.prefs.bool(forKey: "FreeGameInProgress")
            print("Free Play view did appear")
            self.prefs.set(true, forKey: "FreeGameInProgress")
            self.ActIndGroup.isHidden = true
            
        case "TimerPlay":
            ResumingGame = self.prefs.bool(forKey: "TimerGameInProgress")
            print("Timer view did appear")
            self.prefs.set(true, forKey: "TimerGameInProgress")
            self.ActIndGroup.isHidden = true
            
        case "GroupPlay":
            self.ActIndGroup.isHidden = false
            self.TraitViewHolder.isHidden = true
            self.nextTraitView.isHidden = true
            self.currentGameTraitsBTN.isHidden = true
            self.difLabel.isHidden = true
            
            ResumingGame = self.prefs.bool(forKey: "GroupGameInProgress")
            
            print("Group - view did appear")
            self.prefs.set(true, forKey: "GroupGameInProgress")
            
            print("NUMBER OF PLAYERS: \(NumberPlayersArray)")
            print("Traits Currently = \(Traits)")
            StartingTraits = Traits
            
            
            var playerTemp = 0
            
            
            
            
            if !IsUnwinding {
                 print("NOT UNWINDING")
            
            if !ResumingGame {
                
                print("NOT RESUMING")
            GroupGameMaxRounds = floor(Double(Traits.count) / Double(NumberPlayersArray.count))
            
                let GroupGameMaxRoundInt = Int(GroupGameMaxRounds)
                
            prefs.set(GroupGameMaxRoundInt, forKey: "GroupGameMaxRounds")
              //  prefs.set(value: GroupGameMaxRoundInt, forKey: "GroupGameMaxRounds")
            
            print("GROUP MAX ROUNDS = \(GroupGameMaxRounds)")
            
            for player in NumberPlayersArray {
                
               playerTemp += 1
                
                
                if (Traits.isEmpty == false) {
                    
                    ShownTrait_ID = GetTraitID(Traits)
                    
                   // print("****getting this is the trait id*** = \(ShownTrait_ID)")
                    
                    //get Image ID
                    Image_ID = Int(Traits[ShownTrait_ID])
                    recentTraitUsed = Traits[ShownTrait_ID]
                    
                    print("Player \(playerTemp): \(recentTraitUsed)")
                    
                   // let newTrait = Double()
                    
                    
                    
                    
                    if (Traits.count > 1) {
                        Traits.remove(at: ShownTrait_ID)
                        TraitsUsed.append(recentTraitUsed)
                        GroupGameTraits.append(recentTraitUsed)
                        print("Trait Added to Traits used.  Now = \(TraitsUsed)")
                        
                    } else {
                        
                        Traits.remove(at: 0)
                        TraitsUsed.append(recentTraitUsed)
                        GroupGameTraits.append(recentTraitUsed)
                    }
                    
                } else {
                    
                    
                }

            }
                
          
                
            DispatchQueue.main.async(execute: {
                
            self.ResumeGroupGame = false
            self.performSegue(withIdentifier: "GroupGameTraits", sender: self)
            })
                
            } else {
                
                DispatchQueue.main.async(execute: {
                    print("Should Resume Group Game")
                    self.ResumeGroupGame = true
                    self.performSegue(withIdentifier: "GroupGameTraits", sender: self)
                })
                
                
            }
            } else {
            print("IS UNWINDING")
                prefs.set(false, forKey: "UnwindFromGroupPlay")
                print("Group Unwind set to false")
            }
            
        default:
            break
            
        }
        
        
        let TraitsRemaining = Traits.count
        
        
        let UnwindFromGroupPlay = prefs.bool(forKey: "UnwindFromGroupPlay")
        
        if !UnwindFromGroupPlay {
            
        let UnwindFromGroupPlay = prefs.set(false, forKey: "UnwindFromGroupPlay")
        
            if !IsUnwinding {
                
        if GameType != "GroupPlay" {
            
            if !PlayedAd {
                
            if ResumingGame {
                
                 self.reportContentBTN.isHidden = false
            //Do some stuff
            // self.performSegueWithIdentifier("Select_NewGame", sender: self)
            
            //print("Resuming Group Game")
            
            let ViewedCurrentTraits = self.prefs.bool(forKey: "ViewedCurrentTraits")
            
            if !ViewedCurrentTraits {
            
            let actionSheetControllerNew: UIAlertController = UIAlertController(title: "Resumed Game", message: "There are \(TraitsRemaining) Traits Remaining", preferredStyle: .alert)
            
            //Create and add the Cancel action
            let cancelActionNew: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
                //Do some stuff
                // self.performSegueWithIdentifier("Select_NewGame", sender: self)
                
                
                
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
            self.present(actionSheetControllerNew, animated: true, completion: nil)
            
            
            }
            
           }
                
            }
            
            }
      }
        
        } else {
            
             prefs.set(false, forKey: "UnwindFromGroupPlay")
        }
    
        if TraitsUsed.count < 1 {
            self.currentGameTraitsBTN.isHidden = true
        } else {
            self.currentGameTraitsBTN.isHidden = false
        }
        
        
        let sumTest = Traits.count + TraitsUsed.count
        print("***TRAITS Count: \(Traits.count) Current Actual: \(Traits)")
        print("***TRAITS Count: \(TraitsUsed.count) Current Actual: \(TraitsUsed)")
        print("***TRAITS PLUS TRAITSUSED = \(sumTest)")
        
    
    }
    
    
    @IBAction func backBTN(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
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
    
    func GetTraitID(_ Traits: [Double]) -> Int {
        let UsedTrait = Int(arc4random_uniform(UInt32(Traits.count)))
        return UsedTrait
    }
    
    @IBAction func NewTrait(_ sender: UIButton) {
        
       //  actInd.hidden = false
        
        
        if DidRemoveAds {
        interstitial = createAndLoadInterstitial()
        }
        
        
         //UNCOMMENT TO ADD ADS
        
        if !DidRemoveAds {
        if (self.interstitial?.isReady)! {
            
            print("***Should show Ad now***")
            
            self.interstitial?.present(fromRootViewController: self)
        }
        }
        
        
        
       actInd.startAnimating()
        
        self.introLBL.isHidden = true
        
       GetNextTrait()
        
           DispatchQueue.main.async(execute: {
        
            if self.TraitsUsed.count < 1 {
                self.currentGameTraitsBTN.isHidden = true
            } else {
                self.currentGameTraitsBTN.isHidden = false
            }
            
        self.actInd.stopAnimating()
            
            self.reportContentBTN.isHidden = false
          // self.actInd.hidden = true
        })
       
        
    }
    
    func GetNextTrait() {
        
        if (Traits.isEmpty == false) {
            
            ShownTrait_ID = GetTraitID(Traits)
            
            print("****getting this is the trait id*** = \(ShownTrait_ID)")
            
            //get Image ID
            Image_ID = Int(Traits[ShownTrait_ID])
            recentTraitUsed = Traits[ShownTrait_ID]
            
            print("*** or is it this Trait??? \(Traits[ShownTrait_ID])")
            
            // print("SHOULD GET TRAIT IN FOR ID \(Image_ID)")
            
            //Get NSData from PHP
            //ImageURLData = GetTraitInfo(Image_ID)
            
            
            var Image64Data2 = Data()
            
            //  var (TraitNameOld, TraitDescOld, Image64Data) = GetTraitInfo(Image_ID)
            
            // var (TraitNameOld, TraitDescOld, Image64Data) = RetrieveImages(TraitID: Double(Image_ID))
            
            // var (TraitName, TraitDesc, Image64Data) = RetrieveTraitImages(TraitID: Double(Image_ID))
            var (TraitNameOld, TraitDesc, imageURLname) = RetrieveTraitImages(TraitID: Image_ID)
            // print("got urldata")
            
            
            
            
            //let TraitDesc1 = TraitDescOld.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            // let TraitName1 = TraitNameOld.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let TraitName = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            /*
             let TraitDescNSData = Data(base64Encoded: TraitDescOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
             let TraitDesc = NSString(data: TraitDescNSData, encoding: String.Encoding.utf8.rawValue)!
             
             */
            
            //let emailParse1 = email.stringByReplacingOccurrencesOfString("(", withString: "")
            //let emailParse2 = emailParse1.stringByReplacingOccurrencesOfString(")", withString: "")
            //let emailParse3 = emailParse2.stringByReplacingOccurrencesOfString(" ", withString: "")
            // let TraitDesc = TraitDesc1!.stringByReplacingOccurrencesOfString("+", withString: " ")
            // let TraitName = TraitName1!.stringByReplacingOccurrencesOfString("+", withString: " ")
            
            
            
            //let imageName = itemTemp
            let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(imageURLname).png")
            //  print("url for image = \(url)")
            let theImageData = try? Data(contentsOf: url)
            
            //TestImage = UIImage(data:theImageData!)!
            
            let image  = UIImage(data: theImageData!)!
            
            
            //  let decodedData = Data(base64Encoded: Image64Data as String, options: NSData.Base64DecodingOptions(rawValue: 0))
            //   let image = UIImage(data: decodedData!)
            
            TraitNameLabel.text = ("\(TraitName)") as String
            TraitDescLabel.text = ("\(TraitDesc)") as String
            
            TraitImage.contentMode = UIViewContentMode.scaleAspectFit
            TraitImage.image = image
            
            //Remove used Image ID
            
            if (Traits.count > 1) {
                Traits.remove(at: ShownTrait_ID)
                TraitsUsed.append(recentTraitUsed)
                print("Trait Added to Traits used.  Now = \(TraitsUsed)")
                
            } else {
                
                Traits.remove(at: 0)
                TraitsUsed.append(recentTraitUsed)
            }
            
            switch GameType {
                
                
            case "FreePlay":
                prefs.setValue(Traits, forKey: "FREECURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "FREECURRENTGAMEIDSused")
                
            case "GroupPlay":
                prefs.setValue(Traits, forKey: "GROUPCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "GROUPCURRENTGAMEIDSused")
                
            case "TimerPlay":
                prefs.setValue(Traits, forKey: "TIMERCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "TIMERCURRENTGAMEIDSused")
                
            default:
                break
                
            }
            
            
            //  print("Number of Traits = \(Traits.count)")
            //print(Traits)
        } else {
            
            //  print("Number of Traits = \(Traits.count)")
            
            //prefs.setValue(Traits, forKey: "CURRENTGAMEIDS")
            
            
            switch GameType {
                
                
            case "FreePlay":
                prefs.setValue(Traits, forKey: "FREECURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "FREECURRENTGAMEIDSused")
                prefs.set(false, forKey: "FreeGameInProgress")
                prefs.set(false, forKey: "FreeResumingGame")
            case "GroupPlay":
                prefs.setValue(Traits, forKey: "GROUPCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "GROUPCURRENTGAMEIDSused")
                prefs.set(false, forKey: "GroupGameInProgress")
                prefs.set(false, forKey: "GroupResumingGame")
            case "TimerPlay":
                prefs.setValue(Traits, forKey: "TIMERCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "TIMERCURRENTGAMEIDSused")
                prefs.set(false, forKey: "TimerGameInProgress")
                prefs.set(false, forKey: "TimerResumingGame")
            default:
                break
                
            }
            
            
            UIApplication.shared.cancelAllLocalNotifications()
            print("Cancelling all local notifications")
            // prefs.setBool(false, forKey: "GameInProgress")
            
            
            print("Traits Array is empty")
            
            var alert = UIAlertController(title: "Alert", message: "Game Over", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            // self.presentViewController(alert, animated: true, completion: nil)
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Game Over", subTitle: "You have viewed all the traits for this game", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
        }
        
    }
    
    
    func GetNextGroupTrait() {
        
        if (Traits.isEmpty == false) {
            
            ShownTrait_ID = GetTraitID(Traits)
            
            print("****getting this is the trait id*** = \(ShownTrait_ID)")
            
            //get Image ID
            Image_ID = Int(Traits[ShownTrait_ID])
            recentTraitUsed = Traits[ShownTrait_ID]
        
            print("*** or is it this Trait??? \(Traits[ShownTrait_ID])")
            
           // print("SHOULD GET TRAIT IN FOR ID \(Image_ID)")
            
            //Get NSData from PHP
            //ImageURLData = GetTraitInfo(Image_ID)
            
            
            var Image64Data2 = Data()
            
          //  var (TraitNameOld, TraitDescOld, Image64Data) = GetTraitInfo(Image_ID)
            
           // var (TraitNameOld, TraitDescOld, Image64Data) = RetrieveImages(TraitID: Double(Image_ID))
            
           // var (TraitName, TraitDesc, Image64Data) = RetrieveTraitImages(TraitID: Double(Image_ID))
            var (TraitNameOld, TraitDesc, imageURLname) = RetrieveTraitImages(TraitID: Image_ID)
           // print("got urldata")
            
            
            
            
            //let TraitDesc1 = TraitDescOld.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
           // let TraitName1 = TraitNameOld.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let TraitName = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            /*
            let TraitDescNSData = Data(base64Encoded: TraitDescOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let TraitDesc = NSString(data: TraitDescNSData, encoding: String.Encoding.utf8.rawValue)!
            
            */
            
            //let emailParse1 = email.stringByReplacingOccurrencesOfString("(", withString: "")
            //let emailParse2 = emailParse1.stringByReplacingOccurrencesOfString(")", withString: "")
            //let emailParse3 = emailParse2.stringByReplacingOccurrencesOfString(" ", withString: "")
           // let TraitDesc = TraitDesc1!.stringByReplacingOccurrencesOfString("+", withString: " ")
           // let TraitName = TraitName1!.stringByReplacingOccurrencesOfString("+", withString: " ")
            
            
            
            //let imageName = itemTemp
            let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(imageURLname).png")
          //  print("url for image = \(url)")
            let theImageData = try? Data(contentsOf: url)
            
            //TestImage = UIImage(data:theImageData!)!
            
            let image  = UIImage(data: theImageData!)!
            
            
          //  let decodedData = Data(base64Encoded: Image64Data as String, options: NSData.Base64DecodingOptions(rawValue: 0))
         //   let image = UIImage(data: decodedData!)
            
            TraitNameLabel.text = ("\(TraitName)") as String
            TraitDescLabel.text = ("\(TraitDesc)") as String
            
            TraitImage.contentMode = UIViewContentMode.scaleAspectFit
            TraitImage.image = image
            
            //Remove used Image ID
            
            if (Traits.count > 1) {
                Traits.remove(at: ShownTrait_ID)
                TraitsUsed.append(recentTraitUsed)
                print("Trait Added to Traits used.  Now = \(TraitsUsed)")
                
            } else {
                
                Traits.remove(at: 0)
                TraitsUsed.append(recentTraitUsed)
            }
            
            switch GameType {
            
                
               case "FreePlay":
                prefs.setValue(Traits, forKey: "FREECURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "FREECURRENTGAMEIDSused")
                
               case "GroupPlay":
                prefs.setValue(Traits, forKey: "GROUPCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "GROUPCURRENTGAMEIDSused")

               case "TimerPlay":
                prefs.setValue(Traits, forKey: "TIMERCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "TIMERCURRENTGAMEIDSused")
                
            default:
                break
            
            }
            
            
          //  print("Number of Traits = \(Traits.count)")
            //print(Traits)
        } else {
            
          //  print("Number of Traits = \(Traits.count)")
            
            //prefs.setValue(Traits, forKey: "CURRENTGAMEIDS")
            
            
            switch GameType {
                
                
            case "FreePlay":
                prefs.setValue(Traits, forKey: "FREECURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "FREECURRENTGAMEIDSused")
                prefs.set(false, forKey: "FreeGameInProgress")
                prefs.set(false, forKey: "FreeResumingGame")
            case "GroupPlay":
                prefs.setValue(Traits, forKey: "GROUPCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "GROUPCURRENTGAMEIDSused")
                prefs.set(false, forKey: "GroupGameInProgress")
                prefs.set(false, forKey: "GroupResumingGame")
            case "TimerPlay":
                prefs.setValue(Traits, forKey: "TIMERCURRENTGAMEIDS")
                prefs.setValue(TraitsUsed, forKey: "TIMERCURRENTGAMEIDSused")
                prefs.set(false, forKey: "TimerGameInProgress")
                prefs.set(false, forKey: "TimerResumingGame")
            default:
                break
                
            }
            
            
            UIApplication.shared.cancelAllLocalNotifications()
            print("Cancelling all local notifications")
           // prefs.setBool(false, forKey: "GameInProgress")
            
            
            print("Traits Array is empty")
            
            var alert = UIAlertController(title: "Alert", message: "Game Over", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
           // self.presentViewController(alert, animated: true, completion: nil)
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Game Over", subTitle: "You have viewed all the traits for this game", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
        }
        
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    func RetrieveTraitImages(TraitID: Int) -> (String, String, String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var TraitNameOld = String()
        var TraitDescOld = String()
        var Image64Data = String()
        
        
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
                TotalItems += 1
                // ItemsInventoryArray.append(CurNumGroups)
                
               // let traitImageURL = items.value(forKey: "imageURL") as! String
                //let ItemCategory = items.value(forKey: "category") as! String
                //let ItemOrder = items.value(forKey: "itemOrder") as! String
                
                
                let traitname = items.value(forKey: "traitname") as! String
                let traitimagedata = items.value(forKey: "traitimagedata") as! String
                let traitlevel = items.value(forKey: "traitlevel") as! String
                let traitdescription = items.value(forKey: "traitdescription") as! String
                let traitid = items.value(forKey: "traitid") as! String
                
                let traitImageURL = items.value(forKey: "imageURL") as! String
                let localTrait = items.value(forKey: "localTrait") as! Bool
                
                
                
               // if (traitlevel == "\(theDifLevel)") && (itemOrder != "0") {
                
                if traitid == TraitID.description {
                    
                    TraitNameOld = traitname
                    TraitDescOld = traitdescription
                   // Image64Data = traitimagedata
                    Image64Data = traitImageURL
                    
                   // print("Trying to load image with url \(traitImageURL)")
                    
                    
                }
                
                
                /*
                
                switch theDifLevel {
                    
                    
                    case "Easy":
                    
                    
                        if (traitlevel == "\(theDifLevel)") {
                            
                            // TotalTraitsInventoryArray.append(ItemInventorySorted(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, itemOrderNum: Int(itemOrder)!, health: health, stamina: stamina, viewRange: viewRange, subCategory: subCategory))
                            
                            TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString))
                            
                    }
                    
                    case "Medium":
                    
                        if (traitlevel == "\(theDifLevel)") || (traitlevel == "Medium") {
                            
                            // TotalTraitsInventoryArray.append(ItemInventorySorted(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, itemOrderNum: Int(itemOrder)!, health: health, stamina: stamina, viewRange: viewRange, subCategory: subCategory))
                            
                            TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString))
                            
                    }
                    
                    case "Hard":
                    
                    
                     TotalTraitsInventoryArray.append(TraitInventorySorted(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString))
                    
                    
                    
                default:
                    break
                }
                
                
                */
                
                
            }
            
            //    print("TotalItemsInventoryArray - PreSorted - \(TotalItemsInventoryArray)")
            
            
            /*
            
            TotalTraitsInventoryArray.sort { (lhs: TraitInventorySorted, rhs: TraitInventorySorted) -> Bool in
                // you can have additional code here
                return lhs.traitid < rhs.traitid
            }
            
            
            
            print("TotalItemsInventoryArray - Sorted - \(TotalTraitsInventoryArray)")
            
            
            // print("Current items IMAGE URL =\(TotalItemsArray)")
            
            
            
            if self.SavedItemsInventory.count > 0 {
                //  GroupInfoLBL.hidden = true
            } else {
                //  GroupInfoLBL.hidden = false
            }
            
            */
            
            
        } catch {
            print(error)
        }
        
        
        return (TraitNameOld, TraitDescOld, Image64Data)
        
    }
    
    
    
    
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
    
    @IBAction func reportContent(_ sender: Any) {
        let theAlert = SCLAlertView()
        
        theAlert.addButton("Yes") {
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Content Reported", subTitle: "Thanks for reporting this, we will review.", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
        }
        
        theAlert.addButton("No") {
            
            //OkToCreate = false
        }
        
        theAlert.showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Report Content", subTitle: "Are you sure you want to report this content as inappropriate?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
    }
    // MARK: - Help methods
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9759787683845878/9895698149")
        
        PlayedAd = true
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentTraits" {
            let viewController = segue.destination as! CurrentGameTraitsViewController
            
            //viewController.Traits = leveldata
            viewController.TraitsUsed = TraitsUsed
            //viewController.GameType = gameType
            
            
            // let Traits = trait_ids
        }
        
        if segue.identifier == "GroupGameTraits" {
            let viewController = segue.destination as! GroupGameTraitsViewController
            
            //viewController.Traits = leveldata
            viewController.GroupGameTraits = GroupGameTraits
            viewController.TraitsUsed = TraitsUsed
            viewController.TotalTraits = Traits
            viewController.GroupGameMaxRounds = GroupGameMaxRounds
            viewController.ResumeGroupGame =  ResumeGroupGame
            viewController.NumberPlayersArray = NumberPlayersArray
            viewController.StartingTraits = StartingTraits
            //viewController.GameType = gameType
            
            
            // let Traits = trait_ids
        }
        
        
        
        
    }
    
    @IBAction func CurrentGameTraits(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CurrentTraits", sender: self)
        
    }
    
    
    
    /*
    func CreateImageData(ImageURLData: NSData) -> [NSString] {
    
    // var ImageData = [NSString]()
    
    
    //    var json = NSJSONSerialization.JSONObjectWithData(urlData, options: nil, error: nil) as! NSDictionary
    
    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(ImageURLData, options:NSJSONReadingOptions.MutableContainers , error: nil) as! NSDictionary
    
    var json = JSON(ImageURLData)
    
    for result in json["Data"].arrayValue {
    
    var tname = result["TraitName"].stringValue
    var tdesc = result["TraitDesc"].stringValue
    var image64 = result["imageData"].stringValue
    
    //var lat2 = (lat as NSString).doubleValue
    // var long2 = (long as NSString).doubleValue
    // let new_id = ["id": trait_id]
    //cnameArray.append(cname)
    ImageArrayData.append(tname)
    ImageArrayData.append(tdesc)
    ImageArrayData.append(image64)
    }
    
    //return ImageArrayData
    return ImageArrayData
    //  return ( tname, tdesc, image64 )
    
    }
    */
}
