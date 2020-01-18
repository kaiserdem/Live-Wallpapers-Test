//
//  ViewController.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 17.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit
import PhotosUI
import AVFoundation
import LPLivePhotoGenerator

class MainWallpapersVC: BaseLivePhotoViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundlePath = Bundle.main.path(forResource: "video3", ofType: ".mov")
    
    copyfileToDocs(bundlePath!)
  }
  
  func copyfileToDocs(_ bundlePath: String){
    
    print(bundlePath, "\n") //prints the correct path
    let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let fileManager = FileManager.default
    let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("1.mov")
    let fullDestPathString = fullDestPath?.path
    print(fileManager.fileExists(atPath: bundlePath)) // prints true
    do
    {
      try fileManager.copyItem(atPath: bundlePath, toPath: fullDestPathString!)
      print("DB Copied")
    }
    catch
    {
      print("\n")
      print(error)
    }
  }
  
  private func checkImageConteint() -> URL? {
    
    let filename = getDocumentsDirectory().appendingPathComponent("image1.jpg")
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Image file is found")
      return filename
      
    } else {
      print("error: Image file not found")
      return nil
    }
  }
  
  private func checkVideoConteint() -> URL? {
    
    let filename = getDocumentsDirectory().appendingPathComponent("video1.mov")
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Video file is found")
      return filename
      
    } else {
      print("error: Video file not found")
      return nil
      
    }
  }
  
  
  func renderWallpapers(imageUrl: URL, videoUrl: URL) {
    
    LivePhoto.generate(from: imageUrl, videoURL: videoUrl, progress: { (percent) in
      print(percent)
      
    }) { [weak self] (livePhoto, resources) in
      DispatchQueue.main.async {
        self?.imageView.alpha = 0
        self?.livePhotoView.livePhoto = livePhoto
        self?.livePhotoView.startPlayback(with: .full)
      }
    }
  }
  
  private func saveImagesToDisk(image: UIImage) -> URL? {
    
    let namedImageFile = "image3.jpg"
    
    let filename = getDocumentsDirectory().appendingPathComponent(namedImageFile)
    print(filename)
    
    do {
      try image.jpegData(compressionQuality: 1)?.write(to: filename)
      return filename
    } catch {
      print("error save")
    }
    return nil
  }
  
  
  private func saveVideoToDisk(video: Data) -> URL? {
    
    let namedVideoFile = "video1.mov"
    
    let filename = getDocumentsDirectory().appendingPathComponent(namedVideoFile)
    
    do {
      try video.write(to: filename)
      return filename
    } catch let error as NSError {
      print(error)
      print("Failed to write")
    }
    
    return nil
  }
  
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  @IBAction func saveButtonAction(_ sender: Any) {
    
  }
}

