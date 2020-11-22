//
//  StorageManager.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 05/11/2020.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    /// This method uploads picture to Firebase Storage and returns completion with url string to download
    /// - Parameters:
    ///   - data: image data
    ///   - fileName: profile picture file name
    ///   - completion: when everything is done, it gives result (string image url) or an error
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                // Failed
                completion(.failure(StorageErrors.failedToUpload))
                print("Failed to upload data to Firebase")
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToDownloadURL))
                    print("Failed to get download URL")
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    /// This method downloads URL for given path
    /// - Parameters:
    ///   - path: a place of the image that we are looking for in Storage
    ///   - completion: when everything is done, it gives result (image URL) or an error
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
    
    // MARK: Errors
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadURL
    }
}
