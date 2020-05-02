//
//  PinchLayout.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/29/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class PinchLayout: UICollectionViewFlowLayout {
    
    var pinchedCellScale: CGFloat? {
        didSet {
            self.invalidateLayout()
        }
    }
    
    var pinchedCellCenter: CGPoint? {
        didSet {
            self.invalidateLayout()
        }
    }
    
    var pinchedCellPath: IndexPath?
    
    //MARK:- For Future References
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        
        for layoutAttribute in layoutAttributes {
            applyPinchLayoutToAttributes(layoutAttribute)
        }
        
        return layoutAttributes
    }
    
    func applyPinchLayoutToAttributes(_ layoutAttribute: UICollectionViewLayoutAttributes) {
        
        if layoutAttribute.indexPath == self.pinchedCellPath {
            layoutAttribute.transform3D = CATransform3DMakeScale(self.pinchedCellScale!, self.pinchedCellScale!, 1.0)
            layoutAttribute.center = pinchedCellCenter!
            layoutAttribute.zIndex = 1
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribtues = super.layoutAttributesForItem(at: indexPath)
        
        applyPinchLayoutToAttributes(attribtues!)
        
        return attribtues
    }
    
}

