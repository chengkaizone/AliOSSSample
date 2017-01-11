//
//  ViewController.swift
//  AliOSSSample
//
//  Created by tony on 2017/1/11.
//  Copyright © 2017年 chengkaizone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    // 建议图片(不超过5张)
    var adviseImages: [UIImage] = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // load image
    func loadImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func uploadAction(_ sender: Any) {
        
        let adviseStr = textView.text!
            
        if adviseStr == "" || adviseStr.characters.count < 10 {
            
            NSLog("建议不得少于10个字符喔~")
            return
        }
        
        // 路径列表
        var paths: [(String, String)] = [(String, String)]()
        
        for image in self.adviseImages {
            
            let filename = String.init(format: "advise_%lu.jpg", Int64(Date().timeIntervalSince1970 * 1000))
            let filepath = saveImage(image: image, imageName: filename)
            
            NSLog("upload path:\(filename)  \(filepath)")
            paths.append((filepath, filename))
        }
        
        DispatchQueue.global().async {
            
            for (filepath, filename) in paths {// 同步上传
                
                // AliyunOSSKit.uploadObjectAsync(fileURL: URL(fileURLWithPath: filepath), filename: filename, resourcePath: "image/")
                
                let url = AliyunOSSKit.uploadObjectSync(fileURL: URL(fileURLWithPath: filepath), filename: filename, resourcePath: "image/", uploadProgressBlock: ({(bytesSent: Int64, totalByteSent: Int64, totalBytesExpectedToSend: Int64) in
                    
                    NSLog("%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                }))
                
                if url != nil {
                    NSLog("result: \(url!)")
                }
                
                do {
                    // 上传后删除路径
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: filepath))
                } catch let error {
                    
                    NSLog("upload error: \(error.localizedDescription)")
                }

            }
            
            // 提交提取的建议内容
            NSLog("advise: \(adviseStr)")
            
            DispatchQueue.main.async {
                
            }
            
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.adviseImages.count < 5 {// 小于5时需要显示添加选项
            return self.adviseImages.count + 1
        }
        
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdviseImageViewCell", for: indexPath) as! AdviseImageViewCell
        cell.delegate = self
        
        if indexPath.row >= self.adviseImages.count {// 显示
            cell.btDel.isHidden = true
            // 显示添加图片
        } else {
            cell.btDel.isHidden = false
            
            let image = self.adviseImages[indexPath.row]
            cell.imageView.image = image
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.loadImage()
    }
    
}

extension ViewController: AdviseImageViewCellDelegate {
    
    // 删除某个图片
    func cellDelete(cell: AdviseImageViewCell) {
        
        if let indexPath = self.mCollectionView.indexPath(for: cell) {
            self.adviseImages.remove(at: indexPath.row)
        }
        
        self.mCollectionView.reloadData()
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("\(info)")
        if let image = info["UIImagePickerControllerEditedImage"] as? UIImage {
            self.adviseImages.append(image)
            self.mCollectionView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

