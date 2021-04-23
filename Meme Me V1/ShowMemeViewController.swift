//
//  ShowMemeViewController.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 2/5/21.
//

import UIKit

class ShowMemeViewController: UIViewController {

    @IBOutlet weak var showMemedImage: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    var meme: Meme!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showMemedImage.image = meme.originalImage
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.text = meme.bottomText
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.text = meme.topText
        
        // Add buttons to the navbar in code rather than storyboard
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
        self.navigationItem.rightBarButtonItems = [editButton]
        
        setImageOrientation(size: self.view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setImageOrientation(size: size)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let activityView = UIActivityViewController(activityItems: [self.meme.memedImage], applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
        
        // Once the memedImage has been shared, save it to the photo Library.
        activityView.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: self.meme.memedImage)
            }
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteMeme(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).memes.removeAll(where: {$0 == meme})
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func editMeme() {
        let editMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        editMemeVC.meme = meme
        self.navigationController?.pushViewController(editMemeVC, animated: true)
    }

    // Aspect fill when in portrait, aspect fit for landscape. The image is distorted in landscape otherwise.
    
    func setImageOrientation(size: CGSize) {
        if size.height > size.width {
//            self.showMemedImage.contentMode = .scaleAspectFit
            self.showMemedImage.contentMode = .scaleAspectFill
        } else {
            self.showMemedImage.contentMode = .scaleAspectFit
        }
    }
}
