//
//  EpisodeViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/17/15.
//
//

import Foundation
import UIKit
import SwiftyJSON
import AVKit

class EpisodeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timesViewedLabel: UILabel!
    @IBOutlet weak var stillCollectionView: UICollectionView!
    @IBOutlet weak var playButton: UIButton!
    
    let UGManager = UitzendingGemistManager.sharedInstance
    
    //http://apps-api.uitzendinggemist.nl/episodes/KN_1673147.json
    var mid:String? {
        didSet {
            self.view.startLoading()

            UGManager.getEpisode(mid!, success: { episode in
                self.episode = episode
                self.view.stopLoading()
            }) { error in
                debugPrint("error getting episode for mid '\(self.mid)' (\(error))")
                self.view.stopLoading()
            }
        }
    }
    
    var episode:JSON? {
        didSet {
            if let episode = self.episode {
                setEpisodeInformation(episode)
            }
        }
    }
    
    var stills:JSON? {
        didSet {
            stillCollectionView.reloadData()
        }
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(animated: Bool) {
        // setting the focus on the play button will be ignored by the focus engine
        // instead focussing on the parent viewcontroller itself solves the issue
        // see: http://nerds.airbnb.com/tvos-focus-engine/
        // this only works if we focus the playButton first
        playButton.setNeedsFocusUpdate()
        playButton.updateFocusIfNeeded()
        // and then focus ourselves...
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
    }
    
    //MARK: Episode information
    
    func setEpisodeInformation(episode: JSON) {
        // set background image
        backgroundImageView.setImageWithJSON(episode)
        
        // set description
        if let description = episode["description"].string {
            descriptionLabel.text = description
        }
        
        // set title
        titleLabel.text = episode.getFormattedName()
        
        // set genres
        genreLabel.text = episode.getFormattedGenre()
        
        // set duration
        if let duration = episode["duration"].int64 {
            durationLabel.text = duration.getFormattedDuration()
        }
        
        // set times viewed
        if let views = episode["views"].int64 {
            timesViewedLabel.text = views.getFormattedTimesViewed()
        }
        
        // set stills
        self.stills = episode["stills"]
    }
    
    //MARK: Viewed
    
    func setTimesViewed(total: Int64) {
        
    }
    
    //MARK: Still collection view
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (stills != nil) ? stills!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:StillCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("StillCell", forIndexPath: indexPath) as! StillCollectionViewCell

        if let still = stills![indexPath.row]["url"].string, stillURL = NSURL(string: still) {
            cell.stillImageView.af_setImageWithURL(stillURL)
        }
        
        return cell
    }

    //MARK: Play button
    
    @IBAction func playEpisode(sender: UIButton) {
        if let mid = self.mid {
            playVideo(mid)
        }
    }
    
    func playVideo(mid: String) {
        UGManager.getVideoURL(mid, success: { url in
            let player = AVPlayer(URL: NSURL(string: url)!)
            let playerViewController = PlayerViewController()
            playerViewController.player = player
            
            self.presentViewController(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }) { error in
            debugPrint("could not get video stream for mid '\(mid)' (\(error))")
        }
    }
    
    //MARK: Go to series button
    
    var seriesMID = ""
    
    @IBAction func goToSeries(sender: UIButton) {
        if let episode = self.episode, seriesMID = episode["series"]["mid"].string {
            self.seriesMID = seriesMID
            performSegueWithIdentifier("EpisodeToSeriesSegue", sender: self)
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! SeriesViewController
        vc.parentEpisodeViewController = self
        vc.mid = seriesMID
    }
}