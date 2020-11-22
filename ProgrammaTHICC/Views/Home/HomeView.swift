//
//  HomeView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 17/11/2020.
//

import SwiftUI

struct HomeView: View {
    // MARK: Properties
    @EnvironmentObject var userData: UserData
    @State var show = false
    @State var showingProfile = false
    var suggested = UserDefaults.standard.value(forKey: "Suggested") as? String ?? "C#"
        
    var body: some View {
        NavigationView {
            ZStack {
                // Setup Background and show white status bar
                Color.black.opacity(0.9).ignoresSafeArea()
                    .onAppear() { UIApplication.setStatusBarStyle(.lightContent) }
                
                // Profile View
                NavigationLink(destination: ProfileView()
                                .navigationBarHidden(true), isActive: $showingProfile) {
                    EmptyView()
                }
                
                // MARK: UI
                VStack {
                    // If name/tutorials array is empty or image is not updated
                    if userData.name.isEmpty || !userData.updatedImage || tutorials.isEmpty {
                        // Show loading screen
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .transition(.slide)
                    } else {
                        // Otherwise show main view
                        VStack {
                            // Header
                            ZStack {
                                Color.white.opacity(0.1)
                                    .blur(radius: 40)
                                    .frame(width: UIScreen.main.bounds.size.width, height: 80)
                                HStack {
                                    // Greetings
                                    VStack(alignment: .leading) {
                                        Text("Hi, \(userData.name)!")
                                            .font(.title)
                                            .fontWeight(.medium)
                                        Text("Suggested language: \(suggested)")
                                    }
                                    .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                    
                                    // Profile image
                                    VStack(alignment: .center) {
                                        Button(action: {
                                            showingProfile = true
                                        }, label: {
                                            Image(uiImage: userData.image)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                        })
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    }
                                }.padding(10)
                                .shadow(color: .white, radius: 1)
                                .background(Color.white.opacity(0.1).blur(radius: 30))
                            }
                            
                            // Scroll View
                            ScrollView(.vertical, showsIndicators: false, content: {
                                // Search Bar
                                SearchBar()
                                
                                // Tutorials
                                HStack {
                                    Text("Tutorials: ")
                                        .font(.system(size: 20))
                                        .fontWeight(.medium)
                                        .padding(.leading, 10)
                                        .foregroundColor(.white)
                                    
                                    Spacer(minLength: 0)
                                    
                                    // Clear the Searchbar and show all tutorials
                                    Button(action: {
                                        userData.searchText = ""
                                    }, label: {
                                        Text("View all")
                                            .foregroundColor(.white)
                                    })
                                }
                                .padding(.trailing, 10)
                                
                                // Setup cards in the grid
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 20) {
                                    
                                    ForEach(tutorials.filter({userData.searchText.isEmpty ? true : $0.name.contains(userData.searchText)}), id: \.self) { tutorial in
                                        CardView(tutorial: tutorial)
                                    }
                                    .padding([.leading, .trailing], 5)
                                }
                            })
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
            // Download picture when the view is loaded
            .onAppear(perform: downloadPicture)
            // Hide NavBar
            .navigationBarHidden(true)
        }
        // Fixing NavBar on iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// This method gets url for the user's profile picture from Firebase Storage
    func downloadPicture() {
        StorageManager.shared.downloadURL(for: "images/\(userData.profilePictureName)", completion: { res in
            switch res {
            case .success(let url):
                downloadImage(url: url)
                UserDefaults.standard.set(url, forKey: "profile_picture_url")
                
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    /// Ths method downloads image from given url and sets the image by data.
    /// - Parameter url: url to the user's profile picture in Firebase Storage
    func downloadImage(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                userData.image = UIImage(data: data)!
            }
            
            DispatchQueue.main.async {
                userData.updatedImage = true
            }
        }).resume()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
