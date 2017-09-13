//
//  GraphView.swift
//  Calculator III
//
//  Created by Michel Deiman on 14/03/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//
import UIKit

@IBDesignable
class GraphView: UIView
{
	@IBInspectable var scale: CGFloat = 100 { didSet { setNeedsDisplay() }}
	@IBInspectable var origin: CGPoint! 	{ didSet { setNeedsDisplay() }}
	@IBInspectable var color: UIColor = UIColor.blue        { didSet { setNeedsDisplay() }}
	@IBInspectable var axesColor: UIColor = UIColor.black   { didSet { setNeedsDisplay() }}
	@IBInspectable var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() }}
	
	weak var dataSource: GraphViewDataSource?
	
	// set when bounds change (ie rotation), 
	// to maintain relative origin
	var boundsBeforeTransitionToSize: CGRect?
	
	func zoom(recognizer: UIPinchGestureRecognizer) {
		switch recognizer.state {
		case .began:
			localContentScaleFactor = gesturingContentScaleFactor
		case .changed:
			scale *= recognizer.scale
			recognizer.scale = 1.0
		case .ended:
			localContentScaleFactor = contentScaleFactor
			storeData()
		default: break
		}
	}
	
	func pan(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			localContentScaleFactor = gesturingContentScaleFactor
		case .changed:
			let translation = recognizer.translation(in: self)
			origin.offsetBy(dx: translation.x, dy: translation.y)
			recognizer.setTranslation(CGPoint.zero, in: self)
		case .ended:
			localContentScaleFactor = contentScaleFactor
			storeData()
		default: break
		}
	}
	
	func setOrigin(recognizer: UITapGestureRecognizer) {
		origin = recognizer.location(in: self)
		storeData()
	}
	
	override internal func draw(_ rect: CGRect) {
		super.draw(rect)
		if origin == nil {
			origin = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
			storeData()
		} else if boundsBeforeTransitionToSize != nil { // interface rotation
			origin.x = origin.x * bounds.width / boundsBeforeTransitionToSize!.width
			origin.y = origin.y * bounds.height / boundsBeforeTransitionToSize!.height
			boundsBeforeTransitionToSize = nil
		}
		if axesDrawer == nil {
			axesDrawer = AxesDrawer(color: axesColor, contentScaleFactor: localContentScaleFactor)
		}
        axesDrawer!.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
		if let fx = dataSource?.graphView {
			drawMathFunction(fx: fx)
		}
	}
	
	func storeData() {
		let dataToSave = [scale, origin.x, origin.y]
		userdefaults.set(dataToSave, forKey: Keys.ScaleAndOrigin)
	}
	
	func restoreData() {
		if let dataToRestore = userdefaults.array(forKey: Keys.ScaleAndOrigin) as? [CGFloat], dataToRestore.count == 3
		{
			scale = dataToRestore[0]
			origin = CGPoint(x: dataToRestore[1], y: dataToRestore[2])
		}
	}

	///////////////////////////  private methods and properties
	// for performance, use low contentScaleFactor when 'gesturing'
	private var gesturingContentScaleFactor: CGFloat = 0.3
	private var localContentScaleFactor: CGFloat!

	private var axesDrawer: AxesDrawer?
	
	private func drawMathFunction(fx: @escaping (CGFloat) -> CGFloat)
	{
		let maxY = bounds.maxY + bounds.height * 0.2
		let minY = bounds.minY - bounds.height * 0.2
		let minX = Int(bounds.minX * localContentScaleFactor)
		let maxX = Int(bounds.maxX * localContentScaleFactor)
		
		func isValidTargetPointFor(x: CGFloat) -> CGPoint? {
			let cartesianY = fx((x - origin.x) / scale)
			guard cartesianY.isNormal || cartesianY.isZero else { return nil }
			let y = origin.y - cartesianY * scale
			let yIsInBounds = y >= minY && y <= maxY
			return yIsInBounds ? CGPoint(x: x, y: y) : nil
		}
		
		color.set()
		var path: UIBezierPath?
		for pixelX in minX...maxX
		{
			let x = CGFloat(pixelX) / localContentScaleFactor
			if let targetPoint = isValidTargetPointFor(x: x) {
				path?.addLine(to: targetPoint)
				if path == nil {
					path = UIBezierPath()
                    path!.move(to: targetPoint)
				}
			} else  {
				path?.lineWidth = lineWidth
				path?.stroke()
				path = nil
			}
		}
		path?.lineWidth = lineWidth
		path?.stroke()
	}

	private let userdefaults = UserDefaults.standard
	private struct Keys {
		static let ScaleAndOrigin = "GraphViewScaleAndOrigin"
	}
	
//	deinit {
//		print("memory leaks?")
//	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		localContentScaleFactor = contentScaleFactor
		if axesDrawer == nil {
			axesDrawer = AxesDrawer(color: axesColor, contentScaleFactor: localContentScaleFactor)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		localContentScaleFactor = contentScaleFactor
		if axesDrawer == nil {
			axesDrawer = AxesDrawer(color: axesColor, contentScaleFactor: localContentScaleFactor)
		}
	}
}
