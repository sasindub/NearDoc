import SwiftUI

struct MedicationHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var medications: [Medication] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("Medication History")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding()
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if medications.isEmpty {
                Spacer()
                Text("No medications found")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(medications) { medication in
                            MedicationCard(medication: medication)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            loadMedications()
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
    
    // Backend integration for medication data
    private func loadMedications() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/medications") { (result: Result<[Medication], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let medicationItems):
                self.medications = medicationItems
            case .failure(let error):
                self.errorMessage = "Failed to load medications: \(error.localizedDescription)"
            }
        }
    }
}

// Medication card component
struct MedicationCard: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "pill.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color(red: 0.88, green: 0.93, blue: 1.0))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(medication.name)
                        .font(.headline)
                    
                    Text("\(medication.dosage) - \(medication.schedule)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(dateRangeString(start: medication.startDate, end: medication.endDate))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Progress indicator for active medications
            if isActive() {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Progress")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(completionPercentage())%")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width, height: 10)
                                .foregroundColor(.gray.opacity(0.2))
                                .cornerRadius(5)
                            
                            Rectangle()
                                .frame(width: geometry.size.width * CGFloat(Double(completionPercentage()) / 100.0), height: 10)
                                .foregroundColor(.blue)
                                .cornerRadius(5)
                        }
                    }
                    .frame(height: 10)
                }
            } else {
                HStack {
                    Text("Status:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(isCompleted() ? "Completed" : "Not Started")
                        .font(.subheadline)
                        .foregroundColor(isCompleted() ? .green : .orange)
                    
                    Spacer()
                    
                    Button(action: {
                        // View details action
                    }) {
                        Text("View Details")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.88, green: 0.93, blue: 1.0))
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Helper functions
    private func dateRangeString(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    private func isActive() -> Bool {
        let now = Date()
        return now >= medication.startDate && now <= medication.endDate
    }
    
    private func isCompleted() -> Bool {
        return Date() > medication.endDate
    }
    
    private func completionPercentage() -> Int {
        let now = Date()
        let totalDuration = medication.endDate.timeIntervalSince(medication.startDate)
        let elapsedDuration = now.timeIntervalSince(medication.startDate)
        
        let percentage = min(max(0, elapsedDuration / totalDuration * 100), 100)
        return Int(percentage)
    }
}

struct MedicationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationHistoryView()
    }
}
