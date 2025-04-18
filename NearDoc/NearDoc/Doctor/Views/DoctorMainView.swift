import SwiftUI

struct DoctorMainView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    @State private var doctorId: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DoctorHomeView(doctorId: doctorId)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationView {
                AppointmentsView(doctorId: doctorId)
            }
            .tabItem {
                Label("Appointments", systemImage: "calendar")
            }
            .tag(1)
            
            NavigationView {
                PatientsView(doctorId: doctorId)
            }
            .tabItem {
                Label("Patients", systemImage: "person.3.fill")
            }
            .tag(2)
            
            NavigationView {
                DoctorEarningsView(doctorId: doctorId)
            }
            .tabItem {
                Label("Earnings", systemImage: "dollarsign.circle.fill")
            }
            .tag(3)
            
            NavigationView {
                ProfileView(isLoggedIn: $isLoggedIn, userType: .doctor, userId: doctorId)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
            .tag(4)
        }
        .onAppear {
            // Retrieve doctor ID from UserDefaults
            if let id = UserDefaults.standard.string(forKey: "userId") {
                doctorId = id
            } else {
                // Default for testing
                doctorId = "4"
            }
        }
    }
}

struct DoctorMainView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorMainView(isLoggedIn: .constant(true))
    }
}
