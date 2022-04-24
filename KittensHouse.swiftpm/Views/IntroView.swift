//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//

import SwiftUI

struct IntroView: View{
    @Binding var startARExperience: Bool
    @Binding var index: Int
    
    let texts = ["One sunny day you were passing down a road, coming back of your work....",
                 "And you saw a big paper box by the road... You were curious to know what was inside that box. So you've decided to check it out.",
                 "The cutest kitten was inside the box and you couldn't let him there, all by himself. ",
                 "So you've decided to take him home with you. It was time to adopt a cat.",
                 "But in the next month, you found another cat and did the same thing...",
                 "Also, in the next month.",
                 "And in the next one....",
                 "Let's see how your house turned out!"]
    let bgs = ["bg1", "bg2", "bg3", "bg4", "bg1", "bg1", "bg1", "bg1"]
        
    var body: some View{
        ZStack(alignment: .top){
            Image(bgs[index])
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(){
                IntroViewBallon(texts: texts, index: index)
                    Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        if index<texts.count-1{
                            self.index += 1
                        }else{
                            startARExperience = true
                        }
                    }) {
                        Image("nextButton")
                    }
                }
            }
                .padding(EdgeInsets(top: 50, leading: 40, bottom: 50, trailing: 40))
        }.navigationBarHidden(true)
    }
}

struct IntroViewBallon: View{
    
    var texts: [String]
    var index: Int

    var body: some View{
        ZStack(alignment: .top){
            VStack(alignment: .trailing){
                Text(texts[index])
                    .font(Font.custom("CraftyGirls-Regular", size: 30))
                    .foregroundColor(.black)
            }.padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))


        }.background(RoundedRectangle(cornerRadius: 20).foregroundColor(.white))
        

    }
}
