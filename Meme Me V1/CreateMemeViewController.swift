//
//  ViewController.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 1/22/21.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomNavBar: UINavigationBar!
    
    @IBOutlet weak var imagePickerViewer: UIImageView!
    @IBOutlet weak var shareMemeButton: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareMemeButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes

        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // disable share button while editing, so that image does not show cursor
        
        shareMemeButton.isEnabled = false
        
        if textField == bottomTextField {
            subscribeToKeyboardNotifications()
        }
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // enable share button
        shareMemeButton.isEnabled = true
        
        if textField == bottomTextField {
            unsubscribeToKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = saveMemedImage(topNavBar: topNavBar, bottomNavBar: bottomNavBar)
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
        
        // Once the memedImage has been shared, save it to the photo Library.
        activityView.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: memedImage)
            }
        }
        
        let meme = createMemeObject(memedImage: memedImage, topText: topTextField, bottomText: bottomTextField)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pickAnImageFromGallery(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func takePicture(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera

        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func changeFont(_ sender: Any) {
        let fontConfig = UIFontPickerViewController.Configuration()
        fontConfig.includeFaces = true
        let fontPicker = UIFontPickerViewController(configuration: fontConfig)
        fontPicker.delegate = self
        self.present(fontPicker, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            self.imagePickerViewer.image = image
        }
        
        shareMemeButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func createMemeObject(memedImage: UIImage, topText: UITextField, bottomText: UITextField) -> Meme {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerViewer.image!, memedImage: memedImage)
        return meme
    }
    
    func saveMemedImage(topNavBar: UINavigationBar?, bottomNavBar: UINavigationBar?) -> UIImage {
        
        // Hide navbars for shared image
        if let topNavBar = topNavBar {
            topNavBar.isHidden = true
        }
        
        if let bottomNavBar = bottomNavBar {
            bottomNavBar.isHidden = true
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show navbars

        if let topNavBar = topNavBar {
            topNavBar.isHidden = false
        }
        
        if let bottomNavBar = bottomNavBar {
            bottomNavBar.isHidden = false
        }
        
        return memedImage
        
    }
    
}




    


