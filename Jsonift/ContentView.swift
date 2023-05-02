//
//  ContentView.swift
//  Jsonift
//
//  Created by Ram Kumar on 25/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "swift")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Jsonift")
        }
        .padding()
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
