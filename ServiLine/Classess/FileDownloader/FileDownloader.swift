//
//  FileDownloader.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 09/04/22.
//

import UIKit

protocol FileDownloadingDelegate: AnyObject {
    func updateDownloadProgressWith(progress: Float)
    func downloadFinished(localFilePath: URL)
    func downloadFailed(withError error: Error)
}

class FilesDownloader: NSObject, URLSessionDownloadDelegate {
    private weak var delegate: FileDownloadingDelegate?

    func download(from url: URL, delegate: FileDownloadingDelegate) {
        self.delegate = delegate
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: url.absoluteString) // use this identifier to resume download after app restart
        let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async { self.delegate?.downloadFinished(localFilePath: location) }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async { self.delegate?.updateDownloadProgressWith(progress: Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)) }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error)
        guard let theError = error else { assertionFailure("something weird happened here"); return }
        DispatchQueue.main.async { self.delegate?.downloadFailed(withError: theError) }
    }

}













class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?,String?, Error?) -> Void)
    {
       
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsUrl)

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        print(destinationUrl)
        print(destinationUrl.path)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, "File already exists", "File already exists" as? Error)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, "", error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, "", error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, "", error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, "", error)
                }
            })
            task.resume()
        }
    }
}
