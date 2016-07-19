//
//  StillCollectionViewCell.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/17/15.
//
//

import Foundation
import UIKit

class StillCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stillImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        // Initialization code
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if self.focused {
            self.stillImageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.stillImageView.adjustsImageWhenAncestorFocused = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
