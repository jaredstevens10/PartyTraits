//
//  MyTraitsViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 11/30/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit
import CoreData

class MyTraitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var AddTraitBTN: UIButton!
    
    @IBOutlet weak var HaveTraitsLBL: UILabel!
    var myData: Array<AnyObject> = []
    
    let dirpath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    var TotalItems = Int()
    var SavedItemsInventory = [NSManagedObject]()
    
    var TotalTraitsInventoryArray = [TraitInventoryLimited]()
    
    let prefs:UserDefaults = UserDefaults.standard
    var username = NSString()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var TableView: UITableView!
    
    var NumTraits = [Int]()
    var TraitsObject = [NSManagedObject]()
    var LocalTraits = [NSManagedObject]()
    var CurNum = Int()
    var CurNumTraits = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.HaveTraitsLBL.isHidden = true
        self.AddTraitBTN.clipsToBounds = true
        self.AddTraitBTN.layer.cornerRadius = 20
        self.AddTraitBTN.layer.masksToBounds = true
        
        self.title = "My Traits"
        if let font = UIFont(name: "Noteworthy", size: 25.0) {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
        navigationController!.navigationBar.barTintColor = UIColor.black
        
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.TableView.separatorStyle = UITableViewCellSeparatorStyle.none
        TableView.delegate = self
        TableView.dataSource = self
        self.TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        // view.addGestureRecognizer(tap)
        
       
        //  username = prefs.valueForKey("USERNAME") as! NSString as String
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("view appeared")
        
        TotalTraitsInventoryArray = RetrieveLocalTraitInfo()
        
        self.TableView.reloadData()
        
        if TotalTraitsInventoryArray.count == 0 {
            
            self.HaveTraitsLBL.isHidden = false
               
        } else {
            self.HaveTraitsLBL.isHidden = true
        }
        
       // self.TableView.reloadData
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TotalTraitsInventoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        
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
        
        let image  = UIImage(data: theImageData!)!
        
        
        cell.titleLBL.text = TraitNameFinal as String
        cell.traitImageView.image = image as UIImage
        cell.descLBL.text = TheTrait.traitdescription as String
        cell.levelLBL.text = TheTrait.traitlevel as String
        
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
    
    func RetrieveLocalTraitInfo() -> [TraitInventoryLimited] {
        
        var TotalTraitsInventoryArrayTemp = [TraitInventoryLimited]()
        
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
                
                myData.append(items)
                
                if localTrait {
                    
                    //myData.append(items)
                        
                    TotalTraitsInventoryArrayTemp.append(TraitInventoryLimited(traitname: traitname as NSString, imageURL: traitImageURL, traitlevel: traitlevel, traitid: traitid, traitimagedata: traitimagedata, traitdescription: traitdescription as NSString, localTrait: localTrait, index: localIndex))
                    
                        trait_ids_temp.append((traitid as NSString).doubleValue)
                        
                        
                    }
                    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        /*
         if tableView == TableView {
         switch editingStyle {
         case .Delete:
         let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         let context:NSManagedObjectContext = appDel.managedObjectContext!
         context.deleteObject(Friends[indexPath.row] as NSManagedObject)
         Friends.removeAtIndex(indexPath.row)
         context.save(nil)
         
         CurNum = NumFriends.count
         CurNum--
         NumFriends.append(CurNum)
         
         self.TableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         default:
         return
         }
         } else {
         */
        
        let TempTrait = TotalTraitsInventoryArray[indexPath.row]
        
        let TempIndex = TempTrait.index
        print("TEMP INDEX \(TempIndex)")
        
        
        print("group editing")
        
        switch editingStyle {
        case .delete:
            
            
            
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.managedObjectContext!
            
            
           // print("Context = \(context.)")
           // context.delete(LocalTraits[(indexPath as NSIndexPath).row] as NSManagedObject)
            
            
           // let traitid = (myData[(indexPath as NSIndexPath).row] as! NSManagedObject).description
            
            let traitidtemp = (myData[TempIndex] as! NSManagedObject).description
            
            
           // print("Deleting Trait Data Function Start, Trait ID = \(traitidtemp)")
            DeleteTraitData(traitidtemp as NSString)
            
            myData.remove(at: TempIndex)
            do {
                try context.save()
            } catch _ {
            }
            
           
            CurNumTraits = NumTraits.count
            CurNumTraits -= 1
            NumTraits.append(CurNumTraits)
            
            TotalTraitsInventoryArray.remove(at: indexPath.row)
            
            self.TableView.deleteRows(at: [indexPath], with: .fade)
            
        default:
            return
            
            //  }
        }
        /*
         if editingStyle == UITableViewCellEditingStyle.Delete {
         Friends.removeAtIndex(indexPath.row);
         //   EmailInfo.removeAtIndex(indexPath.row);
         //   NameInfo.removeAtIndex(indexPath.row)
         self.editTableView(EditBTN)
         TableView.reloadData()
         } else if editingStyle == UITableViewCellEditingStyle.Insert{
         //  Friends.append();
         //   EmailInfo.append("New Item");
         //   NameInfo.append("New Name");
         }
         */
    }
    
    
    func DeleteTraitData(_ DeleteTraitID: NSString) {
        
        
        print("***DELETE THIS TRAIT ID: \(DeleteTraitID)***")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //  let fetchRequest = NSFetchRequest(entityName: "Person")
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TraitInfo")
        let error: NSError?
        
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            
            if let results = fetchedResults {
                //Friends = results
                //print(Friends)
                
                TraitsObject = results
                
                
                
                for items in TraitsObject as [NSManagedObject] {
                    
                    let traitname = items.value(forKey: "traitname") as! String
                    
                    let traitid = items.value(forKey: "traitid") as! String
                    
                   // let GroupNameObject = items.value(forKey: "group") as! String
                   // let FID = items.value(forKey: "id") as! String
                    
                   // print(items)
                    print(items.value(forKey: "traitid")!)
                    
                    if items.description == DeleteTraitID as String {
                        
                        print("Deleting Trait: \(traitname) with ID \(traitid)")
                        
                        managedContext.delete(items)
                        
                        do {
                            try managedContext.save()
                        } catch _ {
                        }
                        
                        // NumMembers++
                        // PlayerCount.append(NumMembers.description)
                    }
                    //   theFriends.append(MyFriends(name:FName,email:EmailAdd))
                    
                }
                
            }
            else {
                //print("Could not fetch \(error), \(error!.userInfo)")
            }
            // println("Friends Now: \(NameInfo)")
        } catch {
            print(error)
        }
    }
    
    
    
    
}
