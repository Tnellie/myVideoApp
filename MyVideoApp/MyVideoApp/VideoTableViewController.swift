//
//  VideoTableViewController.swift
//  MyVideoApp
//
//  Created by Charles Konkol on 6/1/17.
//  Copyright © 2017 Charles Konkol. All rights reserved.
//

import UIKit
//1 Imports
import MediaPlayer
import MobileCoreServices
import AVFoundation
import CoreData
import Foundation

class VideoTableViewController: UITableViewController {
    
    //2) Add variable to hold NSManagedObject
    var photoArray = [NSManagedObject]()
    
    //3 load db code
    func loaddb()
    {
        
        let managedContext  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Video")
        
        
        
        //return contactArray.count
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                photoArray = results
                tableView.reloadData()
            } else {
                print("Could not fetch")
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
        }
        
        
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        //4 func
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //5 viewWillAppear
        loaddb()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //6 Change to 1
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //7 Change to return photoArray.count
        return photoArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //8) Uncomment & Change to below to load rows
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
                as UITableViewCell!
        let person = photoArray[indexPath.row]
        cell?.textLabel?.text = person.value(forKey: "name") as! String?
        
        return cell!
    }
    
    //9) Add to show row clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\(indexPath.row)")
    }
    
    
    //10 Uncomment
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //11 Uncomment & Change to delete swiped row
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(photoArray[indexPath.row])
            var error: NSError? = nil
            do {
                try context.save()
                loaddb()
            } catch let error1 as NSError {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }
    }
    
    
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
    
    
    // MARK: - Navigation
    
    //12) Uncomment override func prepareForSegue & Change to go to proper record on proper Viewcontroller
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "video" {
            if let destination = segue.destination as?
                ViewController {
                if let SelectIndex = tableView.indexPathForSelectedRow?.row {
                    let selectedDevice:NSManagedObject = photoArray[SelectIndex] as NSManagedObject
                    destination.videodb = selectedDevice
                }
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
