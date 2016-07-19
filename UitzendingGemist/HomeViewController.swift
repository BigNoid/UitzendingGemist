//
//  HomeViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/16/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    let UGManager = UitzendingGemistManager.sharedInstance
    
    var episodeMID:String?
    
    var featured:JSON? {
        didSet {
            featuredCollectionView.reloadData()
        }
    }
    
    var popular:JSON? {
        didSet {
            popularCollectionView.reloadData()
        }
    }
    
    var recent:JSON? {
        didSet {
            recentCollectionView.reloadData()
        }
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Fetch data
    
    func refresh() {
        self.featured = nil
        UGManager.getFeatured(success: { featured in
            self.featured = featured
        }) { error in
            debugPrint("error getting series (\(error))")
        }
        
        self.popular = nil
        UGManager.getPopular(success: { popular in
            self.popular = popular
        }) { error in
            debugPrint("error getting series (\(error))")
        }
        
        self.recent = nil
        UGManager.getRecent(success: { recent in
            self.recent = recent
        }) { error in
            debugPrint("error getting series (\(error))")
        }
    }
    
    //MARK: Collection View Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.featuredCollectionView) {
            return (featured != nil) ? featured!.count : 0
        } else if (collectionView == self.recentCollectionView) {
            return (recent != nil) ? recent!.count : 0
        } else {
            return (popular != nil) ? popular!.count : 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (collectionView == self.featuredCollectionView) {
            return featuredCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else if (collectionView == self.recentCollectionView) {
            return recentCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        } else {
            return popularCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == featuredCollectionView {
            featuredCollectionView(didSelectItemAtIndexPath: indexPath)
        } else if (collectionView == self.recentCollectionView) {
            recentCollectionView(didSelectItemAtIndexPath: indexPath)
        } else {
            popularCollectionView(didSelectItemAtIndexPath: indexPath)
        }
    }
    
    //MARK: Featured Collection View
    
    func featuredCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FeaturedCell", forIndexPath: indexPath) as! FeaturedCollectionViewCell
        
        if let featured = featured?[indexPath.row] {
            cell.featured = featured
        }
        
        return cell
    }
    
    func featuredCollectionView(didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // get featured item
        if let episode = featured?[indexPath.row], mid = episode["episode"]["mid"].string {
            episodeMID = mid
            performSegueWithIdentifier("HomeToEpisodeSegue", sender: self)
        } else {
            debugPrint("no featured mid!")
        }
    }
    
    //MARK: Popular Collection View
    
    func popularCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PopularCell", forIndexPath: indexPath) as! PopularCollectionViewCell
        
        if let episode = popular?[indexPath.row] {
            cell.episode = episode
        }
        
        return cell
    }
    
    func popularCollectionView(didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // get popular item
        if let episode = popular?[indexPath.row], mid = episode["mid"].string {
            episodeMID = mid
            performSegueWithIdentifier("HomeToEpisodeSegue", sender: self)
        } else {
            debugPrint("no popular mid!")
        }
    }
    
    
    //MARK: Recent Collection View
    
    func recentCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecentCell", forIndexPath: indexPath) as! RecentCollectionViewCell
        
        if let episode = recent?[indexPath.row]["episode"] {
            cell.episode = episode
        }
        
        return cell
    }
    
    func recentCollectionView(didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // get popular item
        if let info = recent?[indexPath.row], mid = info["episode"]["mid"].string {
            episodeMID = mid
            performSegueWithIdentifier("HomeToEpisodeSegue", sender: self)
        } else {
            debugPrint("no popular mid!")
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EpisodeViewController
        vc.mid = episodeMID
    }
}