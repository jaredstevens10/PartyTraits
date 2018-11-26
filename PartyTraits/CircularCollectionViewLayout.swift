//
//  CircularCollectionViewLayout.swift
//  PartyTraits
//
//  Created by Jared Stevens2 on 12/9/16.
//  Copyright © 2016 Jared Stevens. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    
  
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle*1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone?) -> Any {
        
          print("Attributes shown")
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
    
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    
   // let itemSize = CGSize(width: 223, height: 295)
    let itemSize = CGSize(width: 267, height: 354)
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection: 0)-1)*anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme*collectionView!.contentOffset.x/(collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width/radius)
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0))*itemSize.width,
                      height: collectionView!.bounds.height)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
          print("Preparing Layout")
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width/2.0)
        let anchorPointY = ((itemSize.height/2.0) + radius)/itemSize.height
        //1
        let theta = atan2(collectionView!.bounds.width/2.0, radius + (itemSize.height/2.0) - (collectionView!.bounds.height/2.0)) //1
        //2
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        //3
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle)/anglePerItem))
        }
        //4
        endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
        //5
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        attributesList = (startIndex...endIndex).map { (i) -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            attributes.angle = self.angle + (self.anglePerItem*CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
    }
    
    
    /*
     func layoutAttributesForElements(in rect: CGRect) -> [AnyObject]? {
     return attributesList
     }
     */
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes! {
            return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //Uncomment the section below to activate snapping behavior
    /*
     override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
     var finalContentOffset = proposedContentOffset
     let factor = -angleAtExtreme/(collectionViewContentSize().width - CGRectGetWidth(collectionView!.bounds))
     let proposedAngle = proposedContentOffset.x*factor
     let ratio = proposedAngle/anglePerItem
     var multiplier: CGFloat
     if (velocity.x > 0) {
     multiplier = ceil(ratio)
     } else if (velocity.x < 0) {
     multiplier = floor(ratio)
     } else {
     multiplier = round(ratio)
     }
     finalContentOffset.x = multiplier*anglePerItem/factor
     return finalContentOffset
     }
     */
}

