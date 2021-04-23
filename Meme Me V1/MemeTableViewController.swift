//
//  MemeHistoryViewController.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 2/4/21.
//

import UIKit

// Create class for TableViewCells for custom layout
class tableViewCell : UITableViewCell {
    @IBOutlet weak var memedPhotoImageView: UIImageView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var bottomTextView: UITextView!
}

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var memeTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.memeTableView.reloadData()
    }
    
    // MARK: Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMeme = memes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! tableViewCell
        cell.memedPhotoImageView.image = currentMeme.memedImage
        cell.topTextView.text = currentMeme.topText
        cell.bottomTextView.text = currentMeme.bottomText

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let showMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowMemeViewController") as! ShowMemeViewController
        showMemeVC.meme = meme
        self.navigationController?.pushViewController(showMemeVC, animated: true)
    }

    @IBAction func createMeme(_ sender: Any) {
        let createMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeViewController
        self.navigationController?.pushViewController(createMemeVC, animated: true)
    }
}
