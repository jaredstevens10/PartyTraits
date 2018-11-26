//
//  CreateTraitViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 2/12/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import StoreKit
import CoreData

protocol ImageViewControllerDelegate: class {
    func ImageViewControllerFinished(_ imageviewController: CreateTraitViewController)
}


class CreateTraitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, UITextViewDelegate {
    
    
      let prefs:UserDefaults = UserDefaults.standard
    
     var LocalSavedTraits = [String]()
    var UnSyncedTraits = [String]()
    
    @IBOutlet weak var googleBTN: UIButton!
    
    var TotalTraitsArray = [NSString]()
    
    var SavedItemsInventory = [NSManagedObject]()
    var TotalItems = Int()
    var googleImageData = String()
    //var browseimageviewcontroller: BrowseImageViewController = BrowseImageViewController()
    
    var SelectedGoogleImage = Bool()
    var useGoogleImage = Bool()
    var fromGoogle = Bool()
    var WasPasted = true
    var MediaTypeNew = NSString()
    var gifNSData = Data()
    var MediaType = NSString()
    
    //weak var delegate: CreateTraitViewControllerDelegate?
    
    
    var approvedStatus:String = "no"
    
    let TrialTraitLimit = 4
    
    @IBOutlet weak var addImageLBL: UILabel!
    
    var messageToUser = String()
    var messageToUserArray = ["Ok...Tell me about this personality Traits","This should be good...","Ok...I'm listening...tell me about it.","This better be funny.","Try and be clever.","I hope this is a good idea..."]
    
    var messageToUserImage = String()
    var messageToUserArrayImage = ["You'll need to add a funny picture","Pick something funny","Add an image!","Hurry up and pick a picture"]
    
    
    
    var products = [SKProduct]()
    var product: SKProduct?
    var product_id_ads: NSString?;
    
    var productsArray = Array<SKProduct>()
    
     let productIdentifiers = Set(["com.JaredStevens.PartyTraits.CreateTraits"])


   // let prefs:UserDefaults = UserDefaults.standard
    
    var leveldata = NSString()
    @IBOutlet weak var segmentControl: ADVSegmentedControl!
    //var DifDropData: [String] = ["Easy", "Medium", "Hard"]
    
    
    let picker = UIImagePickerController()
    var ProfileImageFinal = String()
    var TraitPictureAdded = Bool()
    
    var base64Image = String()
    
    @IBOutlet weak var traitTitle: UITextField!
    @IBOutlet weak var traitDESC: UITextView!
    
    @IBOutlet weak var cameraBTN: UIButton!
    
    @IBOutlet weak var photosBTN: UIButton!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var createTraitVIEW: UIView!
    
    
    @IBAction func browseGoogle(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "browseimage", sender: self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if prefs.bool(forKey: "UserHasAdminAcces"){
            
            approvedStatus = "yes"
            print("User has admin access")
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(messageToUserArray.count)))
        let randomIndexImage = Int(arc4random_uniform(UInt32(messageToUserArrayImage.count)))
        
        messageToUser = messageToUserArray[randomIndex]
        

        messageToUserImage = messageToUserArrayImage[randomIndexImage]
        
        self.leveldata = "Medium"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTraitViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addImageLBL.text = messageToUserImage
            
        traitDESC.text = messageToUser
        traitDESC.textColor = UIColor.lightGray
        traitDESC.textAlignment = .center
        traitDESC.delegate = self
        
        picker.delegate = self
        self.createTraitVIEW.layer.cornerRadius = 30
        self.createTraitVIEW.layer.masksToBounds = true
        self.createTraitVIEW.clipsToBounds = true
        
        
        segmentControl.items = ["Easy", "Medium", "Hard"]
        segmentControl.font = UIFont(name: "Noteworthy", size: 12)
        segmentControl.borderColor = UIColor(white: 1.0, alpha: 0.3)
        segmentControl.selectedIndex = 1
        segmentControl.thumbColor = UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0)
        segmentControl.selectedLabelColor = UIColor.white
        segmentControl.addTarget(self, action: #selector(CreateTraitViewController.segmentValueChanged(_:)), for: .valueChanged)
        
        ProfileImage.layer.cornerRadius = 5
        ProfileImage.clipsToBounds = true
        ProfileImage.layer.masksToBounds = true
        ProfileImage.layer.borderWidth = 1
        ProfileImage.layer.borderColor = UIColor.white.cgColor
        
        googleBTN.layer.cornerRadius = 25
        googleBTN.clipsToBounds = true
        googleBTN.layer.masksToBounds = true
        
        photosBTN.layer.cornerRadius = 25
        photosBTN.clipsToBounds = true
        photosBTN.layer.masksToBounds = true
        
        traitTitle.becomeFirstResponder()
  
        SKPaymentQueue.default().add(self)
        
       // requestProductData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTraitViewController.googleImage(_:)), name: NSNotification.Name(rawValue: "googleImage"),  object: nil)
        
        // browseimageviewcontroller.browseimagedelegate=self
        
        // Do any additional setup after loading the view.
    }
    
    
    func googleImage(_ notification:Notification) {
        
        let data = (notification as NSNotification).userInfo
        let googleImageData2 = data!["data"] as! Data
        
        self.prefs.setValue("image", forKey: "PICTUREDATA_MEDIATYPE")
        
        useGoogleImage = true
        
        
        fromGoogle = true
        WasPasted = false
        self.addImageLBL.isHidden = true
        
        
        let imageGoogle = UIImage(data: googleImageData2)
        //  tempImageView.image = image
        ProfileImage.image = imageGoogle
        
        self.MediaTypeNew = "image"
        self.prefs.setValue(self.MediaTypeNew, forKey: "PICTUREDATA_MEDIATYPE")
        
        
        
        let DeviceH = self.view.frame.height
        //let halfH = DeviceH / 2;
        let DeviceW = self.view.frame.width
       
        
        self.prefs.setValue("", forKey: "GOOGLEDATAD")
        
        
        
        
    }
    
    func tapTextView(sender:UITapGestureRecognizer) {
        print("tapped term – but blocking the tap for textView :-/")
        
        traitDESC.text = ""
        traitDESC.textColor = UIColor.black
        traitDESC.textAlignment = .left
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if traitDESC.text == messageToUser {
            
            traitDESC.text = ""
            traitDESC.textColor = UIColor.black
            traitDESC.textAlignment = .left
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if traitDESC.text == "" {
            
            traitDESC.text = messageToUser
            traitDESC.textAlignment = .center
            
        }
        
    }
    
    
  


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentValueChanged(_ sender: AnyObject?){
        
        if segmentControl.selectedIndex == 0 {
            leveldata = "Easy"
            // })
            //salesValue.text = "$23,399"
            
            DispatchQueue.main.async(execute: {
                
            })
            
            //filterContentForSearchText("", scope: "All")
            
        } else if segmentControl.selectedIndex == 1{
            leveldata = "Medium"
            //  })
            DispatchQueue.main.async(execute: {
                
            })
            //filterContentForSearchText("", scope: "Complete")
            //salesValue.text = "$81,295"
        } else {
            leveldata = "Hard"
            
            DispatchQueue.main.async(execute: {
                
            })
            //   })
            // filterContentForSearchText("", scope: "In Process")
            //salesValue.text = "$199,392"
        }
    }

    
    
    @IBAction func closeBTN(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func DismissKeyboard(){
        
        view.endEditing(true)
    }
    
    @IBAction func photoFromLibary(_ sender: AnyObject) {
        
        print("photo from library")
        self.picker.allowsEditing = false //2
        self.picker.sourceType = .photoLibrary //3
        self.picker.modalPresentationStyle = .popover
        self.present(self.picker, animated: true, completion: nil)//4
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
       // ShowingProfileView = true
        
        ProfileImage.contentMode = .scaleAspectFit //3
        // myImageView.image = chosenImage
        ProfileImage.image = chosenImage//4
        addImageLBL.isHidden = true
        TraitPictureAdded = true
        
        //  (StartSegment.subviews[0] ).tintColor = UIColor(red: 0.4, green: 1, blue: 0.69, alpha: 1.0)
        
       // print("Picture add = \(ProfilePictureAdded)")
        
        
        print("image picked")
        /*
        if UserFirstName.isEqualToString("") || UserLastName.isEqualToString("") {
            
            ProfileLoadLBL.text = "Waiting for input..."
            
        } else {
            
            ProfileLoadLBL.text = "Tap 'Submit' to continue"
        }
        */
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
      //  ShowingProfileView = true
        
        
        
        dismiss(animated: true, completion: nil)
        print("image picker cancelled")
        
        
        
        
    }
    
    @IBAction func shootPhoto(_ sender: AnyObject)  {
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
            // mainImageView.image =
            
          //  self.ShootingPhoto = true
         //   self.ShowingProfileView = true
        } else {
            noCamera()
        }
        
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    
    
    func UploadTraitData (_ traitName: String, traitDescription: String, FileName: String, Type: String, imageData2: String) {
        
        
        //let traitDescriptionNew = traitDescription.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
       // let traitNameNew = traitName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        
        
        print("Trait Encoded Description = \(traitDescription)")
        print("Trait Encoded Name = \(traitName)")
        
        
        
        let WasTraitAdded = UploadGameFileData(imageData2, FileName: FileName, Type: Type, traitName: traitName, traitDescription: traitDescription, difLevel: self.leveldata as String, approvedStatus: "\(self.approvedStatus)")
        
        
       
        
        
        
    DispatchQueue.main.async(execute: {
        
        
    print("Was Trait Added2 = \(WasTraitAdded)")
        
        
        if WasTraitAdded {
            self.traitDESC.text = ""
            self.traitTitle.text = ""
            self.ProfileImage.image = nil
            
            
             SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0), title: "New Trait Added", subTitle: "Your Trait was successfully added!", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
             self.RetrieveTraits()
            
            
            
            DispatchQueue.main.async(execute: {
                print("updating traits")
                
                //let UpdatedTraits = false
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
                        
                        let URLDataItems = RefreshTraitInventory(username as NSString, UnsyncedTraits: self.UnSyncedTraits)
                        
                        
                        TraitInventoryInfo = self.FilterTraitData(URLDataItems)
                        
                        // var name = prefs.valueForKey("USERNAME") as! NSString as String
                        
                        //  self.usernameLabel.text = "Welcome Back \(name)"
                        
                        
                        
                        
                      //  DispatchQueue.main.async(execute: {
                            // print("Item Inventory Info = \(self.ItemInventoryInfo)")
                            
                            
                            
                            
                            
                            
                            backgroundThread(background: {
                                
                                
                                
                                let URLDataItems = RefreshTraitInventory(username as NSString, UnsyncedTraits: self.UnSyncedTraits)
                                
                                
                                TraitInventoryInfo = self.FilterTraitData(URLDataItems)
                                

                                
                                
                                //self.GetPublicTurns()
                                //  print("BACKGROUND THREAD - Updating Users' location")
                                
                                //     print("Saving Images now")
                                
                                for items in TraitInventoryInfo {
                                    
                                    //   print("Saving \(items.name)")
                                    
                                    // let theImageURL = "\(self.ServerURL)\(items.imageURL).png"
                                    // let theImageURL100 = "\(self.ServerURL)\(items.imageURL100).png"
                                    
                                    // SaveFile(theImageURL, name: "/\(items.imageURL).png")
                                    
                                    let TraitImageName = "\(items.traitname)_\(items.traitid)"
                                    
                                    
                                    SaveFileNSData(items.traitimagedata, name: "/\(TraitImageName).png")
                                    
                                    /*
                                     if items.imageURL100 != "" {
                                     SaveFile(theImageURL100, name: "/\(items.imageURL100).png")
                                     }
                                     */
                                }
                                
                                //self.LoadProgressView.setProgress(0.7, animated: true)
                                
                                
                            }, completion: {
                                
                                
                                self.prefs.set(true, forKey: "TRAITSUPDATED")
                                
                                DispatchQueue.main.async(execute: {
                                    
                                   // self.LoadProgressView.setProgress(1.0, animated: true)
                                    
                                    print("FINISHED UPDATING ALL THE TRAITS")
                                    
                                 
                                        self.dismiss(animated: true, completion: nil)
                                        
                                  
                                    
                                    //self.GetMyHUD.removeFromSuperview()
                                    //  self.tableView.reloadData()
                                    // print("DISPATCH ASYNC - Finished Updating the users' location")
                                })
                                // print("Done Getting Steal Turns")
                                //   self.kolodaView.resetCurrentCardNumber()
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
            
            
            
            
            
            
            
            
            //self.dismiss(animated: true, completion: nil)
            
            
        } else {
            print("There was an error creating new trait")
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Eror", subTitle: "There was an error adding your Trait. Try again", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
        }
        
    })
    
        
    }
    
    func RetrieveTraits() {
        
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
                //SavedServerTraits += 1
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
    
    
    func CreateNewTrait() -> Bool {
        var traitName = NSString()
        var traitDescription = NSString()
        
        var ProfileToken = Data()
        
        var UpdatedPro = Bool()
        
       // ProfileToken  = prefs.valueForKey("deviceToken") as! NSData
        // print("deviceToken not nil")
     //   print("token = \(token)")
        
        
        // let Token = ProfileToken
        let TokenNew2 = ProfileToken.description.replacingOccurrences(of: "<", with: "")
        let TokenNew3 = TokenNew2.replacingOccurrences(of: ">", with: "")
        let TokenNew = TokenNew3.replacingOccurrences(of: " ", with: "")
        
        /*
        if (prefs.valueForKey("USERNAME") != nil)
        {
            ProfileUsername = self.prefs.valueForKey("USERNAME") as! NSString as String
            ProfileUserID = self.prefs.valueForKey("PLAYERID") as! NSString as String            //   myID = prefs.valueForKey("PLAYERID") as! NSString as String
            print("Myid = \(ProfileUserID)")
            print("username not nil")
        }
        
        */
        
        var email = "test123@clavensolutions.com"
        var privacy = "no"
        var password = "NA"
        
        var post_old = "traitName=\(traitName))&traitDescription=\(traitDescription)"
        
        print("POST OLD DATA = \(post_old)")
        
        
        
        var post = post_old.addingPercentEscapes(using: String.Encoding.utf8)!
        
        
        
        post = ("\(post)&ImageData=\(ProfileImageFinal)")
        
        
        // progressHUD.removeFromSuperview()
        //  progressHUD = ProgressHUD(text: "Saving Game Data...")
        //  self.view.addSubview(progressHUD)
        
        
        print("NEW POST STRING: \(post)")
        
        
        /*
        &Player1Cell=\(Player1Cell)&Player2Cell=\(Player2Cell)&Player3Cell=\(Player3Cell)&Player4Cell=\(Player4Cell)&Player5Cell=\(Player5Cell)&Player6Cell=\(Player6Cell)&Player7Cell=\(Player7Cell)&Player8Cell=\(Player8Cell)&Player9Cell=\(Player9Cell)&Player10Cell=\(Player10Cell)
        */
       //NSLog("PostData: %@",post);
        
        let url:URL = URL(string: "http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/CreateNewTrait.php")!
        
        let postData:Data = post.data(using: String.Encoding.ascii)!
        
        // var postData:NSData = post.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let postLength:NSString = String( postData.count ) as NSString
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var reponseError: NSError?
        var response: URLResponse?
        
        var urlData: Data?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        if ( urlData != nil ) {
            let res = response as! HTTPURLResponse!;
            
           //NSL//NSLog("Response code: %ld", res?.statusCode);
           
            if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                
               //NSLog("Response ==> %@", responseData);
                
                //var error: NSError?
                
                let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                
                
                let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                
                //[jsonData[@"success"] integerValue];
                
               //NSLog("Success: %ld", success);
                
                if(success == 1)
                {
                    UpdatedPro = true
                    
                    var NewTraitImage = UIImage()
                    NewTraitImage = UIImage(named: "PartyTraitsLogoCircle.png")!
                    var NewTraitID = "TEST"
                    
                    UploadTraitFile(NewTraitImage, FileName: "Trait\(NewTraitID)1", Type: "jpg")
                    
                   //NSLog("New Game SUCCESS");
                    //self.dismissViewControllerAnimated(true, completion: nil)
                    
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Success!"
                    alertView.message = "User Profile Updated."
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    // alertView.show()
                    
                    
                    
                    //  self.performSegueWithIdentifier("Turn_Complete", sender: self)
                    
                    //NEED TO ADD NSNotification to go back to Home
                    
                    
                } else if (success == 5){
                    
                    UpdatedPro = true
                    
                } else {
                    UpdatedPro = false
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    //  alertView.show()
                    print("error message = \(error_msg)")
                    
                }
                
            } else {
                UpdatedPro = false
                
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                //   alertView.show()
            }
        }  else {
            UpdatedPro = false
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            //  alertView.show()
        }
        // }
        
        return UpdatedPro
        
    }
    
    @IBAction func CreateTraitBTN(_ sender: AnyObject) {
        
        let ttitle: NSString = traitTitle.text! as NSString
        let tdesc: NSString = traitDESC.text! as NSString
        
        var OkToCreate = Bool()
        
        
        let CreateTraitPurchased = prefs.bool(forKey: "CreateTraitsPurchased")
        let UserIsAdmin = prefs.bool(forKey: "UserHasAdminAcces")
        
        if UserIsAdmin {
            OkToCreate = true
        } else {
        
        if !CreateTraitPurchased {
            
            var CreateTraitCount = prefs.integer(forKey: "CreateTraitsCount")
            
            
            print("MY CURRENT TRIAL CREATE TRAIT COUNT = \(CreateTraitCount)")
            
            if CreateTraitCount < TrialTraitLimit {
                
                OkToCreate = true
                
                CreateTraitCount += 1
                prefs.set(CreateTraitCount, forKey: "CreateTraitsCount")
                
            } else {
                
                
              
                
                
                let theAlert = SCLAlertView()
                
                theAlert.addButton("Yes") {
                    
                    self.requestProductData()
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.buyProduct()
                        
                    })
                 
                }
                
                theAlert.addButton("No Thanks") {
                    
                   OkToCreate = false
                }
                
                self.DismissKeyboard()
                
                theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Create Trait", subTitle: "Uh oh, looks like you've already met your limit...but you can create all the traits you want for only $0.99", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
                
 
            }
            
        } else {
            OkToCreate = true
        }
            
        }
        
        if OkToCreate {
        
        
        if ttitle.isEqual(to: "") || tdesc.isEqual(to: "") {
            
             print("no trait title or description")
            
            SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Add Title", subTitle: "Please add a Trait Title and Description", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            
        } else {
        
        if TraitPictureAdded {
            
            let image = ProfileImage.image!
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            base64Image = imageData!.base64EncodedString(options: [])
            
            
            let theAlert = SCLAlertView()
            
            theAlert.addButton("Yes") {
               // self.view.addSubview(self.SaveProgressHUD)
                
                /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                 */
                
               if Reachability.isConnectedToNetwork() {
                
                
                DispatchQueue.main.async(execute: {
                    
                    
                   self.UploadTraitData(ttitle as String, traitDescription: tdesc as String, FileName: "NewTraitID", Type: "image", imageData2: self.base64Image as String)
                    //self.ActInd.stopAnimating()
                    //  });
                })
                
                
            } else {
                
                SCLAlertView().showCustomOK(UIImage(named: "PartyFoulCircle.png")!, color: UIColor(red: 0.74901961, green: 0.11764706, blue: 0.18039216, alpha: 1.0), title: "Oops, Network Error", subTitle: "Please Confirm Your Network Settings", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
                
            }
            
            
            }
            
            theAlert.addButton("No, just for me") {
                
                 DispatchQueue.main.async(execute: {
                    
                    
                    var LocalTraitNextID = String()
                    var LocalTraitNextIDint = Int()
                    var NewLocalTraitNextID = String()
                    var NewLocalTraitNextIDint = Int()
                    
                    if self.prefs.value(forKey: "LocalTraitsNextID") == nil {
                        LocalTraitNextID = "1000000"
                        LocalTraitNextIDint = 1000000
                        NewLocalTraitNextIDint = 1000001
                        NewLocalTraitNextID = NewLocalTraitNextIDint.description
                    } else {
                        LocalTraitNextID = self.prefs.value(forKey: "LocalTraitsNextID") as! String
                        LocalTraitNextIDint = Int(LocalTraitNextID)!
                        NewLocalTraitNextIDint = LocalTraitNextIDint + 1
                        NewLocalTraitNextID = NewLocalTraitNextIDint.description
                    }
                    
                    
                    //let encodedTitle = ttitle.dataUsingEncoding(NSUTF8StringEncoding.rawValue)
                    
                    let plainData = (ttitle as NSString).data(using: String.Encoding.utf8.rawValue)!
                    let encodedTitle = plainData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    //base64EncodedStringWithOptions(NSData.Base64EncodingOptions.fromRaw(0)!)
                    
                    let encodedImageURL = "\(encodedTitle)_\(NewLocalTraitNextID)"
                    
                    
                    let DidSave = SaveNewItem(encodedTitle as NSString, imageurltemp: encodedImageURL, leveltemp: self.leveldata as String, idtemp: NewLocalTraitNextID, imagedatatemp: self.base64Image, descriptiontemp: tdesc, localTrait: true)
                    
                    
                    
                    if DidSave {
                    
                    SaveFileNSData(self.base64Image, name: "/\(encodedImageURL).png")
                    

                    self.traitDESC.text = ""
                    self.traitTitle.text = ""
                    self.ProfileImage.image = nil
                    
                    
                    SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0), title: "New Trait Added", subTitle: "Your Trait was successfully added!", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Eror", subTitle: "There was an error adding your Trait. Try again", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                })
                
                
            }
            // theAlert.showCustomOK(UIImage(named: "SadPixie.png")!, color: UIColor(red: 0.0, green: 0.65098, blue: 0.317647, alpha: 1.0), title: "Submit", subTitle: "Are you sure you want to submit this \(QorA)?")
            
            theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Create Trait", subTitle: "Would you like to submit this trait for everyone to use?", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
            

            
            
        } else {
            
              SCLAlertView().showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.9647, green: 0.34117, blue: 0.42745, alpha: 1.0), title: "Image?", subTitle: "Please add a Trait Image", duration: nil, completeText: "Ok", style: .custom, colorStyle: 1, colorTextButton: 1)
            
            print("no trait image added")
        }
     
        }
        
    }
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
        
        if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits"
            
            /* if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.AllTraits" || transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.RemoveAds"
 */
        {
            print("Non-Consumable Product Purchased")
            
            if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits" {
                
                prefs.set(true, forKey: "CreateTraitsPurchased")
                
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
            
            if transaction.payment.productIdentifier == "com.JaredStevens.PartyTraits.CreateTraits"
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
