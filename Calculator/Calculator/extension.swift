//
//  extension UIView.swift
//  Calculator
//
//  Created by Michel Deiman on 16/05/16.
//  Copyright © 2016-2017 Michel Deiman. All rights reserved.
//

import UIKit

extension UIViewController
{
	var contentViewController: UIViewController? {
		if let navcon = self as? UINavigationController {
			return navcon.visibleViewController
		} else {
			return self
		}
	}
}

extension CGPoint {
	mutating func offsetBy(dx: CGFloat, dy: CGFloat) {
		self.x += dx
		self.y += dy
	}
}


