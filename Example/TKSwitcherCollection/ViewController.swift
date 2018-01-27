//
//  ViewController.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit
import TKSwitcherCollection

var count : Int = 0

class ViewController: UIViewController {

    @IBOutlet var switchArray: [TKBaseSwitch]!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func animateSwitch(_ timer:Timer){
        let switcher = switchArray[count]
        switcher.setOn(switcher.isOn, animate: true)
        count += 1
        if count  == (switchArray.count){
            count = 0
            timer.invalidate()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.animateSwitch(_:)), userInfo: nil, repeats: true)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

