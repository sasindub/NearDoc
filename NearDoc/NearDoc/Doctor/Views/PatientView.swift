import SwiftUI

struct PatientsView: View {
    let doctorId: String
    
    @State private var patients: [Patient] = []
    @State private var filteredPatients: [Patient] = []
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search patients", text: $searchText)
                    .onChange(of: searchText) { newValue in
                        filterPatients()
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top)
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if filteredPatients.isEmpty {
                Spacer()
                Text(searchText.isEmpty ? "No patients found" : "No matching patients")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                // Patients list
                List {
                    ForEach(filteredPatients) { patient in
                        NavigationLink(destination: PatientHistoryView(patientId: patient.id)) {
                            patientRow(patient)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Patients")
        .onAppear {
            loadPatients()
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
    
    // Patient row view
    private func patientRow(_ patient: Patient) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(patient.name)
                    .font(.headline)
                
                Text("\(patient.gender) • \(patient.age) years")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(patient.phone)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    // Load patients from backend
    private func loadPatients() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/patients?doctorId=\(doctorId)") { (result: Result<[Patient], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let patients):
                self.patients = patients
                self.filteredPatients = patients
            case .failure(let error):
                self.errorMessage = "Failed to load patients: \(error.localizedDescription)"
            }
        }
    }
    
    // Filter patients based on search text
    private func filterPatients() {
        if searchText.isEmpty {
            filteredPatients = patients
        } else {
            filteredPatients = patients.filter { patient in
                patient.name.lowercased().contains(searchText.lowercased()) ||
                patient.phone.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
