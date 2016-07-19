//
//  DailyCollectionViewCell.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/21/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class DailyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var serieImage:UIImage?
    
    var recent:JSON? {
        didSet {
            // set broadcast date
            if let broadcastTimestamp = recent?["starts_at"].double {
                dateLabel.text = NSDate(timeIntervalSince1970: broadcastTimestamp).getFormattedDate()
            }
            
            if let episode = recent?["episode"] {
                // set name
                nameLabel.text = episode.getFormattedName()
                
                // load image
                imageView.setImageWithJSON(episode)
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
            self.imageView.adjustsImageWhenAncestorFocused = true
        } else {
            self.imageView.adjustsImageWhenAncestorFocused = false
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