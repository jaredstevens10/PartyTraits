//
//  HowToVC1.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 7/22/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class HowToVC1: UIViewController {
    
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var pageNotes: UILabel!
    
    var pageTitles = NSString()
    var pageNoteInfo = NSString()
    
    var NumColors = [UIColor]()
   
    
    var pageIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("on howtovc viewdidload")
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: (UIFont(name: "Noteworthy", size: 25.0))!,
            NSForegroundColorAttributeName : UIColor.white
        ]
        
        pageTitle.text = pageTitles as String
        pageNotes.text = pageNoteInfo as String
        
        NumColors.append(UIColor.red)
        NumColors.append(UIColor.blue)
        NumColors.append(UIColor.green)
        NumColors.append(UIColor.purple)
        NumColors.append(UIColor.yellow)
        NumColors.append(UIColor.orange)
        NumColors.append(UIColor.cyan)
        NumColors.append(UIColor.magenta)
        
        self.pageTitle.layer.cornerRadius = 40
        self.pageTitle.layer.borderWidth = 2
        let randomIndex = Int(arc4random_uniform(UInt32(NumColors.count)))
        
        
        pageTitle.textColor = NumColors[randomIndex]
        self.pageTitle.layer.borderColor = NumColors[randomIndex].cgColor

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       // let randomIndex = Int(arc4random_uniform(UInt32(NumColors.count)))
       // print(array[randomIndex])
        
    //    pageTitle.text = pageTitles as String
    //    pageNotes.text = pageNoteInfo as String

        
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

}
