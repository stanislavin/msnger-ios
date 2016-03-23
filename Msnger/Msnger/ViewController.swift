//
//  ViewController.swift
//  Msnger
//
//  Created by Stanislav Slavin on 23/03/16.
//  Copyright © 2016 Stanislav Slavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let msnger:Msnger = Msnger()
        let number = "79213276120".dataUsingEncoding(NSUTF8StringEncoding)!
        let message = "Hello from swift!".dataUsingEncoding(NSUTF8StringEncoding)!
        let lat = 0.0
        let lon = 0.0
        sendMessage(msnger, UnsafeMutablePointer(number.bytes), UnsafeMutablePointer(message.bytes), lat, lon,
            {
                code in
                let _ = code
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

