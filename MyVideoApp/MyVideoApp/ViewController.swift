//
//  ViewController.swift
//  MyVideoApp
//
//  Created by cis290 on 6/3/17.
//  Copyright © 2017 Rock Valley College. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import CoreData
import CoreMedia
import AVKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var moviePlayer:AVPlayerViewController = AVPlayerViewController()
    
    var vidlink:String!
    
    var videodb:NSManagedObject!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var btnRecord: UIButton!
    
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
        if (videodb != nil) {
            videodb.setValue(txtName.text, forKey: "name")
        } else {
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Video", in: managedObjectContext)
            
            let photod = Video(entity: entityDescription!, insertInto: managedObjectContext)
            
            photod.name = txtName.text!
            photod.datestamp = txtDate.text!
            print("asdadadad: " + vidlink)
            photod.link = vidlink
        }
        
        do {
            try managedObjectContext.save()
            self.dismiss(animated: false, completion: nil)
        } catch let error1 as NSError {
            print(error1)
        }
        
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        let movieURL = NSURL.fileURL(withPath: vidlink!)
        
        let player = AVPlayer(url:movieURL as URL)
        
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
    }
    
    func RecordVideo() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            print("captureVideoPressed and camera available")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        else {
            print("Camera not available.")
        }
    }
    
    @IBAction func btnRecord(_ sender: UIButton) {
        
        if txtName.text == "" {
            let alert = UIAlertController(title: "Name Required", message: "Please add name for video", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            RecordVideo()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (videodb != nil) {
            txtName.text = videodb.value(forKey: "name") as? String
            txtDate.text = videodb.value(forKey: "datestamp") as? String
            print(videodb.value(forKey: "datestamp") as! String)
            vidlink = videodb.value(forKey: "link") as! String
            
            self.btnSave.title = "Update"
            btnSave.isEnabled = true
            
            btnRecord.isHidden = true
        }
        else {
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            formatter.string(from: date as Date)
            print(formatter.string(from: date as Date))
            txtDate.text = formatter.string(from: date as Date)
            txtName.becomeFirstResponder()
            btnPlay.isHidden = true
            btnSave.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playerDidfinishPlaying(note: NSNotification) {
        print("Video Finished")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let myVar: Int = Int(arc4random())
        
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let name = txtName.text! + "\(myVar)" + ".MOV"
        
        let filePathToWrite = "\(paths)/\(name)"
        
        do {
            let MovieData:NSData = try NSData(contentsOf: tempImage! as URL, options: .mappedIfSafe)
            MovieData.write(toFile: filePathToWrite, atomically: true)
            let pathString = tempImage?.relativePath
            vidlink = filePathToWrite
            print("Video Save Link: " + vidlink)
            
            UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
            btnSave.isEnabled = true
            self.dismiss(animated: true, completion: {})
        } catch {
            print(error)
            return
        }
    }
    
    func moviePlayerDidFinishPlaying(notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController) {
        print("User cancelled")
        self.dismiss(animated: true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        print("editedVideoPath: " + editedVideoPath)
        self.dismiss(animated: true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didFailWithError error: NSError) {
        self.dismiss(animated: true, completion: nil)
    }
}

