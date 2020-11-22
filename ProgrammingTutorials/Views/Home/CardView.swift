//
//  CardView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 22/11/2020.
//

import SwiftUI

struct CardView: View {
    // MARK: Properties
    var tutorial: Tutorial
    @EnvironmentObject var userData: UserData
    @State var showingDetail = false
    
    var body: some View {
        VStack {
            Button(action: {
                // Check which card was tapped
                switch tutorial.name {
                case Languages.cpp.name:
                    userData.selectedTutorial = Languages.cpp
                    userData.topics = cppTopics
                case Languages.csharp.name:
                    userData.selectedTutorial = Languages.csharp
                    userData.topics = csharpTopics
                case Languages.swift.name:
                    userData.selectedTutorial = Languages.swift
                    userData.topics = swiftTopics
                case Languages.php.name:
                    userData.selectedTutorial = Languages.php
                    userData.topics = phpTopics
                case Languages.js.name:
                    userData.selectedTutorial = Languages.js
                    userData.topics = jsTopics
                default:
                    userData.selectedTutorial = Languages.cpp
                    userData.topics = cppTopics
                }
                
                // Show Detail View
                self.showingDetail.toggle()
            }, label: {
                Image(tutorial.imageName)
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Color.black.opacity(0.44).aspectRatio(contentMode: .fit)
                    )
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding([.top, .leading], 10)
            }).sheet(isPresented: $showingDetail) {
                DetailView()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(tutorial.name)
                        .font(.headline)
                    switch tutorial.name {
                    case Languages.cpp.name: Text("\(Languages.cpp.topicsCount) lessons")
                        .font(.subheadline)
                    case Languages.csharp.name: Text("\(Languages.csharp.topicsCount) lessons")
                        .font(.subheadline)
                    case Languages.swift.name: Text("\(Languages.swift.topicsCount) lessons")
                        .font(.subheadline)
                    case Languages.php.name: Text("\(Languages.php.topicsCount) lessons")
                        .font(.subheadline)
                    case Languages.js.name:
                        Text("\(Languages.js.topicsCount) lessons")
                            .font(.subheadline)
                    default:
                        Text("\(Languages.cpp.topicsCount) lessons")
                            .font(.subheadline)
                    }
                }.foregroundColor(.white)
                Spacer(minLength: 0)
            }.padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .cornerRadius(10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(tutorial: Tutorial(name: "C++", imageName: "cpp")).environmentObject(UserData())
    }
}
