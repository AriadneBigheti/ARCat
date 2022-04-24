//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 23/04/22.
//

import SwiftUI

struct StartView: View{
    @Binding var startARExperience: Bool
    @State var startIntro: Bool = false
    @State var index: Int = 0
    
    var body: some View{
        ZStack(alignment: .top){
            if startIntro{
                IntroView(startARExperience: $startARExperience, index: $index)
            }else{
                FrontPageView(startIntro: $startIntro)
            }
        }
    }
}

struct FrontPageView: View{
    @Binding var startIntro: Bool
    
    var body: some View{
        ZStack(alignment: .center){
            Image("frontpage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    startIntro = true
                }
        }
    }
}
