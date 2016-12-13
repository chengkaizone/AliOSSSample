//
//  AliyunOSSKit.swift
//  AliOSSSample
//
//  Created by joinhov on 2016/12/13.
//  Copyright © 2016年 tony. All rights reserved.
//

import UIKit

// 文件操作需要用到的参数
fileprivate let AccessKey: String = "***"
fileprivate let SecretKey: String = "***"
fileprivate let endPoint: String = "http://oss-cn-shanghai.aliyuncs.com"
fileprivate let bucketName: String = "ying-resource"

/**
 * 阿里云上传接口
 */
class AliyunOSSKit: NSObject {
    
    class func confClient() ->OSSClient {
        
        let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: AccessKey, secretKey: SecretKey)
        
        let conf = OSSClientConfiguration()
        
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 30
        conf.timeoutIntervalForResource = TimeInterval(14 * 60 * 60)
        
        let client = OSSClient(endpoint: endPoint, credentialProvider: credential, clientConfiguration: conf)
        
        return client!
    }
    
    /** 
     * 上传单个文件
     */
    public class func uploadObjectAsync(fileURL: URL, filename: String, resourcePath: String?) {
        
        let put = OSSPutObjectRequest()
        
        put.bucketName = bucketName
        
        if resourcePath != nil {
            put.objectKey = resourcePath!.appending(filename)
        } else {
            put.objectKey = filename
        }
        
        put.uploadingFileURL = fileURL
        
//        typedef void (^OSSNetworkingUploadProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
        
//        put.uploadProgress = (bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) ->Void {
//            
//        }
        
        put.contentType = ""
        put.contentMd5 = ""
        put.contentEncoding = ""
        put.contentDisposition = ""
        
        let client = self.confClient()
        
        let putTask = client.putObject(put)
        
        putTask?.continue({ (task: OSSTask<AnyObject>) -> Any? in
            
            if task.error == nil {
                NSLog("upload \(put.objectKey) success!")
            } else {
                NSLog("upload \(put.objectKey) failed, error: \(task.error!.localizedDescription)")
            }
            
            return nil
        })
    }
    
    /**
     *
     */
    public class func uploadObjectSync(fileURL: URL, filename: String, resourcePath: String?) {
        
        let put = OSSPutObjectRequest()
        
        put.bucketName = bucketName
        
        if resourcePath != nil {
            put.objectKey = resourcePath!.appending(filename)
        } else {
            put.objectKey = filename
        }
        
        put.uploadingFileURL = fileURL

        put.contentType = ""
        put.contentMd5 = ""
        put.contentEncoding = ""
        put.contentDisposition = ""
        
        let client = self.confClient()
        
        let putTask = client.putObject(put)
        putTask?.waitUntilFinished()
        
        if putTask?.error == nil {
            NSLog("upload \(put.objectKey) success!")
        } else {
            NSLog("upload \(put.objectKey) failed, error: \(putTask!.error!.localizedDescription)")
        }
        
        
    }
    
    
    
}
