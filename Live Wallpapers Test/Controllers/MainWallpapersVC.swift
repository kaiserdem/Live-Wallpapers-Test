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
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadResourseToFilemanager()
    
    let videoUrl = checkVideoConteint()
    let imageUrl = checkImageConteint()
    
    renderWallpapers(imageUrl: imageUrl!, videoUrl: videoUrl!, isSave: false)
    
  }
  
  func loadResourseToFilemanager() {
    
    let wallpapers = WallpaperList.getWallpaperList()[0].wallpapers
    
    for i in wallpapers {
      let filenameImage = i.image + i.imageType
      let bundlePathImage = Bundle.main.path(forResource: i.image, ofType: i.imageType)
      
      let filenameVideo = i.video + i.videoType
      let bundlePathVideo = Bundle.main.path(forResource: i.video, ofType: i.videoType)
      
      copyfileToDocs(bundlePathImage!, filenameImage)
      copyfileToDocs(bundlePathVideo!, filenameVideo)
    }
  }
  
  func copyfileToDocs(_ bundlePath: String, _ filename: String){
    
    print(bundlePath, "\n") //prints the correct path
    let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let fileManager = FileManager.default
    let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent(filename)
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
    
    let filename = getDocumentsDirectory().appendingPathComponent("image2.jpg")
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Image file is found")
      return filename
      
    } else {
      print("error: Image file not found")
      return nil
    }
  }
  
  private func checkVideoConteint() -> URL? {
    
    let filename = getDocumentsDirectory().appendingPathComponent("video2.mov")
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Video file is found")
      return filename
      
    } else {
      print("error: Video file not found")
      return nil
      
    }
  }
  
  
  func renderWallpapers(imageUrl: URL, videoUrl: URL, isSave: Bool?) {
    
    if isSave == false {
      DispatchQueue.main.async {
        self.livePhotoView.alpha = 0
        self.imageView.alpha = 1
        let data = try? Data(contentsOf: imageUrl)
        self.imageView.image = UIImage(data: data!)
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
      }
    }
    
    LivePhoto.generate(from: imageUrl, videoURL: videoUrl, progress: { (percent) in
      print(percent)
      
    }) { [weak self] (livePhoto, resources) in
      self?.livePhotoView.livePhoto = livePhoto
      self?.livePhotoView.startPlayback(with: .full)
      
      if let resources = resources {
        
        if isSave == false {
          DispatchQueue.main.async {
            self?.livePhotoView.alpha = 1
            self?.imageView.alpha = 0
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
          }
        }
        if isSave == true {
          LivePhoto.saveToLibrary(resources, completion: { (success) in
            
            if success {
              if success {
                self?.postAlert("Живая фотография сохранена в гелерею")
              }
              else {
                self?.postAlert("Живая фотография не сохранена")
              }
            }
          })
        }
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
    let videoUrl = checkVideoConteint()
    let imageUrl = checkImageConteint()
    
    renderWallpapers(imageUrl: imageUrl!, videoUrl: videoUrl!, isSave: true)
  }
}

