import SwiftUI

@main
struct MyApp: App {
    
    init(){
        let craftyGirls = Bundle.main.url(forResource: "CraftyGirls-Regular", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(craftyGirls, CTFontManagerScope.process, nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ARContentView()
        }
    }
}
