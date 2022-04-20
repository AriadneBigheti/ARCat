import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARContentView: View {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var interactionSettings = InteractionSettings()

    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
                .environmentObject(placementSettings)
                .environmentObject(interactionSettings)
            if !placementSettings.didTapButton && placementSettings.isAnchorActivaded{
                PlacementView()
                    .environmentObject(placementSettings)
            }else if placementSettings.modelIsPlaced{
                InteractionsView()
                    .environmentObject(interactionSettings)
            }
        }

        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .navigationBarHidden(true)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var interactionSettings: InteractionSettings

    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)

        arView.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self,
        { (event) in
            updateScene(for: arView)
        })
        
        arView.playButtonObserver = interactionSettings.$didTapPlayButton.sink(receiveValue: { value in
            arView.model?.playFun()
        })
     
        arView.exploreButtonObserver = interactionSettings.$didTapExploreButton.sink(receiveValue: { value in
            arView.model?.explore()
        })
                
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    
    }
         
    private func updateScene(for arView: CustomARView){
        placementSettings.isAnchorActivaded = arView.isAnchorActivaded
        
        if placementSettings.shouldAddModel{
            arView.placeCat()
            placementSettings.modelIsPlaced = true
            placementSettings.shouldAddModel = false
            arView.focusEntity?.isEnabled = false
            arView.sceneObserver?.cancel()
        }else{
            arView.focusEntity?.isEnabled = true
        }
    }
    
}
