//
//  RecentSearchTableViewController.swift
//  SmashTag
//
//  Created by Xie kesong on 6/3/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {

    private var defaults = NSUserDefaults()
    
    private var searchRecord: [String]{
        get{
            return defaults.stringArrayForKey(Key.SearchHistoryArrayForUserDefault) as? [String] ?? [String]()
        }
        set{
            defaults.setObject(newValue, forKey: Key.SearchHistoryArrayForUserDefault)
        }
    }
    
    
    
    
    
    
    private var searchTime: [String:String]{
        get{
            return defaults.dictionaryForKey(Key.SearachHistoryTimeDictionaryForUserDefault) as? [String:String] ?? [String:String]()
        }
        set{
            defaults.setObject(newValue, forKey: Key.SearachHistoryTimeDictionaryForUserDefault)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return searchRecord.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Recent Search", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = searchRecord[indexPath.section]
        cell.detailTextLabel?.text = searchTime[searchRecord[indexPath.section]] ?? "N/A"
        cell.textLabel?.textColor = UIColor(red: 0.04, green: 0.65, blue: 0.84, alpha: 1.0)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            searchTime.removeValueForKey(searchRecord[indexPath.section])
            searchRecord.removeAtIndex(indexPath.section)
            //each section contains only one row, and each time the row is deleted the section is deleted as well
            tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        }
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? UINavigationController{
            if let ttvc = destination.visibleViewController as? TweetTableViewController{
                if let iden = segue.identifier{
                    switch iden{
                    case "navigate recent":
                        ttvc.searchText = (sender as? UITableViewCell)?.textLabel?.text
                    default:break
                    }
                }
            }
        }
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
