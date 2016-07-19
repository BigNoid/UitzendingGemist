//
//  DailyViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/20/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class DailyViewController: UIViewController, UITabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar! {
        didSet {
            setFormattedDays()
        }
    }
    
    var recents:JSON? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let UGManager = UitzendingGemistManager.sharedInstance
    
    //MARK: View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        setFormattedDays()
    }
    
    //MARK: Day calculation
    
    func setFormattedDays() {
        debugPrint("update days")
        for item in tabBar.items! {
            var description = ""
            
            if item.tag == 0 {
                description = "Vandaag"
            } else if item.tag == 1 {
                description = "Gisteren"
            } else if item.tag == 2 {
                description = "Eergisteren"
            } else {
                // substract days and get the dutch name
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "nl_NL")
                dateFormatter.dateFormat = "EEEE"
                description = dateFormatter.stringFromDate(getDate(item.tag)).capitalizedString
            }
            
            item.title = description
        }
    }
    
    func getDate(daysAgo: Int) -> NSDate {
        let today = NSDate()
        let dateComponents = NSDateComponents()
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: NSDate())
        let nowMinutes = comp.minute + (comp.hour * 60)
        
        // get the date for the number of days ago
        // as at the NPO the day runs from 6am to 6am, we need to check for 6 hours (= 3600 minutes)
        dateComponents.day = (nowMinutes < 360) ? -daysAgo - 1 : -daysAgo
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: today, options: NSCalendarOptions(rawValue: 0))!
    }
    
    //MARK: Collection view datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (recents != nil) ? recents!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DailyCollectionViewCell", forIndexPath: indexPath) as! DailyCollectionViewCell
        
        if let recent = recents?[indexPath.row] {
            cell.recent = recent
        }
        
        return cell
    }
    
    //MARK: Collection view delegate

    var episodeMID = ""

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let recent = recents?[indexPath.row], episodeMID = recent["episode"]["mid"].string {
            // we need to segue to the episode
            self.episodeMID = episodeMID
            performSegueWithIdentifier("DailyToEpisodeSegue", sender: self)
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EpisodeViewController
        vc.mid = episodeMID
    }
    
    //MARK: Tab Bar Delegate
    
    var previousTabBarItemTag = -1
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag != previousTabBarItemTag) {
            let date = getDate(item.tag)

            self.view.startLoading()
            
            UGManager.getDailyRecents(date, success: { recents in
                self.recents = recents
                self.view.stopLoading()
                self.previousTabBarItemTag = item.tag
            }) { error in
                debugPrint("error getting recents (\(error))")
                self.view.stopLoading()
            }
        }
    }
}