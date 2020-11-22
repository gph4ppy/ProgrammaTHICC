//
//  TopicView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 27/10/2020.
//

import SwiftUI

struct TopicView: View {
    // MARK: Properties
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
                        // Setup Topic Header Background
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
                                // Display selected topic
                                Text(userData.selectedTopic.title)
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .shadow(radius: 30)
                                    .lineLimit(3)
                        ).padding()
                    }
                }.padding(10)
                
                // Scroll View
                ScrollView(.vertical, showsIndicators: false, content: {
                    // Show which language is selected
                    HStack {
                        Text("[\(userData.selectedTutorial.name) Tutorial]")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .padding(.leading, 10)
                            .foregroundColor(.white)
                        Spacer(minLength: 0)
                    }.padding(.trailing, 10)
                    
                    // Tutorial
                    HStack {
                        VStack {
                            // Content
                            Text("""
                                \(userData.selectedTopic.content)
                                """)
                                .padding(.top, 5)
                                .padding([.horizontal])
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            // Image
                            if userData.selectedTopic.codeImage != "" {
                                Image(userData.selectedTopic.codeImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        Spacer()
                    }
                })
                Spacer(minLength: 0)
            }
        }
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        TopicView().environmentObject(UserData())
    }
}
