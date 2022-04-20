//
//  PlacementView.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//

import SwiftUI

struct PlacementView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        if placementSettings.isAnchorActivaded{
        PlacementButton(systemIconName: "checkmark.circle.fill", action: {
            self.placementSettings.didTapButton = true
        })
        .padding(.bottom, 30)
        }
    }
}

struct PlacementButton: View{
    var systemIconName: String
    var action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            Image(systemName: self.systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .buttonStyle(.plain)
                .foregroundColor(.white)
        }
        .frame(width: 75, height: 75)
    }
}

struct PlacementView_Previews: PreviewProvider {
    static var previews: some View {
        PlacementView()
    }
}
