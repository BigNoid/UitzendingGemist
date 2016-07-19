//
//  EpisodeCollectionViewCell.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/17/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class EpisodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var serieImageURL:NSURL?
    
    var episode:JSON? {
        didSet {
            if let episode = self.episode {
                // set name
                if let name = episode["name"].string {
                    nameLabel.text = name
                }
                
                // set broadcast date
                if let broadcastTimestamp = episode["broadcasted_at"].double {
                    dateLabel.text = NSDate(timeIntervalSince1970: broadcastTimestamp).getFormattedDate()
                }
                
                imageView.setImageWithJSON(episode, fallbackImageURL: serieImageURL)
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