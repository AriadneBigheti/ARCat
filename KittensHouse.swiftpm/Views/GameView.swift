//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 23/04/22.
//

import SwiftUI

struct GameView: View{
    @State var startAR = false
    
    var body: some View{
        if startAR{
            ARContentView()
        }else{
            ZStack(alignment: .center){
                Image("gameview")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center){
                    Spacer()
                    Button(action: {
                        startAR = true
                    }) {
                        Image("gameViewButton")
                    }.padding(.bottom, 80)
                }
            }
        }
    }
}
