//
//  TKMainSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

typealias ValueChangeHook  = (value:Bool) -> Void

class TKMainSwitch: UIView {
    
    // MARK: - Property
    var valueChange : ValueChangeHook?
    var on : Bool = true
    var animateDuration : Double = 0.4
    
    
    // MARK: - Getter
    var isOn : Bool{
        return on
    }
    
    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: "changeValue")
        self.addGestureRecognizer(tap)        
    
    }
    
    func changeValue(){
        if valueChange != nil{
            valueChange!(value: isOn)
        }
        on = !on
    }

}


extension UIView{
    var sizeScale : CGFloat{
        return min(self.bounds.width, self.bounds.height)/100.0
    }
}

func CGPointMake(scale:CGFloat)(_ x: CGFloat, _ y: CGFloat) -> CGPoint{
    return CGPointMake(x * scale ,y * scale)
}

