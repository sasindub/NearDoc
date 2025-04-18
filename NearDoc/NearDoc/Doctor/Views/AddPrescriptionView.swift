import SwiftUI

struct AddPrescriptionView: View {
    let doctorId: String
    let patientId: String
    let patientName: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var medications: [MedicationEntry] = [MedicationEntry()]
    @State private var notes: String = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingSuccess = false
    
    // Model for medication entry form
    struct MedicationEntry: Identifiable {
        var id = UUID()
        var name: String = ""
        var dosage: String = ""
        var instructions: String = ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Patient information
                    Section(header: Text("Patient Information")) {
                        Text(patientName)
                            .font(.headline)
                    }
                    
                    // Prescription details
                    Section(header: Text("Prescription Details")) {
                        TextField("Enter prescription name", text: $medications[0].name)
                            .padding(.vertical, 5)
                        
                        TextField("Enter dosage", text: $medications[0].dosage)
                            .padding(.vertical, 5)
                        
                        TextField("Enter instructions", text: $medications[0].instructions)
                            .padding(.vertical, 5)
                    }
                    
                    // Additional medications
                    ForEach(1..<medications.count, id: \.self) { index in
                        Section(header: Text("Additional Medication \(index)")) {
                            TextField("Enter medication name", text: $medications[index].name)
                                .padding(.vertical, 5)
                            
                            TextField("Enter dosage", text: $medications[index].dosage)
                                .padding(.vertical, 5)
                            
                            TextField("Enter instructions", text: $medications[index].instructions)
                                .padding(.vertical, 5)
                            
                            Button(action: {
                                medications.remove(at: index)
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Remove Medication")
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // Add more medications button
                    Section {
                        Button(action: {
                            medications.append(MedicationEntry())
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Medication")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    
                    // Special notes
                    Section(header: Text("Special Notes")) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    }
                    
                    // Submit button
                    Section {
                        Button(action: {
                            savePrescription()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Save Prescription")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .disabled(medications[0].name.isEmpty || isLoading)
                    }
                }
            }
            .navigationTitle("Add Prescription")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .alert(isPresented: .constant(!errorMessage.isEmpty)) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        errorMessage = ""
                    }
                )
            }
            .alert(isPresented: $showingSuccess) {
                Alert(
                    title: Text("Success"),
                    message: Text("Prescription has been added successfully."),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    // Save prescription to backend
    private func savePrescription() {
        // Validate form
        if medications[0].name.isEmpty {
            errorMessage = "Please enter at least one medication name"
            return
        }
        
        // Prepare prescription data
        let prescriptionMedications = medications.map { entry in
            PrescriptionMedication(
                name: entry.name,
                dosage: entry.dosage,
                instructions: entry.instructions
            )
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let prescriptionRequest = AddPrescriptionRequest(
            doctorId: doctorId,
            patientId: patientId,
            date: dateFormatter.string(from: Date()),
            medications: prescriptionMedications,
            notes: notes
        )
        
        isLoading = true
        
        NetworkManager.shared.postData(endpoint: "/add-prescription", body: prescriptionRequest) { (result: Result<BookingResponse, Error>) in
            self.isLoading = false
            
            switch result {
            case .success(_):
                self.showingSuccess = true
            case .failure(let error):
                self.errorMessage = "Failed to save prescription: \(error.localizedDescription)"
            }
        }
    }
}

struct AddPrescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddPrescriptionView(
            doctorId: "1",
            patientId: "2",
            patientName: "Sarah Johnson"
        )
    }
}
