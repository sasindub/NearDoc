import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var userType: LoginView.UserType = .patient
    
    var body: some View {
        if isLoggedIn {
            if userType == .doctor {
                DoctorMainView(isLoggedIn: $isLoggedIn)
            } else {
                MainTabView(isLoggedIn: $isLoggedIn)
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn, selectedUserType: $userType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
