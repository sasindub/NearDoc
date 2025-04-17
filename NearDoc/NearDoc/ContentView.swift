import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            MainTabView(isLoggedIn: $isLoggedIn)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
