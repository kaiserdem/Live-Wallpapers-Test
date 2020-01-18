//
//  Wallpaper.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 18.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import Foundation

class Wallpaper {
  var image: String
  var imageType: String
  var imageUrl: String?
  var video: String
  var videoType: String
  var videoUrl: String?
  
  init(image: String,imageType: String, video: String, videoType: String) {
    self.image = image
    self.imageType = imageType
    self.video = video
    self.videoType = videoType
  }
}
