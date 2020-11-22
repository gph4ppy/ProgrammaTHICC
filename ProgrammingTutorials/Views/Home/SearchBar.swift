//
//  SearchBar.swift
//  ProgrammingTutorials
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 26/10/2020.
//

import SwiftUI

struct SearchBar: View {
    // MARK: Properties
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        HStack {
            TextField("Search", text: $userData.searchText)
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .overlay(
                    HStack {
                        // Search glass
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.bottom, 10.0)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar().environmentObject(UserData())
    }
}
