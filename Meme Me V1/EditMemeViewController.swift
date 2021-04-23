//
//  EditMemeViewController.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 2/5/21.
//

import UIKit

class EditMemeViewController: CreateMemeViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var originalImage: UIImageView!
    var navController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topText.delegate = self
        self.bottomText.delegate = self
        self.navController = self.navigationController
        
        navController.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveMeme))
    }
    
    // override viewWillAppear to prevent viewWillAppear from CreateMemeVC being called
    override func viewWillAppear(_ animated: Bool) {
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes

        self.topText.text = meme.topText
        self.bottomText.text = meme.bottomText
        self.originalImage.image = meme.originalImage
    }
    
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        // disable save button while editing, so that image does not show cursor
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if textField == bottomText {
            subscribeToKeyboardNotifications()
        }
        textField.text = ""
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        // enable save button
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if textField == bottomText {
            unsubscribeToKeyboardNotifications()
        }
    }
    
    @objc func saveMeme() {
        // Use methods written in CreateMemeVC to create new image and meme object
        let navigationBar = self.navigationController?.navigationBar
        let newMemeImage = self.saveMemedImage(topNavBar: navigationBar, bottomNavBar: nil)
        let memeObject = self.createMemeObject(memedImage: newMemeImage, topText: topText, bottomText: bottomText)
        
        // Remove old meme from array
        (UIApplication.shared.delegate as! AppDelegate).memes.removeAll(where: {$0 == meme})
        (UIApplication.shared.delegate as! AppDelegate).memes.append(memeObject)
        
        // Create alert, go back to root view controller once dismiss is tapped
        
        let alert = UIAlertController(title: "Meme Successfully Edited", message: nil, preferredStyle: .alert)
        
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
//            self.navigationController?.popToRootViewController(animated: true)
//        }));
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { action in
            self.navigationController?.popToRootViewController(animated: true)
        })

        
        present(alert, animated: true, completion: nil)

    }

}
