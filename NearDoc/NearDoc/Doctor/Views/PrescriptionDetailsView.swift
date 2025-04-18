import SwiftUI

struct PrescriptionDetailView: View {
    let prescription: Prescription
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with doctor and patient
                headerCard()
                
                // Medications list
                medicationsCard()
                
                // Notes
                if !prescription.notes.isEmpty {
                    notesCard()
                }
                
                // Action buttons
                actionButtons()
            }
            .padding()
        }
        .navigationTitle("Prescription Details")
    }
    
    // Header card with doctor and patient info
    private func headerCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Doctor")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(prescription.doctorName)
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Patient")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(prescription.patientName)
                        .font(.headline)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Prescription Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formattedDate(prescription.date))
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text("ID: #\(prescription.id)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Medications card
    private func medicationsCard() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Medications")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(0..<prescription.medications.count, id: \.self) { index in
                let medication = prescription.medications[index]
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(medication.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(medication.dosage)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    
                    if !medication.instructions.isEmpty {
                        Text("Instructions:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(medication.instructions)
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
                
                if index < prescription.medications.count - 1 {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Notes card
    private func notesCard() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Special Notes")
                .font(.headline)
            
            Text(prescription.notes)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Action buttons
    private func actionButtons() -> some View {
        HStack(spacing: 15) {
            Button(action: {
                // Generate PDF logic would go here
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                    Text("Generate PDF")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            
            Button(action: {
                // Share functionality would go here
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
    
    // Helper to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
