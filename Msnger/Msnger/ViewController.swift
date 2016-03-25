//
//  ViewController.swift
//  Msnger
//
//  Created by Stanislav Slavin on 23/03/16.
//  Copyright © 2016 Stanislav Slavin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {

    static var mMsnger:Msnger? = nil
    let mLocationManager = CLLocationManager()
    var mLastLocation:CLLocation? = nil
    static var mSelf:ViewController? = nil
    
    @IBOutlet weak var mTextNumber: UITextField!
    @IBOutlet weak var mTextMessage: UITextView!
    @IBAction func onSendPressed(sender: UIButton) {
        guard let number = mTextNumber.text,
              let message = mTextMessage.text
        else
        {
            return;
        }
        
        var loc:CLLocation? = mLocationManager.location
        if loc == nil {
            loc = CLLocation(latitude: 0, longitude: 0)
        }
        
        guard let location = loc
        else
        {
            ViewController.showAlert("Cannot get your location", text: "Please check GPS settings");
            return;
        }
        
        guard let mMsnger = ViewController.mMsnger
        else
        {
            return;
        }
        
        ViewController.showActivityIndicator("Sending message", text: "Please wait")
        sendMessage(mMsnger, number, message, location.coordinate.latitude, location.coordinate.longitude,
            {
                code in
                dispatch_async(dispatch_get_main_queue(), {
                    ViewController.hideActivityIndicatior({
                            ViewController.showAlertForError(code)
                        })
                    })
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        ViewController.mSelf = self
        ViewController.mMsnger = createMsnger()
        
        guard let mTextMessage = mTextMessage,
              let mTextNumber = mTextNumber
            else
        {
            return;
        }
        
        let borderColor = UIColor(colorLiteralRed:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:0.6)
        
        mTextMessage.layer.cornerRadius = 10
        mTextMessage.layer.borderColor = borderColor.CGColor
        mTextMessage.layer.borderWidth = 1
        mTextNumber.layer.borderColor = borderColor.CGColor
        
        mTextMessage.delegate = self
        
        mLocationManager.delegate = self
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager.distanceFilter = kCLDistanceFilterNone
        mLocationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
             mLocationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if let mMsnger = ViewController.mMsnger {
            releaseMsnger(mMsnger)
        }
        ViewController.mSelf = nil
        mLocationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) == nil {
            return true;
        }
        self.view.endEditing(true);
        return false;
    }
    
    static var mActivityAlert:UIAlertController = UIAlertController(title:"", message:"", preferredStyle: UIAlertControllerStyle.Alert)
    static func showActivityIndicator(title:String, text:String) {
        guard let mSelf = ViewController.mSelf
        else
        {
            return
        }
        
        mActivityAlert.title = title
        mActivityAlert.message = text
        mSelf.presentViewController(mActivityAlert, animated: true, completion: nil)
    }
    
    static func hideActivityIndicatior(completion: (() -> Void)?) {
        mActivityAlert.dismissViewControllerAnimated(true, completion: completion)
    }
    
    static func showAlert(title:String, text:String) {
        guard let mSelf = ViewController.mSelf
            else
        {
            return
        }
        let alertController = UIAlertController(title: title, message:text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        mSelf.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static let ERROR_CODE_SUCCESS:Int32                      = 0;
    static let ERROR_CODE_UNSUCCESSFUL:Int32                 = -1;
    static let ERROR_CODE_TIMEOUT:Int32                      = -5;
    static let ERROR_CODE_GIS_FAILURE:Int32                  = -6;
    static let ERROR_GIS_TIMEOUT:Int32                       = -7;
    static let ERROR_INFOBIP_TIMEOUT:Int32                   = -8;
    static let ERROR_INFOBIP_REJECTED_NO_DESTINATION:Int32   = -9;
    static let ERROR_INFOBIP_PENDING:Int32                   = -10;
    static let ERROR_HOST_NOT_FOUND:Int32                    = -11;
    static let ERROR_GIS_RESULTS_EMPTY:Int32                 = -12;
    static let ERROR_INFOBIP_REJECTED_NO_PREFIX:Int32        = -13;
    
    static func showAlertForError(code:Int32) {
        var title = "Message not sent"
        var text = ""
        switch code {
        case ViewController.ERROR_CODE_SUCCESS:
            title = "Message sent"
        case ViewController.ERROR_INFOBIP_PENDING:
            title = "Message sent"
            text = "Your message was submitted to operator for delivery."
        case ViewController.ERROR_CODE_UNSUCCESSFUL:
            text = "Please try again later"
        case ViewController.ERROR_CODE_TIMEOUT:
            text = "Timed out while waiting for result. Try again later."
        case ViewController.ERROR_CODE_GIS_FAILURE:
            text = "Cannot retrieve street location. Try again later."
        case ViewController.ERROR_GIS_TIMEOUT:
            text = "Timed out while getting street location. Try again later."
        case ViewController.ERROR_INFOBIP_TIMEOUT:
            text = "Timed out while sending message. Try again later."
        case ViewController.ERROR_INFOBIP_REJECTED_NO_DESTINATION:
            text = "Please check if recipient number is correct."
        case ViewController.ERROR_HOST_NOT_FOUND:
            text = "Cannot connect to the server. Please check your connectivity settings."
        case ViewController.ERROR_GIS_RESULTS_EMPTY:
            text = "Cannot obtain street address. Please check your GPS coverage."
        case ViewController.ERROR_INFOBIP_REJECTED_NO_PREFIX:
            text = "Invalid prefix in recipient number."
        default:
            break
        }
        
        showAlert(title, text: text);
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            mLastLocation = locations[0]
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mLocationManager.startUpdatingLocation()
        }
    }
}

