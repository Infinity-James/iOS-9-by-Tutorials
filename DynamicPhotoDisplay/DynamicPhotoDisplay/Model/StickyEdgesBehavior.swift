//
//  StickyEdgesBehavior.swift
//  DynamicPhotoDisplay
//
//  Created by James Valaitis on 22/12/2015.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

class StickyEdgesBehavior: UIDynamicBehavior {
  
  enum StickyEdge: Int {
    case Top
    case Bottom
  }
  
  var isEnabled = true {
    didSet {
      if isEnabled {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.addItem(item)
        }
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
      } else {
        for fieldBehavior in fieldBehaviors {
          fieldBehavior.removeItem(item)
        }
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
      }
    }
  }
  
  private let edgeInset: CGFloat
  private let itemBehavior: UIDynamicItemBehavior
  private let collisionBehavior: UICollisionBehavior
  private let item: UIDynamicItem
  private let fieldBehaviors = [
                                UIFieldBehavior.springField(),
                                UIFieldBehavior.springField()
                              ]
  
  init(item: UIDynamicItem, edgeInset: CGFloat) {
    self.item = item
    self.edgeInset = edgeInset
    
    collisionBehavior = UICollisionBehavior(items: [item])
    collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    
    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 0.01
    itemBehavior.resistance = 20.0
    itemBehavior.friction = 0.0
    itemBehavior.allowsRotation = false
    
    super.init()
    
    addChildBehavior(collisionBehavior)
    addChildBehavior(itemBehavior)
    
    for fieldBehavior in fieldBehaviors {
      fieldBehavior.addItem(item)
      addChildBehavior(fieldBehavior)
    }
  }
  
  func updateFieldsInBounds(bounds: CGRect) {
    
    guard bounds != CGRect.zero else { return }
    
    let height = bounds.height
    let width = bounds.width
    let itemHeight = item.bounds.height
    
    func updateRegionForField(field: UIFieldBehavior, location: CGPoint) {
      let size = CGSize(width: width - (2.0 * edgeInset), height: height - (2.0 * edgeInset) - itemHeight)
      field.position = location
      field.region = UIRegion(size: size)
    }
    
    let top = CGPoint(x: width / 2.0, y: edgeInset + (itemHeight / 2.0))
    let bottom = CGPoint(x: width / 2.0, y: height - edgeInset - (itemHeight / 2.0))
    
    updateRegionForField(fieldBehaviors[StickyEdge.Top.rawValue], location: top)
    updateRegionForField(fieldBehaviors[StickyEdge.Bottom.rawValue], location: bottom)
  }
  
  func addLinearVelocity(velocity: CGPoint) {
    itemBehavior.addLinearVelocity(velocity, forItem: item)
  }
}