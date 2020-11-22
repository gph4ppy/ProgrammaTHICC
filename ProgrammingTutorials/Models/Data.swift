//
//  Data.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 28/10/2020.
//

import Foundation
import UIKit
import SwiftUI

// MARK: Topics
let tutorials: [Tutorial] = decode("Tutorials.json")
let cppTopics: [Topic] = decode("CppTopics.json")
let csharpTopics: [Topic] = decode("CSharpTopics.json")
let swiftTopics: [Topic] = decode("SwiftTopics.json")
let phpTopics: [Topic] = decode("PHPTopics.json")
let jsTopics: [Topic] = decode("JSTopics.json")

// Decode JSON Files
func decode<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
