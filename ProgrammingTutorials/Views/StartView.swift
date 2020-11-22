//
//  StartView.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/10/2020.
//

import SwiftUI

// MARK: TODO
// - Write tutorials [SWIFT, PHP, JS]

struct StartView: View {
    // MARK: Properties
    @State var isLogged = UserDefaults.standard.value(forKey: "LoggedIn") as? Bool ?? false
    
    var body: some View {
        // If user is logged
        if isLogged {
            // Show Home View
            HomeView()
        } else {
            // Otherwise show Login View
            LoginView()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(UserData())
    }
}
