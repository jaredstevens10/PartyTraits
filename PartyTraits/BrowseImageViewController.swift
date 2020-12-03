//
//  BrowseImageViewController.swift
//  TelePictionary
//
//  Created by Jared Stevens on 11/8/15.
//  Copyright © 2015 Claven Solutions. All rights reserved.
//


import UIKit
import WebKit
import Foundation
import iAd


protocol BrowseImageViewControllerDelegate: class {
    func BrowseImageViewControllerFinished(_ browseimageviewController: BrowseImageViewController)
}




class BrowseImageViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, ADInterstitialAdDelegate {
    
    var FromNVC = Bool()
    var imageData: Data!
    var resizeX = CGFloat()
    var resizeY = CGFloat()
    var resizeH = CGFloat()
    var resizeW = CGFloat()
    var interAd: ADInterstitialAd?
    var interAdView = UIView()
    var closeButton = UIButton(type: UIButtonType.system)
    @IBOutlet weak var snippedPic: UIImageView!
    
    
    
    @IBOutlet weak var trimSaveBTN: UIButton!
    
    
    var lastLocation:CGPoint = CGPoint(x: 0, y: 0)
    
    var snipVisible = Bool()
    @IBOutlet weak var snipView: UIView!
    
    @IBOutlet weak var snipImage: UIImageView!
    var htmlTitle = String()
    let prefs = UserDefaults.standard
    var theImageData = NSString()
    
    var XPoint = CGFloat()
    var YPoint = CGFloat()
    var longpressTouchedPoint = CGPoint()
    
    @IBOutlet weak var SelectLinkBTN: UIButton!
    
    var CanDownLoad = Bool()
    
    @IBOutlet weak var SnipControlsView: UIView!
    @IBOutlet var ActInd: UIActivityIndicatorView!
    
    var browseimagedelegate: BrowseImageViewControllerDelegate?
    
    var SelectedYTAudio = Bool()
    var videoURL = String()
    var thewebURL = NSString()
    //var webView: WKWebView!
    
    @IBOutlet weak var webView2: UIWebView!
    @IBOutlet weak var urlText: UILabel!
    
    @IBOutlet weak var forwardBTN: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var backBTN: UIButton!
    // @IBOutlet weak var theWebView: UIWebView!
    
    @IBOutlet weak var theWebView: UIView!
    /*
     override func loadView() {
     webView = WKWebView()
     webView.navigationDelegate = self
     theWebView = webView
     }
     */
    
    var article_id: Int = 1
    //  var article: Article = Article()
    
    let kTouchJavaScriptString: String = "document.ontouchstart=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:start:\"+x+\":\"+y;};document.ontouchmove=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:move:\"+x+\":\"+y;};document.ontouchcancel=function(event){document.location=\"myweb:touch:cancel\";};document.ontouchend=function(event){document.location=\"myweb:touch:end\";};"
    var _gesState: Int = 0
    /*
     _gesState:
     GESTURE_STATE_NONE = 0,
     GESTURE_STATE_START = 1,
     GESTURE_STATE_MOVE = 2,
     GESTURE_STATE_END = 4
     */
    
    var _imgURL: String = "", _timer: Timer = Timer()
    
    @IBOutlet var snipPan: UIPanGestureRecognizer!
    
    
    @IBOutlet weak var SnipControlsViewW: NSLayoutConstraint!
    @IBOutlet weak var SnipControlsViewH: NSLayoutConstraint!
    
    @IBOutlet weak var SnipControlsViewLEAD: NSLayoutConstraint!
    
    @IBOutlet weak var SnipControlsViewBOTTOM: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        
        //    self.SnipControlsViewBOTTOM.constant = 0
        //   self.SnipControlsViewH.constant = 0
        //  self.SnipControlsViewW.constant = 0
        // self.SnipControlsViewLEAD.constant = 0
        
    }
    
    
    override func viewDidLoad() {
        
        self.urlText.isHidden = true
        
        self.trimSaveBTN.isHidden = true
        self.SnipControlsViewBOTTOM.constant = 0
        self.SnipControlsViewH.constant = 0
        self.SnipControlsViewW.constant = 0
        self.SnipControlsViewLEAD.constant = 0
        
        super.viewDidLoad()
        self.snipView.isHidden = true
        self.snipView.layer.borderWidth = 1
        self.snipView.layer.borderColor = UIColor.gray.cgColor
        self.snippedPic.isHidden = true
        
        self.SnipControlsView.layer.cornerRadius = 5
        self.SnipControlsView.layer.masksToBounds = true
        self.SnipControlsView.clipsToBounds = true
        
        self.SnipControlsView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        
        webView2.delegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(BrowseImageViewController.handleTap(_:)))
        // 4
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
        recognizer.require(toFail: snipPan)
        
        htmlTitle = webView2.stringByEvaluatingJavaScript(from: "document.title")!
        print("Html title = \(htmlTitle)")
        
        SelectLinkBTN.isHidden = true
        
        let url = URL(string: "https://www.google.com/imghp")!
        
        
        webView2.keyboardDisplayRequiresUserAction = true
        
        //  let url = NSBundle.mainBundle().URLForResource("index", withExtension: "html")
        let request = URLRequest(url: url)
        webView2.loadRequest(request)
        ActInd.stopAnimating()
        // webView2.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
        //  self.webView = WKWebView()
        // Do any additional setup after loading the view.
        
        
        // let webViewTapped = UITapGestureRecognizer(target: self, action: "tapAction:")
        let webViewTapped = UILongPressGestureRecognizer(target: self, action: #selector(BrowseImageViewController.LongPressAction(_:)))
        //  let webViewTapped = UITapGestureRecognizer (target: self, action: "LongPressAction:")
        //  webViewTapped.numberOfTouchesRequired = 2
        webViewTapped.delegate = self
        webView2.addGestureRecognizer(webViewTapped)
        
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.automatic
        
    }
    
    
    /*
     func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
     return true
     }
     */
    
    @IBAction func forwardBTN(_ sender: AnyObject) {
        if webView2.canGoForward{
            webView2.goForward()
        }
        
    }
    
    @IBAction func backBTN(_ sender: AnyObject) {
        if webView2.canGoBack{
            webView2.goBack()
        }
        
    }
    
    
    //   func tapAction(sender: UITapGestureRecognizer) {
    @objc func LongPressAction(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: self.view)
        
        let currentURL = self.webView2.request!.url?.absoluteString
        
        print("Current URL - Tapped = \(currentURL)")
        
        XPoint = point.x
        YPoint = point.y
        
        print(point.x)
        print(point.y)
        
        let imgTagName = "document.elementFromPoint(\(XPoint), \(YPoint)).tagName"
        
        
        
        print("img URL String = \(imgTagName)")
        
        let imageTag = webView2.stringByEvaluatingJavaScript(from: imgTagName)
        
        print("Image Javascript tag = \(imageTag)")
        
        if currentURL != "https://www.google.com/imghp" {
            
            if ((imageTag?.caseInsensitiveCompare("IMG")) != nil) {
                
                let imgURLString = webView2.stringByEvaluatingJavaScript(from: "document.elementFromPoint(\(XPoint), \(YPoint)).src")
                print("Image URL STRING from Source = \(imgURLString)")
                
                let ImageBase64DataString = imgURLString?.components(separatedBy: "base64,").last
                
                if ImageBase64DataString == nil || ImageBase64DataString == "" {
                    print("Image64 Data was nil, trying to load image from URL")
                    
                    if let checkedUrl = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
                        // imageURL.contentMode = .ScaleAspectFit
                        let imgTempData = downloadImage(checkedUrl)
                        print("temp data = \(imgTempData)")
                    }
                    
                }
                
                print("IMAGE 64 DATA = \(ImageBase64DataString!)")
                
                // let imageDataTempString = ImageBase64DataString
                let temprange = ImageBase64DataString?.contains("gstatic.com")
                
                print("Temp range = \(temprange)")
                
                if temprange! {
                    
                    //  let AC = JSController("Image Error", MyMessage: "This image is returning with an error, please select another image.",Color: "Red")
                    //    self.presentViewController(AC, animated: true, completion: nil)
                    
                    let AC = JSController("Error", MyMessage: "Some of the images on Google are more difficult to retrieve, this one caused an error...please select another image or just screen shot the image (On the iphone, hold home button and the Sleep/Wake button together), which will save to your photo album. Now just select that image from your photo album.",Color: "Red")
                    self.present(AC, animated: true, completion: nil)
                    
                    
                    
                } else {
                    
                    DispatchQueue.main.async(execute: {
                        
                        let alertController = UIAlertController(title: "Select Image", message: "Do you want to select this Image?", preferredStyle: .alert)
                        
                        let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
                            print("Cancel button pressed")
                            
                        }
                        
                        
                        
                        let yesAction = UIAlertAction(title: "Select Image", style: .default) { (action:UIAlertAction) in
                            print("image Selected")
                            
                            //  NSNotificationCenter.defaultCenter().postNotificationName("gooleImage", object: nil, userInfo: ["data":ImageBase64DataString!]);
                            self.theImageData = ImageBase64DataString! as NSString
                            self.prefs.setValue(ImageBase64DataString!, forKey: "GOOGLEDATAD")
                            
                            //{NSNotificationCenter.defaultCenter().postNotificationName("gooleImage", object: nil, userInfo: ["data":ImageBase64DataString!]);})
                            
                            if self.theImageData != "" {
                                self.closeView()
                                
                            } else {
                                let AC = JSController("Error", MyMessage: "Some of the images on Google are more difficult to retrieve, this one caused an error...please select another image or just screen shot the image (On the iphone, hold home button and the Sleep/Wake button together), which will save to your photo album. Now just select that image from your photo album.",Color: "Red")
                                self.present(AC, animated: true, completion: nil)
                                
                            }
                            
                            // self.closeView()
                            
                            
                            //   self.browseimagedelegate?.BrowseImageViewControllerFinished(self)
                            
                            
                            
                        }
                        
                        
                        alertController.addAction(yesAction);
                        
                        alertController.addAction(CancelAction);
                        
                        alertController.view.tintColor = UIColor.black;
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    })
                    
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeView(){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "googleImage"), object: nil, userInfo: nil)
        print("google image should not be true")
        
        self.dismiss(animated: true, completion: nil)
        
        print("dismissing google")
        
    }
    
    func downloadImage(_ url: URL) -> Data {
        var theData = Data()
        
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data , error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                theData = data
                
                
                // return data
                //   imageURL.image = UIImage(data: data)
            }
        }
        return theData
    }
    
    
    /*
     if let checkedUrl = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
     imageURL.contentMode = .ScaleAspectFit
     downloadImage(checkedUrl)
     }
     */
    
    
    /*
     
     func webView(webView: UIWebView, shouldStartLoadWithRequest _request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     if (_request.URL! == "about:blank") {
     return false
     }
     
     thewebURL = String(_request.URL)
     
     //thewebURL = request.description
     urlText.text = thewebURL as String
     
     
     
     
     let requestString: String = (_request.URL?.absoluteString)!
     var components: [String] = requestString.componentsSeparatedByString(":")
     
     
     if (components.count > 1 && components[0] == "myweb") {
     print("great than 1 components")
     if (components[1] == "touch") {
     print("Component touch")
     if (components[2] == "start") {
     _gesState = 1
     print("touch start!")
     let ptX: Float = Float(components[3])!
     let ptY: Float = Float(components[4])!
     print("touch point \(ptX), \(ptY)")
     let js: String = "document.elementFromPoint(\(ptX), \(ptY)).tagName"
     let tagName: String = webView2.stringByEvaluatingJavaScriptFromString(js)!
     _imgURL = ""
     print(tagName)
     if (tagName == "IMG") {
     _imgURL = webView2.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(ptX), \(ptY)).src")!
     _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "handleLongTouch", userInfo: nil, repeats: false)
     }
     } else {
     if (components[2] == "move") {
     self._gesState = 2
     print("you are move")
     } else {
     if (components[2] == "end") {
     _timer.invalidate()
     self._timer = NSTimer()
     self._gesState = 4
     print("touch end")
     }
     }
     }
     }
     return false
     }
     return true
     }
     
     func handleLongTouch() {
     print("Image URL = \(_imgURL)")
     if (_gesState == 1) {
     print("YES!!! I DID IT!!!")
     }
     }
     
     */
    
    /*
     
     func handleLongTouch() {
     print("Image URL = \(_imgURL)")
     if (_gesState == 1) {
     print("YES!!! I DID IT!!!")
     }
     }
     */
    
    
    @IBAction func closeBTN(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func snipPictureBTN(_ sender: AnyObject) {
        
        if !snipVisible {
            self.snipView.isHidden = false
            snipVisible = true
            
            resizeH = (snipView.frame.size.height)
            
            //   resizeW = resizeIMG.frame.width
            resizeW = (snipView.frame.size.width)
            
            // resizeH = (snipImage.image?.size.height)!
            
            //   resizeW = resizeIMG.frame.width
            // resizeW = (snipImage.image?.size.width)!
            
            // resizeHEIGHT.constant = DeviceW - 50
            //  resizeWIDTH.constant = DeviceW - 50
            
            
            //  self.resizeX = DeviceW - (resizeIMG.frame.width / 2)
            //  self.resizeY = DeviceH - (resizeIMG.frame.height / 2)
            
            self.resizeX = snipView.center.x
            self.resizeY = snipView.center.y
            
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                
                // self.ShowQuoteViewTOP.constant = middleY
                
                self.SnipControlsView.center.y = self.SnipControlsView.center.y - 50
                self.SnipControlsView.center.x = self.SnipControlsView.center.x + 50
                
                self.SnipControlsViewBOTTOM.constant = 10
                self.SnipControlsViewH.constant = 40
                self.SnipControlsViewW.constant = 130
                self.SnipControlsViewLEAD.constant = 10
                
                //self.ViewShowing = true
                // ShowingInfo = true
                
                // self.ViewTransTOP.constant = 0
            })
            
            
            snipVisible = true
            
            
        } else {
            self.snipView.isHidden = true
            
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                
                // self.ShowQuoteViewTOP.constant = middleY
                
                self.SnipControlsView.center.y = self.SnipControlsView.center.y + 50
                self.SnipControlsView.center.x = self.SnipControlsView.center.x - 50
                
                self.SnipControlsViewBOTTOM.constant = -20
                self.SnipControlsViewH.constant = 0
                self.SnipControlsViewW.constant = 0
                self.SnipControlsViewLEAD.constant = -20
                
                //self.ViewShowing = true
                // ShowingInfo = true
                
                // self.ViewTransTOP.constant = 0
            })
            
            snipVisible = false
        }
        
        
    }
    
    
    @IBAction func saveBTN(_ sender: AnyObject) {
        
        
        print("the image data in save BTN = \(imageData)")
        
        
        // let imageData2 = UIImageJPEGRepresentation(snipImage.image!, 1.0)!;
        
        let ImageBase64DataString = imageData
        
        // let ImageBase64DataString = String(data: imageData, encoding: NSUTF8StringEncoding)
        
        
        // print("image base data \(ImageBase64DataString)")
        
        
        // self.theImageData = ImageBase64DataString!
        
        
        // self.prefs.setValue(ImageBase64DataString, forKey: "GOOGLEDATAD")
        
        
        if FromNVC {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "googleImageNVC"), object: nil, userInfo: ["data":ImageBase64DataString]);
            
        } else {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "googleImage"), object: nil, userInfo: ["data":ImageBase64DataString]);
            
        }
        self.dismiss(animated: true, completion: nil)
        
        /*
         if self.theImageData != "" {
         self.closeView()
         } else {
         let AC = JSController("Error", MyMessage: "Error selecting the image, please try again",Color: "Red")
         self.presentViewController(AC, animated: true, completion: nil)
         }
         
         */
        
    }
    
    
    @IBAction func closeControls(_ sender: AnyObject) {
        
        self.snipView.isHidden = true
        
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            
            // self.ShowQuoteViewTOP.constant = middleY
            
            self.SnipControlsView.center.y = self.SnipControlsView.center.y + 50
            self.SnipControlsView.center.x = self.SnipControlsView.center.x - 50
            
            self.SnipControlsViewBOTTOM.constant = -20
            self.SnipControlsViewH.constant = 0
            self.SnipControlsViewW.constant = 0
            self.SnipControlsViewLEAD.constant = -20
            
            //self.ViewShowing = true
            // ShowingInfo = true
            
            // self.ViewTransTOP.constant = 0
        })
        
        self.trimSaveBTN.isHidden = true
        snipVisible = false
        snipImage.image = nil
        
    }
    
    @IBAction func CaptureScreen(_ sender: AnyObject) {
        
        print("CAPTURE resize x = \(resizeX)")
        print("CAPTURE resize y = \(resizeY)")
        print("CAPTURE resize height = \(resizeH)")
        print("CAPTURE resize Width = \(resizeW)")
        
        self.snipView.isHidden = true
        //   let snipTemp = self.snipView.pb_takeSnapshot(resizeX, y: resizeY, h: resizeH, w: resizeW)
        
        
        
        
        
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: resizeH,height: resizeW), false, 0)
        
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        
        // drawViewHierarchyInRect(CGRectMake(-01, -01, self.frame.size.width, self.frame.size.height), afterScreenUpdates: true)
        
        //  self.view.drawViewHierarchyInRect(CGRectMake((resizeX), (resizeY), resizeW, resizeH), afterScreenUpdates: true)
        
        
        //  self.view.drawViewHierarchyInRect(CGRectMake((-1 * resizeX), (-1 * resizeY), snipView.bounds.size.width, snipView.bounds.size.height), afterScreenUpdates: true)
        
        //   self.view.drawViewHierarchyInRect(CGRectMake((-100), (-100), snipView.bounds.size.width, snipView.bounds.size.height), afterScreenUpdates: true)
        
        let FromSide = resizeX - (resizeW / 2)
        let FromTop = resizeY - (resizeH / 2)
        
        print("From Side = \(FromSide)")
        print("From Top = \(FromTop)")
        
        //  self.view.drawViewHierarchyInRect(CGRectMake(-(resizeX), -(resizeY), self.view.frame.width, self.view.frame.height), afterScreenUpdates: true)
        
        
        self.view.drawHierarchy(in: CGRect(x: -(FromSide), y: -(FromTop), width: self.view.frame.width, height: self.view.frame.height), afterScreenUpdates: true)
        
        
        // var snipTemp  = UIGraphicsGetImageFromCurrentImageContext()
        
        self.snipImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.snipImage.isHidden = false
        
        
        //self.snipImage.image = snipTemp
        self.snipView.isHidden = false
        imageData = UIImageJPEGRepresentation(snipImage.image!, 1.0)!;
        
        print("ImageNSData = \(imageData)")
        self.trimSaveBTN.isHidden = false
        
        
        //self.snippedPic.image = snipTemp
        //  self.snippedPic.hidden = false
    }
    
    @IBAction func howtoBTN(_ sender: AnyObject) {
        
        let AC = JSController("Select Image", MyMessage: "Broswe Google Images for an Image to insert.  Tap and hold on an image to select it, then tap 'Import Image' to add the selected image.",Color: "Red")
        self.present(AC, animated: true, completion: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("did finish loading web page")
        print("request = \(request.url)")
        thewebURL = String(describing: request.url) as NSString
        
        //thewebURL = request.description
        urlText.text = thewebURL as String
        
        
        let js: String = "document.elementFromPoint(\(XPoint), \(YPoint)).tagName"
        let tagName: String = webView2.stringByEvaluatingJavaScript(from: js)!
        
        
        //   _imgURL = webView2.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(XPoint), \(YPoint)).src")!
        //   _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "handleLongTouch", userInfo: nil, repeats: false)
        print("Tag Name = \(tagName)")
        
        return true
    }
    
    
    func webView(_ webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("did finish navigation")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let currentURL = self.webView2.request!.url?.absoluteString
        
        print("Current URL = \(currentURL)")
        
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("stared loading web view")
    }
    
    
    @IBAction func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            print("resized Image X = \(view.center.x)")
            print("resized Image Y = \(view.center.y)")
            self.resizeX = view.center.x
            self.resizeY = view.center.y
            
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    @IBAction func handlePinch(_ recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
        
        self.snipView.transform = self.snipView.transform.scaledBy(x: sender.scale, y: sender.scale)
        //  self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale, sender.scale)
        
        sender.scale = 1
        print("resized Image H = \(snipView.frame.height)")
        print("resized Image W = \(snipView.frame.width)")
        resizeH = snipView.frame.height
        resizeW = snipView.frame.width
        
        /*
         
         
         self.snipImage.transform = CGAffineTransformScale(self.snipImage.transform, sender.scale, sender.scale)
         //  self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale, sender.scale)
         
         sender.scale = 1
         print("resized Image H = \(snipImage.frame.height)")
         print("resized Image W = \(snipImage.frame.width)")
         resizeH = snipImage.frame.height
         resizeW = snipImage.frame.width
         
         */
        /*+
         
         if fromGoogle {
         resizeW = (resizeIMG.image?.size.width)!
         resizeH = (resizeIMG.image?.size.height)!
         } else {
         resizeW = (resizeIMG.frame.width)
         resizeH = (resizeIMG.frame.height)
         }
         */
        
    }
    
    @IBAction func handleRotate(_ recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        // let snipTemp = self.snipView.pb_takeSnapshot()
        // self.snippedPic.image = snipTemp
        // self.snippedPic.hidden = false
        
        // self.chompPlayer?.play()
    }
    
    
    /*
     func gestureRecognizer(UIGestureRecognizer,
     shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
     return true
     }
     */
    
    /*
     override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
     testTouches(touches)
     }
     
     override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
     testTouches(touches)
     }
     */
    
    func prepareAd() {
        print(" --- AD: Try Load ---")
        // Attempt to load a new ad:
        interAd = ADInterstitialAd()
        interAd?.delegate = self
    }
    
    func showAd() -> Bool {
        if interAd != nil && interAd!.isLoaded {
            interAdView = UIView()
            interAdView.frame = self.view!.bounds
            self.view?.addSubview(interAdView)
            
            interAd!.present(in: interAdView)
            UIViewController.prepareInterstitialAds()
            
            interAdView.addSubview(closeButton)
        }
        
        // Return true if we're showing an ad, false if an ad can't be displayed:
        return interAd?.isLoaded ?? false
    }
    
    // When the user clicks the close button, route to the adFinished function:
    func closeAd(_ sender: UIButton) {
        adFinished()
    }
    
    // A function of common functionality to run when the user returns to your app:
    func adFinished() {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        // (Do whatever is next in your app)
    }
    
    // The ad loaded successfully (we don't need to do anything for the basic implementation)
    func interstitialAdDidLoad(_ interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Load Success ---")
    }
    
    // The ad unloaded (we don't need to do anything for the basic implementation)
    func interstitialAdDidUnload(_ interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Unload --- ")
    }
    
    // This is called if the user clicks into the interstitial, and then finishes interacting with the ad
    // We'll call our adFinished function since we're returning to our app:
    func interstitialAdActionDidFinish(_ interstitialAd: ADInterstitialAd!) {
        print(" --- ADD: Action Finished --- ")
        adFinished()
    }
    
    func interstitialAdActionShouldBegin(_ interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    // Error in the ad load, print out the error
    func interstitialAd(_ interstitialAd: ADInterstitialAd!, didFailWithError error: Error!) {
        print(" --- AD: Error --- ")
        print(error.localizedDescription)
    }
    
    fileprivate func showIntersitialAd() { //call this method whenever you want to show an interstitial
        self.requestInterstitialAdPresentation()
    }
    
    
}


/*
 extension UIView {
 
 func pb_takeSnapshot(x: CGFloat, y: CGFloat, h: CGFloat, w: CGFloat) -> UIImage {
 
 
 
 var keyWindow = UIApplication.sharedApplication().keyWindow!
 var theSize = CGSize(width: w, height: h)
 var theRect = CGRect(x: x, y: y, width: w, height: h)
 
 //UIGraphicsBeginImageContextWithOptions(theRect.size, false, UIScreen.mainScreen().scale)
 
 UIGraphicsBeginImageContextWithOptions(theRect.size, false, 0)
 
 UIGraphicsBeginImageContext(bounds.size)
 
 // UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
 
 var context:CGContextRef = UIGraphicsGetCurrentContext()!
 
 keyWindow.layer.renderInContext(context)
 
 print("x from the extension = \(x)")
 print("y fromt the extension = \(y)")
 
 drawViewHierarchyInRect(CGRectMake((-1 * x),(-1 * y), self.frame.size.width, self.frame.size.height), afterScreenUpdates: true)
 
 //drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
 
 //drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
 // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
 
 let image = UIGraphicsGetImageFromCurrentImageContext()
 
 
 UIGraphicsEndImageContext()
 
 
 
 let imageRef = CGImageCreateWithImageInRect(image.CGImage, theRect);
 
 // var finalImage = UIImage(CGImage: imageRef!)
 //[UIImage imageWithCGImage:imageRef];
 
 // return finalImage
 
 
 
 return image
 }
 
 
 func screenShot(x: CGFloat, y: CGFloat, h: CGFloat, w: CGFloat) -> UIImage {
 
 
 
 
 //  UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width*0.99,self.frame.size.height*0.70), false, 0)
 
 UIGraphicsBeginImageContextWithOptions(CGSizeMake(h,w), false, 0)
 
 var image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
 
 drawViewHierarchyInRect(CGRectMake(-01, -01, self.frame.size.width, self.frame.size.height), afterScreenUpdates: true)
 
 //    drawViewHierarchyInRect(CGRectMake(-01, -01, snipView.bounds.size.width, self.frame.size.height), afterScreenUpdates: true)
 
 var screenShot  = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 
 return screenShot
 }
 }
 
 */

