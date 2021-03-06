//
//  PathMenuItem.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol PathMenuItemDelegate: NSObjectProtocol {
    func PathMenuItemTouchesBegan(item: PathMenuItem)
    func PathMenuItemTouchesEnd(item:PathMenuItem)
}

public class PathMenuItem: UIImageView {
    
    public var contentImageView: UIImageView?
    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    public var nearPoint: CGPoint?
    public var farPoint: CGPoint?
    
    public weak var delegate: PathMenuItemDelegate!
    
    private var _highlighted: Bool = false
    override public var highlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            self.contentImageView?.highlighted = newValue
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    convenience public init(image:UIImage!, highlightedImage himg:UIImage?, ContentImage cimg:UIImage?, highlightedContentImage hcimg:UIImage?) {
        self.init(frame: CGRectZero)
        self.image = image
        self.highlightedImage = himg
        self.userInteractionEnabled = true
        self.contentImageView = UIImageView(image: cimg)
        self.contentImageView?.highlightedImage = hcimg
        self.addSubview(self.contentImageView!)
    }

    private func ScaleRect(rect: CGRect, n: CGFloat) -> CGRect {
        let width = rect.size.width
        let height = rect.size.height
        return CGRectMake(CGFloat((width - width * n)/2), CGFloat((height - height * n)/2), CGFloat(width * n), CGFloat(height * n))
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let image = self.image {
            self.bounds = CGRectMake(0, 0, image.size.width, image.size.height)
        }
        if let imageView = self.contentImageView {
            let width: CGFloat! = imageView.image?.size.width
            let height: CGFloat! = imageView.image?.size.height
            imageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height)
        }
    }
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlighted = true
        if self.delegate.respondsToSelector("PathMenuItemTouchesBegan:") {
            self.delegate.PathMenuItemTouchesBegan(self)
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location:CGPoint? = touch?.locationInView(self)
        if let loc = location {
            if (!CGRectContainsPoint(ScaleRect(self.bounds, n: 1), loc)) {
                self.highlighted = false
            }
        }
    }

    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlighted = false
        let touch = touches.first
        let location:CGPoint? = touch?.locationInView(self)
        if let loc = location {
            if (CGRectContainsPoint(ScaleRect(self.bounds, n: 1), loc)) {
                self.delegate.PathMenuItemTouchesEnd(self)
            }
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.highlighted = false
    }
}
