//
//  SeriesViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/16/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class SeriesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    @IBOutlet weak var episodesCollectionView: UICollectionView!
    
    weak var parentEpisodeViewController:EpisodeViewController?
    
    let UGManager = UitzendingGemistManager.sharedInstance
    
    var mid:String? {
        didSet {
            UGManager.getSerie(mid!, success: { serie in
                self.serie = serie
            }) { error in
                debugPrint("error getting series for mid '\(self.mid)' (\(error))")
            }
        }
    }

    var serieImage:UIImage?
    
    var serie:JSON? {
        didSet {
            if let serie = self.serie {
                setSerieInformation(serie)
                episodesCollectionView.reloadData()
                
                // get serie image
                if let imageString = serie["image"].string, imageURL = NSURL(string: imageString), imageData = NSData(contentsOfURL: imageURL), image = UIImage(data: imageData) {
                    self.serieImage = image
                }

                self.view.stopLoading()
            }
        }
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        self.view.startLoading(parentEpisodeViewController?.backgroundImageView.image)
    }
    
    //MARK: Set series information
    
    func setSerieInformation(serie: JSON) {
        // get background image
        backgroundImageView.setImageWithJSON(serie)
        
        // set title
        if let name = serie["name"].string {
            titleLabel.text = name
        }
        
        // set genres
        genreLabel.text = serie.getFormattedGenre()
    }
    
    //MARK: Episodes Collection

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if let serie = self.serie, episodes = serie["episodes"].array {
            count = episodes.count > 0 ? episodes.count : 0
        }
        
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EpisodeCell", forIndexPath: indexPath) as! EpisodeCollectionViewCell
        
        if let episode = self.serie?["episodes"][indexPath.row] {
            if let serieImageURL = self.serie?["image"].string {
                cell.serieImageURL = NSURL(string: serieImageURL)
            }
            
            cell.episode = episode
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let row = context.nextFocusedIndexPath?.row, serie = self.serie {
            let episode = serie["episodes"][row]
            
            // update episode title
            if let title = episode["name"].string {
                episodeTitleLabel.text = title
            }
            
            // update episode description
            if let description = episode["description"].string {
                episodeDescriptionLabel.text = description
            }
        }
    }

    var episodeMID = ""
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let serie = self.serie, episodeMID = serie["episodes"][indexPath.row]["mid"].string {
            if let vc = parentEpisodeViewController {
                vc.mid = episodeMID
                dismissViewControllerAnimated(true, completion: { })
            } else {
                // we need to segue to the episode
                self.episodeMID = episodeMID
                performSegueWithIdentifier("SeriesToEpisodeSegue", sender: self)
            }
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EpisodeViewController
        vc.mid = episodeMID
    }
}