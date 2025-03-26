//
//  Untitled.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

import Foundation
import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        scrollDirection = .horizontal
        minimumLineSpacing = -60
        itemSize = CGSize(width: UIScreen.main.bounds.width * 0.68, height: collectionView!.frame.height)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)

        guard let attributes = layoutAttributesForElements(in: targetRect) else { return proposedContentOffset }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2

        for layoutAttributes in attributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return nil }

        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2

        for attributes in superAttributes {
            let distance = abs(attributes.center.x - centerX)
            let scale = 1 - min(distance / collectionView.bounds.width, 0.5)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return superAttributes
    }
}

