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

class WallpapersVC: BaseLivePhotoViewController {
  
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var saveButton: UIButton!
  
  var wallpaperIndex = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backButton.tintColor = .white
    loadResourseToFilemanager()
    loadWallpaper(wallpaperIndex)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func loadWallpaper(_ index: String) {
    
    let videoUrl = checkVideoConteint(index)
    let imageUrl = checkImageConteint(index)
    
    renderWallpapers(imageUrl: imageUrl!, videoUrl: videoUrl!, isSave: false)
  }
  
  // determine file path using model for write in FileManager
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
  
  // // load image and video to FileManager
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
  
  // check file availability in FileManager
  
  private func checkImageConteint(_ string: String) -> URL? {
    
    let namedImageFile = "image\(string).jpg"
    
    let filename = getDocumentsDirectory().appendingPathComponent(namedImageFile)
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Image file is found")
      return filename
      
    } else {
      print("error: Image file not found")
      return nil
    }
  }
  
  private func checkVideoConteint(_ string: String) -> URL? {
    
    let namedVideoFile = "video\(string).mov"
    
    let filename = getDocumentsDirectory().appendingPathComponent(namedVideoFile)
    
    if FileManager.default.fileExists(atPath: filename.path ) {
      print("saccess Video file is found")
      return filename
      
    } else {
      print("error: Video file not found")
      return nil
      
    }
  }
  
  // render video and image for getting livePhoto and save to photo library
  func renderWallpapers(imageUrl: URL, videoUrl: URL, isSave: Bool?) {
    
    DispatchQueue.main.async {
      self.livePhotoView.alpha = 0
      self.imageView.alpha = 1
      let data = try? Data(contentsOf: imageUrl)
      self.imageView.image = UIImage(data: data!)
      self.activityIndicator.startAnimating()
      self.activityIndicator.isHidden = false
    }
    
    // render video and image for getting livePhoto
    LivePhoto.generate(from: imageUrl, videoURL: videoUrl, progress: { (percent) in
      
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
          self?.livePhotoView.alpha = 1
          self?.imageView.alpha = 0
          self?.activityIndicator.stopAnimating()
          self?.activityIndicator.isHidden = true
          
          // save livePhoto to photo library
          LivePhoto.saveToLibrary(resources, completion: { (success) in
            
            if success {
              self?.postAlert("Живая фотография сохранена в гелерею")
            }
            else {
              self?.postAlert("Живая фотография не сохранена")
            }
          })
        }
      }
    }
  }
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  @IBAction func backButtonAction(_ sender: Any) {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let menuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
    self.present(menuVC, animated: true)
  }
  
  @IBAction func saveButtonAction(_ sender: Any) {
    let videoUrl = checkVideoConteint(wallpaperIndex)
    let imageUrl = checkImageConteint(wallpaperIndex)
    
    renderWallpapers(imageUrl: imageUrl!, videoUrl: videoUrl!, isSave: true)
  }
}

