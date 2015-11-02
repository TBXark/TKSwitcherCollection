//
//  TKMainSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

typealias ValueChangeHook  = (value:Bool) -> Void


// 自定义 Switch 基类
class TKMainSwitch: UIControl {
    
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


// 柯里化函数,快速创建按比利缩放的 Rect
func CGPointMake(scale:CGFloat)(_ x: CGFloat, _ y: CGFloat) -> CGPoint{
    return CGPointMake(x * scale ,y * scale)
}

