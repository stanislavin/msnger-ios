//
//  ViewController.swift
//  Msnger
//
//  Created by Stanislav Slavin on 23/03/16.
//  Copyright © 2016 Stanislav Slavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static var mMsnger:Msnger? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        ViewController.mMsnger = createMsnger()
        let number = "79213276120"
        let message = "Hello from swift!"
        let lat = 59.944263
        let lon = 30.315868
        
        sendMessage(ViewController.mMsnger!, number, message, lat, lon,
            {
                code in
                print("Message result code: \(code)")
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        if let mMsnger = ViewController.mMsnger {
            releaseMsnger(mMsnger)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

