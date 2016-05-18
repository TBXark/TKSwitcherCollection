//
//  TKBaseSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

typealias ValueChangeHook  = (value:Bool) -> Void
func CGPointScaleMaker(scale: CGFloat) -> ((CGFloat, CGFloat) -> CGPoint) {
    return { (x, y) in
        return CGPointMake(x * scale ,y * scale)}
}


// 自定义 Switch 基类
class TKBaseSwitch: UIControl {
    
    // MARK: - Property
    var valueChange : ValueChangeHook?
    var on : Bool = true
    var animateDuration : Double = 0.4
    
    
    // MARK: - Getter
    var isOn : Bool{
        return on
    }
    
    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TKBaseSwitch.changeValue))
        self.addGestureRecognizer(tap)        
    }
    
    func changeValue(){
        if valueChange != nil{
            valueChange!(value: isOn)
        }
        sendActionsForControlEvents(UIControlEvents.ValueChanged);
        on = !on
    }

}


//活的视图缩放比例
extension UIView{
    var sizeScale : CGFloat{
        return min(self.bounds.width, self.bounds.height)/100.0
    }
}


