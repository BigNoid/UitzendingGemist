//
//  FeaturedCollectionViewCell.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/16/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class FeaturedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var featuredNameLabel: UILabel!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    @IBOutlet weak var infoCollectionView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var featured:JSON? {
        didSet {
            if let featured = self.featured {
                // set name
                if let name = featured["name"].string {
                    featuredNameLabel.text = name
                }
                
                // set broadcaster
                if let title = featured["episode"]["series"]["name"].string, broadcastersJSON = featured["episode"]["broadcasters"].array {
                    var broadcasters:[String] = []
                    for broadcaster in broadcastersJSON {
                        if let broadcasterName = broadcaster.string {
                            broadcasters.append(broadcasterName)
                        }
                    }
                    
                    let broadcasterNames = (broadcasters.count > 0) ? broadcasters.joinWithSeparator(", ") : ""
                    
                    featuredTitleLabel.text = "\(title) (\(broadcasterNames))"
                }
                
                featuredImageView.setImageWithJSON(featured)
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
            self.featuredImageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.featuredImageView.adjustsImageWhenAncestorFocused = false
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