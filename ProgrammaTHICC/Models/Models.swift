//
//  Models.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 15/11/2020.
//

import Foundation
import SwiftUI

// MARK: - Data
struct Tutorial: Codable, Hashable {
    var name: String
    var imageName: String
}

struct Topic: Codable, Hashable {
    var title: String
    var content: String
    var codeImage: String
}

class UserData: ObservableObject {
    // User Data
    @Published var name = UserDefaults.standard.value(forKey: "name") as? String ?? ""
    @Published var email = UserDefaults.standard.value(forKey: "Email") as? String ?? ""
    @Published var profilePictureName = UserDefaults.standard.value(forKey: "ProfilePicture") as? String ?? ""
    
    // App Data
    @Published var updatedImage = false
    @Published var selectedTutorial = Languages.cpp
    @Published var topics = cppTopics
    @Published var selectedTopic = Topic(title: "Error?", content: "An error has occurred", codeImage: "")
    @Published var searchText = ""
    
    // Image data
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .large)
    @Published var image = UIImage(systemName: "person.circle", withConfiguration: largeConfig)!.withTintColor(.white, renderingMode: .alwaysTemplate)
}

// Languages data
enum Languages: Int, CaseIterable {
    // Tutorials
    case cpp
    case csharp
    case swift
    case php
    case js
    
    // Tutorial name
    var name: String {
        switch self {
            case .cpp: return "C++"
            case .csharp: return "C#"
            case .swift: return "Swift"
            case .php: return "PHP"
            case .js: return "JavaScript"
        }
    }
    
    // Amount of topics
    var topicsCount: Int {
        switch self {
            case .cpp: return cppTopics.count
            case .csharp: return csharpTopics.count
            case .swift: return swiftTopics.count
            case .php: return phpTopics.count
            case .js: return jsTopics.count
        }
    }
    
    // Colors for Detail and Topic Views
    var detailColors: [Color] {
        switch self {
            case .cpp: return [.blue, .black]
            case .csharp: return [.purple, .black]
            case .swift: return [.red, .orange]
            case .php: return [.blue, .purple]
            case .js: return [.yellow, .black]
        }
    }
}

// User Object
struct AppUser {
    var name: String
    let emailAddress: String
    var profilePictureFileName: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

// MARK: - UI
struct LineView: UIViewRepresentable {
    typealias UIViewType = UIView
    var lineColor: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<LineView>) -> UIView {
        let view = UIView()
        view.backgroundColor = lineColor
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LineView>) {
    }
}

struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .padding(.trailing, 15)
                    .shadow(color: .white, radius: 7)
                    .lineLimit(1)
            }
            content.foregroundColor(Color.white)
        }
    }
}
