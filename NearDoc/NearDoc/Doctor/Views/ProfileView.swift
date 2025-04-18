import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    let userType: LoginView.UserType
    let userId: String
    
    @State private var doctor: Doctor?
    @State private var patient: Patient?
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    // Profile header
                    profileHeader()
                    
                    // Settings options
                    settingsOptions()
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .onAppear {
            loadProfileData()
        }
        .alert(isPresented: .constant(!errorMessage.isEmpty)) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
    }
    
    // Profile header section
    private func profileHeader() -> some View {
        VStack(spacing: 15) {
            // Profile image
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            // Name and role
            if userType == .doctor && doctor != nil {
                Text(doctor?.name ?? "Doctor")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(doctor?.specialization ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else if userType == .patient && patient != nil {
                Text(patient?.name ?? "Patient")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(patient?.gender ?? "") • \(patient?.age ?? 0) years")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Settings options
    private func settingsOptions() -> some View {
        VStack(spacing: 15) {
            Group {
                settingsRow(icon: "person.fill", title: "Account Settings") {
                    // Account settings action
                }
                
                Divider()
                
                settingsRow(icon: "lock.fill", title: "Privacy & Security") {
                    // Privacy settings action
                }
                
                Divider()
                
                settingsRow(icon: "bell.fill", title: "Notifications") {
                    // Notifications settings action
                }
                
                Divider()
                
                settingsRow(icon: "questionmark.circle.fill", title: "Help & Support") {
                    // Help and support action
                }
                
                Divider()
                
                settingsRow(icon: "arrow.right.doc.on.clipboard", title: "Terms & Conditions") {
                    // Terms and conditions action
                }
                
                Divider()
            }
            
            // Logout button
            Button(action: {
                showingLogoutConfirmation = true
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                    
                    Text("Logout")
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .alert(isPresented: $showingLogoutConfirmation) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Settings row
    private func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                
                Text(title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
    
    // Load profile data from backend
    private func loadProfileData() {
        isLoading = true
        errorMessage = ""
        
        if userType == .doctor {
            NetworkManager.shared.fetchData(endpoint: "/doctor/\(userId)") { (result: Result<Doctor, Error>) in
                self.isLoading = false
                
                switch result {
                case .success(let doctor):
                    self.doctor = doctor
                case .failure(let error):
                    self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                }
            }
        } else {
            NetworkManager.shared.fetchData(endpoint: "/patient/\(userId)") { (result: Result<Patient, Error>) in
                self.isLoading = false
                
                switch result {
                case .success(let patient):
                    self.patient = patient
                case .failure(let error):
                    self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Logout function
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userType")
        isLoggedIn = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true), userType: .doctor, userId: "1")
    }
}
