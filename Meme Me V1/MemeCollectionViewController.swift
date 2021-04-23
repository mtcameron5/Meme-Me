//
//  MemeCollectionViewController.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 2/5/21.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImage: UIImageView!
}

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.orientation.isPortrait {
            applyPortraitFlowLayout(size: view.frame.size)
        } else {
            applyLandscapeFlowLayout(size: view.frame.size)
        }

        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.memeCollectionView.reloadData()
    }
    
    // MARK: Collection View Data Source And Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let showMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowMemeViewController") as! ShowMemeViewController
        showMemeVC.meme = meme
        self.navigationController?.pushViewController(showMemeVC, animated: true)
    }
    
    @IBAction func createMeme(_ sender: Any) {
        let createMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeViewController
        self.navigationController?.pushViewController(createMemeVC, animated: true)
    }
    
    // Change the flowLayout.itemSize property based on whether the view is in portrait or landscape mode
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isPortrait {
            applyPortraitFlowLayout(size: size)
        } else {
            applyLandscapeFlowLayout(size: size)
        }
        
        self.memeCollectionView.reloadData()
    }
    
    func applyPortraitFlowLayout(size: CGSize) {
        let widthDimension = size.width / 2.0
        let heightDimension = size.height / 3.5
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    func applyLandscapeFlowLayout(size: CGSize) {
        let widthDimension = size.width / 4.0
        let heightDimension = size.height / 2.3
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
}
