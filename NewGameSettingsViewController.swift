//
//  NewGameSettingsViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 7/22/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class NewGameSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let prefs:UserDefaults = UserDefaults.standard
    
    var NumberPlayersArray = [Int]()
    var AllTraitsPurchased = Bool()
    @IBOutlet weak var timerHolderView: UIView!
    @IBOutlet weak var timerLBL: UILabel!
    @IBOutlet weak var timerBTN: UIButton!
    @IBOutlet weak var gameTypeTitle: UILabel!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    var NumColors = [UIColor]()
    
    var gameType = NSString()
    
    var trait_ids = [Double]()
    var trait_ids_used = [Double]()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerDataSource = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
    
    var pickerDataSourceLimited = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
    
    var NumberPlayers = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllTraitsPurchased = prefs.bool(forKey: "AllTraitsPurchased")
        
        self.timerLBL.text = "Select"
        NotificationCenter.default.addObserver(self, selector: #selector(NewGameSettingsViewController.updateTimerLBLName), name: NSNotification.Name(rawValue: "updateTimerLBL"), object: nil)
        
        NumColors.append(UIColor.red)
        NumColors.append(UIColor.blue)
        NumColors.append(UIColor.green)
        NumColors.append(UIColor.purple)
        NumColors.append(UIColor.yellow)
        NumColors.append(UIColor.orange)
        NumColors.append(UIColor.cyan)
        NumColors.append(UIColor.magenta)
        
        
        let randomIndex = Int(arc4random_uniform(UInt32(NumColors.count)))
        
        self.pickerView.layer.borderWidth = 2
        self.pickerView.layer.borderColor = NumColors[randomIndex].cgColor
        self.pickerView.layer.cornerRadius = 10
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        print("Play Type = \(gameType)")
        
        switch gameType {
            case "FreePlay":
            self.gameTypeTitle.text = "Free Play"
            self.timerBTN.isHidden = true
            self.timerLBL.isHidden = true
            
            print("Should segue to new game now")
            //self.performSegue(withIdentifier: "Select_NewGame", sender: self)
            
            case "GroupPlay":
            self.gameTypeTitle.text = "Group Play"
            self.timerBTN.isHidden = true
            self.timerLBL.isHidden = true
            
            case "TimerPlay":
            self.gameTypeTitle.text = "Timer Play"
            self.timerBTN.isHidden = false
            self.timerLBL.isHidden = false
            
            default:
            self.gameTypeTitle.text = "Free Play"
        }
        //self.gameTypeTitle.text = gameType as String
        
        startGameButton.layer.cornerRadius = 65
        startGameButton.layer.borderWidth = 1
        startGameButton.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        switch gameType {
        case "FreePlay":
            break
         //   self.gameTypeTitle.text = "Free Play"
         //   self.timerBTN.hidden = true
         //   self.timerLBL.hidden = true
            
          //  self.performSegue(withIdentifier: "Select_NewGame", sender: self)
            
        case "GroupPlay":
            break
            
        case "TimerPlay":
          //  self.gameTypeTitle.text = "Timer Play"
          //  self.timerBTN.hidden = false
          //  self.timerLBL.hidden = false
            
            let subViews = self.view.subviews
            for subview in subViews{
                if subview.tag == 1000 {
                    //  self.CapturingTerritory = false
                    subview.removeFromSuperview()
                }
            }
            
            DispatchQueue.main.async(execute: {
                let view = TimerMenu.instanceFromNib()
                view.tag = 1000
                self.view.addSubview(view)
            })
            
        default:
            self.gameTypeTitle.text = "Free Play"
        }
        
        
      
        
        
        
    }
    
    
    @objc func updateTimerLBLName() {
        let timerString = prefs.value(forKey: "TimerGameTimeLBL") as! String
        self.timerLBL.text = "\(timerString)"
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if AllTraitsPurchased {
        return pickerDataSource.count;
        } else {
        return pickerDataSourceLimited.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if AllTraitsPurchased {
            return pickerDataSource[row]
        } else {
            return pickerDataSourceLimited[row]
        }
        
       // return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        self.NumberPlayers = row + 1
        
        print("Number of Players = \(self.NumberPlayers)")
        /*
        if(row == 0)
        {
            self.view.backgroundColor = UIColor.whiteColor();
        }
        else if(row == 1)
        {
            self.view.backgroundColor = UIColor.redColor();
        }
        else if(row == 2)
        {
            self.view.backgroundColor =  UIColor.greenColor();
        }
        else
        {
            self.view.backgroundColor = UIColor.blueColor();
        }
        
        */
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select_NewGame" {
            let viewController = segue.destination as! NewGameViewController
            
            //viewController.Traits = leveldata
            viewController.Traits = trait_ids
            viewController.GameType = gameType
            viewController.TraitsUsed = trait_ids_used
            viewController.NumberPlayersArray = NumberPlayersArray
            
            
            // let Traits = trait_ids
        }
    }
    
    
    @IBAction func StartGameBTN(_ sender: AnyObject) {
        
        
        switch NumberPlayers {
            
        case 1:
            NumberPlayersArray = [1]
        case 2:
            NumberPlayersArray = [1,2]
        case 3:
            NumberPlayersArray = [1,2,3]
        case 4:
            NumberPlayersArray = [1,2,3,4]
        case 5:
            NumberPlayersArray = [1,2,3,4,5]
        case 6:
            NumberPlayersArray = [1,2,3,4,5,6]
        case 7:
            NumberPlayersArray = [1,2,3,4,5,6,7]
        case 8:
            NumberPlayersArray = [1,2,3,4,5,6,7,8]
        case 9:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9]
        case 10:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10]
        case 11:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11]
        case 12:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12]
        case 13:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13]
        case 14:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        case 15:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        case 16:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
        case 17:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
        case 18:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        case 19:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
        case 20:
            NumberPlayersArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        default:
            break
            
        }
        
        
        
        
        switch gameType {
        case "FreePlay":
           // break
            //   self.gameTypeTitle.text = "Free Play"
            //   self.timerBTN.hidden = true
            //   self.timerLBL.hidden = true
            
            self.performSegue(withIdentifier: "Select_NewGame", sender: self)
            
        case "GroupPlay":
            
            print("Group Play")
            
            self.performSegue(withIdentifier: "Select_NewGame", sender: self)
            
        case "TimerPlay":
          
            let notification = UILocalNotification()
            
            /* Time and timezone settings */
            notification.fireDate = Date(timeIntervalSinceNow: 8.0)
            notification.repeatInterval = NSCalendar.Unit.minute
            notification.timeZone = Calendar.current.timeZone
            notification.alertBody = "A New Trait is ready!"
            
            /* Action settings */
            notification.hasAction = true
            notification.alertAction = "View"
            
            /* Badge settings */
            notification.applicationIconBadgeNumber =
                UIApplication.shared.applicationIconBadgeNumber + 1
            /* Additional information, user info */
            notification.userInfo = [
                "alert" : "test alert info",
                "identifier" : "Test identifier value"
            ]
            
            /* Schedule the notification */
           // UIApplication.shared.scheduleLocalNotification(notification)
            
              self.performSegue(withIdentifier: "Select_NewGame", sender: self)
            
        default:
           break
            //self.gameTypeTitle.text = "Free Play"
        }
        
        
      
        
        
    
      
        
        
    }
    
    
    @IBAction func backBTN(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ShowTimerView(_ sender: AnyObject) {
        //DEMO BUTTON
        let subViews = self.view.subviews
        for subview in subViews{
            if subview.tag == 1000 {
              //  self.CapturingTerritory = false
                subview.removeFromSuperview()
            }
        }
        
        DispatchQueue.main.async(execute: {
            let view = TimerMenu.instanceFromNib()
            view.tag = 1000
            self.view.addSubview(view)
        })
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
