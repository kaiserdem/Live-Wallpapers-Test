//
//  WallpaperList.swift
//  Live Wallpapers Test
//
//  Created by Kaiserdem on 18.01.2020.
//  Copyright © 2020 Kaiserdem. All rights reserved.
//

import UIKit

class WallpaperList {
  
  var wallpapers: [Wallpaper]
  
  init(includeWallpapers: [Wallpaper]) {
    wallpapers = includeWallpapers
  }
  class func getWallpaperList() -> [WallpaperList] {
    return [wallpapers()]
  }
  
  //MARK: - Private Halper Methods
  
  private class func wallpapers() -> WallpaperList {
    
    var wallpapers = [Wallpaper]()
    
    wallpapers.append(Wallpaper(image: "image1", imageType: ".jpg", video: "video1", videoType: ".mov"))
    wallpapers.append(Wallpaper(image: "image2", imageType: ".jpg",video: "video2", videoType: ".mov"))
    wallpapers.append(Wallpaper(image: "image3", imageType: ".jpg",video: "video3", videoType: ".mov"))
                        
    return WallpaperList(includeWallpapers: wallpapers)
  }  
}
