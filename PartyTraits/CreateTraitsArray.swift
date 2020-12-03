//
//  CreateTraitsArray.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/4/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import Foundation

func CreateGameArray (_ level: NSString) -> Data {
    
    
    var post:NSString = "level=\(level)" as NSString
    
   
    
    //&password=\(password)"
    
  // //NSLog("PostData: %@",post);
    
    //var url:URL = URL(string:"http://clavensolutions.com/Apps/PartyTraits/CreateTraitArray.php")!
    
    //var dir_server_name = ServerInfo
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/CreateTraitArray.php")!
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    var postLength:NSString = String(postData.count) as NSString
    
    var request:NSMutableURLRequest = NSMutableURLRequest(url: url)
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
        //let reponseError = error
        print(error)
        urlData = nil
    }
    
    if ( urlData != nil ) {
        let res = response as! HTTPURLResponse!;
        
        //NSLog("Response code: %ld", res?.statusCode);
        
        if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
        {
            var responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
            
           //NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
         let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            //[jsonData[@"success"] integerValue];
            
           //NSLog("Success: %ld", success);
            
            if(success == 1)
            {
               //NSLog("Login SUCCESS");
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
    
    return urlData!
}



func FilterTraitData(_ urlData: Data) -> [Double] {
    
    var traits = [Double]()
    
    
    //    var data = NSJSONSerialization.JSONObjectWithData(urlData, options: nil, error: nil) as! NSDictionary
    
    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
    
    var json = JSON(jsonData)
    
    for result in json["Data"].arrayValue {
        
        var trait_id2 = result["id"].stringValue
        var trait_id = (trait_id2 as NSString).doubleValue
        // let new_id = ["id": trait_id]
        
      //  println(trait_id)
        if (trait_id2 != "0.0") {
        traits.append(trait_id)
        }
        
    }
    
    return traits
    
}
