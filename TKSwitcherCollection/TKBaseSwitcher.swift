//
//  TKBaseSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

public typealias TKSwitchValueChangeHook  = (_ value: Bool) -> Void

// 自定义 Switch 基类
@IBDesignable
open class TKBaseSwitch: UIControl {
    
    // MARK: - Property
    open var valueChange : TKSwitchValueChangeHook?
    @IBInspectable open var animateDuration : Double = 0.4
    @IBInspectable open var isOn : Bool {
        set {
            on = newValue
        }
        get {
            return on
        }
    }

    internal var on : Bool = true
    internal var sizeScale: CGFloat {
        return min(self.bounds.width, self.bounds.height)/100.0
    }
    
    open override var frame: CGRect {
        didSet {
            guard frame.size != oldValue.size else { return }
            resetView()
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            guard frame.size != oldValue.size else { return }
            resetView()
        }
    }
    
    // MARK: - Getter

    
    final public func setOn(_ on: Bool, animate: Bool = true) {
        guard on != isOn else { return }
        changeValue()

    }

    
    // MARK: - Init
    convenience public init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    
    // MARK: - Internal

    internal func resetView() {
        gestureRecognizers?.forEach(self.removeGestureRecognizer)
        layer.sublayers?.forEach( { $0.removeFromSuperlayer()})
        setUpView()
    }
    
    internal func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TKBaseSwitch.changeValue))
        self.addGestureRecognizer(tap)        

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    @objc internal func changeValue(){
        on = !on
        valueChange?(!isOn)
        sendActions(for: UIControlEvents.valueChanged);
    }

}



