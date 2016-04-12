//: Playground - noun: a place where people can play

import XCPlayground
import UIKit

let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
view.backgroundColor = .lightTextColor()
XCPlaygroundPage.currentPage.liveView = view

let whiteSquare = UIView(frame: CGRect(x: 100.0, y: 100.0, width: 100.0, height: 100.0))
whiteSquare.backgroundColor = .whiteColor()
view.addSubview(whiteSquare)

let orangeSquare =  UIView(frame: CGRect(x: 400.0, y: 100.0, width: 100.0, height: 100.0))
orangeSquare.backgroundColor = .orangeColor()
view.addSubview(orangeSquare)

let animator = UIDynamicAnimator(referenceView: view)
let gravity = UIGravityBehavior(items: [orangeSquare])
animator.addBehavior(gravity)

let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)

let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200.0
bounce.resistance = 2.0
animator.addBehavior(bounce)

animator.setValue(true, forKey: "debugEnabled")

let parentBehaviour = UIDynamicBehavior()

let viewBehaviour = UIDynamicItemBehavior(items: [whiteSquare])
viewBehaviour.density = 0.01
viewBehaviour.resistance = 10.0
viewBehaviour.friction = 0.0
viewBehaviour.allowsRotation = false
parentBehaviour.addChildBehavior(viewBehaviour)

let fieldBehaviour = UIFieldBehavior.springField()
fieldBehaviour.addItem(whiteSquare)
fieldBehaviour.position = CGPoint(x: 150.0, y: 350.0)
fieldBehaviour.region = UIRegion(size: CGSize(width: 500.0, height: 500.0))
parentBehaviour.addChildBehavior(fieldBehaviour)

animator.addBehavior(parentBehaviour)

let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
dispatch_after(delayTime, dispatch_get_main_queue()) {
    let pushBehaviour = UIPushBehavior(items: [whiteSquare], mode: .Instantaneous)
    pushBehaviour.pushDirection = CGVector(dx: 0.0, dy: -1.0)
    pushBehaviour.magnitude = 0.3
    animator.addBehavior(pushBehaviour)
}