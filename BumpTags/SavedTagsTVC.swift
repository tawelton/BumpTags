//
//  SavedTagsTVC.swift
//  BumpTags
//
//  Created by Tanner Welton on 7/27/17.
//  Copyright © 2017 Lyaze Technology. All rights reserved.
//

import UIKit

class SavedTagsTVC: UITableViewController{

    //MARK: Properties
    var records = [BTRecord]()
    
    // Necessary for table to function -- found in Apple Guide --------------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        
        
        return cell
    }
    
    // ----------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tableView.tableFooterView = UIView()
        
        
        
//        func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//            return UIImage(named: "TapToScan")
//        }
//
//        func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//            let text = "You have no items"
//            let attribs = [
//                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
//                NSAttributedStringKey.foregroundColor: UIColor.darkGray
//            ]
//
//            return NSAttributedString(string: text, attributes: attribs)
//        }
//
//        func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
//            let text = "Add items to track the things that are important to you. Add your first item by tapping the + button."
//
//            var para = NSMutableParagraphStyle()
//            para.lineBreakMode = NSLineBreakMode.byWordWrapping
//            para.alignment = NSTextAlignment.center
//
//            let attribs = [
//                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
//                NSAttributedStringKey.foregroundColor: UIColor.lightGray,
//                NSAttributedStringKey.paragraphStyle: para
//            ]
//
//            return NSAttributedString(string: text, attributes: attribs)
//        }
//
//        func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
//            let text = "Add First Item"
//            let attribs = [
//                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
//                NSAttributedStringKey.foregroundColor: view.tintColor
//                ] as [NSAttributedStringKey : Any]
//
//            return NSAttributedString(string: text, attributes: attribs)
//        }
//        func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
//            return true
//        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
