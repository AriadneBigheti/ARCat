import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARContentView: View {
    @StateObject var placementSettings = PlacementSettings()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            if !placementSettings.didTapButton && placementSettings.isAnchorActivaded{
                PlacementView()
            }
        }
        .environmentObject(placementSettings)
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .navigationBarHidden(true)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
    
        arView.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self,
        { (event) in
            placementSettings.isAnchorActivaded = arView.isAnchorActivaded
            updateScene(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
        
    private func updateScene(for arView: CustomARView){
        arView.focusEntity?.isEnabled = !arView.box!.isPlaced

        if placementSettings.shouldAddModel{
            arView.box?.place(in: arView)
            arView.generateOcclusionBox()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                arView.box?.rotateBox()
                arView.placeCat()
            }
            placementSettings.shouldAddModel = false
        }
    }
    
}
