//
//  ContentView.swift
//  ScrollToTop
//
//  Created by nakamura motoki on 2022/02/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            HomeView()
                .navigationTitle("Medium")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
