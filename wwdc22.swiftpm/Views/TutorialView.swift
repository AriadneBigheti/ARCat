//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 22/04/22.
//

import SwiftUI
import RealityKit

struct TutorialView: View{
    @Binding var index: Int
    @Binding var exploreisRunning: Bool
    @Binding var selectedCat: Entity?
    
    var body: some View{
        TutorialBallon(index: $index, exploreisRunning: $exploreisRunning, selectedCat: $selectedCat)
    }
}

struct TutorialBallon: View{
    var texts: [String] = ["Tap in a horizontal surface to place your cats in the room.", "Tap in each cat to know more about it's history and personality.", "Do you want to explore the room with a kitten?  ", "Tap the cat to select him then tap the desired surface to fix the cat in it. Try to put it in seats, tables, walls..."]
    @Binding var index: Int
    @Binding var exploreisRunning: Bool
    @Binding var selectedCat: Entity?

    var body: some View{
        ZStack(alignment: .top){
            VStack(alignment: .trailing){
                Text(texts[index])
                    .font(Font.custom("CraftyGirls-Regular", size: 30))
                    .foregroundColor(.black)
                TutorialButton(index: $index, exploreisRunning: $exploreisRunning, selectedCat: $selectedCat)
            }.padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))


        }.background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color("white")))

    }
}

struct TutorialButton: View{
    @Binding var index: Int
    @Binding var exploreisRunning: Bool
    @Binding var selectedCat: Entity?
    var name = "None"
    
    init(index: Binding<Int>, exploreisRunning: Binding<Bool>, selectedCat: Binding<Entity?>){
        self._index = index
        self._exploreisRunning = exploreisRunning
        self._selectedCat = selectedCat
        if let cat = selectedCat.wrappedValue{
            name = cat.name
        }
    }
    
    @ViewBuilder
    var body: some View{
        switch index{
        case 2:
            Button(action: {
                exploreisRunning = true
                index+=1
            }){
                Image("startButton")
            }
        case 3:
            HStack{
                Text("selected cat: ")
                    .font(Font.custom("CraftyGirls-Regular", size: 30))
                    .foregroundColor(.black)
                Text(name)
                    .font(Font.custom("CraftyGirls-Regular", size: 30))
                    .foregroundColor(.pink)
                Spacer()
                Button(action: {
                    exploreisRunning = false
                    index-=1
                }){
                    Image("stopButton")
                }
            }
            .padding(.top, 5)
        default:
            EmptyView()
        }
    }
}


