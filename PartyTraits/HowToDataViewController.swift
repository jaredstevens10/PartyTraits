//
//  HowToDataViewController.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 7/22/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class HowToDataViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let prefs:UserDefaults = UserDefaults.standard
    
    var HowToPages = 3
    var pageTitles = [NSString]()
    var pageNotes = [NSString]()
    
    var HowToPage : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print("on how to date view did load")

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: (UIFont(name: "Noteworthy", size: 25.0))!,
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        
        pageTitles.append("1")
        pageTitles.append("2")
        pageTitles.append("3")
        pageTitles.append("4")
        pageTitles.append("5")
        pageTitles.append("6")
        pageTitles.append("7")
        pageNotes.append("Party Traits is a game designed to be played out in public (Going out with a group of friends).  Let's Learn how.")
        
        pageNotes.append("Select the difficulty level, the harder the game the more uncomfortbale the traits can get")
        pageNotes.append("Tap 'Go'")
        pageNotes.append("Select the number of players for the game, then tap 'Start Game'")
        pageNotes.append("Select a person from your group to go first...then tap 'Get Next Trait'")
        pageNotes.append("This player must then begin acting out this trait throughout the duration of the game")
        pageNotes.append("Make sure everyone gets a turn...everyone wins, non stop laughter!")
       
        
       reset()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       //  reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func swipeLeft(_ sender: AnyObject) {
        print("SWipe left")
    }
    @IBAction func swiped(_ sender: AnyObject) {
        
        self.HowToPage.view .removeFromSuperview()
        self.HowToPage.removeFromParentViewController()
        reset()
        
        
        
    }
    
    func reset() {
        /* Getting the page View controller */
        HowToPage = self.storyboard?.instantiateViewController(withIdentifier: "HowToPage") as! UIPageViewController
        
        self.HowToPage.dataSource = self
        //self.HowToPage.delegate = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        
        self.HowToPage.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.HowToPage.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30)
        
        
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.clear
        
        // self.view.bringSubviewToFront(pageControl)
        //   self.HowToPage.view.addSubview(pageControl)
        
        self.addChildViewController(HowToPage)
        
        self.view.addSubview(HowToPage.view)
        //  self.view.addSubview(pageControl)
        
        self.HowToPage.didMove(toParentViewController: self)
        /*
         var pageControl = UIPageControl.appearance()
         pageControl.pageIndicatorTintColor = UIColor.whiteColor()
         pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
         pageControl.backgroundColor = UIColor.clearColor()
         // self.view.addSubview(pageControl.view)
         */
        
    }
    
    @IBAction func start(_ sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.HowToPage.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        // return pageTitles.count
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! HowToVC1).pageIndex
        index += 1
        if(index == self.pageTitles.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! HowToVC1).pageIndex
        if(index == 0){
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
        
    }
    
    
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "HowToVC") as! HowToVC1
        //pageContentViewController.imageName = self.images[index]
        
        pageContentViewController.pageTitles = self.pageTitles[index]
        pageContentViewController.pageNoteInfo = self.pageNotes[index]
        pageContentViewController.pageIndex = index
        
        /*
         pageContentViewController.titleText = self.pageTitles[index] as String
         pageContentViewController.pageIndex = index
         pageContentViewController.LBL1text = self.LBL1text[index] as String
         pageContentViewController.LBL2text = self.LBL2text[index] as String
         pageContentViewController.imageTOPname = self.images1[index]
         pageContentViewController.imageBOTTOMname = self.images2[index]
         pageContentViewController.IMG1hidden  = self.images1Hidden[index]
         pageContentViewController.IMG2hidden  = self.images2Hidden[index]
         pageContentViewController.IMGfullname  = self.imagesFull[index]
         pageContentViewController.IMGfullHidden  = self.imagesFullHidden[index]
         */
        return pageContentViewController
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
