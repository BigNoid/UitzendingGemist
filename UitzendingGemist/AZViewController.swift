//
//  AZViewController.swift
//  UitzendingGemist
//
//  Created by Jeroen Wesbeek on 11/17/15.
//
//

import Foundation
import UIKit
import SwiftyJSON

class AZViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var series:JSON? {
        didSet {
            tableView.reloadData()
        }
    }
    
    let UGManager = UitzendingGemistManager.sharedInstance
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        self.view.startLoading()
        
        // get data
        UGManager.getSeries(success: { series in
            self.series = series
            self.disableEmptyTabBarItems()
            self.view.stopLoading()
        }) { error in
            debugPrint("error getting series (\(error))")

            self.view.stopLoading()
        }
    }
    
    //MARK: Serie in Section
    
    func isInSection(section: Int, serie: JSON) -> Bool {
        let sectionChar = String(UnicodeScalar(96 + section))
        var isInSection = false
        
        if let name = serie["name"].string {
            if let char = name.characters.first {
                let lowercaseChar = String(char).lowercaseString

                if (section == 0 && !("a"..."z" ~= lowercaseChar)) {
                    isInSection = true
                } else if (section > 0 && lowercaseChar == sectionChar) {
                    isInSection = true
                }
            }
        }
        
        return isInSection
    }
    
    func getSerie(section: Int, row: Int) -> JSON? {
        var foundSerie:JSON? = nil
        
        if let series = self.series {
            var count = 0
            
            for serie in series.array! {
                if isInSection(section, serie: serie) {
                    if row == count++ {
                        foundSerie = serie
                        break
                    }
                }
            }
        }
        
        return foundSerie
    }
    
    func numberOfSeries(section: Int) -> Int {
        if let series = self.series {
            var count = 0
            
            for serie in series.array! {
                if isInSection(section, serie: serie) {
                    count++
                }
            }
            
            return count
        } else {
            return 0
        }
    }
    
    //MARK: Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSeries(selectedSection)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AZTableViewCell", forIndexPath: indexPath) as! AZTableViewCell

        if let serie = getSerie(selectedSection, row: indexPath.row), name = serie["name"].string {
            cell.textLabel!.text = name
            cell.textLabel?.textAlignment = NSTextAlignment.Center
        }
        
        return cell
    }
    
    var seriesMID = ""
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let serie = getSerie(selectedSection, row: indexPath.row), seriesMID = serie["mid"].string {
            self.seriesMID = seriesMID
            performSegueWithIdentifier("AZToSeriesSegue", sender: self)
        }
    }
    
    //MARK: Tab bar
    
    var selectedSection = 0
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        selectedSection = item.tag
        tableView.reloadData()
    }
    
    func disableEmptyTabBarItems() {
        for item in tabBar.items! {
            item.enabled = numberOfSeries(item.tag) > 0
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! SeriesViewController
        vc.mid = seriesMID
    }
}