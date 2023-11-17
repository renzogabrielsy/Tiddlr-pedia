//
//  ContentView.swift
//  Tiddlr-pedia
//
//  Created by Renzo Sy on 11/16/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        NavigationView {
            VStack{
                NavigationLink(destination: CalcGD_View()) {
                    Text("GD Calculator")
                }
                NavigationLink(destination: CalcAD_View()) {
                    Text("Formula 2")
                }
            }
        }
    }
}

#Preview {
    Home()
}
