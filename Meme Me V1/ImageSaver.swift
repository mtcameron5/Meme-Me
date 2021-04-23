//
//  ImageSaver.swift
//  Meme Me V1
//
//  Created by Cameron Augustine on 1/31/21.
//

import UIKit

class ImageSaver: NSObject {

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }

}
