//
//  PresentableView.swift
//  ViperBase
//
//  Created by SOL on 28.04.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import UIKit

/**
 The base class for your custom views subclasses in VIPER architecture.
 Use it to implement UI classes with own presenter based on UIView.
 Also the class interprete UIView's appearance methods to UIViewController lifecycle similar interface.
 */
open class PresentableView: UIView, ViewInterface, ContentContainerInterface {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        
        setupContent()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupContent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// The strong link to class represents UX logic of your module.
    /// You can use dynamic 'as' cast to convert `PresenterInterface` to specific interface
    open var presenterInterface: PresenterInterface? {
        didSet {
            if let presenter = presenterInterface {
                presenter.viewInterface = self
                presenter.viewDidLoad()
                if self.superview != nil {
                    presenter.viewWillAppear(animated: false)
                    presenter.viewDidAppear(animated: false)
                }
            }
        }
    }
    
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        if newWindow != nil {
            presenterInterface?.viewWillAppear(animated: false)
        } else {
            presenterInterface?.viewWillDisappear(animated: false)
        }
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            presenterInterface?.viewDidAppear(animated: false)
        } else {
            presenterInterface?.viewDidDisappear(animated: false)
        }
    }
    
    // MARK: - ContentContainerInterface
    
    @objc dynamic open func setupContent() {
        // Does nothing
    }
}
