//
//  DetailView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/10/2020.
//

import SwiftUI

struct DetailView: View {
    // MARK: Properties
    @State var showingTopic = false
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            // Setup Background and show white status bar
            Color.black.opacity(0.9).ignoresSafeArea()
                .onAppear() { UIApplication.setStatusBarStyle(.lightContent) }
            
            // MARK: UI
            VStack(spacing: 15) {
                // Header
                ZStack {
                    // Header Background
                    Color.white.opacity(0.1)
                        .frame(height: 100, alignment: .center)
                        .blur(radius: 30)
                    // Header Styling
                    VStack {
                        // Setup Detail Header Background
                        userData.selectedTutorial.detailColors[0]
                            .blur(radius: 50)
                            .frame(height: 75, alignment: .center)
                            .aspectRatio(1.0, contentMode: .fill)
                            .overlay(
                                userData.selectedTutorial.detailColors[1].opacity(0.35)
                                    .blur(radius: 30)
                            )
                            .blur(radius: 10)
                            .padding()
                            .overlay(
                                // Display selected language
                                Text(userData.selectedTutorial.name)
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .shadow(radius: 30)
                        ).padding()
                    }
                }.padding(10)
                
                // Scroll View
                ScrollView(.vertical, showsIndicators: false, content: {
                    // "Topics" label
                    HStack {
                        Text("Topics")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .underline()
                            .padding(.leading, 10)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    // Topics list
                    HStack {
                        VStack(alignment: .leading, spacing: -3) {
                            ForEach(userData.topics, id: \.self) { topic in
                                Button(action: {
                                    // Select topic
                                    userData.selectedTopic = topic
                                    // Show selected topic
                                    showingTopic.toggle()
                                }, label: {
                                    Text(topic.title).foregroundColor(.white)
                                }).sheet(isPresented: $showingTopic) {
                                    TopicView()
                                }
                            }.padding()
                        }
                        Spacer()
                    }.padding(.top, 5)
                })
                Spacer(minLength: 0)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView().environmentObject(UserData())
    }
}
