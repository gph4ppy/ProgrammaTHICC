//
//  RegisterView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 03/11/2020.
//

import SwiftUI
import FirebaseAuth
import WidgetKit

struct RegisterView: View {
    // MARK: Properties
    @EnvironmentObject var userData: UserData
    @State private var password = ""
    @State private var showPassword = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var loadedImage = false
    @State private var loggedIn = false
    @State var showingProfile = false
    let suggested = Languages.allCases.randomElement()!.name
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
                
                // Home View
                NavigationLink(destination: HomeView()
                                .navigationBarHidden(true), isActive: $loggedIn) {
                    EmptyView()
                }
                
                // MARK: UI
                VStack(spacing: 0) {
                    // Scroll View
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            // Back Arrow Button
                            HStack {
                                Button(action: {
                                    self.mode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "arrowshape.turn.up.left.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                        .shadow(color: .white, radius: 10)
                                }).padding(.leading, 10)
                                .padding(.top, 15)
                                Spacer()
                            }
                            
                            // Profile Image Picker
                            VStack {
                                Button(action: {
                                    // Show Image Picker
                                    self.showingImagePicker.toggle()
                                }, label: {
                                    // If user uploaded image
                                    if loadedImage {
                                        // Show it
                                        Image(uiImage: inputImage!)
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                            )
                                    } else {
                                        // Show blank image
                                        Image(systemName: "person.circle")
                                            .font(.system(size: 150))
                                            .foregroundColor(.white)
                                    }
                                })
                            }
                            .padding(.vertical, 20)
                            .shadow(color: .white, radius: 5)
                            .shadow(color: .purple, radius: 30)
                            
                            // TextFields
                            VStack {
                                // Name Field
                                TextField("", text: $userData.name)
                                    .disableAutocorrection(true)
                                    .shadow(color: .white, radius: 7)
                                    .modifier(PlaceholderStyle(showPlaceHolder: userData.name.isEmpty, placeholder: "Name"))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 20)
                                    .foregroundColor(.white)
                                    .overlay(
                                        // Line
                                        VStack {
                                            Spacer()
                                                .padding(22)
                                            LineView(lineColor: UIColor.systemPurple)
                                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                                .padding(5)
                                                .shadow(color: .blue, radius: 15)
                                        }
                                    )
                                
                                // Email Field
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
                                            LineView(lineColor: UIColor.systemPurple)
                                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                                .padding(5)
                                                .shadow(color: .blue, radius: 15)
                                        }
                                    ).padding(.vertical, 8)
                                
                                // Password Field
                                VStack {
                                    // If decided to show password
                                    if showPassword {
                                        // Show password
                                        TextField("Password", text: $password)
                                    } else {
                                        // Hide password
                                        SecureField("", text: $password)
                                    }
                                }
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
                                        LineView(lineColor: UIColor.systemPurple)
                                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                            .padding(5)
                                            .shadow(color: .blue, radius: 15)
                                            .overlay(
                                                // Eye Button (show password)
                                                HStack {
                                                    Spacer()
                                                    VStack {
                                                        Button(action: { self.showPassword.toggle()}) {
                                                            Image(systemName: "eye")
                                                                .foregroundColor(.white)
                                                                .font(.system(size: 15))
                                                                .shadow(radius: 15)
                                                                .shadow(color: .white, radius: 10)
                                                        }
                                                    }.padding(.top, -25)
                                                    .padding(.trailing, 10)
                                                }
                                            )
                                    }
                                )
                                .padding(.bottom)
                            }
                            
                            // Register Button
                            VStack(spacing: 20) {
                                Button(action: registerButtonTapped) {
                                    HStack {
                                        Text("Register")
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 10)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.purple)
                                    .clipShape(Capsule())
                                    .shadow(color: .purple, radius: 7)
                                }
                                .offset(y: 30)
                                Spacer()
                            }
                            
                            Spacer()
                        }.padding(10)
                    })
                    // Fixing Scroll View
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .padding([.leading, .bottom, .trailing])
                // Hide NavBar
                .navigationBarHidden(true)
            }
            // Show Image Picker
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            // Show alert
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("FORGIVE ME!")))
            })
        }
        // Fixing NavBar on iPad
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    /// This method loads an image to the placeholder
    func loadImage() {
        guard let inputImage = inputImage else { return }
        userData.image = inputImage
        self.loadedImage = true
    }
    
    /// This method validates all fields, checks for errors and if the user exists, when everything is ok, it creates new entry in Realtime Database
    func registerButtonTapped() {
        // Check if email field is not empty
        if !self.userData.email.isEmpty {
            // Check if password is longer than 10 letters
            if self.password.count >= 6 {
                // Check if username is not longer than 16 characters
                if userData.name.count > 16 {
                    self.alertTitle = "Error?"
                    self.alertMessage = "Your name must be shorter than 16 letters."
                    self.showingAlert.toggle()
                    return
                }
                
                if userData.email.count > 254 {
                    self.alertTitle = "Error?"
                    self.alertMessage = "Your email must be shorter than 254 characters."
                    self.showingAlert.toggle()
                    return
                }
                
                Auth.auth().createUser(withEmail: self.userData.email, password: self.password) { (result, err) in
                    // An error has occurred
                    if err != nil {
                        self.alertTitle = "Error?"
                        self.alertMessage = err!.localizedDescription
                        self.showingAlert.toggle()
                        return
                    }
                    
                    // Prepare image data
                    let data = getData()
                    var safeEmail = userData.email.replacingOccurrences(of: ".", with: "-")
                    safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                    let fileName = "\(safeEmail)_\(userData.name)_\(Date())_\(UUID().uuidString)"
                    userData.profilePictureName = fileName
                    
                    // Set values into UserDefaults
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "LoggedIn")
                    defaults.set(userData.email, forKey: "Email")
                    defaults.set(fileName, forKey: "ProfilePicture")
                    defaults.set(userData.name, forKey: "name")
                    
                    // Set the suggested language
                    defaults.set(suggested, forKey: "Suggested")
                    UserDefaults(suiteName: "group.com.example.ProgrammingTutorials.ProgrammingWidget")?.setValue(suggested, forKey: "Suggested")
                    
                    // Reload Widget
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    // Upload profile picture to the Firebase Storage
                    StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                        switch result {
                        case .success(let url):
                            // Download image from returned URL
                            downloadImage(url: URL(string: url)!)
                            defaults.set(url, forKey: "profile_picture_url")
                        case .failure(let error):
                            print("Error \(error)")
                        }
                    })
                    
                    let user = AppUser(name: userData.name, emailAddress: safeEmail, profilePictureFileName: fileName)
                    
                    // Upload name to DB and UD
                    DatabaseManager().insertUser(with: user) { _ in
                        defaults.set(userData.name, forKey: "name")
                        defaults.set(userData.email, forKey: "email")
                        defaults.set(fileName, forKey: "pictureName")
                    }
                    
                    // Show Home View
                    self.loggedIn.toggle()
                }
            } else {
                // Setup Error Alert
                self.alertTitle = "Error?"
                self.alertMessage = "Your password must be longer than 6 characters."
                self.showingAlert.toggle()
            }
        } else {
            // Setup Error Alert
            self.alertTitle = "Error?"
            self.alertMessage = "Fill in email field"
            self.showingAlert.toggle()
        }
    }
    
    /// This method gets the data from uploaded image
    /// - Returns: image data, which will be used to upload  profile picture to the Firebase Storage
    func getData() -> Data {
        // If user uploaded picture
        if loadedImage {
            // Unwrap uploaded image data
            guard let image = self.inputImage,
                  let data = image.pngData() else {
                // When it fails, return empty data
                return Data()
            }
            // Return image data
            return data
        } else {
            // Otherwise unwrap default image data
            guard let image = UIImage(systemName: "person.circle")?.withTintColor(.white),
                  let data = image.pngData() else {
                return Data()
            }
            // Return image data
            return data
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(UserData())
    }
}
