import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARContentView: View {
   @State private var entity: Entity? = nil
   @State private var tutorialIndex = 0
   @State private var exploreIsRunning: Bool = false
   @State private var selectedCat: Entity?
    
    var body: some View {
        ZStack(alignment: .top){
            ARViewContainer(tutorialIndex: $tutorialIndex, exploreIsRunning: $exploreIsRunning, selectedCat: $selectedCat)
                .edgesIgnoringSafeArea(.all)
//            Image("bg1")
//                .resizable()
//                .edgesIgnoringSafeArea(.all)
            VStack(){
                TutorialView(index: $tutorialIndex, exploreisRunning: $exploreIsRunning, selectedCat: $selectedCat)
                    .edgesIgnoringSafeArea([.trailing, .leading])
                
            }.padding(.top, 50)
            .padding(.leading, 50)
            .padding(.trailing, 50)
        }
        .statusBar(hidden: true)
        .navigationBarHidden(true)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @Binding var tutorialIndex: Int
    @Binding var exploreIsRunning: Bool
    @Binding var selectedCat: Entity?

    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero, tutorialIndex: $tutorialIndex, exploreIsRunning: $exploreIsRunning, selectedCat: $selectedCat)

        BallonComponent.registerComponent()

        return arView
    }

    func updateUIView(_ uiView: CustomARView, context: Context) {

    }

}
