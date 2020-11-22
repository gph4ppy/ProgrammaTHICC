//
//  ProfileView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/11/2020.
//

import SwiftUI
import FirebaseAuth
import Combine

struct ProfileView: View {
    // MARK: Properties
    @EnvironmentObject var userData: UserData
    @State private var showingLogin = false
    @State var loggedIn = false
    @State var showingProfile = false
    
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
                
                // Login View
                NavigationLink(destination: LoginView()
                                .navigationBarHidden(true), isActive: $showingLogin) {
                    EmptyView()
                }
                
                // MARK: UI
                VStack {
                    // Scroll View
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            // Back Arrow Button
                            HStack {
                                Button(action: {
                                    showingProfile = false
                                    self.mode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "arrowshape.turn.up.left.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                        .shadow(color: .white, radius: 10)
                                }).padding(.leading, 10)
                                Spacer()
                            }
                            Spacer()
                            
                            // Profile Picture
                            VStack {
                                Image(uiImage: userData.image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                    )
                            }
                            .shadow(color: .white, radius: 5)
                            .shadow(color: .green, radius: 30)
                            .padding()
                            
                            // Informations about user
                            VStack {
                                // Name
                                HStack {
                                    Text("Name:")
                                    Text(userData.name)
                                        .lineLimit(1)
                                        .padding()
                                    Spacer()
                                }
                                .font(.title)
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 10)
                                .padding([.top, .leading])
                                .overlay(
                                    // Line
                                    VStack {
                                        Spacer()
                                            .padding(22)
                                        LineView(lineColor: UIColor.systemGreen)
                                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                            .padding(5)
                                            .padding(.horizontal, 10)
                                            .shadow(color: .green, radius: 15)
                                    }
                                )
                                
                                // Email
                                HStack {
                                    Text("E-mail:")
                                    Text(userData.email)
                                        .lineLimit(1)
                                        .padding()
                                    Spacer()
                                }
                                .font(.title)
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 10)
                                .padding(.leading)
                                .overlay(
                                    // Line
                                    VStack {
                                        Spacer()
                                            .padding(22)
                                        LineView(lineColor: UIColor.systemGreen)
                                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 2)
                                            .padding(5)
                                            .padding(.horizontal, 10)
                                            .shadow(color: .green, radius: 15)
                                    }
                                )
                            }
                            Spacer()
                            
                            // Log Out Button
                            Button(action: signOut) {
                                Text("Sign Out")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                                    .fontWeight(.medium)
                                    .shadow(color: .red, radius: 10)
                            }
                            .padding(.top, 50)
                        }.padding(10)
                    })
                    // Fixing Scroll View
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                .padding()
            }
            // Hide NavBar
            .navigationBarHidden(true)
            // Show Alert
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OH NO!")))
            })
        }
        // Fixing NavBar on iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// This method signs out the user
    func signOut() {
        do {
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "LoggedIn")
            userData.updatedImage = false
            loggedIn = false
            showingLogin = true
            try Auth.auth().signOut()
        } catch {
            // When error has occurred, show alert
            print(error.localizedDescription)
            alertTitle = "Error?"
            alertMessage = "An error has occurred: \(error)"
            showingAlert.toggle()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserData())
    }
}
