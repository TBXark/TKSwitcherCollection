//
//  TKBaseSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

public typealias ValueChangeHook  = (_ value: Bool) -> Void
internal func CGPointScaleMaker(_ scale: CGFloat) -> ((CGFloat, CGFloat) -> CGPoint) {
    return { (x, y) in
        return CGPoint(x: x * scale ,y: y * scale)}
}

protocol TKViewScale {}
extension TKViewScale where Self: UIView  {
    var sizeScale: CGFloat {
        return min(self.bounds.width, self.bounds.height)/100.0
    }
}

// 自定义 Switch 基类
open class TKBaseSwitch: UIControl {
    
    // MARK: - Property
    open var valueChange : ValueChangeHook?
    internal var on : Bool = true
    open var animateDuration : Double = 0.4

    func setOn(_ on: Bool, animate: Bool) {
        if on != isOn {
            changeValue()
        }
    }
    
    // MARK: - Getter
    open var isOn : Bool{
        return on
    }
    
    convenience public init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    }

    
    internal func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TKBaseSwitch.changeValue))
        self.addGestureRecognizer(tap)        
    }
    
    internal func changeValue(){
        if valueChange != nil{
            valueChange!(isOn)
        }
        sendActions(for: UIControlEvents.valueChanged);
        on = !on
    }

}



