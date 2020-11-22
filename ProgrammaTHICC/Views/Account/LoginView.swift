//
//  LoginView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 31/10/2020.
//

import SwiftUI
import FirebaseAuth
import WidgetKit

struct LoginView: View {
    // MARK: Properties
    @EnvironmentObject var userData: UserData
    @State private var password = ""
    @State var showingRegister = false
    @State var loggedIn = false
    @State var showingProfile = false
    let suggested = Languages.allCases.randomElement()!.name
    
    var safeEmail: String {
        var safeEmail = userData.email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Setup Background and show white status bar
                Color.black.opacity(0.9).ignoresSafeArea()
                    .onAppear() { UIApplication.setStatusBarStyle(.lightContent) }
                
                // Register View
                NavigationLink(destination: RegisterView()
                                .navigationBarHidden(true), isActive: $showingRegister) {
                    EmptyView()
                }
                
                // Home View
                NavigationLink(destination: HomeView()
                                .navigationBarHidden(true), isActive: $loggedIn) {
                    EmptyView()
                }
                
                // MARK: UI
                VStack {
                    // Scroll View
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            Spacer()
                            
                            // App Title
                            VStack {
                                Text("PROGRAMMA")
                                    .font(.system(size: 40, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Text("THICC")
                                    .font(.system(size: 50, weight: .heavy, design: .default))
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 20)
                            .shadow(color: .blue, radius: 15)
                            
                            // TextFields
                            VStack(spacing: 30) {
                                Spacer()
                                
                                // Email TextField
                                TextField("", text: $userData.email)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .shadow(color: .white, radius: 7)
                                    .modifier(PlaceholderStyle(showPlaceHolder: userData.email.isEmpty, placeholder: "Email"))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 20)
                                    .foregroundColor(.white)
                                    .overlay(
                                        // Line
                                        VStack {
                                            Spacer()
                                                .padding(22)
                                            LineView(lineColor: UIColor.systemPink)
                                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                                .padding(5)
                                                .shadow(color: .purple, radius: 15)
                                        }
                                    )
                                // Password TextField
                                SecureField("", text: $password)
                                    .shadow(color: .white, radius: 7)
                                    .textContentType(.password)
                                    .modifier(PlaceholderStyle(showPlaceHolder: password.isEmpty, placeholder: "Password"))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 20)
                                    .foregroundColor(.white)
                                    .overlay(
                                        // Line
                                        VStack {
                                            Spacer()
                                                .padding(22)
                                            LineView(lineColor: UIColor.systemPink)
                                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                                .padding(5)
                                                .shadow(color: .purple, radius: 15)
                                        }
                                    )
                                Spacer()
                            }
                            
                            // Buttons
                            VStack(spacing: 20) {
                                Spacer()
                                
                                // Login Button
                                Button(action: loginButtonTapped) {
                                    HStack {
                                        Text("Login")
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 10)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.pink)
                                    .clipShape(Capsule())
                                    .shadow(color: .pink, radius: 7)
                                }
                                
                                // Register Button
                                Button(action: {
                                    self.showingRegister.toggle()
                                }) {
                                    // Register Button Styling
                                    HStack {
                                        Text("Register")
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 10)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .clipShape(Capsule())
                                    .shadow(color: .blue, radius: 7)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(10)
                    })
                    // Fixing Scroll View
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .padding()
            }
            // Hide NavBar
            .navigationBarHidden(true)
            // Show alert
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("FORGIVE ME!")))
            })
        }
        // Sets the white line when TextFields are selected
        .accentColor(.white)
        // Fixing NavBar on iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// This method validates all fields, checks if the user exists and logs him in
    func loginButtonTapped() {
        // Check if fields are not empty
        if !self.userData.email.isEmpty && !self.userData.email.isEmpty {
            // Auth user
            Auth.auth().signIn(withEmail: self.userData.email, password: self.password) { (result, err) in
                // An error has occurred
                if err != nil {
                    self.alertTitle = "Error?"
                    self.alertMessage = err!.localizedDescription
                    self.showingAlert.toggle()
                    return
                }
                
                // Set values into UserDefaults
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "LoggedIn")
                defaults.set(userData.email, forKey: "Email")
                defaults.set(suggested, forKey: "Suggested")
                UserDefaults(suiteName: "group.com.example.ProgrammingTutorials.ProgrammingWidget")?.setValue(suggested, forKey: "Suggested")
                
                // Reload Widget
                WidgetCenter.shared.reloadAllTimelines()
                
                // Get username
                DatabaseManager().getDataFor(path: "\(safeEmail)/name") { (res) in
                    switch res {
                    case .success(let username):
                        userData.name = username as! String
                        UserDefaults.standard.setValue(username, forKey: "name")
                    case .failure(let err):
                        print(err)
                    }
                }
                
                // Get profile picture name
                DatabaseManager().getDataFor(path: "\(safeEmail)/pictureName") { (res) in
                    switch res {
                    case .success(let fileName):
                        userData.profilePictureName = fileName as! String
                        UserDefaults.standard.setValue(fileName, forKey: "ProfilePicture")
                    case .failure(let err):
                        print(err)
                    }
                }
                
                // Download picture
                StorageManager.shared.downloadURL(for: "images/\(userData.profilePictureName)", completion: { res in
                    switch res {
                    case .success(let url):
                        downloadImage(url: url)
                        defaults.set(url, forKey: "profile_picture_url")
                    case .failure(let error):
                        print("Failed to get download url: \(error)")
                    }
                })
                
                // Show Home View
                self.loggedIn.toggle()
            }
        } else {
            // Setup Error Alert
            alertTitle = "Error?"
            alertMessage = "Fill in all fields!"
            showingAlert.toggle()
        }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserData())
    }
}
