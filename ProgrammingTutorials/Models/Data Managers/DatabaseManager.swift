//
//  DatabaseManager.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 05/11/2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    /// This method converts e-mail address to the safe version - removes dot and hyphen
    /// - Parameter emailAddress: user's e-mail address
    /// - Returns: (String) new, safe version of e-mail address
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

// MARK: - Account Management
extension DatabaseManager {
    /// This method inserts new user to the Realtime Database
    /// - Parameters:
    ///   - user: object with user data: name, email and name of profile picture file
    ///   - completion: when everything is done, check for errors
    public func insertUser(with user: AppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "email": user.safeEmail,
            "pictureName": user.profilePictureFileName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to write to database")
                return
            }
        })
    }
}

extension DatabaseManager {
    /// This method gets data from a Realtime Database path
    /// - Parameters:
    ///   - path: a place of the data that we are looking for in Database
    ///   - completion: when everything is done, it gives result or an error
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        self.database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
}

// MARK: Errors
public enum DatabaseError: Error {
    case failedToFetch
}
