//
//  ViewController.swift
//  AliOSSSample
//
//  Created by joinhov on 2016/12/13.
//  Copyright © 2016年 tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadImageAction(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
    
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func uploadAction(_ sender: Any) {
        
        if previewImageView.image == nil {
            NSLog("请先加载图片")
            return
        }
        
        let filename = String.init(format: "%lu.jpg", Int64(Date().timeIntervalSince1970))
        let filepath = saveImage(image: previewImageView.image!, imageName: filename)
        
        NSLog("upload path: \(filepath)")
        // AliyunOSSKit.uploadObjectAsync(fileURL: URL(fileURLWithPath: filepath), filename: filename, resourcePath: "image/")
        
        let url = AliyunOSSKit.uploadObjectSync(fileURL: URL(fileURLWithPath: filepath), filename: filename, resourcePath: "image/", uploadProgressBlock: ({(bytesSent: Int64, totalByteSent: Int64, totalBytesExpectedToSend: Int64) in
            
            NSLog("%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        }))
        
        if url != nil {
            NSLog("result: \(url!)")
        }
        
    }
    
    // 保存图片并返回绝对路径
    fileprivate func saveImage(image: UIImage, imageName: String) ->String {
        
        let imageData = UIImagePNGRepresentation(image)
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = documentPath.appending("/\(imageName)")
        
        do {
            try imageData?.write(to: URL(fileURLWithPath: path))
        } catch let error {
            NSLog("upload error: \(error.localizedDescription)")
            return ""
        }
        
        return path
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("\(info)")
        previewImageView.image = info["UIImagePickerControllerEditedImage"] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

