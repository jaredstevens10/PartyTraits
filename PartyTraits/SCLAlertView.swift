//
//  SCLAlertView.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 3/17/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

//
//  SCLAlertView.swift
//  TelePictionary
//
//  Created by Jared Stevens2 on 1/6/16.
//  Copyright © 2016 Claven Solutions. All rights reserved.
//

//import Foundation

//
//  SCLAlertView.swift
//  SCLAlertView Example
//
//  Created by Viktor Radchenko on 6/5/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



/*
// Pop Up Styles
public enum SCLAlertViewStyle {
case Success, Error, Notice, Warning, Info, Edit, Wait, Custom
}

// Action Types
public enum SCLActionType {
case None, Selector, Closure
}

// Button sub-class
public class SCLButton: UIButton {
var actionType = SCLActionType.None
var target:AnyObject!
var selector:Selector!
var action:(()->Void)!

public init() {
super.init(frame: CGRectZero)
}

required public init?(coder aDecoder: NSCoder) {
super.init(coder:aDecoder)
}

override public init(frame:CGRect) {
super.init(frame:frame)
}
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
public class SCLAlertViewResponder {
let alertview: SCLAlertView

// Initialisation and Title/Subtitle/Close functions
public init(alertview: SCLAlertView) {
self.alertview = alertview
}

public func setTitle(title: String) {
self.alertview.labelTitle.text = title
}

public func setSubTitle(subTitle: String) {
self.alertview.viewText.text = subTitle
}

public func close() {
self.alertview.hideView()
}
}

let kCircleHeightBackground: CGFloat = 62.0

//let kCircleHeightBackgroundCustom: CGFloat = 80.0

// The Main Class
public class SCLAlertView: UIViewController {
let kDefaultShadowOpacity: CGFloat = 0.7
let kCircleTopPosition: CGFloat = -12.0
let kCircleBackgroundTopPosition: CGFloat = -15.0
let kCircleHeight: CGFloat = 56.0
let kCircleIconHeight: CGFloat = 20.0


//  let kCircleHeightCustom: CGFloat = 70.0
//  let kCircleIconHeightCustom: CGFloat = 40.0


let kTitleTop:CGFloat = 30.0
let kTitleHeight:CGFloat = 40.0
let kWindowWidth: CGFloat = 240.0
var kWindowHeight: CGFloat = 178.0
var kTextHeight: CGFloat = 90.0
let kTextFieldHeight: CGFloat = 45.0
let kButtonHeight: CGFloat = 45.0

// Font
//let kDefaultFont = "HelveticaNeue"
let kDefaultFont = "DK Cool Crayon"
let kButtonFont = "HelveticaNeue-Bold"

// UI Colour
var viewColor = UIColor()
var pressBrightnessFactor = 0.85

// UI Options
public var showCloseButton = true

// Members declaration
var baseView = UIView()
var labelTitle = UILabel()
var viewText = UITextView()
var contentView = UIView()
var circleBG = UIView(frame:CGRect(x:0, y:0, width:kCircleHeightBackground, height:kCircleHeightBackground))
var circleView = UIView()


// var circleBGCustom = UIView(frame:CGRect(x:0, y:0, width:kCircleHeightBackgroundCustom, height:kCircleHeightBackgroundCustom))
//  var circleViewCustom = UIView()

var circleIconView : UIView?

//   var circleIconViewCustom : UIView?

var durationTimer: NSTimer!
private var inputs = [UITextField]()
private var buttons = [SCLButton]()
private var selfReference: SCLAlertView?

required public init?(coder aDecoder: NSCoder) {
fatalError("NSCoding not supported")
}

required public init() {
super.init(nibName:nil, bundle:nil)
// Set up main view
view.frame = UIScreen.mainScreen().bounds
view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:kDefaultShadowOpacity)
view.addSubview(baseView)
// Base View
baseView.frame = view.frame
baseView.addSubview(contentView)
// Content View
contentView.backgroundColor = UIColor(white:1, alpha:1)
contentView.layer.cornerRadius = 5
contentView.layer.masksToBounds = true
contentView.layer.borderWidth = 0.5
contentView.addSubview(labelTitle)
contentView.addSubview(viewText)
// Circle View
circleBG.backgroundColor = UIColor.whiteColor()
circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
baseView.addSubview(circleBG)
circleBG.addSubview(circleView)
let x = (kCircleHeightBackground - kCircleHeight) / 2

circleView.frame = CGRect(x:x, y:x, width:kCircleHeight, height:kCircleHeight)
circleView.layer.cornerRadius = circleView.frame.size.height / 2

//  circleViewCustom.frame = CGRect(x:x, y:x, width:kCircleHeight, height:kCircleHeight)
//  circleViewCustom.layer.cornerRadius = circleView.frame.size.height / 2



// Title
labelTitle.numberOfLines = 1
labelTitle.textAlignment = .Center
labelTitle.font = UIFont(name: kDefaultFont, size:20)
labelTitle.frame = CGRect(x:12, y:kTitleTop, width: kWindowWidth - 24, height:kTitleHeight)
// View text
viewText.editable = false
viewText.textAlignment = .Center
viewText.textContainerInset = UIEdgeInsetsZero
viewText.textContainer.lineFragmentPadding = 0;
viewText.font = UIFont(name: kDefaultFont, size:14)
// Colours
contentView.backgroundColor = UIColorFromRGB(0xFFFFFF)
labelTitle.textColor = UIColorFromRGB(0x4D4D4D)
viewText.textColor = UIColorFromRGB(0x4D4D4D)
contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor
//Gesture Recognizer for tapping outside the textinput
let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
tapGesture.numberOfTapsRequired = 1
self.view.addGestureRecognizer(tapGesture)
}

override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
}

override public func viewWillLayoutSubviews() {
super.viewWillLayoutSubviews()
let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
let sz = rv.frame.size

// Set background frame
view.frame.size = sz

// computing the right size to use for the textView
let maxHeight = sz.height - 100 // max overall height
var consumedHeight = CGFloat(0)
consumedHeight += kTitleTop + kTitleHeight
consumedHeight += 14
consumedHeight += kButtonHeight * CGFloat(buttons.count)
consumedHeight += kTextFieldHeight * CGFloat(inputs.count)
let maxViewTextHeight = maxHeight - consumedHeight
let viewTextWidth = kWindowWidth - 24
let suggestedViewTextSize = viewText.sizeThatFits(CGSizeMake(viewTextWidth, CGFloat.max))
let viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)

// scroll management
if (suggestedViewTextSize.height > maxViewTextHeight) {
viewText.scrollEnabled = true
} else {
viewText.scrollEnabled = false
}

let windowHeight = consumedHeight + viewTextHeight
// Set frames
var x = (sz.width - kWindowWidth) / 2
var y = (sz.height - windowHeight - (kCircleHeight / 8)) / 2
contentView.frame = CGRect(x:x, y:y, width:kWindowWidth, height:windowHeight)
y -= kCircleHeightBackground * 0.6
x = (sz.width - kCircleHeightBackground) / 2

circleBG.frame = CGRect(x:x, y:y+6, width:kCircleHeightBackground, height:kCircleHeightBackground)

//  circleBGCustom.frame = CGRect(x:x, y:y+6, width:kCircleHeightBackgroundCustom, height:kCircleHeightBackgroundCustom)


// Subtitle
y = kTitleTop + kTitleHeight
viewText.frame = CGRect(x:12, y:y, width: kWindowWidth - 24, height:kTextHeight)
viewText.frame = CGRect(x:12, y:y, width: viewTextWidth, height:viewTextHeight)
// Text fields
y += viewTextHeight + 14.0
for txt in inputs {
txt.frame = CGRect(x:12, y:y, width:kWindowWidth - 24, height:30)
txt.layer.cornerRadius = 3
y += kTextFieldHeight
}
// Buttons
for btn in buttons {
btn.frame = CGRect(x:12, y:y, width:kWindowWidth - 24, height:35)
btn.layer.cornerRadius = 3
y += kButtonHeight
}
}

override public func touchesEnded(touches:Set<UITouch>, withEvent event:UIEvent?) {
if event?.touchesForView(view)?.count > 0 {
view.endEditing(true)
}
}

public func addTextField(title:String?=nil)->UITextField {
// Update view height
kWindowHeight += kTextFieldHeight
// Add text field
let txt = UITextField()
txt.borderStyle = UITextBorderStyle.RoundedRect
txt.font = UIFont(name:kDefaultFont, size: 14)
txt.autocapitalizationType = UITextAutocapitalizationType.Words
txt.clearButtonMode = UITextFieldViewMode.WhileEditing
txt.layer.masksToBounds = true
txt.layer.borderWidth = 1.0
if title != nil {
txt.placeholder = title!
}
contentView.addSubview(txt)
inputs.append(txt)
return txt
}

public func addButton(title:String, action:()->Void)->SCLButton {
let btn = addButton(title)
btn.actionType = SCLActionType.Closure
btn.action = action
btn.addTarget(self, action:Selector("buttonTapped:"), forControlEvents:.TouchUpInside)
btn.addTarget(self, action:Selector("buttonTapDown:"), forControlEvents:[.TouchDown, .TouchDragEnter])
btn.addTarget(self, action:Selector("buttonRelease:"), forControlEvents:[.TouchUpInside, .TouchUpOutside, .TouchCancel, .TouchDragOutside] )
return btn
}

public func addButton(title:String, target:AnyObject, selector:Selector)->SCLButton {
let btn = addButton(title)
btn.actionType = SCLActionType.Selector
btn.target = target
btn.selector = selector
btn.addTarget(self, action:Selector("buttonTapped:"), forControlEvents:.TouchUpInside)
btn.addTarget(self, action:Selector("buttonTapDown:"), forControlEvents:[.TouchDown, .TouchDragEnter])
btn.addTarget(self, action:Selector("buttonRelease:"), forControlEvents:[.TouchUpInside, .TouchUpOutside, .TouchCancel, .TouchDragOutside] )
return btn
}

private func addButton(title:String)->SCLButton {
// Update view height
kWindowHeight += kButtonHeight
// Add button
let btn = SCLButton()
btn.layer.masksToBounds = true
btn.setTitle(title, forState: .Normal)
btn.titleLabel?.font = UIFont(name:kButtonFont, size: 14)
contentView.addSubview(btn)
buttons.append(btn)
return btn
}

func buttonTapped(btn:SCLButton) {
if btn.actionType == SCLActionType.Closure {
btn.action()
} else if btn.actionType == SCLActionType.Selector {
let ctrl = UIControl()
ctrl.sendAction(btn.selector, to:btn.target, forEvent:nil)
return
} else {
print("Unknow action type for button")
}
hideView()
}


func buttonTapDown(btn:SCLButton) {
var hue : CGFloat = 0
var saturation : CGFloat = 0
var brightness : CGFloat = 0
var alpha : CGFloat = 0
btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
//brightness = brightness * CGFloat(pressBrightness)
btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
}

func buttonRelease(btn:SCLButton) {
btn.backgroundColor = viewColor
}

//Dismiss keyboard when tapped outside textfield
func dismissKeyboard(){
self.view.endEditing(true)
}

// showSuccess(view, title, subTitle)
public func showSuccess(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0x22B573, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Success, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showError(view, title, subTitle)
public func showError(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0xC1272D, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Error, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showNotice(view, title, subTitle)
public func showNotice(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0x727375, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Notice, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showWarning(view, title, subTitle)
public func showWarning(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0xFFD110, colorTextButton: UInt=0x000000) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Warning, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showInfo(view, title, subTitle)
public func showInfo(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0x2866BF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Info, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showWait(view, title, subTitle)
public func showWait(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt?=0xD62DA5, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Wait, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

public func showEdit(title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Edit, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

public func showCustom(image: UIImage, color: UIColor, title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showCustom(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Custom, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

public func showCustomOK(image: UIImage, color: UIColor, title: String, subTitle: String, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showCustom(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .Custom, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showTitle(view, title, subTitle, style)
public func showTitle(title: String, subTitle: String, style: SCLAlertViewStyle, closeButtonTitle:String?=nil, duration:NSTimeInterval=0.0, colorStyle: UInt?, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
return showTitle(title, subTitle: subTitle, duration:duration, completeText:closeButtonTitle, style: style, colorStyle: colorStyle, colorTextButton: colorTextButton)
}

// showTitle(view, title, subTitle, duration, style)

public func showCustom(theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: NSTimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
selfReference = self
view.alpha = 0
let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
rv.addSubview(view)
view.frame = rv.bounds
baseView.frame = rv.bounds

// Alert colour/icon
viewColor = UIColor()
var iconImage: UIImage?

// Icon style
switch style {
case .Success:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCheckmark

case .Error:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCross

case .Notice:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfNotice

case .Warning:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfWarning

case .Info:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfInfo

case .Edit:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfEdit

case .Wait:
viewColor = UIColorFromRGB(colorStyle!)

case .Custom:
// viewColor = UIColorFromRGB(colorStyle!)
viewColor = color
iconImage = theImage
}

// Title
if !title.isEmpty {
self.labelTitle.text = title
}

// Subtitle
if !subTitle.isEmpty {
viewText.text = subTitle
// Adjust text view size, if necessary
let str = subTitle as NSString
let attr = [NSFontAttributeName:viewText.font ?? UIFont()]
let sz = CGSize(width: kWindowWidth - 24, height:90)
let r = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attr, context:nil)
let ht = ceil(r.size.height)
if ht < kTextHeight {
kWindowHeight -= (kTextHeight - ht)
kTextHeight = ht
}
}

// Done button

showCloseButton = false

if showCloseButton {
let txt = completeText != nil ? completeText! : "Done"
addButton(txt, target:self, selector:Selector("hideView"))
}

// Alert view colour and images
circleView.backgroundColor = viewColor
// Spinner / icon
if style == .Wait {
let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
indicator.startAnimating()
circleIconView = indicator
}
else {
circleIconView = UIImageView(image: iconImage!)

}


/*
circleViewCustom.addSubview(circleIconViewCustom!)
let x = (kCircleHeightCustom - kCircleIconHeightCustom) / 2
let x4 = (kCircleHeightCustom - kCircleIconHeightCustom) / 4
let x2 = (kCircleHeightCustom - 10)
circleIconViewCustom!.frame = CGRectMake( x4, x4, x2, x2)
*/


let x = (kCircleHeight - kCircleIconHeight) / 2
circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)

for txt in inputs {
txt.layer.borderColor = viewColor.CGColor
}
for btn in buttons {
btn.backgroundColor = viewColor
btn.setTitleColor(UIColorFromRGB(colorTextButton!), forState:UIControlState.Normal)
}

// Adding duration
if duration > 0 {
durationTimer?.invalidate()
durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration!, target: self, selector: Selector("hideView"), userInfo: nil, repeats: false)
}

// Animate in the alert view
self.baseView.frame.origin.y = -400
UIView.animateWithDuration(0.2, animations: {
self.baseView.center.y = rv.center.y + 15
self.view.alpha = 1
}, completion: { finished in
UIView.animateWithDuration(0.2, animations: {
self.baseView.center = rv.center
})
})
// Chainable objects
return SCLAlertViewResponder(alertview: self)
}


public func showCustomOK(theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: NSTimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
selfReference = self
view.alpha = 0
let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
rv.addSubview(view)
view.frame = rv.bounds
baseView.frame = rv.bounds

// Alert colour/icon
viewColor = UIColor()
var iconImage: UIImage?

// Icon style
switch style {
case .Success:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCheckmark

case .Error:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCross

case .Notice:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfNotice

case .Warning:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfWarning

case .Info:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfInfo

case .Edit:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfEdit

case .Wait:
viewColor = UIColorFromRGB(colorStyle!)

case .Custom:
// viewColor = UIColorFromRGB(colorStyle!)
viewColor = color
iconImage = theImage
}

// Title
if !title.isEmpty {
self.labelTitle.text = title
}

// Subtitle
if !subTitle.isEmpty {
viewText.text = subTitle
// Adjust text view size, if necessary
let str = subTitle as NSString
let attr = [NSFontAttributeName:viewText.font ?? UIFont()]
let sz = CGSize(width: kWindowWidth - 24, height:90)
let r = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attr, context:nil)
let ht = ceil(r.size.height)
if ht < kTextHeight {
kWindowHeight -= (kTextHeight - ht)
kTextHeight = ht
}
}

// Done button

showCloseButton = true

if showCloseButton {
let txt = completeText != nil ? completeText! : "OK"
addButton(txt, target:self, selector:Selector("hideView"))
}

// Alert view colour and images
circleView.backgroundColor = viewColor
// Spinner / icon
if style == .Wait {
let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
indicator.startAnimating()
circleIconView = indicator
}
else {
circleIconView = UIImageView(image: iconImage!)
}

circleView.addSubview(circleIconView!)
//  let x = (kCircleHeight - kCircleIconHeight) / 4
//  let x2 = (kCircleHeight - 10)

//  let x5 = (kCircleHeight - 5)
//let x2 = (kCircleHeight - 10)


//circleIconView!.frame = CGRectMake( x, x, x5, x5)

let x = (kCircleHeight - kCircleIconHeight) / 2
circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)

for txt in inputs {
txt.layer.borderColor = viewColor.CGColor
}
for btn in buttons {
btn.backgroundColor = viewColor
btn.setTitleColor(UIColorFromRGB(colorTextButton!), forState:UIControlState.Normal)
}

// Adding duration
if duration > 0 {
durationTimer?.invalidate()
durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration!, target: self, selector: Selector("hideView"), userInfo: nil, repeats: false)
}

// Animate in the alert view
self.baseView.frame.origin.y = -400
UIView.animateWithDuration(0.2, animations: {
self.baseView.center.y = rv.center.y + 15
self.view.alpha = 1
}, completion: { finished in
UIView.animateWithDuration(0.2, animations: {
self.baseView.center = rv.center
})
})
// Chainable objects
return SCLAlertViewResponder(alertview: self)
}


public func showTitle(title: String, subTitle: String, duration: NSTimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
selfReference = self
view.alpha = 0
let rv = UIApplication.sharedApplication().keyWindow! as UIWindow
rv.addSubview(view)
view.frame = rv.bounds
baseView.frame = rv.bounds

// Alert colour/icon
viewColor = UIColor()
var iconImage: UIImage?

// Icon style
switch style {
case .Success:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCheckmark

case .Error:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfCross

case .Notice:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfNotice

case .Warning:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfWarning

case .Info:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfInfo

case .Edit:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfEdit

case .Wait:
viewColor = UIColorFromRGB(colorStyle!)

case .Custom:
viewColor = UIColorFromRGB(colorStyle!)
iconImage = SCLAlertViewStyleKit.imageOfEdit
}

// Title
if !title.isEmpty {
self.labelTitle.text = title
}

// Subtitle
if !subTitle.isEmpty {
viewText.text = subTitle
// Adjust text view size, if necessary
let str = subTitle as NSString
let attr = [NSFontAttributeName:viewText.font ?? UIFont()]
let sz = CGSize(width: kWindowWidth - 24, height:90)
let r = str.boundingRectWithSize(sz, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attr, context:nil)
let ht = ceil(r.size.height)
if ht < kTextHeight {
kWindowHeight -= (kTextHeight - ht)
kTextHeight = ht
}
}

// Done button
if showCloseButton {
let txt = completeText != nil ? completeText! : "Done"
addButton(txt, target:self, selector:Selector("hideView"))
}

// Alert view colour and images
circleView.backgroundColor = viewColor
// Spinner / icon
if style == .Wait {
let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
indicator.startAnimating()
circleIconView = indicator
}
else {
circleIconView = UIImageView(image: iconImage!)
}
circleView.addSubview(circleIconView!)
let x = (kCircleHeight - kCircleIconHeight) / 2
circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)

for txt in inputs {
txt.layer.borderColor = viewColor.CGColor
}
for btn in buttons {
btn.backgroundColor = viewColor
btn.setTitleColor(UIColorFromRGB(colorTextButton!), forState:UIControlState.Normal)
}

// Adding duration
if duration > 0 {
durationTimer?.invalidate()
durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration!, target: self, selector: Selector("hideView"), userInfo: nil, repeats: false)
}

// Animate in the alert view
self.baseView.frame.origin.y = -400
UIView.animateWithDuration(0.2, animations: {
self.baseView.center.y = rv.center.y + 15
self.view.alpha = 1
}, completion: { finished in
UIView.animateWithDuration(0.2, animations: {
self.baseView.center = rv.center
})
})
// Chainable objects
return SCLAlertViewResponder(alertview: self)
}

// Close SCLAlertView
public func hideView() {
UIView.animateWithDuration(0.2, animations: {
self.view.alpha = 0
}, completion: { finished in
self.view.removeFromSuperview()
self.selfReference = nil
})
}

// Helper function to convert from RGB to UIColor
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
return UIColor(
red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
alpha: CGFloat(1.0)
)
}
}

// ------------------------------------
// Icon drawing
// Code generated by PaintCode
// ------------------------------------

class SCLAlertViewStyleKit : NSObject {

// Cache
struct Cache {
static var imageOfCheckmark: UIImage?
static var checkmarkTargets: [AnyObject]?
static var imageOfCross: UIImage?
static var crossTargets: [AnyObject]?
static var imageOfNotice: UIImage?
static var noticeTargets: [AnyObject]?
static var imageOfWarning: UIImage?
static var warningTargets: [AnyObject]?
static var imageOfInfo: UIImage?
static var infoTargets: [AnyObject]?
static var imageOfEdit: UIImage?
static var editTargets: [AnyObject]?
}

// Initialization
/// swift 1.2 abolish func load
//    override class func load() {
//    }

// Drawing Methods
class func drawCheckmark() {
// Checkmark Shape Drawing
let checkmarkShapePath = UIBezierPath()
checkmarkShapePath.moveToPoint(CGPointMake(73.25, 14.05))
checkmarkShapePath.addCurveToPoint(CGPointMake(64.51, 13.86), controlPoint1: CGPointMake(70.98, 11.44), controlPoint2: CGPointMake(66.78, 11.26))
checkmarkShapePath.addLineToPoint(CGPointMake(27.46, 52))
checkmarkShapePath.addLineToPoint(CGPointMake(15.75, 39.54))
checkmarkShapePath.addCurveToPoint(CGPointMake(6.84, 39.54), controlPoint1: CGPointMake(13.48, 36.93), controlPoint2: CGPointMake(9.28, 36.93))
checkmarkShapePath.addCurveToPoint(CGPointMake(6.84, 49.02), controlPoint1: CGPointMake(4.39, 42.14), controlPoint2: CGPointMake(4.39, 46.42))
checkmarkShapePath.addLineToPoint(CGPointMake(22.91, 66.14))
checkmarkShapePath.addCurveToPoint(CGPointMake(27.28, 68), controlPoint1: CGPointMake(24.14, 67.44), controlPoint2: CGPointMake(25.71, 68))
checkmarkShapePath.addCurveToPoint(CGPointMake(31.65, 66.14), controlPoint1: CGPointMake(28.86, 68), controlPoint2: CGPointMake(30.43, 67.26))
checkmarkShapePath.addLineToPoint(CGPointMake(73.08, 23.35))
checkmarkShapePath.addCurveToPoint(CGPointMake(73.25, 14.05), controlPoint1: CGPointMake(75.52, 20.75), controlPoint2: CGPointMake(75.7, 16.65))
checkmarkShapePath.closePath()
checkmarkShapePath.miterLimit = 4;

UIColor.whiteColor().setFill()
checkmarkShapePath.fill()
}

class func drawCross() {
// Cross Shape Drawing
let crossShapePath = UIBezierPath()
crossShapePath.moveToPoint(CGPointMake(10, 70))
crossShapePath.addLineToPoint(CGPointMake(70, 10))
crossShapePath.moveToPoint(CGPointMake(10, 10))
crossShapePath.addLineToPoint(CGPointMake(70, 70))
crossShapePath.lineCapStyle = CGLineCap.Round;
crossShapePath.lineJoinStyle = CGLineJoin.Round;
UIColor.whiteColor().setStroke()
crossShapePath.lineWidth = 14
crossShapePath.stroke()
}

class func drawNotice() {
// Notice Shape Drawing
let noticeShapePath = UIBezierPath()
noticeShapePath.moveToPoint(CGPointMake(72, 48.54))
noticeShapePath.addLineToPoint(CGPointMake(72, 39.9))
noticeShapePath.addCurveToPoint(CGPointMake(66.38, 34.01), controlPoint1: CGPointMake(72, 36.76), controlPoint2: CGPointMake(69.48, 34.01))
noticeShapePath.addCurveToPoint(CGPointMake(61.53, 35.97), controlPoint1: CGPointMake(64.82, 34.01), controlPoint2: CGPointMake(62.69, 34.8))
noticeShapePath.addCurveToPoint(CGPointMake(60.36, 35.78), controlPoint1: CGPointMake(61.33, 35.97), controlPoint2: CGPointMake(62.3, 35.78))
noticeShapePath.addLineToPoint(CGPointMake(60.36, 33.22))
noticeShapePath.addCurveToPoint(CGPointMake(54.16, 26.16), controlPoint1: CGPointMake(60.36, 29.3), controlPoint2: CGPointMake(57.65, 26.16))
noticeShapePath.addCurveToPoint(CGPointMake(48.73, 29.89), controlPoint1: CGPointMake(51.64, 26.16), controlPoint2: CGPointMake(50.67, 27.73))
noticeShapePath.addLineToPoint(CGPointMake(48.73, 28.71))
noticeShapePath.addCurveToPoint(CGPointMake(43.49, 21.64), controlPoint1: CGPointMake(48.73, 24.78), controlPoint2: CGPointMake(46.98, 21.64))
noticeShapePath.addCurveToPoint(CGPointMake(39.03, 25.37), controlPoint1: CGPointMake(40.97, 21.64), controlPoint2: CGPointMake(39.03, 23.01))
noticeShapePath.addLineToPoint(CGPointMake(39.03, 9.07))
noticeShapePath.addCurveToPoint(CGPointMake(32.24, 2), controlPoint1: CGPointMake(39.03, 5.14), controlPoint2: CGPointMake(35.73, 2))
noticeShapePath.addCurveToPoint(CGPointMake(25.45, 9.07), controlPoint1: CGPointMake(28.56, 2), controlPoint2: CGPointMake(25.45, 5.14))
noticeShapePath.addLineToPoint(CGPointMake(25.45, 41.47))
noticeShapePath.addCurveToPoint(CGPointMake(24.29, 43.44), controlPoint1: CGPointMake(25.45, 42.45), controlPoint2: CGPointMake(24.68, 43.04))
noticeShapePath.addCurveToPoint(CGPointMake(9.55, 43.04), controlPoint1: CGPointMake(16.73, 40.88), controlPoint2: CGPointMake(11.88, 40.69))
noticeShapePath.addCurveToPoint(CGPointMake(8, 46.58), controlPoint1: CGPointMake(8.58, 43.83), controlPoint2: CGPointMake(8, 45.2))
noticeShapePath.addCurveToPoint(CGPointMake(14.4, 55.81), controlPoint1: CGPointMake(8.19, 50.31), controlPoint2: CGPointMake(12.07, 53.84))
noticeShapePath.addLineToPoint(CGPointMake(27.2, 69.56))
noticeShapePath.addCurveToPoint(CGPointMake(42.91, 77.8), controlPoint1: CGPointMake(30.5, 74.47), controlPoint2: CGPointMake(35.73, 77.21))
noticeShapePath.addCurveToPoint(CGPointMake(43.88, 77.8), controlPoint1: CGPointMake(43.3, 77.8), controlPoint2: CGPointMake(43.68, 77.8))
noticeShapePath.addCurveToPoint(CGPointMake(47.18, 78), controlPoint1: CGPointMake(45.04, 77.8), controlPoint2: CGPointMake(46.01, 78))
noticeShapePath.addLineToPoint(CGPointMake(48.34, 78))
noticeShapePath.addLineToPoint(CGPointMake(48.34, 78))
noticeShapePath.addCurveToPoint(CGPointMake(71.61, 52.08), controlPoint1: CGPointMake(56.48, 78), controlPoint2: CGPointMake(69.87, 75.05))
noticeShapePath.addCurveToPoint(CGPointMake(72, 48.54), controlPoint1: CGPointMake(71.81, 51.29), controlPoint2: CGPointMake(72, 49.72))
noticeShapePath.closePath()
noticeShapePath.miterLimit = 4;

UIColor.whiteColor().setFill()
noticeShapePath.fill()
}

class func drawWarning() {
// Color Declarations
let greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.000)

// Warning Group
// Warning Circle Drawing
let warningCirclePath = UIBezierPath()
warningCirclePath.moveToPoint(CGPointMake(40.94, 63.39))
warningCirclePath.addCurveToPoint(CGPointMake(36.03, 65.55), controlPoint1: CGPointMake(39.06, 63.39), controlPoint2: CGPointMake(37.36, 64.18))
warningCirclePath.addCurveToPoint(CGPointMake(34.14, 70.45), controlPoint1: CGPointMake(34.9, 66.92), controlPoint2: CGPointMake(34.14, 68.49))
warningCirclePath.addCurveToPoint(CGPointMake(36.22, 75.54), controlPoint1: CGPointMake(34.14, 72.41), controlPoint2: CGPointMake(34.9, 74.17))
warningCirclePath.addCurveToPoint(CGPointMake(40.94, 77.5), controlPoint1: CGPointMake(37.54, 76.91), controlPoint2: CGPointMake(39.06, 77.5))
warningCirclePath.addCurveToPoint(CGPointMake(45.86, 75.35), controlPoint1: CGPointMake(42.83, 77.5), controlPoint2: CGPointMake(44.53, 76.72))
warningCirclePath.addCurveToPoint(CGPointMake(47.93, 70.45), controlPoint1: CGPointMake(47.18, 74.17), controlPoint2: CGPointMake(47.93, 72.41))
warningCirclePath.addCurveToPoint(CGPointMake(45.86, 65.35), controlPoint1: CGPointMake(47.93, 68.49), controlPoint2: CGPointMake(47.18, 66.72))
warningCirclePath.addCurveToPoint(CGPointMake(40.94, 63.39), controlPoint1: CGPointMake(44.53, 64.18), controlPoint2: CGPointMake(42.83, 63.39))
warningCirclePath.closePath()
warningCirclePath.miterLimit = 4;

greyColor.setFill()
warningCirclePath.fill()


// Warning Shape Drawing
let warningShapePath = UIBezierPath()
warningShapePath.moveToPoint(CGPointMake(46.23, 4.26))
warningShapePath.addCurveToPoint(CGPointMake(40.94, 2.5), controlPoint1: CGPointMake(44.91, 3.09), controlPoint2: CGPointMake(43.02, 2.5))
warningShapePath.addCurveToPoint(CGPointMake(34.71, 4.26), controlPoint1: CGPointMake(38.68, 2.5), controlPoint2: CGPointMake(36.03, 3.09))
warningShapePath.addCurveToPoint(CGPointMake(31.5, 8.77), controlPoint1: CGPointMake(33.01, 5.44), controlPoint2: CGPointMake(31.5, 7.01))
warningShapePath.addLineToPoint(CGPointMake(31.5, 19.36))
warningShapePath.addLineToPoint(CGPointMake(34.71, 54.44))
warningShapePath.addCurveToPoint(CGPointMake(40.38, 58.16), controlPoint1: CGPointMake(34.9, 56.2), controlPoint2: CGPointMake(36.41, 58.16))
warningShapePath.addCurveToPoint(CGPointMake(45.67, 54.44), controlPoint1: CGPointMake(44.34, 58.16), controlPoint2: CGPointMake(45.67, 56.01))
warningShapePath.addLineToPoint(CGPointMake(48.5, 19.36))
warningShapePath.addLineToPoint(CGPointMake(48.5, 8.77))
warningShapePath.addCurveToPoint(CGPointMake(46.23, 4.26), controlPoint1: CGPointMake(48.5, 7.01), controlPoint2: CGPointMake(47.74, 5.44))
warningShapePath.closePath()
warningShapePath.miterLimit = 4;

greyColor.setFill()
warningShapePath.fill()
}

class func drawInfo() {
// Color Declarations
let color0 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)

// Info Shape Drawing
let infoShapePath = UIBezierPath()
infoShapePath.moveToPoint(CGPointMake(45.66, 15.96))
infoShapePath.addCurveToPoint(CGPointMake(45.66, 5.22), controlPoint1: CGPointMake(48.78, 12.99), controlPoint2: CGPointMake(48.78, 8.19))
infoShapePath.addCurveToPoint(CGPointMake(34.34, 5.22), controlPoint1: CGPointMake(42.53, 2.26), controlPoint2: CGPointMake(37.47, 2.26))
infoShapePath.addCurveToPoint(CGPointMake(34.34, 15.96), controlPoint1: CGPointMake(31.22, 8.19), controlPoint2: CGPointMake(31.22, 12.99))
infoShapePath.addCurveToPoint(CGPointMake(45.66, 15.96), controlPoint1: CGPointMake(37.47, 18.92), controlPoint2: CGPointMake(42.53, 18.92))
infoShapePath.closePath()
infoShapePath.moveToPoint(CGPointMake(48, 69.41))
infoShapePath.addCurveToPoint(CGPointMake(40, 77), controlPoint1: CGPointMake(48, 73.58), controlPoint2: CGPointMake(44.4, 77))
infoShapePath.addLineToPoint(CGPointMake(40, 77))
infoShapePath.addCurveToPoint(CGPointMake(32, 69.41), controlPoint1: CGPointMake(35.6, 77), controlPoint2: CGPointMake(32, 73.58))
infoShapePath.addLineToPoint(CGPointMake(32, 35.26))
infoShapePath.addCurveToPoint(CGPointMake(40, 27.67), controlPoint1: CGPointMake(32, 31.08), controlPoint2: CGPointMake(35.6, 27.67))
infoShapePath.addLineToPoint(CGPointMake(40, 27.67))
infoShapePath.addCurveToPoint(CGPointMake(48, 35.26), controlPoint1: CGPointMake(44.4, 27.67), controlPoint2: CGPointMake(48, 31.08))
infoShapePath.addLineToPoint(CGPointMake(48, 69.41))
infoShapePath.closePath()
color0.setFill()
infoShapePath.fill()
}

class func drawEdit() {
// Color Declarations
let color = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)

// Edit shape Drawing
let editPathPath = UIBezierPath()
editPathPath.moveToPoint(CGPointMake(71, 2.7))
editPathPath.addCurveToPoint(CGPointMake(71.9, 15.2), controlPoint1: CGPointMake(74.7, 5.9), controlPoint2: CGPointMake(75.1, 11.6))
editPathPath.addLineToPoint(CGPointMake(64.5, 23.7))
editPathPath.addLineToPoint(CGPointMake(49.9, 11.1))
editPathPath.addLineToPoint(CGPointMake(57.3, 2.6))
editPathPath.addCurveToPoint(CGPointMake(69.7, 1.7), controlPoint1: CGPointMake(60.4, -1.1), controlPoint2: CGPointMake(66.1, -1.5))
editPathPath.addLineToPoint(CGPointMake(71, 2.7))
editPathPath.addLineToPoint(CGPointMake(71, 2.7))
editPathPath.closePath()
editPathPath.moveToPoint(CGPointMake(47.8, 13.5))
editPathPath.addLineToPoint(CGPointMake(13.4, 53.1))
editPathPath.addLineToPoint(CGPointMake(15.7, 55.1))
editPathPath.addLineToPoint(CGPointMake(50.1, 15.5))
editPathPath.addLineToPoint(CGPointMake(47.8, 13.5))
editPathPath.addLineToPoint(CGPointMake(47.8, 13.5))
editPathPath.closePath()
editPathPath.moveToPoint(CGPointMake(17.7, 56.7))
editPathPath.addLineToPoint(CGPointMake(23.8, 62.2))
editPathPath.addLineToPoint(CGPointMake(58.2, 22.6))
editPathPath.addLineToPoint(CGPointMake(52, 17.1))
editPathPath.addLineToPoint(CGPointMake(17.7, 56.7))
editPathPath.addLineToPoint(CGPointMake(17.7, 56.7))
editPathPath.closePath()
editPathPath.moveToPoint(CGPointMake(25.8, 63.8))
editPathPath.addLineToPoint(CGPointMake(60.1, 24.2))
editPathPath.addLineToPoint(CGPointMake(62.3, 26.1))
editPathPath.addLineToPoint(CGPointMake(28.1, 65.7))
editPathPath.addLineToPoint(CGPointMake(25.8, 63.8))
editPathPath.addLineToPoint(CGPointMake(25.8, 63.8))
editPathPath.closePath()
editPathPath.moveToPoint(CGPointMake(25.9, 68.1))
editPathPath.addLineToPoint(CGPointMake(4.2, 79.5))
editPathPath.addLineToPoint(CGPointMake(11.3, 55.5))
editPathPath.addLineToPoint(CGPointMake(25.9, 68.1))
editPathPath.closePath()
editPathPath.miterLimit = 4;
editPathPath.usesEvenOddFillRule = true;
color.setFill()
editPathPath.fill()
}

// Generated Images
class var imageOfCheckmark: UIImage {
if (Cache.imageOfCheckmark != nil) {
return Cache.imageOfCheckmark!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawCheckmark()
Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfCheckmark!
}

class var imageOfCross: UIImage {
if (Cache.imageOfCross != nil) {
return Cache.imageOfCross!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawCross()
Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfCross!
}

class var imageOfNotice: UIImage {
if (Cache.imageOfNotice != nil) {
return Cache.imageOfNotice!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawNotice()
Cache.imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfNotice!
}

class var imageOfWarning: UIImage {
if (Cache.imageOfWarning != nil) {
return Cache.imageOfWarning!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawWarning()
Cache.imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfWarning!
}

class var imageOfInfo: UIImage {
if (Cache.imageOfInfo != nil) {
return Cache.imageOfInfo!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawInfo()
Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfInfo!
}

class var imageOfEdit: UIImage {
if (Cache.imageOfEdit != nil) {
return Cache.imageOfEdit!
}
UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 80), false, 0)
SCLAlertViewStyleKit.drawEdit()
Cache.imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
return Cache.imageOfEdit!
}
}



*/








// Pop Up Styles
public enum SCLAlertViewStyle {
    case success, error, notice, warning, info, edit, wait, custom
    
}

// Action Types
public enum SCLActionType {
    case none, selector, closure
}

// Button sub-class
open class SCLButton: UIButton {
    var actionType = SCLActionType.none
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
open class SCLAlertViewResponder {
    let alertview: SCLAlertView
    
    // Initialisation and Title/Subtitle/Close functions
    public init(alertview: SCLAlertView) {
        self.alertview = alertview
    }
    
    open func setTitle(_ title: String) {
        self.alertview.labelTitle.text = title
    }
    
    open func setSubTitle(_ subTitle: String) {
        self.alertview.viewText.text = subTitle
    }
    
    open func close() {
        self.alertview.hideView()
    }
}

let kCircleHeightBackground: CGFloat = 62.0

// The Main Class
open class SCLAlertView: UIViewController {
    let kDefaultShadowOpacity: CGFloat = 0.7
    let kCircleTopPosition: CGFloat = -12.0
    let kCircleBackgroundTopPosition: CGFloat = -15.0
    let kCircleHeight: CGFloat = 56.0
    let kCircleIconHeight: CGFloat = 20.0
    let kTitleTop:CGFloat = 30.0
    let kTitleHeight:CGFloat = 40.0
    let kWindowWidth: CGFloat = 240.0
    var kWindowHeight: CGFloat = 178.0
    var kTextHeight: CGFloat = 90.0
    let kTextFieldHeight: CGFloat = 45.0
    let kButtonHeight: CGFloat = 45.0
    
    // Font
    let kDefaultFont = "Noteworthy-Bold"
    //    let kDefaultFont = "HelveticaNeue"
    // let kButtonFont = "HelveticaNeue-Bold"
    let kButtonFont = "Noteworthy-Bold"
    
    
    // UI Colour
    var viewColor = UIColor()
    var pressBrightnessFactor = 0.85
    
    // UI Options
    open var showCloseButton = true
    
    // Members declaration
    var baseView = UIView()
    var labelTitle = UILabel()
    var viewText = UITextView()
    var contentView = UIView()
    var circleBG = UIView(frame:CGRect(x:0, y:0, width:kCircleHeightBackground, height:kCircleHeightBackground))
    var circleView = UIView()
    var circleIconView : UIView?
    var durationTimer: Timer!
    fileprivate var inputs = [UITextField]()
    fileprivate var buttons = [SCLButton]()
    fileprivate var selfReference: SCLAlertView?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    required public init() {
        super.init(nibName:nil, bundle:nil)
        // Set up main view
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:kDefaultShadowOpacity)
        view.addSubview(baseView)
        // Base View
        baseView.frame = view.frame
        baseView.addSubview(contentView)
        // Content View
        contentView.backgroundColor = UIColor(white:1, alpha:1)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(labelTitle)
        contentView.addSubview(viewText)
        // Circle View
        circleBG.backgroundColor = UIColor.white
        circleBG.layer.cornerRadius = circleBG.frame.size.height / 2
        baseView.addSubview(circleBG)
        circleBG.addSubview(circleView)
        let x = (kCircleHeightBackground - kCircleHeight) / 2
        circleView.frame = CGRect(x:x, y:x, width:kCircleHeight, height:kCircleHeight)
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
        // Title
        labelTitle.numberOfLines = 1
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont(name: kDefaultFont, size:20)
        labelTitle.frame = CGRect(x:12, y:kTitleTop, width: kWindowWidth - 24, height:kTitleHeight)
        // View text
        viewText.isEditable = false
        viewText.textAlignment = .center
        viewText.textContainerInset = UIEdgeInsets.zero
        viewText.textContainer.lineFragmentPadding = 0;
        viewText.font = UIFont(name: kDefaultFont, size:14)
        // Colours
        contentView.backgroundColor = UIColorFromRGB(0xFFFFFF)
        labelTitle.textColor = UIColorFromRGB(0x4D4D4D)
        viewText.textColor = UIColorFromRGB(0x4D4D4D)
        contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).cgColor
        //Gesture Recognizer for tapping outside the textinput
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SCLAlertView.dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let rv = UIApplication.shared.keyWindow! as UIWindow
        let sz = rv.frame.size
        
        // Set background frame
        view.frame.size = sz
        
        // computing the right size to use for the textView
        let maxHeight = sz.height - 100 // max overall height
        var consumedHeight = CGFloat(0)
        consumedHeight += kTitleTop + kTitleHeight
        consumedHeight += 14
        consumedHeight += kButtonHeight * CGFloat(buttons.count)
        consumedHeight += kTextFieldHeight * CGFloat(inputs.count)
        let maxViewTextHeight = maxHeight - consumedHeight
        let viewTextWidth = kWindowWidth - 24
        let suggestedViewTextSize = viewText.sizeThatFits(CGSize(width: viewTextWidth, height: CGFloat.greatestFiniteMagnitude))
        let viewTextHeight = min(suggestedViewTextSize.height, maxViewTextHeight)
        
        // scroll management
        if (suggestedViewTextSize.height > maxViewTextHeight) {
            viewText.isScrollEnabled = true
        } else {
            viewText.isScrollEnabled = false
        }
        
        let windowHeight = consumedHeight + viewTextHeight
        // Set frames
        var x = (sz.width - kWindowWidth) / 2
        var y = (sz.height - windowHeight - (kCircleHeight / 8)) / 2
        contentView.frame = CGRect(x:x, y:y, width:kWindowWidth, height:windowHeight)
        y -= kCircleHeightBackground * 0.6
        x = (sz.width - kCircleHeightBackground) / 2
        circleBG.frame = CGRect(x:x, y:y+6, width:kCircleHeightBackground, height:kCircleHeightBackground)
        // Subtitle
        y = kTitleTop + kTitleHeight
        viewText.frame = CGRect(x:12, y:y, width: kWindowWidth - 24, height:kTextHeight)
        viewText.frame = CGRect(x:12, y:y, width: viewTextWidth, height:viewTextHeight)
        // Text fields
        y += viewTextHeight + 14.0
        for txt in inputs {
            txt.frame = CGRect(x:12, y:y, width:kWindowWidth - 24, height:30)
            txt.layer.cornerRadius = 3
            y += kTextFieldHeight
        }
        // Buttons
        for btn in buttons {
            btn.frame = CGRect(x:12, y:y, width:kWindowWidth - 24, height:35)
            btn.layer.cornerRadius = 3
            y += kButtonHeight
        }
    }
    
    override open func touchesEnded(_ touches:Set<UITouch>, with event:UIEvent?) {
        if event?.touches(for: view)?.count > 0 {
            view.endEditing(true)
        }
    }
    
    open func addTextField(_ title:String?=nil)->UITextField {
        // Update view height
        kWindowHeight += kTextFieldHeight
        // Add text field
        let txt = UITextField()
        txt.borderStyle = UITextBorderStyle.roundedRect
        txt.font = UIFont(name:kDefaultFont, size: 14)
        txt.autocapitalizationType = UITextAutocapitalizationType.words
        txt.clearButtonMode = UITextFieldViewMode.whileEditing
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1.0
        if title != nil {
            txt.placeholder = title!
        }
        contentView.addSubview(txt)
        inputs.append(txt)
        return txt
    }
    
    open func addButton(_ title:String, action:@escaping ()->Void)->SCLButton {
        let btn = addButton(title)
        btn.actionType = SCLActionType.closure
        btn.action = action
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(SCLAlertView.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    
    open func addButton(_ title:String, target:AnyObject, selector:Selector)->SCLButton {
        let btn = addButton(title)
        btn.actionType = SCLActionType.selector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(SCLAlertView.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(SCLAlertView.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    
    fileprivate func addButton(_ title:String)->SCLButton {
        // Update view height
        kWindowHeight += kButtonHeight
        // Add button
        let btn = SCLButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = UIFont(name:kButtonFont, size: 14)
        contentView.addSubview(btn)
        buttons.append(btn)
        return btn
    }
    
    @objc func buttonTapped(_ btn:SCLButton) {
        if btn.actionType == SCLActionType.closure {
            btn.action()
        } else if btn.actionType == SCLActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to:btn.target, for:nil)
            return
        } else {
            print("Unknow action type for button")
        }
        hideView()
    }
    
    
    @objc func buttonTapDown(_ btn:SCLButton) {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        //brightness = brightness * CGFloat(pressBrightness)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    @objc func buttonRelease(_ btn:SCLButton) {
        btn.backgroundColor = viewColor
    }
    
    //Dismiss keyboard when tapped outside textfield
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    // showSuccess(view, title, subTitle)
    open func showSuccess(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0x22B573, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .success, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showError(view, title, subTitle)
    open func showError(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xC1272D, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .error, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showNotice(view, title, subTitle)
    open func showNotice(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0x727375, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .notice, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showWarning(view, title, subTitle)
    open func showWarning(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xFFD110, colorTextButton: UInt=0x000000) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .warning, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showInfo(view, title, subTitle)
    open func showInfo(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0x2866BF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .info, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showWait(view, title, subTitle)
    open func showWait(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt?=0xD62DA5, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .wait, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    open func showEdit(_ title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .edit, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    // showTitle(view, title, subTitle, style)
    open func showTitle(_ title: String, subTitle: String, style: SCLAlertViewStyle, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt?, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showTitle(title, subTitle: subTitle, duration:duration, completeText:closeButtonTitle, style: style, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    open func showCustom(_ image: UIImage, color: UIColor, title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showCustom(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .custom, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    open func showCustomOK(_ image: UIImage, color: UIColor, title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF) -> SCLAlertViewResponder {
        return showCustom(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .custom, colorStyle: colorStyle, colorTextButton: colorTextButton)
    }
    
    open func showCustomTitleText(_ image: UIImage, color: UIColor, title: String, subTitle: String, closeButtonTitle:String?=nil, duration:TimeInterval=0.0, colorStyle: UInt=0xA429FF, colorTextButton: UInt=0xFFFFFF, textTitle: String) -> SCLAlertViewResponder {
       // return showCustom(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .custom, colorStyle: colorStyle, colorTextButton: colorTextButton)
        return showCustomOKText(image, color: color, title: title, subTitle: subTitle, duration: duration, completeText:closeButtonTitle, style: .custom, colorStyle: colorStyle, colorTextButton: colorTextButton, textTitle: textTitle)
        
    }
    
    
    open func showCustomOKText(_ theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?, textTitle: String?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = color
            //iconImage = theImage
            iconImage = SCLAlertViewStyleKit.imageOfEdit
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        /*
        if textTitle != "" {
            //self.labelTitle.text = textTitle
            let TextFieldTitle = textTitle
            addTextField(TextFieldTitle)
        }
        */
        
        // // Done button
        
        //showCloseButton = true
        
        if completeText == "" {
            
        } else {
            
            if completeText == "Save" {
                
                if showCloseButton {
                    let txt = completeText != nil ? completeText! : "OK"
                    addButton(txt, target:self, selector:#selector(SCLAlertView.SaveTextFieldView))
                }
                
                
            } else {
            
            if showCloseButton {
                let txt = completeText != nil ? completeText! : "OK"
                addButton(txt, target:self, selector:#selector(SCLAlertView.hideView))
            }
                
            }
            
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        
        
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        //  circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        circleIconView!.frame = CGRect( x: 5, y: 5, width: kCircleHeight-10, height: kCircleHeight-10)
        
        
        /*
         circleView.addSubview(circleIconView!)
         //  let x = (kCircleHeight - kCircleIconHeight) / 4
         //  let x2 = (kCircleHeight - 10)
         
         //  let x5 = (kCircleHeight - 5)
         //let x2 = (kCircleHeight - 10)
         
         
         //circleIconView!.frame = CGRectMake( x, x, x5, x5)
         
         let x = (kCircleHeight - kCircleIconHeight) / 2
         circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
         
         
         */
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                self.baseView.center = rv.center
            })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    
    
    
    open func showCustom(_ theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = color
            iconImage = theImage
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // Done button
        
        showCloseButton = false
        
        if showCloseButton {
            //    let txt = completeText != nil ? completeText! : "Done"
            //    addButton(txt, target:self, selector:Selector("hideView"))
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
            
        }
        
        
        /*
        circleViewCustom.addSubview(circleIconViewCustom!)
        let x = (kCircleHeightCustom - kCircleIconHeightCustom) / 2
        let x4 = (kCircleHeightCustom - kCircleIconHeightCustom) / 4
        let x2 = (kCircleHeightCustom - 10)
        circleIconViewCustom!.frame = CGRectMake( x4, x4, x2, x2)
        */
        
        
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x-10, y: x-10, width: kCircleHeight-20, height: kCircleHeight-20)
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    self.baseView.center = rv.center
                })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    
    open func showCustomOK2(_ theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = color
            iconImage = theImage
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // // Done button
        
        //showCloseButton = true
        
        if showCloseButton {
            //      let txt = completeText != nil ? completeText! : "OK"
            //      addButton(txt, target:self, selector:Selector("hideView"))
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        
        
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        //  circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        circleIconView!.frame = CGRect( x: 5, y: 5, width: kCircleHeight-5, height: kCircleHeight-5)
        
        
        /*
        circleView.addSubview(circleIconView!)
        //  let x = (kCircleHeight - kCircleIconHeight) / 4
        //  let x2 = (kCircleHeight - 10)
        
        //  let x5 = (kCircleHeight - 5)
        //let x2 = (kCircleHeight - 10)
        
        
        //circleIconView!.frame = CGRectMake( x, x, x5, x5)
        
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        
        */
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    self.baseView.center = rv.center
                })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    open func showCustomOK(_ theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = color
            iconImage = theImage
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // // Done button
        
        //showCloseButton = true
        
        if completeText == "" {
            
        } else {
            
            if showCloseButton {
                let txt = completeText != nil ? completeText! : "OK"
                addButton(txt, target:self, selector:#selector(SCLAlertView.hideView))
            }
            
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        
        
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        //  circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        circleIconView!.frame = CGRect( x: 5, y: 5, width: kCircleHeight-10, height: kCircleHeight-10)
        
        
        /*
        circleView.addSubview(circleIconView!)
        //  let x = (kCircleHeight - kCircleIconHeight) / 4
        //  let x2 = (kCircleHeight - 10)
        
        //  let x5 = (kCircleHeight - 5)
        //let x2 = (kCircleHeight - 10)
        
        
        //circleIconView!.frame = CGRectMake( x, x, x5, x5)
        
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        
        */
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    self.baseView.center = rv.center
                })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    open func showCustomOKSIGN(_ theImage: UIImage, color: UIColor, title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = color
            iconImage = theImage
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // // Done button
        
        //showCloseButton = true
        
        if completeText == "" {
            
        } else {
            
            if showCloseButton {
                let txt = completeText != nil ? completeText! : "OK"
                addButton(txt, target:self, selector:#selector(SCLAlertView.hideView))
            }
            
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        
        
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        //  circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        circleIconView!.frame = CGRect( x: 5, y: 5, width: kCircleHeight-10, height: kCircleHeight-10)
        
        
        /*
        circleView.addSubview(circleIconView!)
        //  let x = (kCircleHeight - kCircleIconHeight) / 4
        //  let x2 = (kCircleHeight - 10)
        
        //  let x5 = (kCircleHeight - 5)
        //let x2 = (kCircleHeight - 10)
        
        
        //circleIconView!.frame = CGRectMake( x, x, x5, x5)
        
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRectMake( x, x, kCircleIconHeight, kCircleIconHeight)
        
        
        */
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        // self.baseView.frame.origin.y = -400
        self.baseView.frame.origin.y = -550
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    self.baseView.center = rv.center
                })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    // showTitle(view, title, subTitle, duration, style)
    open func showTitle(_ title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // Done button
        if showCloseButton {
            let txt = completeText != nil ? completeText! : "Done"
            addButton(txt, target:self, selector:#selector(SCLAlertView.hideView))
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x, y: x, width: kCircleIconHeight, height: kCircleIconHeight)
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                self.baseView.center = rv.center
            })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    open func showTitleCustom(_ title: String, subTitle: String, duration: TimeInterval?, completeText: String?, style: SCLAlertViewStyle, colorStyle: UInt?, colorTextButton: UInt?, textTitle: String) -> SCLAlertViewResponder {
        selfReference = self
        view.alpha = 0
        let rv = UIApplication.shared.keyWindow! as UIWindow
        rv.addSubview(view)
        view.frame = rv.bounds
        baseView.frame = rv.bounds
        
        // Alert colour/icon
        viewColor = UIColor()
        var iconImage: UIImage?
        
        // Icon style
        switch style {
        case .success:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCheckmark
            
        case .error:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfCross
            
        case .notice:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfNotice
            
        case .warning:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfWarning
            
        case .info:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfInfo
            
        case .edit:
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
            
        case .wait:
            viewColor = UIColorFromRGB(colorStyle!)
            
        case .custom:
            // viewColor = UIColorFromRGB(colorStyle!)
            viewColor = UIColorFromRGB(colorStyle!)
            iconImage = SCLAlertViewStyleKit.imageOfEdit
        }
        
        // Title
        if !title.isEmpty {
            self.labelTitle.text = title
        }
        
        // Subtitle
        if !subTitle.isEmpty {
            viewText.text = subTitle
            // Adjust text view size, if necessary
            let str = subTitle as NSString
            let attr = [NSAttributedStringKey.font:viewText.font ?? UIFont()]
            let sz = CGSize(width: kWindowWidth - 24, height:90)
            let r = str.boundingRect(with: sz, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attr, context:nil)
            let ht = ceil(r.size.height)
            if ht < kTextHeight {
                kWindowHeight -= (kTextHeight - ht)
                kTextHeight = ht
            }
        }
        
        // Done button
        if showCloseButton {
            let txt = completeText != nil ? completeText! : "Done"
            addButton(txt, target:self, selector:#selector(SCLAlertView.hideView))
        }
        
        // Alert view colour and images
        circleView.backgroundColor = viewColor
        // Spinner / icon
        if style == .wait {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.startAnimating()
            circleIconView = indicator
        }
        else {
            circleIconView = UIImageView(image: iconImage!)
        }
        circleView.addSubview(circleIconView!)
        let x = (kCircleHeight - kCircleIconHeight) / 2
        circleIconView!.frame = CGRect( x: x, y: x, width: kCircleIconHeight, height: kCircleIconHeight)
        
        for txt in inputs {
            txt.layer.borderColor = viewColor.cgColor
        }
        for btn in buttons {
            btn.backgroundColor = viewColor
            btn.setTitleColor(UIColorFromRGB(colorTextButton!), for:UIControlState())
        }
        
        // Adding duration
        if duration > 0 {
            durationTimer?.invalidate()
            durationTimer = Timer.scheduledTimer(timeInterval: duration!, target: self, selector: #selector(SCLAlertView.hideView), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        self.baseView.frame.origin.y = -400
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.center.y = rv.center.y + 15
            self.view.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 0.2, animations: {
                    self.baseView.center = rv.center
                })
        })
        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }
    
    // Close SCLAlertView
    @objc open func hideView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
            }, completion: { finished in
                self.view.removeFromSuperview()
                self.selfReference = nil
        })
    }
    
    //Save TextField
    @objc open func SaveTextFieldView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { finished in
            self.view.removeFromSuperview()
            self.selfReference = nil
        })
    }
    
    // Helper function to convert from RGB to UIColor
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

// ------------------------------------
// Icon drawing
// Code generated by PaintCode
// ------------------------------------

class SCLAlertViewStyleKit : NSObject {
    
    // Cache
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var checkmarkTargets: [AnyObject]?
        static var imageOfCross: UIImage?
        static var crossTargets: [AnyObject]?
        static var imageOfNotice: UIImage?
        static var noticeTargets: [AnyObject]?
        static var imageOfWarning: UIImage?
        static var warningTargets: [AnyObject]?
        static var imageOfInfo: UIImage?
        static var infoTargets: [AnyObject]?
        static var imageOfEdit: UIImage?
        static var editTargets: [AnyObject]?
    }
    
    // Initialization
    /// swift 1.2 abolish func load
    //    override class func load() {
    //    }
    
    // Drawing Methods
    class func drawCheckmark() {
        // Checkmark Shape Drawing
        let checkmarkShapePath = UIBezierPath()
        checkmarkShapePath.move(to: CGPoint(x: 73.25, y: 14.05))
        checkmarkShapePath.addCurve(to: CGPoint(x: 64.51, y: 13.86), controlPoint1: CGPoint(x: 70.98, y: 11.44), controlPoint2: CGPoint(x: 66.78, y: 11.26))
        checkmarkShapePath.addLine(to: CGPoint(x: 27.46, y: 52))
        checkmarkShapePath.addLine(to: CGPoint(x: 15.75, y: 39.54))
        checkmarkShapePath.addCurve(to: CGPoint(x: 6.84, y: 39.54), controlPoint1: CGPoint(x: 13.48, y: 36.93), controlPoint2: CGPoint(x: 9.28, y: 36.93))
        checkmarkShapePath.addCurve(to: CGPoint(x: 6.84, y: 49.02), controlPoint1: CGPoint(x: 4.39, y: 42.14), controlPoint2: CGPoint(x: 4.39, y: 46.42))
        checkmarkShapePath.addLine(to: CGPoint(x: 22.91, y: 66.14))
        checkmarkShapePath.addCurve(to: CGPoint(x: 27.28, y: 68), controlPoint1: CGPoint(x: 24.14, y: 67.44), controlPoint2: CGPoint(x: 25.71, y: 68))
        checkmarkShapePath.addCurve(to: CGPoint(x: 31.65, y: 66.14), controlPoint1: CGPoint(x: 28.86, y: 68), controlPoint2: CGPoint(x: 30.43, y: 67.26))
        checkmarkShapePath.addLine(to: CGPoint(x: 73.08, y: 23.35))
        checkmarkShapePath.addCurve(to: CGPoint(x: 73.25, y: 14.05), controlPoint1: CGPoint(x: 75.52, y: 20.75), controlPoint2: CGPoint(x: 75.7, y: 16.65))
        checkmarkShapePath.close()
        checkmarkShapePath.miterLimit = 4;
        
        UIColor.white.setFill()
        checkmarkShapePath.fill()
    }
    
    class func drawCross() {
        // Cross Shape Drawing
        let crossShapePath = UIBezierPath()
        crossShapePath.move(to: CGPoint(x: 10, y: 70))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 10))
        crossShapePath.move(to: CGPoint(x: 10, y: 10))
        crossShapePath.addLine(to: CGPoint(x: 70, y: 70))
        crossShapePath.lineCapStyle = CGLineCap.round;
        crossShapePath.lineJoinStyle = CGLineJoin.round;
        UIColor.white.setStroke()
        crossShapePath.lineWidth = 14
        crossShapePath.stroke()
    }
    
    class func drawNotice() {
        // Notice Shape Drawing
        let noticeShapePath = UIBezierPath()
        noticeShapePath.move(to: CGPoint(x: 72, y: 48.54))
        noticeShapePath.addLine(to: CGPoint(x: 72, y: 39.9))
        noticeShapePath.addCurve(to: CGPoint(x: 66.38, y: 34.01), controlPoint1: CGPoint(x: 72, y: 36.76), controlPoint2: CGPoint(x: 69.48, y: 34.01))
        noticeShapePath.addCurve(to: CGPoint(x: 61.53, y: 35.97), controlPoint1: CGPoint(x: 64.82, y: 34.01), controlPoint2: CGPoint(x: 62.69, y: 34.8))
        noticeShapePath.addCurve(to: CGPoint(x: 60.36, y: 35.78), controlPoint1: CGPoint(x: 61.33, y: 35.97), controlPoint2: CGPoint(x: 62.3, y: 35.78))
        noticeShapePath.addLine(to: CGPoint(x: 60.36, y: 33.22))
        noticeShapePath.addCurve(to: CGPoint(x: 54.16, y: 26.16), controlPoint1: CGPoint(x: 60.36, y: 29.3), controlPoint2: CGPoint(x: 57.65, y: 26.16))
        noticeShapePath.addCurve(to: CGPoint(x: 48.73, y: 29.89), controlPoint1: CGPoint(x: 51.64, y: 26.16), controlPoint2: CGPoint(x: 50.67, y: 27.73))
        noticeShapePath.addLine(to: CGPoint(x: 48.73, y: 28.71))
        noticeShapePath.addCurve(to: CGPoint(x: 43.49, y: 21.64), controlPoint1: CGPoint(x: 48.73, y: 24.78), controlPoint2: CGPoint(x: 46.98, y: 21.64))
        noticeShapePath.addCurve(to: CGPoint(x: 39.03, y: 25.37), controlPoint1: CGPoint(x: 40.97, y: 21.64), controlPoint2: CGPoint(x: 39.03, y: 23.01))
        noticeShapePath.addLine(to: CGPoint(x: 39.03, y: 9.07))
        noticeShapePath.addCurve(to: CGPoint(x: 32.24, y: 2), controlPoint1: CGPoint(x: 39.03, y: 5.14), controlPoint2: CGPoint(x: 35.73, y: 2))
        noticeShapePath.addCurve(to: CGPoint(x: 25.45, y: 9.07), controlPoint1: CGPoint(x: 28.56, y: 2), controlPoint2: CGPoint(x: 25.45, y: 5.14))
        noticeShapePath.addLine(to: CGPoint(x: 25.45, y: 41.47))
        noticeShapePath.addCurve(to: CGPoint(x: 24.29, y: 43.44), controlPoint1: CGPoint(x: 25.45, y: 42.45), controlPoint2: CGPoint(x: 24.68, y: 43.04))
        noticeShapePath.addCurve(to: CGPoint(x: 9.55, y: 43.04), controlPoint1: CGPoint(x: 16.73, y: 40.88), controlPoint2: CGPoint(x: 11.88, y: 40.69))
        noticeShapePath.addCurve(to: CGPoint(x: 8, y: 46.58), controlPoint1: CGPoint(x: 8.58, y: 43.83), controlPoint2: CGPoint(x: 8, y: 45.2))
        noticeShapePath.addCurve(to: CGPoint(x: 14.4, y: 55.81), controlPoint1: CGPoint(x: 8.19, y: 50.31), controlPoint2: CGPoint(x: 12.07, y: 53.84))
        noticeShapePath.addLine(to: CGPoint(x: 27.2, y: 69.56))
        noticeShapePath.addCurve(to: CGPoint(x: 42.91, y: 77.8), controlPoint1: CGPoint(x: 30.5, y: 74.47), controlPoint2: CGPoint(x: 35.73, y: 77.21))
        noticeShapePath.addCurve(to: CGPoint(x: 43.88, y: 77.8), controlPoint1: CGPoint(x: 43.3, y: 77.8), controlPoint2: CGPoint(x: 43.68, y: 77.8))
        noticeShapePath.addCurve(to: CGPoint(x: 47.18, y: 78), controlPoint1: CGPoint(x: 45.04, y: 77.8), controlPoint2: CGPoint(x: 46.01, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addLine(to: CGPoint(x: 48.34, y: 78))
        noticeShapePath.addCurve(to: CGPoint(x: 71.61, y: 52.08), controlPoint1: CGPoint(x: 56.48, y: 78), controlPoint2: CGPoint(x: 69.87, y: 75.05))
        noticeShapePath.addCurve(to: CGPoint(x: 72, y: 48.54), controlPoint1: CGPoint(x: 71.81, y: 51.29), controlPoint2: CGPoint(x: 72, y: 49.72))
        noticeShapePath.close()
        noticeShapePath.miterLimit = 4;
        
        UIColor.white.setFill()
        noticeShapePath.fill()
    }
    
    class func drawWarning() {
        // Color Declarations
        let greyColor = UIColor(red: 0.236, green: 0.236, blue: 0.236, alpha: 1.000)
        
        // Warning Group
        // Warning Circle Drawing
        let warningCirclePath = UIBezierPath()
        warningCirclePath.move(to: CGPoint(x: 40.94, y: 63.39))
        warningCirclePath.addCurve(to: CGPoint(x: 36.03, y: 65.55), controlPoint1: CGPoint(x: 39.06, y: 63.39), controlPoint2: CGPoint(x: 37.36, y: 64.18))
        warningCirclePath.addCurve(to: CGPoint(x: 34.14, y: 70.45), controlPoint1: CGPoint(x: 34.9, y: 66.92), controlPoint2: CGPoint(x: 34.14, y: 68.49))
        warningCirclePath.addCurve(to: CGPoint(x: 36.22, y: 75.54), controlPoint1: CGPoint(x: 34.14, y: 72.41), controlPoint2: CGPoint(x: 34.9, y: 74.17))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 77.5), controlPoint1: CGPoint(x: 37.54, y: 76.91), controlPoint2: CGPoint(x: 39.06, y: 77.5))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 75.35), controlPoint1: CGPoint(x: 42.83, y: 77.5), controlPoint2: CGPoint(x: 44.53, y: 76.72))
        warningCirclePath.addCurve(to: CGPoint(x: 47.93, y: 70.45), controlPoint1: CGPoint(x: 47.18, y: 74.17), controlPoint2: CGPoint(x: 47.93, y: 72.41))
        warningCirclePath.addCurve(to: CGPoint(x: 45.86, y: 65.35), controlPoint1: CGPoint(x: 47.93, y: 68.49), controlPoint2: CGPoint(x: 47.18, y: 66.72))
        warningCirclePath.addCurve(to: CGPoint(x: 40.94, y: 63.39), controlPoint1: CGPoint(x: 44.53, y: 64.18), controlPoint2: CGPoint(x: 42.83, y: 63.39))
        warningCirclePath.close()
        warningCirclePath.miterLimit = 4;
        
        greyColor.setFill()
        warningCirclePath.fill()
        
        
        // Warning Shape Drawing
        let warningShapePath = UIBezierPath()
        warningShapePath.move(to: CGPoint(x: 46.23, y: 4.26))
        warningShapePath.addCurve(to: CGPoint(x: 40.94, y: 2.5), controlPoint1: CGPoint(x: 44.91, y: 3.09), controlPoint2: CGPoint(x: 43.02, y: 2.5))
        warningShapePath.addCurve(to: CGPoint(x: 34.71, y: 4.26), controlPoint1: CGPoint(x: 38.68, y: 2.5), controlPoint2: CGPoint(x: 36.03, y: 3.09))
        warningShapePath.addCurve(to: CGPoint(x: 31.5, y: 8.77), controlPoint1: CGPoint(x: 33.01, y: 5.44), controlPoint2: CGPoint(x: 31.5, y: 7.01))
        warningShapePath.addLine(to: CGPoint(x: 31.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 34.71, y: 54.44))
        warningShapePath.addCurve(to: CGPoint(x: 40.38, y: 58.16), controlPoint1: CGPoint(x: 34.9, y: 56.2), controlPoint2: CGPoint(x: 36.41, y: 58.16))
        warningShapePath.addCurve(to: CGPoint(x: 45.67, y: 54.44), controlPoint1: CGPoint(x: 44.34, y: 58.16), controlPoint2: CGPoint(x: 45.67, y: 56.01))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 19.36))
        warningShapePath.addLine(to: CGPoint(x: 48.5, y: 8.77))
        warningShapePath.addCurve(to: CGPoint(x: 46.23, y: 4.26), controlPoint1: CGPoint(x: 48.5, y: 7.01), controlPoint2: CGPoint(x: 47.74, y: 5.44))
        warningShapePath.close()
        warningShapePath.miterLimit = 4;
        
        greyColor.setFill()
        warningShapePath.fill()
    }
    
    class func drawInfo() {
        // Color Declarations
        let color0 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        // Info Shape Drawing
        let infoShapePath = UIBezierPath()
        infoShapePath.move(to: CGPoint(x: 45.66, y: 15.96))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 5.22), controlPoint1: CGPoint(x: 48.78, y: 12.99), controlPoint2: CGPoint(x: 48.78, y: 8.19))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 5.22), controlPoint1: CGPoint(x: 42.53, y: 2.26), controlPoint2: CGPoint(x: 37.47, y: 2.26))
        infoShapePath.addCurve(to: CGPoint(x: 34.34, y: 15.96), controlPoint1: CGPoint(x: 31.22, y: 8.19), controlPoint2: CGPoint(x: 31.22, y: 12.99))
        infoShapePath.addCurve(to: CGPoint(x: 45.66, y: 15.96), controlPoint1: CGPoint(x: 37.47, y: 18.92), controlPoint2: CGPoint(x: 42.53, y: 18.92))
        infoShapePath.close()
        infoShapePath.move(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 77), controlPoint1: CGPoint(x: 48, y: 73.58), controlPoint2: CGPoint(x: 44.4, y: 77))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 77))
        infoShapePath.addCurve(to: CGPoint(x: 32, y: 69.41), controlPoint1: CGPoint(x: 35.6, y: 77), controlPoint2: CGPoint(x: 32, y: 73.58))
        infoShapePath.addLine(to: CGPoint(x: 32, y: 35.26))
        infoShapePath.addCurve(to: CGPoint(x: 40, y: 27.67), controlPoint1: CGPoint(x: 32, y: 31.08), controlPoint2: CGPoint(x: 35.6, y: 27.67))
        infoShapePath.addLine(to: CGPoint(x: 40, y: 27.67))
        infoShapePath.addCurve(to: CGPoint(x: 48, y: 35.26), controlPoint1: CGPoint(x: 44.4, y: 27.67), controlPoint2: CGPoint(x: 48, y: 31.08))
        infoShapePath.addLine(to: CGPoint(x: 48, y: 69.41))
        infoShapePath.close()
        color0.setFill()
        infoShapePath.fill()
    }
    
    class func drawEdit() {
        // Color Declarations
        let color = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        
        // Edit shape Drawing
        let editPathPath = UIBezierPath()
        editPathPath.move(to: CGPoint(x: 71, y: 2.7))
        editPathPath.addCurve(to: CGPoint(x: 71.9, y: 15.2), controlPoint1: CGPoint(x: 74.7, y: 5.9), controlPoint2: CGPoint(x: 75.1, y: 11.6))
        editPathPath.addLine(to: CGPoint(x: 64.5, y: 23.7))
        editPathPath.addLine(to: CGPoint(x: 49.9, y: 11.1))
        editPathPath.addLine(to: CGPoint(x: 57.3, y: 2.6))
        editPathPath.addCurve(to: CGPoint(x: 69.7, y: 1.7), controlPoint1: CGPoint(x: 60.4, y: -1.1), controlPoint2: CGPoint(x: 66.1, y: -1.5))
        editPathPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPathPath.addLine(to: CGPoint(x: 71, y: 2.7))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLine(to: CGPoint(x: 13.4, y: 53.1))
        editPathPath.addLine(to: CGPoint(x: 15.7, y: 55.1))
        editPathPath.addLine(to: CGPoint(x: 50.1, y: 15.5))
        editPathPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.addLine(to: CGPoint(x: 47.8, y: 13.5))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLine(to: CGPoint(x: 23.8, y: 62.2))
        editPathPath.addLine(to: CGPoint(x: 58.2, y: 22.6))
        editPathPath.addLine(to: CGPoint(x: 52, y: 17.1))
        editPathPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.addLine(to: CGPoint(x: 17.7, y: 56.7))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLine(to: CGPoint(x: 60.1, y: 24.2))
        editPathPath.addLine(to: CGPoint(x: 62.3, y: 26.1))
        editPathPath.addLine(to: CGPoint(x: 28.1, y: 65.7))
        editPathPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.addLine(to: CGPoint(x: 25.8, y: 63.8))
        editPathPath.close()
        editPathPath.move(to: CGPoint(x: 25.9, y: 68.1))
        editPathPath.addLine(to: CGPoint(x: 4.2, y: 79.5))
        editPathPath.addLine(to: CGPoint(x: 11.3, y: 55.5))
        editPathPath.addLine(to: CGPoint(x: 25.9, y: 68.1))
        editPathPath.close()
        editPathPath.miterLimit = 4;
        editPathPath.usesEvenOddFillRule = true;
        color.setFill()
        editPathPath.fill()
    }
    
    // Generated Images
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawCheckmark()
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawCross()
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    class var imageOfNotice: UIImage {
        if (Cache.imageOfNotice != nil) {
            return Cache.imageOfNotice!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawNotice()
        Cache.imageOfNotice = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfNotice!
    }
    
    class var imageOfWarning: UIImage {
        if (Cache.imageOfWarning != nil) {
            return Cache.imageOfWarning!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawWarning()
        Cache.imageOfWarning = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfWarning!
    }
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawInfo()
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
    
    class var imageOfEdit: UIImage {
        if (Cache.imageOfEdit != nil) {
            return Cache.imageOfEdit!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 80, height: 80), false, 0)
        SCLAlertViewStyleKit.drawEdit()
        Cache.imageOfEdit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfEdit!
    }
}

