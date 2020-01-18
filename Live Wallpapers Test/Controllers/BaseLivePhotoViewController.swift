//
//  BaseLivePhotoViewController.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 17.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

import Photos
import PhotosUI
import MobileCoreServices
import AVFoundation
import AVKit

class BaseLivePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHLivePhotoViewDelegate {
  
  var playerController: AVPlayerViewController?
  var player: AVPlayer?
  var livePhotoBadgeLayer = CALayer()
  
 
  @IBOutlet var livePhotoView: PHLivePhotoView!
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    livePhotoView.contentMode = .scaleAspectFill
    livePhotoView.delegate = self
    
    let livePhotoBadge = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
    
    guard let livePhotoBadgeImage = livePhotoBadge.cgImage else {
      return
    }
    
    self.livePhotoBadgeLayer.frame = livePhotoView.bounds
    self.livePhotoBadgeLayer.contentsGravity = CALayerContentsGravity.topLeft
    self.livePhotoBadgeLayer.isGeometryFlipped = true
    self.livePhotoBadgeLayer.contentsScale = UIScreen.main.scale
    
    self.livePhotoBadgeLayer.contents = livePhotoBadgeImage
    livePhotoView.layer.addSublayer(self.livePhotoBadgeLayer)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if self.livePhotoView.livePhoto != nil {
      self.livePhotoView.startPlayback(with: .hint)
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { () -> Void in
        self.livePhotoView.stopPlayback()
      }
    }
    
    // Get the current authorization state.
    let status = PHPhotoLibrary.authorizationStatus()
    
    if (status == PHAuthorizationStatus.authorized) {
      // Access has been granted.
    }
      
    else if (status == PHAuthorizationStatus.denied) {
      // Access has been denied.
    }
      
    else if (status == PHAuthorizationStatus.notDetermined) {
      
      // Access has not been determined.
      PHPhotoLibrary.requestAuthorization({ (newStatus) in
        
        if (newStatus == PHAuthorizationStatus.authorized) {
          
        }
          
        else {
          
        }
      })
    }
      
    else if (status == PHAuthorizationStatus.restricted) {
      // Restricted access - normally won't happen.
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func playVideo(_ url:URL) {
    let asset = AVAsset(url:url)
    if asset.isPlayable {
      DispatchQueue.main.async {
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.playerController?.player = self.player
        self.player?.play()
      }
    }
  }
  
  // MARK: UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: PHLivePhotoViewDelegate
  
  func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
    self.livePhotoBadgeLayer.opacity = 0.0
  }
  
  func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
    self.livePhotoBadgeLayer.opacity = 1.0
  }
}
