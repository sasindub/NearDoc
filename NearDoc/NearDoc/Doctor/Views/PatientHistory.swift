import SwiftUI

struct PatientHistoryView: View {
    let patientId: String
    
    @State private var patient: Patient?
    @State private var patientHistory: PatientHistory?
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var searchText = ""
    // Summarization states
    @State private var showSummary = false
    @State private var isSummarizing = false
    @State private var summaryText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search prescriptions", text: $searchText)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    // Patient info
                    if let patient = patient {
                        patientInfoCard(patient)
                    }
                    
                    // Medical conditions (static example)
                    medicalConditionsCard()
                    
                    // Allergies (static example)
                    allergiesCard()
                    
                    // Past appointments
                    if let history = patientHistory {
                        pastAppointmentsCard(history.appointments)
                    }
                    
                    // Prescriptions
                    if let history = patientHistory {
                        prescriptionsCard(history.prescriptions)
                    }
                }
                
                // --- Summarization Section START ---
                Button(action: {
                    showSummary = false
                    isSummarizing = true
                    // Simulate ML Kit summarization delay (demo)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        summaryText = """
                        This patient has a history of acute bronchiolitis and mild allergies (penicillin, sulfamide). Last treatment: Amoxicillin 500mg, 3/day. Recent reviews indicate symptom improvement. Continue current meds, monitor for allergy reactions, and follow up in 2 weeks.
                        """
                        isSummarizing = false
                        showSummary = true
                    }
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        if isSummarizing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.leading, 4)
                        }
                        Text("Summarize Medical History")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSummarizing ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isSummarizing)
                .padding(.top, 8)
                
                if showSummary {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "text.justify")
                                .foregroundColor(.blue)
                            Text("Medication Summary")
                                .font(.headline)
                        }
                        Text(summaryText)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.top, 4)
                }
                // --- Summarization Section END ---
            }
            .padding()
        }
        .navigationTitle("Patient History")
        .onAppear {
            loadPatientData()
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
    
    // ... All your existing helper methods (patientInfoCard, medicalConditionsCard, etc.) below ...
    // nothing changed in these!
    
    // Patient info card
    private func patientInfoCard(_ patient: Patient) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(patient.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("\(patient.gender) • \(patient.age) years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    // Call patient functionality would go here
                }) {
                    Image(systemName: "phone.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Phone")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(patient.phone)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(patient.email)
                        .font(.subheadline)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Address")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(patient.address)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // ... keep all your other helper methods unchanged ...
    
    // Medical conditions card (static example)
    private func medicalConditionsCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Medical Conditions")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack {
                medicalConditionItem(
                    name: "Acute Bronchiolitis",
                    date: "Jan 2025",
                    color: .orange
                )
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    private func medicalConditionItem(name: String, date: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(name)
                .font(.subheadline)
            
            Text("• \(date)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func allergiesCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Reported Allergies")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack {
                allergyItem(
                    name: "Penicillin",
                    severity: "Mild",
                    color: .red
                )
                
                Spacer()
                
                allergyItem(
                    name: "Sulfamide",
                    severity: "Mild",
                    color: .red
                )
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    private func allergyItem(name: String, severity: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(name)
                .font(.subheadline)
            
            Text("• \(severity)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func pastAppointmentsCard(_ appointments: [Appointment]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Past Appointments")
                .font(.headline)
            
            if appointments.filter({ $0.status.lowercased() == "completed" }).isEmpty {
                Text("No past appointments found")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(appointments.filter { $0.status.lowercased() == "completed" }) { appointment in
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(formattedDate(appointment.date))
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(appointment.time)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(appointment.doctorName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    
                    if appointment.id != appointments.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    private func prescriptionsCard(_ prescriptions: [Prescription]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Prescriptions")
                .font(.headline)
            
            if prescriptions.isEmpty {
                Text("No prescriptions found")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(prescriptions) { prescription in
                    NavigationLink(destination: PrescriptionDetailView(prescription: prescription)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(formattedDate(prescription.date))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                
                                Text("\(prescription.medications.count) medication(s)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(prescription.doctorName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    if prescription.id != prescriptions.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func loadPatientData() {
        isLoading = true
        errorMessage = ""
        
        // Load patient info
        NetworkManager.shared.fetchData(endpoint: "/patient/\(patientId)") { (result: Result<Patient, Error>) in
            switch result {
            case .success(let patient):
                self.patient = patient
                self.loadPatientHistory()
            case .failure(let error):
                self.isLoading = false
                self.errorMessage = "Failed to load patient: \(error.localizedDescription)"
            }
        }
    }
    
    private func loadPatientHistory() {
        NetworkManager.shared.fetchData(endpoint: "/patient-history/\(patientId)") { (result: Result<PatientHistory, Error>) in
            self.isLoading = false
            switch result {
            case .success(let history):
                self.patientHistory = history
            case .failure(let error):
                self.errorMessage = "Failed to load patient history: \(error.localizedDescription)"
            }
        }
    }
}
