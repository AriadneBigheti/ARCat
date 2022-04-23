import SwiftUI

@main
struct MyApp: App {
    @State var startARExperience = false
    
    init(){
        let craftyGirls = Bundle.main.url(forResource: "CraftyGirls-Regular", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(craftyGirls, CTFontManagerScope.process, nil)
    }
    
    var body: some Scene {
        WindowGroup {
            if startARExperience{
                GameView()
            }else{
                StartView(startARExperience: $startARExperience)
            }
        }
    }
}
