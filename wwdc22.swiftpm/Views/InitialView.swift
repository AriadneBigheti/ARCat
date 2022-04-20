//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//

import SwiftUI

struct InitialView: View{
    let texts = ["One day you were coming back home of your work and you saw a big paper box by the road", "You were curious to know what was inside that box. And you already pictured that it could be an abandoned animal.", "Then you saw the cutest little cat inside the box and you decided to take him home with you.", "Now it's time for him to meet his new home!"]
    let index: Int
    
    init(index: Int){
        self.index = index
    }
    
    init(){
        self.index = 0
    }
    
    @ViewBuilder
    var destination: some View{
        if index==(texts.count-1){
            ARContentView()
        }else{
            InitialView(index: index+1)
        }
    }
    
    var body: some View{
        VStack{
            NavigationView{
                VStack{
                    Text("\(texts[index])")
                    NavigationLink(destination: destination){
                        Text("Next")
                    }
                    .padding()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .statusBar(hidden: true)
            .navigationBarHidden(true)
        }
    }
}

struct InitialView_Previews: PreviewProvider{
    static var previews: some View{
        InitialView(index: 0)
            .previewInterfaceOrientation(.portrait)
    }
}
