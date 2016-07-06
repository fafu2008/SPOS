//
//  CameraPermission.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
class CameraPermission: NSObject {

    //MARK: ---相机权限
    static func isGetCameraPermission()->Bool
    {
        
        let authStaus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        if authStaus != AVAuthorizationStatus.Denied
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: ----获取相册权限
    static func isGetPhotoPermission()->Bool
    {
        var bResult = false
        if( ALAssetsLibrary.authorizationStatus() != ALAuthorizationStatus.Denied )
        {
            bResult = true
        }
 
        return bResult
    }
    
}
