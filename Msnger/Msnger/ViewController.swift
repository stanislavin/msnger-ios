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
        
        guard let location = mLocationManager.location
        else
        {
            showAlert("Cannot get your location", "Please check GPS settings.");
            return;
        }
        
        guard let number = mTextNumber.text,
              let message = mTextMessage.text,
              let mMsnger = ViewController.mMsnger
            else
        {
            return;
        }
        
        showActivityIndicator("Sending message", "Please wait.")
        sendMessage(mMsnger, number, message, location.coordinate.latitude, location.coordinate.longitude,
            {
                code in
                guard let mSelf = ViewController.mSelf else
                {
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    mSelf.hideActivityIndicatior({
                            mSelf.showAlertForError(code)
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
        
        // Setup borders of text fields
        let borderColor = UIColor(colorLiteralRed:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:0.6)
        mTextMessage.layer.cornerRadius = 10
        mTextMessage.layer.borderColor = borderColor.CGColor
        mTextMessage.layer.borderWidth = 1
        mTextMessage.delegate = self
        mTextNumber.layer.borderColor = borderColor.CGColor
        
        // Enable location
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // avoid new lines in message to hide keyboard on "Done"
        if text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) == nil {
            return true;
        }
        self.view.endEditing(true);
        return false;
    }
    
    var mActivityAlert:UIAlertController = UIAlertController(title:"", message:"", preferredStyle: UIAlertControllerStyle.Alert)
    func showActivityIndicator(title:String, _ text:String) {
        mActivityAlert.title = title
        mActivityAlert.message = text
        presentViewController(mActivityAlert, animated: true, completion: nil)
    }
    func hideActivityIndicatior(completion: (() -> Void)?) {
        mActivityAlert.dismissViewControllerAnimated(true, completion: completion)
    }
    
    func showAlert(title:String, _ text:String) {
        let alertController = UIAlertController(title: title, message:text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlertForError(code:Int32) {
        let values = Errors.errorCode2MessageTitleAndText(code);
        showAlert(values.title, values.text);
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

