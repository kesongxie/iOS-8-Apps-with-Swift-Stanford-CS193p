//
//  TweetDetailTableViewController.swift
//  SmashTag
//
//  Created by Xie kesong on 6/1/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    struct renderInfo{
        static let numebrOfSections = 4
        static let titleHeightForSection:CGFloat = 36
        static let headerColorForImageSection = UIColor.whiteColor()
        static let headerTextColor = UIColor.whiteColor()
    }
    struct identifier{
        static let refreshSearchIden = "Refresh Search"
        static let previewImage = "Preview Image"
        static let openWebView = "Open URL"
    }
    
    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return renderInfo.numebrOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return tweet?.media.count ?? 0
        case 1:
            return tweet?.hashtags.count ?? 0
        case 2:
            return tweet?.userMentions.count ?? 0
        case 3:
            return tweet?.urls.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section != 0{
            return UITableViewAutomaticDimension
        }else{
            if let ratio =  tweet?.media[indexPath.row].aspectRatio {
                return tableView.frame.width / CGFloat(ratio)
            }else{
                return 0
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
             let cell = tableView.dequeueReusableCellWithIdentifier("Tweet Detail With Media", forIndexPath: indexPath) as DetailTableViewCell
            cell.tweet = tweet
            cell.rowInSection = indexPath.row
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("URLReuseIden", forIndexPath: indexPath) as URLTableViewCell
            cell.sectionInTable = indexPath.section
            cell.rowInSection = indexPath.row
            cell.tweet = tweet
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("Tweet Detail Without Media", forIndexPath: indexPath) as PlainDetailTableViewCell
            cell.sectionInTable = indexPath.section
            cell.rowInSection = indexPath.row
            cell.tweet = tweet
            return cell
        }
     }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            if tweet?.media.count > 0{
                return renderInfo.titleHeightForSection
            }
        case 1:
            if tweet?.hashtags.count > 0{
                return renderInfo.titleHeightForSection
            }
        case 2:
            if tweet?.userMentions.count > 0{
                return renderInfo.titleHeightForSection
            }
        case 3:
            if tweet?.urls.count > 0{
                return renderInfo.titleHeightForSection
            }
        default:
            return 0
        }
        return 0
  }
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let iden = segue.identifier{
            switch iden{
            case identifier.refreshSearchIden:
                if let destination = segue.destinationViewController as? TweetTableViewController{
                    destination.searchText = (sender as? PlainDetailTableViewCell)?.keyWord
                }
            case identifier.previewImage:
                if let destination = segue.destinationViewController as? PreviewViewController{
                    destination.imageUrl = (sender as? DetailTableViewCell)?.imageUrl
                }
            case identifier.openWebView:
                if let destination = segue.destinationViewController as? WebViewController{
                    destination.url = (sender as? URLTableViewCell)?.keyWord
                    self.hidesBottomBarWhenPushed = true
                }
            default:break
            }
        
        }
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch section{
        case 0:
            if tweet?.media.count > 0{
                let headerView = view as UITableViewHeaderFooterView
               // headerView.contentView.backgroundColor = renderInfo.headerColorForImageSection
              //  headerView.textLabel.textColor = renderInfo.headerTextColor
            }
        default:break
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            if tweet?.media.count > 0{
                return "Images"
            }
        case 1:
            if tweet?.hashtags.count > 0{
                return "Hash Tags"
            }
        case 2:
            if tweet?.userMentions.count > 0{
                return "User Mentioned"
            }
        case 3:
            if tweet?.urls.count > 0{
                return "Urls"
            }
        default:
            return nil
        }
        return nil
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
