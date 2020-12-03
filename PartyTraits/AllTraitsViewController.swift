//
//  AllTraitsViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 12/9/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData


class AllTraitsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
  
    
    @IBOutlet var actInd: UIActivityIndicatorView!
    var isAdmin = Bool()
    
    let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

    let prefs:UserDefaults = UserDefaults.standard
    let username: NSString = "guest"
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    //let images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images")
    
    var TotalItems = Int()
    var SavedItemsInventory = [NSManagedObject]()
    
     var myData: Array<AnyObject> = []
    
   // var TotalTraitsInventoryArray = [TraitInventory]()
    var TotalTraitsInventoryArrayAdmin = [TraitInventoryAdmin]()
    
    var TotalTraitsInventoryArray = [TraitInventoryLimitedHidden]()
    
    let images = [String]()
    
    let reuseIdentifier = "Cell"
    
    var IsJared = Bool()
    
    var AllTraitsPurchased = Bool()
    
    
    func RetrieveTraitsAdmin() {
        
        //LocalSavedTraits.removeAll()
        
        
        
        var SavedServerTraits = 0
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let managedContextGroups = appDelegate.managedObjectContext
        let fetchGroups = NSFetchRequest<NSFetchRequestResult>(entityName: "TraitInfo")
        let errorGroups: NSError?
        
        //self.LoadProgressView.setProgress(0.1, animated: true)
        
        do {
            let fetchedResultsGroups =  try managedContextGroups!.fetch(fetchGroups) as? [NSManagedObject]
            
            if let resultsGroups = fetchedResultsGroups {
                SavedItemsInventory = resultsGroups
                //  print("Saved items = \(SavedItemsInventory)")
            } else {
                //   print("Could not fetch\(errorGroups), \(errorGroups!.userInfo)")
            }
            
            for items in SavedItemsInventory as [NSManagedObject] {
               // TotalItems += 1
                // ItemsInventoryArray.append(CurNumGroups)
                
                let traitname = items.value(forKey: "traitname") as! String
                let traitlevel = items.value(forKey: "traitlevel") as! String
                let imageURL = items.value(forKey: "imageURL") as! String
                let traitid = items.value(forKey: "traitid") as! String
                let traitimagedata = items.value(forKey: "traitimagedata") as! String
                let traitdescription = items.value(forKey: "traitdescription") as! String
                let localTrait = items.value(forKey: "localTrait") as! Bool
                let approvedStatus = "yes"
                
                
                //TotalTraitsArray.append(ItemNameURL as NSString)
                
                self.TotalTraitsInventoryArrayAdmin.append(TraitInventoryAdmin(traitname: traitname as NSString, imageURL: imageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: false, approvedStatus: approvedStatus))
                
               // SavedServerTraits += 1
               // LocalSavedTraits.append(TraitID)
                
            }
            
            //print("Local saved traits: \(LocalSavedTraits)")
            
            
            //  print("Current items IMAGE URL =\(TotalItemsArray)")
            //prefs.set(SavedServerTraits, forKey: "SavedServerTraits")
            //print("Saved Server Traits: \(SavedServerTraits)")
            
//            if self.SavedItemsInventory.count > 0 {
//                //  GroupInfoLBL.hidden = true
//            } else {
//                //  GroupInfoLBL.hidden = false
//            }
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    override func viewDidLoad() {
        
        self.actInd.isHidden = false
        
        AllTraitsPurchased = prefs.bool(forKey: "AllTraitsPurchased")
        
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        IsJared = prefs.bool(forKey: "isJaredAdmin")
        
        
        if IsJared {
           
            isAdmin = true
            
           // LoadTraitsAsAdmin()
            
            // downloads all data from database - takes a long time
            //let URLDataItems = RefreshTraitInventoryAdmin(self.username)
            //self.TotalTraitsInventoryArrayAdmin = self.FilterTraitDataAdmin(URLDataItems)
            
            RetrieveTraitsAdmin()
            
            
            
            
        } else {
        
        TotalTraitsInventoryArray = RetrieveLocalTraitInfo()
            
        }
 
        
        
        
      //  let URLDataItems = RefreshTraitInventory(self.username)
        
        
       // self.TotalTraitsInventoryArray = self.FilterTraitData(URLDataItems)
        
       
        // Register cell classes
       // self.CollectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
       // self.CollectionView.register(UICollectionViewCell.self, forCellReuseIdentifier: "cell")
        
       // self.CollectionView.register(
        self.CollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
       // let imageView = UIImageView(image: UIImage(named: "bg-dark.jpg"))
       // imageView.contentMode = UIViewContentMode.scaleAspectFill
      //  CollectionView!.backgroundView = imageView
    }
    
   // override func c
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        /*
        if isAdmin {
            

                let URLDataItems = RefreshTraitInventoryAdmin(self.username)
                
                self.TotalTraitsInventoryArrayAdmin = self.FilterTraitDataAdmin(URLDataItems)
            
        }
        */
        
        /*
        if IsJared {
            
            isAdmin = true
            
            // LoadTraitsAsAdmin()
            
            let URLDataItems = RefreshTraitInventoryAdmin(self.username)
            
            self.TotalTraitsInventoryArrayAdmin = self.FilterTraitDataAdmin(URLDataItems)
            
            
            
        } else {
            
            TotalTraitsInventoryArray = RetrieveLocalTraitInfo()
            
        }
        */
        
        
        
         DispatchQueue.main.async(execute: {
            
          self.actInd.isHidden = true
            
          self.CollectionView.reloadData()
            
        })
        
    }
    
    
    
    func RetrieveLocalTraitInfo() -> [TraitInventoryLimitedHidden] {
        
        
        let AllTraitsPurchased = self.prefs.bool(forKey: "AllTraitsPurchased")
        
        
        var TotalTraitsInventoryArrayTemp = [TraitInventoryLimitedHidden]()
        
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
                
                let traitIDNum = Int(traitid)!
                
                // if (traitlevel == "\(theDifLevel)") && (itemOrder != "0") {
                
                myData.append(items)
                
                var isHidden = Bool()
                
                
                if AllTraitsPurchased {
                    
                    isHidden = false
                    
                } else {
                
                if localTrait {
                    
                    isHidden = false
                    
                } else {
                    
                    
                    if traitIDNum > 10 {
                        
                        isHidden = false
                        
                    } else {
                        
                        isHidden = true
                        
                    }
                    
                    
                }
                    
                }
                //self.images.append(traitImageURL)
                
              //  if localTrait {
                    
                    //myData.append(items)
                    
                TotalTraitsInventoryArrayTemp.append(TraitInventoryLimitedHidden(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait, index: localIndex, Hidden: isHidden))
                
                    trait_ids_temp.append((traitid as NSString).doubleValue)
                    
                    
              //  }
                
                localIndex += 1
            }
            
            //    print("TotalItemsInventoryArray - PreSorted - \(TotalItemsInventoryArray)")
            
            
            
            /*
             TotalTraitsInventoryArrayTemp.sort { (lhs: TraitInventorySorted, rhs: TraitInventorySorted) -> Bool in
             // you can have additional code here
             return lhs.traitid < rhs.traitid
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
        
        return TotalTraitsInventoryArrayTemp
    }
    
    
func reversePhotoArray(photoArray:[TraitInventoryLimitedHidden], startIndex:Int, endIndex:Int){
    
    if startIndex >= endIndex{ return }
    
    swap(&TotalTraitsInventoryArray[startIndex], &TotalTraitsInventoryArray[endIndex])
    
    reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex:startIndex + 1, endIndex: endIndex - 1)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        if isAdmin {
            return TotalTraitsInventoryArrayAdmin.count
        } else {
        return TotalTraitsInventoryArray.count
        }
    }
    
    
    
    @objc func UpdateStatusTraitClicked(_ sender: UIButton!) {
        
        //let TempSelectedTrait = TraitInventory()
        
        var TheTrait = TotalTraitsInventoryArrayAdmin[sender.tag]
        
        
        let theAlert = SCLAlertView()
        theAlert.addButton("Approved") {
            
            let TraitRowSelected = sender.tag
            print("the comment rowselected: \(sender.tag)")
            print("Should View Trait: \(TheTrait.traitname)")
          
            
            let TraitID = TheTrait.traitid as NSString
            
           // let TraitNameOld = TheTrait.traitname
            
           // let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            //let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
            
            
            //let imageURLname = TheTrait.imageURL
            
           // print("Trait click, imageURL: \(imageURLname)")
            
          
            
         //   DispatchQueue.main.async(execute: {
                
                
                let TraitUpdated = UpdateTraitStatus(TraitID, approvedStatus: "yes")
            
             DispatchQueue.main.async(execute: {
                
                
                let URLDataItems = RefreshTraitInventoryAdmin(self.username)
                
                self.TotalTraitsInventoryArrayAdmin = self.FilterTraitDataAdmin(URLDataItems)
                
                print("Trait Updated = \(TraitUpdated)")
                
                
                DispatchQueue.main.async(execute: {
                    
                    self.CollectionView.reloadData()
                    
                })
                
                
            })
            
            
        }
        
        theAlert.addButton("Unapproved") {
            
            let TraitRowSelected = sender.tag
            print("the comment rowselected: \(sender.tag)")
            print("Should View Trait: \(TheTrait.traitname)")
            
            
            let TraitID = TheTrait.traitid as NSString
            
            // let TraitNameOld = TheTrait.traitname
            
            // let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            //let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
            
            
            //let imageURLname = TheTrait.imageURL
            
            // print("Trait click, imageURL: \(imageURLname)")
            
            
            
         //   DispatchQueue.main.async(execute: {
                
                
                let TraitUpdated = UpdateTraitStatus(TraitID, approvedStatus: "no")
            
            
             DispatchQueue.main.async(execute: {
                
            let URLDataItems = RefreshTraitInventoryAdmin(self.username)
            
            self.TotalTraitsInventoryArrayAdmin = self.FilterTraitDataAdmin(URLDataItems)
                
                print("Trait Updated = \(TraitUpdated)")
            
            DispatchQueue.main.async(execute: {
                
                self.CollectionView.reloadData()
                
            })
                
                
            })
            
        }
        
        theAlert.addButton("Cancel") {
            
           
            print("Cancel pushed")
        }
        
        // theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "View Trait Info?", subTitle: "Are you sure you want to view this player's assigned trait?")
        
        theAlert.showCustomOK(UIImage(named: "PartyTraitsLogoCircle.png")!, color: UIColor(red: 0.14901961, green: 0.6, blue: 1.0, alpha: 1.0), title: "Update Trait Status", subTitle: "Set Trait Approved Status", duration: nil, completeText: "", style: .custom, colorStyle: 1, colorTextButton: 1)
        
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CircularCollectionViewCell
        
        
        if isAdmin {
            
            let TheTrait = TotalTraitsInventoryArrayAdmin[indexPath.row]
            //cell.Turn1ImageBack.hidden = true
            // cell.Turn1Image?.hidden = true
            //  cell.Turn1Image?.contentMode = UIViewContentMode.scaleAspectFit
            let TraitNameOld = TheTrait.traitname
            
           
            
            let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            
            let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
            
             print("Trait Name: \(TraitNameFinal)")
            
            let TraitApprovedStatus = TheTrait.approvedStatus
            
            let imageURLname = TheTrait.imageURL
            
           // let theTraitLevel = TheTrait.traitlevel
            
            let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(imageURLname).png")
            print("url for image = \(url)")
            let theImageData = try? Data(contentsOf: url)
            
            //TestImage = UIImage(data:theImageData!)!
            
            var image = UIImage()
            
            
            if TheTrait.traitid == "2" {
                
        
                let testURL = "http://97.102.21.254/Apps/PartyTraits/GetTraitImage.php?id=2"
            
                let request = URLRequest(url: URL(string: testURL)!)
                let mainQueue = OperationQueue.main
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        
                        
                        
                        
                        image = UIImage(data: data!)!
                        
                        /*
                        
                        
                        // Convert the downloaded data in to a UIImage object
                        var imageTemp = UIImage(data: data!)
                        
                        
                        print("DATA: \(data)")
                        
                        // Store the imge in to our cache
                        //  self.imageCache[urlString] = image
                        // Update the cell
                        DispatchQueue.main.async(execute: {
                            //if let cellToUpdate = TableView.cellForItemAtIndexPath(indexPath) {
                            //if let cellToUpdate = TableView.cel
                            
                            
                            if self.CollectionView.cellForItem(at: indexPath) != nil {
                                
                               
                                    image = imageTemp!
                                    
                            }
                        })
                        */
                        
                    }
                    
                })
                

                
                
                
                
            } else {
            
            if theImageData != nil {
            
            image  = UIImage(data: theImageData!)!
            
            }
                
            }
            /*
             
             cell.titleLBL.text = TraitNameFinal as String
             cell.traitImageView.image = image as UIImage
             cell.descLBL.text = TheTrait.traitdescription as String
             cell.levelLBL.text = TheTrait.traitlevel as String
             
             */
            
            cell.updateTraitStatusBTN.isHidden = false
            cell.approvedStatusLBL.isHidden = false
            cell.updateTraitStatusBTN.tag = (indexPath as NSIndexPath).row
            
            cell.updateTraitStatusBTN?.addTarget(self, action: #selector(AllTraitsViewController.UpdateStatusTraitClicked(_:)), for: .touchUpInside)
            
            cell.approvedStatusLBL.text = "\(TraitApprovedStatus)"
            
            cell.traitLevel.isHidden = false
            cell.traitLevel.text = TheTrait.traitlevel as String
            
            if TraitApprovedStatus == "yes" {
            cell.approvedStatusLBL.textColor = UIColor.green
            } else {
            cell.approvedStatusLBL.textColor = UIColor.red
            }
            
            cell.imageView?.image = image
            cell.traitLBL.text = TraitNameFinal as String
            cell.traitDesc.text = TheTrait.traitdescription as String
            
            return cell
            
        
        } else {
       
        
        
         let TheTrait = TotalTraitsInventoryArray[indexPath.row]
         //cell.Turn1ImageBack.hidden = true
         // cell.Turn1Image?.hidden = true
         //  cell.Turn1Image?.contentMode = UIViewContentMode.scaleAspectFit
         let TraitNameOld = TheTrait.traitname
         
         let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
         
         let TraitNameFinal = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
         
         
         
         let imageURLname = TheTrait.imageURL
         
         let url = URL(fileURLWithPath: dirpath).appendingPathComponent("\(imageURLname).png")
         print("url for image = \(url)")
         let theImageData = try? Data(contentsOf: url)
         
         //TestImage = UIImage(data:theImageData!)!
         
            
            
            
            var image = UIImage()
            
            
            
            if TheTrait.traitid == "2" {
                
                
                let testURL = "http://97.102.21.254/Apps/PartyTraits/GetTraitImage.php?id=2"
                
                let request = URLRequest(url: URL(string: testURL)!)
                let mainQueue = OperationQueue.main
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        var imageTemp = UIImage(data: data!)
                        // Store the imge in to our cache
                        //  self.imageCache[urlString] = image
                        // Update the cell
                        DispatchQueue.main.async(execute: {
                            //if let cellToUpdate = TableView.cellForItemAtIndexPath(indexPath) {
                            //if let cellToUpdate = TableView.cel
                            if self.CollectionView.cellForItem(at: indexPath) != nil {
                                
                                
                                image = imageTemp!
                                
                            }
                        })
                        
                    }
                    
                })
                
                
                
                
                
                
            } else {
            
            
            
          image  = UIImage(data: theImageData!)!
 
            }
        /*
         
         cell.titleLBL.text = TraitNameFinal as String
         cell.traitImageView.image = image as UIImage
         cell.descLBL.text = TheTrait.traitdescription as String
         cell.levelLBL.text = TheTrait.traitlevel as String

 */
        
            cell.updateTraitStatusBTN.isHidden = true
            cell.approvedStatusLBL.isHidden = true
            cell.approvedStatusLBL.text = "no"
            cell.traitLevel.isHidden = true
        
            /*
            if TheTrait.Hidden {
                cell.imageView?.image = UIImage(named: "PT App2 120.png")
            } else {
            
            }
            */
            
        cell.imageView?.image = image
        cell.traitLBL.text = TraitNameFinal as String
        cell.traitDesc.text = TheTrait.traitdescription as String
        
        return cell
            
        }
    }
    
    @IBAction func BackBTN(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
  
    
    
    
    
    func FilterTraitDataAdmin(_ urlData: Data) -> [TraitInventoryAdmin] {
        print("NEED TO UPDATE ITEM INFO/IMAGES, DOING THAT NOW")
        
        var ItemData = [TraitInventoryAdmin]()
        
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
                    let tempapprovedStatus = result["approvedStatus"].stringValue
                    
                    /*
                     let TraitNameNSData = Data(base64Encoded: TraitNameOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                     let traitname = NSString(data: TraitNameNSData, encoding: String.Encoding.utf8.rawValue)!
                     */
                    
                    let TraitDescNSData = Data(base64Encoded: TraitDescOld as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    
                    let traitdescription = NSString(data: TraitDescNSData, encoding: String.Encoding.utf8.rawValue)!
                    
                    
                    let imageURL = "\(traitname)_\(traitid)"
                    
                    // if uniqueitem == "yes" {
                    
                    // ItemData.append(TraitInventory(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range, imageURL100: imageURL100, itemOrder: itemOrder, viewRange: viewRange, subCategory: subCategory))
                    
                    ItemData.append(TraitInventoryAdmin(traitname: traitname as NSString, imageURL: imageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription, localTrait: false, approvedStatus: tempapprovedStatus))
                    
                    //  }
                    
                    //  if uniqueitem == "yes" {
                    
                    /*
                    
                    if !TotalTraitsArray.contains(imageURL as NSString) {
                        
                        print("ITEMS: Name=\(traitname) id=\(traitid)  has not been saved yet, saving now")
                        
                        //  SaveNewItem(itemname, imageurltemp: imageURL, powertemp: power, rangetemp: range, speedtemp: speed, categorytemp: category, imageurl100temp: imageURL100, itemordertemp: itemOrder, healthtemp: health, staminatemp: stamina, viewRangetemp: viewRange, subCategory: subCategory)
                        
                        //SaveNewItem(traitname as NSString, imageurltemp: imageURL, leveltemp: traitlevel, idtemp: traitid, imagedatatemp: traitimagedata, descriptiontemp: traitdescription,  localTrait: false, approvedStatus:)
                        
                        
                        //  }
                        
                        /*
                         if !TotalImagesArray.contains(imageURL) {
                         print("IMAGES: \(itemname) has not been saved yet, saving now")
                         
                         SaveNewImage(itemname, imageurltemp: imageURL, categorytemp: category)
                         }
                         */
                        
                    }
                    
                    */
                }
            }
            
        }
        
        // print("ItemData from Filter \(ItemData)")
        
        return ItemData
    }
    
    
    
    
}

extension AllTraitsViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

// Calculate where the collection view should be at the right-hand end item let fully
    
    
    let fullyScrolledContentOffset: CGFloat = CollectionView.frame.size.width * CGFloat(TotalTraitsInventoryArray.count - 1)
        
    //    if TotalTraitsInventoryArray.count != 0 {
    
    if (scrollView.contentOffset.x >= fullyScrolledContentOffset) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1. // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        if TotalTraitsInventoryArray.count > 2 {
            
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: 0, endIndex: TotalTraitsInventoryArray.count - 1)
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: 0, endIndex: 1)
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: 2, endIndex: TotalTraitsInventoryArray.count - 1)
            
            var indexPath : NSIndexPath = NSIndexPath(row: 1, section: 0)
            
            CollectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false) } } else if (scrollView.contentOffset.x == 0){
        
        if TotalTraitsInventoryArray.count > 2 {
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: 0, endIndex: TotalTraitsInventoryArray.count - 1)
            
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: 0, endIndex: TotalTraitsInventoryArray.count - 3)
            
            reversePhotoArray(photoArray: TotalTraitsInventoryArray, startIndex: TotalTraitsInventoryArray.count - 2, endIndex: TotalTraitsInventoryArray.count - 1)
            
            var indexPath : NSIndexPath = NSIndexPath(row: TotalTraitsInventoryArray.count - 2, section: 0)
            
            CollectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
        
        }
      }
        
   //  }
    }
}

//- See more at: http://www.tothenew.com/blog/infinite-scrolling-using-uicollectionview-in-swift/#sthash.CBqUUR3c.dpuf

/*
 
 
extension CollectionViewController {
    
    // MARK: UICollectionViewDataSource
    
   
    
}
*/
