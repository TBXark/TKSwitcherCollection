//
//  ViewController.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

var count : Int = 0

class ViewController: UIViewController {

    @IBOutlet var switchArray: [TKMainSwitch]!
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "animateSwitch:", userInfo: nil, repeats: true)
    }
    
    func animateSwitch(timer:NSTimer){
        switchArray[count].changeValue()
        count++
        if count  == (switchArray.count){
            count = 0
            timer.invalidate()
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "animateSwitch:", userInfo: nil, repeats: true)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

