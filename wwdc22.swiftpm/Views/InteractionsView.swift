//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 20/04/22.
//
import SwiftUI

struct InteractionsView: View {
    
    var body: some View {
        HStack{
            Spacer()
            InteractionButton(name: "Story", action: {
            })
            Spacer()
            InteractionButton(name: "Explore", action: {
            })
        }
        .padding(.bottom, 30)
    }
}

struct InteractionButton: View{
    var name: String
    var action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            Text(name)
                .font(.system(size: 30, weight: .bold, design: .default))
                .buttonStyle(.plain)
        }
    }
}

