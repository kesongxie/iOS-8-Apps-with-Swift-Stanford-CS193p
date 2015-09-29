//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Xie kesong on 5/31/15.
//  Copyright (c) 2015 ___kesong___. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var searchText:String? = "#RG15"{
        didSet{
            insertSearchRecord(searchText!)
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
   
    var tweets = [[Tweet]]()
    var lastSuccessfulRequest : TwitterRequest?
    var nextRequestAttempt: TwitterRequest?{
        if lastSuccessfulRequest == nil{
            if searchText != nil{
                return TwitterRequest(search: searchText!, count:100)
            }else{
                return nil
            }
        }else{
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    
    
    
    
    
    private struct Storyboard{
        static let CellReuseIdentifier = "Tweet"
    }
    
    private func insertSearchRecord(search: String){
        var  defualts = NSUserDefaults.standardUserDefaults()
        //insert record
        var previousRecord = defualts.stringArrayForKey(Key.SearchHistoryArrayForUserDefault) as? [String] ?? [String]()
        
        var foundIndex:Int?
        for index in 0 ..< previousRecord.count{
            if previousRecord[index] == search{
                foundIndex = index
                break
            }
        }
        
        if let removeIndex = foundIndex{
            previousRecord.removeAtIndex(removeIndex)
        }
        
        
        
       // previousRecord.removeAll(keepCapacity: false)
        
        previousRecord.insert(search, atIndex: 0)
        defualts.setObject(previousRecord, forKey: Key.SearchHistoryArrayForUserDefault)
        
        //update search time
        var previousRecordDic = defualts.dictionaryForKey(Key.SearachHistoryTimeDictionaryForUserDefault) as?[String:String] ?? [String:String]()
      
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
       // var DateInFormat:String = NSDateFormatter.localizedStringFromDate(todaysDate, dateStyle: .FullStyle, timeStyle: .ShortStyle)
        var DateInFormat = dateFormatter.stringFromDate(todaysDate)
        previousRecordDic[search] = DateInFormat
        
        defualts.setObject(previousRecordDic, forKey: Key.SearachHistoryTimeDictionaryForUserDefault)
    }
    
    //wrapper function
    func refresh(){
        if refreshControl != nil{
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil{
            if let request =  nextRequestAttempt{
                request.fetchTweets{(newTweets) -> Void in //this is a call back
                    dispatch_async(dispatch_get_main_queue()){ () -> Void in
                        if newTweets.count > 0{
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        }else{
             sender?.endRefreshing()
        }
    }
    
    
    @IBAction func refreshSearch(segue:UIStoryboardSegue){
        
    }
    
    //MARK: - ViewControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight //comes from the story board
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
      

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false

    }
    
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }

    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
   
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as TweetTableViewCell
        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tvc = segue.destinationViewController as? TweetDetailTableViewController{
            if let iden = segue.identifier{
                switch iden{
                    case "Show Detail":
                        if let tweetSelected = sender as? TweetTableViewCell{
                            tvc.tweet = tweetSelected.tweet
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: searchText, style: .Plain, target: nil, action: nil)
                            self.hidesBottomBarWhenPushed = true
                        }
                default:break
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
