//
//  LiveCollectionViewCell.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 12/6/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class LiveCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var liveImageView: UIImageView!
    
    var name:String? {
        didSet {
            if let name = self.name, image = UIImage(named: name) {
                liveImageView.image = image
            }            
        }
    }
    
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
            self.liveImageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.liveImageView.adjustsImageWhenAncestorFocused = false
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