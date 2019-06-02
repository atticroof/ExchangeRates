//
//  ViewController.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ERManager.shared.update();
        // Do any additional setup after loading the view, typically from a nib.
    }


}

