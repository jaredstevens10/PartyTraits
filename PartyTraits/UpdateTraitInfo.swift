//
//  UpdateTraitInfo.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 11/29/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//


//
//  UpdateItemData.swift
//  BattleField
//
//  Created by Jared Stevens2 on 3/30/16.
//  Copyright © 2016 Claven Solutions. All rights reserved.
//

import Foundation
import CoreData


let WeaponItemKey = "weaponItemData"
let ArmorItemKey = "armorItemData"
//var bedroomFloorID: AnyObject = 101
//var bedroomWallID: AnyObject = 101

func loadGameData() {
    
    // getting path to GameData.plist
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentsDirectory = paths[0] as! String
    let path = (documentsDirectory as NSString).appendingPathComponent("ItemLevelList.plist")
    
    let fileManager = FileManager.default
    
    //check if file exists
    if(!fileManager.fileExists(atPath: path)) {
        // If it doesn't, copy it from the default file in the Bundle
        if let bundlePath = Bundle.main.path(forResource: "ItemLevelList", ofType: "plist") {
            
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            print("Bundle ItemLevelList.plist file is --> \(resultDictionary?.description)")
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: path)
            } catch {
                print(error)
            }
            //  fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            print("copy")
        } else {
            print("ItemLevelList.plist not found. Please, make sure it is part of the bundle.")
        }
    } else {
        print("ItemLevelList.plist already exits at path.")
        // use this to delete file from documents directory
        //fileManager.removeItemAtPath(path, error: nil)
    }
    
    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    print("Loaded ItemLevelList.plist file is --> \(resultDictionary?.description)")
    
    let myDict = NSDictionary(contentsOfFile: path)
    
    if let dict = myDict {
        //loading values
        
        
        let ArmorItems = dict["armorItemData"] as! [String: [String: NSNumber]]
        
        
        
        let WeaponItems = dict["weaponItemData"] as! [String: [String: NSNumber]]
        
        
        
        //  bedroomFloorID = dict.objectForKey(WeaponItemKey)!
        
        
        //   bedroomWallID = dict.objectForKey(ArmorItemKey)!
        //...
    } else {
        print("WARNING: Couldn't create dictionary from ItemLevelList.plist! Default values will be used!")
    }
}

func saveGameData() {
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentsDirectory = paths.object(at: 0) as! NSString
    let path = documentsDirectory.appendingPathComponent("ItemLevelList.plist")
    
    // var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
    
    let ItemDict = NSDictionary(contentsOfFile: path)
    
    
    //saving values
    
    
    
    
    
    //  dict.setObject(bedroomFloorID, forKey: WeaponItemKey)
    //  dict.setObject(bedroomWallID, forKey: ArmorItemKey)
    //...
    
    //writing to GameData.plist
    ItemDict!.write(toFile: path, atomically: false)
    
    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
    print("Saved ItemLevelList.plist file is --> \(resultDictionary?.description)")
}





func CreateLocalInventory(_ Data: Foundation.Data) {
    
    loadGameData()
    
    DispatchQueue.main.async(execute: {
        FilterItemLevelData(Data)
    })
    
    /*
     let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
     let documentsDirectory = paths.objectAtIndex(0) as! NSString
     let path = documentsDirectory.stringByAppendingPathComponent("ItemLevelList.plist")
     
     var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
     //saving values
     dict.setObject(bedroomFloorID, forKey: WeaponItemKey)
     dict.setObject(bedroomWallID, forKey: ArmorItemKey)
     */
    
    
}

func FilterItemLevelData(_ urlData: Data) {
    
    let ArmorKey = "armorItemData"
    let WeaponKey = "weaponItemData"
    let ArmorKeyBody = "armor_body_level"
    let ArmorKeyHelmet = "armor_helmet_level"
    let ArmorKeyBoots = "armor_boots_level"
    let WeaponKeyFist = "weapon_fist_level"
    
    let prefs:UserDefaults = UserDefaults.standard
    
    //   func FilterItemData(urlData: NSData) -> [ItemInventory] {
    
    var ItemDictionary = NSMutableDictionary()
    var traits = [NSString]()
    
    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
    
    var json = JSON(jsonData)
    
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentsDirectory = paths.object(at: 0) as! NSString
    let path = documentsDirectory.appendingPathComponent("ItemLevelList.plist")
    
    
    var CurrentItemDict = NSDictionary(contentsOfFile: path) as! NSMutableDictionary
    
    print("Current ItemLevelList.plist file is --> \(CurrentItemDict.description)")
    
    
    for result in json["Items"].arrayValue {
        
        if ( result["id"] != "0") {
            
            let tempusername = result["username"].stringValue
            let tempemail = result["email"].stringValue
            let templatitude = result["latitude"].stringValue
            let templongitude = result["longitude"].stringValue
            let temphealth = result["health"].stringValue
            let tempstamina = result["stamina"].stringValue
            let templevelarmorbody = result["level_armor_body"].stringValue
            let templevelarmorboots = result["level_armor_boots"].stringValue
            let templevelarmorhelmet = result["level_armor_helmet"].stringValue
            let templevelweaponfist = result["level_weapon_fist"].stringValue
            let templevelshield = result["shield_level"].stringValue
            let tempgold = result["gold"].stringValue
            let WasAttacked = result["wasAttacked"].stringValue
            let AttackedTimeDate = result["attackedtimedate"].stringValue
            let tempdiamonds = result["diamonds"].stringValue
            
            let tempstaminaPotionMax = result["staminaPotionMax"].stringValue
            let tempstaminaPotionCount = result["staminaPotionCount"].stringValue
            let temphealthPotionMax = result["healthPotionMax"].stringValue
            let temphealthPotionCount = result["healthPotionCount"].stringValue
            
            
            let templevelgoldproduction = "1"
            let tempgoldproductionLimit = "100"
            let tempgoldproductionSpeed = "36"
            
            let templevelUser = result["userLevel"].stringValue
            let templevelUserXP = result["userXP"].stringValue
            
            prefs.set(tempstaminaPotionMax, forKey: "UserStaminaPotionMax")
            prefs.set(tempstaminaPotionCount, forKey: "UserStaminaPotionCount")
            prefs.set(temphealthPotionMax, forKey: "UserHealthPotionMax")
            prefs.set(temphealthPotionCount, forKey: "UserHealthPotionCount")
            
            prefs.set(templevelarmorbody, forKey: "ARMORLEVELBODY")
            prefs.set(templevelarmorboots, forKey: "ARMORLEVELBOOTS")
            prefs.set(templevelarmorhelmet, forKey: "ARMORLEVELHELMET")
            prefs.set(templevelweaponfist, forKey: "WEAPONLEVELFIST")
            prefs.set(templevelshield, forKey: "SHIELDLEVEL")
            prefs.set(tempgold, forKey: "GOLDAMOUNT")
            prefs.set(tempdiamonds, forKey: "DIAMONDSAMOUNT")
            
            prefs.set(templevelUser, forKey: "USERLEVEL")
            prefs.set(templevelUserXP, forKey: "USERXPLEVEL")
            
            
            prefs.set(templevelgoldproduction, forKey: "GOLDPRODUCTIONLEVEL")
            prefs.set(tempgoldproductionLimit, forKey: "GOLDPRODUCTIONLIMIT")
            prefs.set(tempgoldproductionSpeed, forKey: "GOLDPRODUCTIONSPEED")
            
            prefs.set(1, forKey: "ALLOWEDNUMBERTOUPGRADE")
            
            prefs.set(120.0, forKey: "BootsUPGRADETIME")
            prefs.set(240.0, forKey: "BodyUPGRADETIME")
            prefs.set(150.0, forKey: "HelmetUPGRADETIME")
            prefs.set(150.0, forKey: "ShieldUPGRADETIME")
            prefs.set(120.0, forKey: "moneyBankUPGRADETIME")
            
            prefs.set(3600.0, forKey: "HealthReplenishTIME")
            prefs.set(3600.0, forKey: "StaminaReplenishTIME")
            let temphealthproductionLimit = "100"
            let tempstaminaproductionLimit = "100"
            let temphealthproductionSpeed = "36"
            let tempstaminaproductionSpeed = "36"
            
            let templevelhealthproduction = "1"
            let templevelstaminaproduction = "1"
            
            prefs.set(templevelhealthproduction, forKey: "GOLDPRODUCTIONLEVEL")
            prefs.set(templevelstaminaproduction, forKey: "GOLDPRODUCTIONLEVEL")
            prefs.set(temphealthproductionLimit, forKey: "HEALTHPRODUCTIONLIMIT")
            prefs.set(tempstaminaproductionLimit, forKey: "STAMINAPRODUCTIONLIMIT")
            prefs.set(tempstaminaproductionSpeed, forKey: "HEALTHPRODUCTIONSPEED")
            prefs.set(tempstaminaproductionSpeed, forKey: "STAMINAPRODUCTIONSPEED")
            
            prefs.set(50, forKey: "ARMORBOOTSUPRGRADECOST")
            prefs.set(1500, forKey: "ARMORBODYUPRGRADECOST")
            prefs.set(100, forKey: "ARMORHELMETUPRGRADECOST")
            prefs.set(50, forKey: "SHIELDUPRGRADECOST")
            
            prefs.set(Int(temphealth)!, forKey: "MYHEALTH")
            
            if Int(temphealth)! <= 0 {
                prefs.set(true, forKey: "AmIDead")
            }
            
            prefs.set(Int(tempstamina)!, forKey: "MYSTAMINA")
            
            if Int(tempstamina)! <= 0 {
                
                prefs.set(true, forKey: "AmITired")
            }
            
            print("MYHEALTH!!!! = \(temphealth)")
            
            print("MYHEALTH INT!!!! = \(Int(temphealth)!)")
            
            if prefs.value(forKey: "VIEWRADIUS") == nil {
                prefs.setValue(1, forKey: "VIEWRADIUS")
            }
            
            prefs.set(WasAttacked, forKey: "WASATTACKED")
            
            prefs.set(AttackedTimeDate, forKey: "ATTACKEDTIMEDATE")
            
            let ServerURLItems = "http://\(ServerInfo.sharedInstance)/Apps/BattleField/Items/"
            
            let ServerURLMaps = "http://\(ServerInfo.sharedInstance)/Apps/BattleField/Maps/"
            
            prefs.setValue(ServerURLItems, forKey: "ServerURLItems")
            prefs.setValue(ServerURLMaps, forKey: "ServerURLMaps")
            
            
            //prefs.setObject(templevelarmorbody, forKey: "ARMORLEVELBODY")
            
            
            
            // CurrentItemDict![ArmorKey]![ArmorKeyBody]?!.setObject(Int(templevelarmorbody), forKey: "level")
            
            // print("Current items test =\((CurrentItemDict["armorItemData"]!["armor_body_level"]!!["level"]!)!.stringValue)")
            
            //![ArmorKeyBody]?!.setObject(2, forKey: "level"))")
            
            //    (CurrentItemDict["armorItemData"]!["armor_body_level"]!!).setObject(2, forKey: "level")
            
            /*
             
             CurrentItemDict![ArmorKey]![ArmorKeyHelmet]?!.setObject(Int(templevelarmorhelmet), forKey: "level")
             
             CurrentItemDict![ArmorKey]![ArmorKeyBoots]?!.setObject(Int(templevelarmorboots), forKey: "level")
             
             CurrentItemDict![WeaponKey]![WeaponKeyFist]?!.setObject(Int(templevelweaponfist), forKey: "level")
             */
            
            // CurrentItemDict.writeToFile(path, atomically: false)
            
            //   let resultDictionary = NSMutableDictionary(contentsOfFile: path)
            //   print("Saved ItemLevelList.plist file is --> \(resultDictionary?.description)")
            
            /*
             
             ItemData.append(ItemInventory(name: itemname, imageURL: imageURL, category: category, power: power, speed: speed, range: range))
             
             
             if !TotalItemsArray.contains(imageURL) {
             
             print("\(itemname) has not been saved yet, saving now")
             
             SaveNewItem(itemname, imageurltemp: imageURL, powertemp: power, rangetemp: range, speedtemp: speed, categorytemp: category)
             
             
             }
             
             */
            
        }
        
    }
    
    //  print("ItemData from Filter \(ItemDictionary)")
    
    // return ItemDictionary
}


func SaveNewItem(_ nametemp: NSString, imageurltemp: String, leveltemp: String, idtemp: String, imagedatatemp: String, descriptiontemp: NSString, localTrait: Bool) -> Bool {
    
    var DidSave = Bool()
    
    let prefs:UserDefaults = UserDefaults.standard
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext!
    
    let entity = NSEntityDescription.entity(forEntityName: "TraitInfo", in: managedContext)
    
    let newitem = NSManagedObject(entity: entity!, insertInto: managedContext)
    
    /*
     let rangetemp = ""
     let speedtemp = ""
     let powertemp = ""
     let nametemp = ""
     let imageurltemp = ""
     */
    
    
    newitem.setValue(idtemp, forKey: "traitid")
    newitem.setValue(leveltemp, forKey: "traitlevel")
    newitem.setValue(imagedatatemp, forKey: "traitimagedata")
    newitem.setValue(nametemp, forKey: "traitname")
    newitem.setValue(imageurltemp, forKey: "imageURL")
    newitem.setValue(descriptiontemp, forKey: "traitdescription")
    newitem.setValue(localTrait, forKey: "localTrait")
    
    
   // prefs.setValue(imageurltemp, forKey: "\(nametemp)ImageIcon")
   // prefs.setValue(imageurl100temp, forKey: "\(nametemp)ImageIcon100")
    
    var error: NSError?
    
    do {
        try managedContext.save()
        
        //  print("\(nametemp) has been saved")
        DidSave = true
        
    } catch let error1 as NSError {
        error = error1
        print("Could not save \(error), \(error!.userInfo)")
        DidSave = false
    }
    
    return DidSave
}

func SaveNewImage(_ nametemp: String, imageurltemp: String, categorytemp: String) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let prefs:UserDefaults = UserDefaults.standard
    
    let managedContext = appDelegate.managedObjectContext!
    
    let entity = NSEntityDescription.entity(forEntityName: "Images", in: managedContext)
    
    let newitem = NSManagedObject(entity: entity!, insertInto: managedContext)
    
    /*
     let rangetemp = ""
     let speedtemp = ""
     let powertemp = ""
     let nametemp = ""
     let imageurltemp = ""
     */
    
    // newitem.setValue(rangetemp, forKey: "range")
    //  newitem.setValue(powertemp, forKey: "power")
    //  newitem.setValue(speedtemp, forKey: "speed")
    newitem.setValue(nametemp, forKey: "name")
    newitem.setValue(imageurltemp, forKey: "imageURL")
    newitem.setValue(categorytemp, forKey: "category")
    
    var error: NSError?
    
    do {
        try managedContext.save()
        
        //  print("\(nametemp) has been saved")
        
        
    } catch let error1 as NSError {
        error = error1
        print("Could not save \(error), \(error!.userInfo)")
    }
}


func RefreshTraitInventoryGetImage (_ username: NSString, traitID: NSString) -> Data {
    
    var prefs:UserDefaults = UserDefaults.standard
    
    // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.2"
    
    var post:NSString = "username=\(username)&full=yes&id=\(traitID)" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TraitInventory.php")!
    
    print("***TEST URL: \(url)")
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
            //  NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             */
        }
    } else {
        
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return urlData
}



func GetServerTraitCount (_ username: NSString) -> (Int, [String]) {
    
    var prefs:UserDefaults = UserDefaults.standard
    
    var CurrentServerTraitCount: Int = 0
    var CurrentServerTraitIDs = [String]()
    
    // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.1"
    
    var post:NSString = "username=\(username)" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TraitCount.php")!
    
    print("***TEST URL: \(url)")
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
              NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                
                let CurrentServerTraitCountTemp:NSInteger = jsonData.value(forKey: "ServerTraitCount") as! NSInteger
                
                CurrentServerTraitCount = Int(CurrentServerTraitCountTemp)
                
                
                
                
                
                var json = JSON(jsonData)
                
                
                
                for result in json["Items"].arrayValue {
                    
                    
                    
                    if ( result["traitid"] != "0") {
                        
                       
                         let traitid = result["traitid"].stringValue
                        
                        CurrentServerTraitIDs.append(traitid)
                        
                    }
                    
                }
                
                print("Current Server Trait IDs: \(CurrentServerTraitIDs)")
                
                
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             */
        }
    } else {
        
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return (CurrentServerTraitCount, CurrentServerTraitIDs)
}




func RefreshTraitInventoryLite (_ username: NSString) -> Data {
    
    var prefs:UserDefaults = UserDefaults.standard
    
    // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.1"
    
    var post:NSString = "username=\(username)&basic=yes" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TraitInventory.php")!
    
    print("***TEST URL: \(url)")
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
            //  NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             */
        }
    } else {
        
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return urlData
}


func RefreshTraitInventory (_ username: NSString, UnsyncedTraits: [String]) -> Data {
    
    
    print("Refresh Traits, should only download these: \(UnsyncedTraits)")
    
    var prefs:UserDefaults = UserDefaults.standard
    
    // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.1"
    
    
    
//    var UnsyncedTraits2 = UnsyncedTraits
//    
//    UnsyncedTraits2.append("1")
//    UnsyncedTraits2.append("2")
    
    var post:NSString = "username=\(username)&neededIDs=\(UnsyncedTraits)" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TraitInventory.php")!
    
    print("***TEST URL: \(url)")
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    //request.httpBody = try JSONSerialization.data(withJSONObject: postData, options: [])
    
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
              NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             */
        }
    } else {
        
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return urlData
}

func RefreshTraitInventoryAdmin (_ username: NSString) -> Data {
    
    var prefs:UserDefaults = UserDefaults.standard
    
    // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.1"
    
    var post:NSString = "username=\(username)&admin=jared" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/TraitInventory.php")!
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
            //  NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             */
        }
    } else {
        
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return urlData
}

func UpdateTraitStatus (_ traitID: NSString, approvedStatus: NSString) -> Bool {
    
    var TraitUpdated = Bool()
    
    var prefs:UserDefaults = UserDefaults.standard
    
   // let appVersion = prefs.value(forKey: "APPVERSION")
    
    let appVersion = "1.0.1"
    
    var post:NSString = "traitID=\(traitID)&approvedStatus=\(approvedStatus)&admin=jared" as NSString
    
    var urlData = Data()
    
    //&password=\(password)"
    
    NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/UpdateTraitApprovedStatus.php")!
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    // var postLength:NSString = String( postData.count )
    let postLength:NSString = String( postData.count ) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postData
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    var reponseError: NSError?
    var response: URLResponse?
    
    urlData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //   NSLog("Response code: %ld", res.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData, encoding:String.Encoding.utf8.rawValue)!
            
            //  NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
            NSLog("Success: %ld", success);
            
            if(success == 1)
            {
                NSLog("Login SUCCESS");
                
                TraitUpdated = true
                /*
                 var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                 prefs.setObject(username, forKey: "USERNAME")
                 prefs.setInteger(1, forKey: "ISLOGGEDIN")
                 prefs.synchronize()
                 
                 self.dismissViewControllerAnimated(true, completion: nil)
                 
                 */
            } else {
                var error_msg:NSString
                
                if jsonData["error_message"] as? NSString != nil {
                    error_msg = jsonData["error_message"] as! NSString
                } else {
                    error_msg = "Unknown Error"
                }
                
                TraitUpdated = false
                /*
                 
                 var alertView:UIAlertView = UIAlertView()
                 alertView.title = "Sign in Failed!"
                 alertView.message = error_msg as String
                 alertView.delegate = self
                 alertView.addButtonWithTitle("OK")
                 alertView.show()
                 
                 */
                
            }
            
        } else {
            TraitUpdated = false
            /*
             var alertView:UIAlertView = UIAlertView()
             alertView.title = "Sign in Failed!"
             alertView.message = "Connection Failed"
             alertView.delegate = self
             alertView.addButtonWithTitle("OK")
             alertView.show()
             
             
             
             */
        }
    } else {
        TraitUpdated = false
        /*
         var alertView:UIAlertView = UIAlertView()
         alertView.title = "Sign in Failed!"
         alertView.message = "Connection Failure"
         
         if let error = reponseError {
         alertView.message = (error.localizedDescription)
         
         }
         
         
         alertView.delegate = self
         alertView.addButtonWithTitle("OK")
         alertView.show()
         
         */
    }
    
    return TraitUpdated
}


func SaveFile(_ fileURL: String, name: String) {
    
    let request: URLRequest = URLRequest(url: URL(string: fileURL)!)
    let mainQueue = OperationQueue.main
    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
        if error == nil {
            // Convert the downloaded data in to a UIImage object
            
            
            
            
            SaveFileToDirectory(data!, name: name)
            
            //var image = UIImage(data: data!)
            // Store the imge in to our cache
            //  self.imageCache[urlString] = image
            // Update the cell
            DispatchQueue.main.async(execute: {
                //if let cellToUpdate = TableView.cellForItemAtIndexPath(indexPath) {
                //if let cellToUpdate = TableView.cel
                
            })
        }
        
    })
    
}


func SaveFileNSData(_ Image64Data: String, name: String) {
    
    //let request: URLRequest = URLRequest(url: URL(string: fileURL)!)
    //let mainQueue = OperationQueue.main
    
    let decodedData = Data(base64Encoded: Image64Data as String, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    //NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
        if decodedData != nil {
            
            // Convert the downloaded data in to a UIImage object
            
            
            
            
            SaveFileToDirectory(decodedData!, name: name)
            
            //var image = UIImage(data: data!)
            // Store the imge in to our cache
            //  self.imageCache[urlString] = image
            // Update the cell
            DispatchQueue.main.async(execute: {
                //if let cellToUpdate = TableView.cellForItemAtIndexPath(indexPath) {
                //if let cellToUpdate = TableView.cel
                
            })
        }
        
   // })
    
}


func SaveFileToDirectory(_ data: Data, name: String ) {
    
    //let data = NSData(contentsOfURL: YTLink)
    
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    
    
    let tempTYVideo = (documentDirectory as NSString).appending(name)
    //let tempTYVideo = (documentDirectory as NSString).stringByAppendingString("/tempYTVideo.mov")
    if FileManager.default.fileExists(atPath: tempTYVideo as String) {
        print("Deleting existing file\n")
        
        do {
            
            try FileManager.default.removeItem(atPath: tempTYVideo as String)
            
            
            
            
        } catch {
            print("Error = \(error)")
        }
    }
    
    
    
    
    do {
        
        //     try data?.writeToFile(tempTYVideo, options: NSDataWritingOptions.AtomicWrite)
        
        try data.write(to: URL(fileURLWithPath: tempTYVideo), options: [.atomic])
        print("File saved to path = \(tempTYVideo)")
        let prefs:UserDefaults = UserDefaults.standard
        
        switch name {
            
        case "/PQTempMusic4.m4v" :
            prefs.set(true, forKey: "DEFAULTSAVEDvideo")
            
        case "/tada.caf" :
            prefs.set(true, forKey: "DEFAULTSAVEDtada")
            
        case "/please.caf" :
            prefs.set(true, forKey: "DEFAULTSAVEDplease")
            
        case "/joy.caf" :
            prefs.set(true, forKey: "DEFAULTSAVEDjoy")
            
        case "/metroid.caf" :
            prefs.set(true, forKey: "DEFAULTSAVEDmetroid")
            
        case "/doorbell.caf" :
            prefs.set(true, forKey: "DEFAULTSAVEDdoorbell")
            
        case "/ComedicFun.mp3":
            prefs.set(true, forKey: "DEFAULTCFUN")
            prefs.set(false, forKey: "MuteGameAudio")
            
        case "/DemoImageTurn.jpg":
            prefs.set(true, forKey: "DemoImageTurn")
            
        default:
            break
            
        }
        
        
    } catch {
        print("ERROR Saving Trait to Directory = \(error)")
    }
    
    
    
    print("Trait Image Saved at Path = \(tempTYVideo)")
    
    //  let savePath = (documentDirectory as NSString).stringByAppendingString("/tempYTAudio.m4a")
    
    //   dispatch_async(dispatch_get_main_queue(), {
    
    // self.createVideoNow(YTLink)
    
    //    })
    
}


func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    // dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
        if(background != nil){ background!(); }
        
        let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            if(completion != nil){ completion!(); }
        }
    }
}


