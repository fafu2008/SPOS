//
//  ScanWrapper.swift
//  SPOS
//
//  Created by 张晓飞 on 16/4/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class ScanWrapper: NSObject , AVCaptureMetadataOutputObjectsDelegate {
    let device:AVCaptureDevice? = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo);
    
    var input:AVCaptureDeviceInput?
    var output:AVCaptureMetadataOutput
    
    let session = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    var stillImageOutput:AVCaptureStillImageOutput?
    
    var callback : ((String)-> Void)?
    /**
     初始化设备
     - parameter videoPreView: 视频显示UIView
     - parameter objType:      识别码的类型,缺省值 QR二维码
     - parameter isCaptureImg: 识别后是否采集当前照片
     - parameter cropRect:     识别区域
     - parameter success:      返回识别信息
     - returns:
     */
    init( videoPreView:UIView , cropRect:CGRect=CGRectZero , success:( (String) -> Void) )
    {
        do{
            input = try AVCaptureDeviceInput(device: device)
        }
        catch let error as NSError {
            print("AVCaptureDeviceInput(): \(error)")
        }
        
        // Output
        output = AVCaptureMetadataOutput()
        stillImageOutput = AVCaptureStillImageOutput();
        
        super.init()
        
        if device == nil{
            return
        }
        callback = success
        
        if session.canAddInput(input){
            session.addInput(input)
        }
        if session.canAddOutput(output){
            session.addOutput(output)
        }
        if session.canAddOutput(stillImageOutput){
            session.addOutput(stillImageOutput)
        }
        
        let outputSettings:Dictionary = [AVVideoCodecJPEG:AVVideoCodecKey]
        stillImageOutput?.outputSettings = outputSettings
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        //参数设置
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]
        
        if !CGRectEqualToRect(cropRect, CGRectZero){
            //启动相机后，直接修改该参数无效
            output.rectOfInterest = cropRect
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        var frame:CGRect = videoPreView.frame
        frame.origin = CGPointZero
        previewLayer?.frame = frame
        
        videoPreView.layer.insertSublayer(previewLayer!, atIndex: 0)

        if ( device!.focusPointOfInterestSupported && device!.isFocusModeSupported(AVCaptureFocusMode.ContinuousAutoFocus) )
        {
            do
            {
                try input?.device.lockForConfiguration()
                
                input?.device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
                
                input?.device.unlockForConfiguration()
            }
            catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
                
            }
        }
        
    }
    
    func start()
    {
        if !session.running{
            session.startRunning()
        }
    }
    
    func stop()
    {
        if session.running{
            session.stopRunning()
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        
        //识别扫码类型
        for current:AnyObject in metadataObjects
        {
            if current.isKindOfClass(AVMetadataMachineReadableCodeObject)
            {
                let code = current as! AVMetadataMachineReadableCodeObject
                
                //码类型
                let codeType = code.type
                print("code type:%@",codeType)
                //码内容
                let codeContent = code.stringValue
                print("code string:%@",codeContent)
                
                callback?(codeContent)
                
                stop()
                
                break
                
            }
        }
        
    }
    
    
    func connectionWithMediaType(mediaType:String,connections:[AnyObject]) -> AVCaptureConnection?
    {
        for connection:AnyObject in connections
        {
            let connectionTmp:AVCaptureConnection = connection as! AVCaptureConnection
            for port:AnyObject in connectionTmp.inputPorts
            {
                if port.isKindOfClass(AVCaptureInputPort)
                {
                    let portTmp:AVCaptureInputPort = port as! AVCaptureInputPort
                    if portTmp.mediaType == mediaType
                    {
                        return connectionTmp
                    }
                }
            }
        }
        return nil
    }
    
    
    //MARK:切换识别区域
    func changeScanRect(cropRect:CGRect)
    {
        //待测试，不知道是否有效
        stop()
        output.rectOfInterest = cropRect
        start()
    }
    
    //MARK: 切换识别码的类型
    func changeScanType(objType:[String])
    {
        //待测试中途修改是否有效
        output.metadataObjectTypes = objType
    }
    
    func isGetFlash()->Bool
    {
        if (device != nil &&  device!.hasFlash && device!.hasTorch)
        {
            return true
        }
        return false
    }
    
    /**
     打开或关闭闪关灯
     - parameter torch: true：打开闪关灯 false:关闭闪光灯
     */
    func setTorch(torch:Bool)
    {
        if isGetFlash()
        {
            do
            {
                try input?.device.lockForConfiguration()
                
                input?.device.torchMode = torch ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
                
                input?.device.unlockForConfiguration()
            }
            catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
                
            }
        }
        
    }
    
    
    /**
     ------闪光灯打开或关闭
     */
    func changeTorch()
    {
        if isGetFlash()
        {
            do
            {
                try input?.device.lockForConfiguration()
                
                var torch = false
                
                if input?.device.torchMode == AVCaptureTorchMode.On
                {
                    torch = false
                }
                else if input?.device.torchMode == AVCaptureTorchMode.Off
                {
                    torch = true
                }
                
                input?.device.torchMode = torch ? AVCaptureTorchMode.On : AVCaptureTorchMode.Off
                
                input?.device.unlockForConfiguration()
            }
            catch let error as NSError {
                print("device.lockForConfiguration(): \(error)")
                
            }
        }
    }
    
    //MARK: -- - 生成二维码，背景色及二维码颜色设置
    static func createCode( codeType:String, codeString:String, size:CGSize,qrColor:UIColor,bkColor:UIColor )->UIImage?
    {
        //if #available(iOS 8.0, *)
        
        let stringData = codeString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        //系统自带能生成的码
        //        CIAztecCodeGenerator
        //        CICode128BarcodeGenerator
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator
        let qrFilter = CIFilter(name: codeType)
        
        
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        var qrImage : CIImage?
        //上色
        if #available(iOS 8.0, *) {
            let colorFilter = CIFilter(name: "CIFalseColor", withInputParameters: ["inputImage":qrFilter!.outputImage!,"inputColor0":CIColor(CGColor: qrColor.CGColor),"inputColor1":CIColor(CGColor: bkColor.CGColor)])
            qrImage = colorFilter!.outputImage
        } else {
            qrImage = qrFilter!.outputImage
        }
        
        //绘制
        let cgImage = CIContext().createCGImage(qrImage!, fromRect: qrImage!.extent)
        
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None);
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return codeImage
        
    }
    
    
}
