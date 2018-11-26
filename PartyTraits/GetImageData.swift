//
//  GetImageData.swift
//  PartyTraits
//
//  Created by Jared Stevens on 7/4/15.
//  Copyright (c) 2015 Jared Stevens. All rights reserved.
//

import Foundation

func GetTraitInfo(_ id: Int) -> (NSString, NSString, NSString) {
    
    var TName = NSString()
    var TDesc = NSString()
    var ImageBase = NSString()
    
    var post:NSString = "id=\(id)" as NSString
    
    
    
    //&password=\(password)"
    
    //NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/GetImageData.php")!
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    var postLength:NSString = String( postData.count ) as NSString
    
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
            
            //  var error: NSError?
            
            // let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            
            TName = jsonData.value(forKey: "TraitName") as! NSString
            
            TDesc = jsonData.value(forKey: "TraitDesc") as! NSString
            
            ImageBase = jsonData.value(forKey: "imageData") as! NSString
            
            print(TName)
            print(TDesc)
            
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
    
    return (TName, TDesc, ImageBase)
}

func GetPassCode(_ version: String) -> String {
    
    var passcode = String()
  
    
    var post:NSString = "version=\(version)" as NSString

    //&password=\(password)"
    
   //NSLog("PostData: %@",post);
    
    var url:URL = URL(string:"http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/GetPasscode.php")!
    
    var postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
    
    var postLength:NSString = String( postData.count ) as NSString
    
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
            
          //  var error: NSError?
            
           // let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
            
            let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
            
            
            let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
            
            
            passcode = jsonData.value(forKey: "passcode") as! String
            
            
            
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
    
    return passcode
}



func UploadTraitFile(_ UploadImage: UIImage, FileName: String, Type: String)
{
    
    let myUrl = URL(string: "http://\(ServerInfo.sharedInstance)/Apps/PartyTraits/UploadTraitFile.php");
    //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
    
    let request = NSMutableURLRequest(url:myUrl!);
    request.httpMethod = "POST";
    
    let param = [
        "firstName"  : "Sergey",
        "lastName"    : "Kargopolov",
        "userId"    : "9"
    ]
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    
    let imageData = UIImageJPEGRepresentation(UploadImage, 1)
    
    if(imageData==nil)  { return; }
    
    request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary, filenameTemp: FileName, Type: "\(Type)")
    
    
    
    //  myActivityIndicator.startAnimating();
    let task = URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
        
        if error != nil {
            print("error=\(error)")
            return
        }
        
        // You can print out response object
        print("******* response = \(response)")
        
        // Print out reponse body
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")
        
        var err: NSError?
        
        do {
            var json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
        } catch {
            print("error = \(error)")
        }
        
        DispatchQueue.main.async(execute: {
            // self.myActivityIndicator.stopAnimating()
            //UploadImage = nil;
        });
        
        /*
        if let parseJSON = json {
        var firstNameValue = parseJSON["firstName"] as? String
        println("firstNameValue: \(firstNameValue)")
        }
        */
        
    }//)
    
    task.resume()
    
}


extension NSString {
    
    func stringByAddingPercentEncodingForURLQueryValue() -> NSString? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: " ", with: "+") as NSString?
    }
    
    func stringByAddingPercentEncodingForURLQueryValue2() -> NSString? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._* ")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)?.replacingOccurrences(of: "%2F", with: "/") as NSString?
    }
    
    
    
    
    
}

/*

func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, filenameTemp: String, Type: String) -> NSData {
    var body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
    }
    
    var filename = String()
    var mimetype = String()
    
    switch Type {
    case "image":
        mimetype = "image/jpg"
        filename = "\(filenameTemp).jpg"
        
    case "audio":
        mimetype = "audio/mpeg"
        filename = "\(filenameTemp).mp3"
        
        
    case "gif":
        
        mimetype = "image/gif"
        filename = "\(filenameTemp).gif"
        
        
    default:
        break
    }
    
    
    /*
    if Type == "image" {
    
    mimetype = "image/jpg"
    filename = "\(filenameTemp).jpg"
    }
    
    if Type == "audio" {
    mimetype = "audio/mpeg"
    filename = "\(filenameTemp).mp3"
    }
    
    */
    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
    body.appendData(imageDataKey)
    body.appendString("\r\n")
    
    
    
    body.appendString("--\(boundary)--\r\n")
    
    return body
}




func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().UUIDString)"
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
*/

