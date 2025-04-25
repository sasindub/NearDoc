import SwiftUI

struct AppointmentDetailView: View {
    let appointmentId: String
    let doctorId: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var appointment: Appointment?
    @State private var currentStatus: String = ""
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var showingAddPrescription = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let appointment = appointment {
                    // Patient info card
                    patientInfoCard(appointment)
                    
                    // Appointment details card
                    appointmentDetailsCard(appointment)
                    
                    // Status buttons
                    statusButtons()
                    
                    // Action buttons
                    actionButtons(appointment)
                }
            }
            .padding()
        }
        .navigationTitle("Appointment Details")
        .onAppear {
            loadAppointmentDetails()
        }
        .alert(isPresented: .constant(!errorMessage.isEmpty)) {
            Alert(
                title: Text("Success"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    errorMessage = ""
                }
            )
        }
        .sheet(isPresented: $showingAddPrescription) {
            if let appointment = appointment {
                AddPrescriptionView(
                    doctorId: doctorId,
                    patientId: appointment.patientId,
                    patientName: appointment.patientName
                )
            }
        }
    }
    
    // Patient info card
    private func patientInfoCard(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(appointment.patientName)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    // Note: In a real app, you would fetch and display patient details
                    Text("Female • 28 years")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: PatientHistoryView(patientId: appointment.patientId)) {
                        Text("View Medical History")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Appointment details card
    private func appointmentDetailsCard(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appointment Details")
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text("Date:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(formattedDate(appointment.date))
                    .fontWeight(.medium)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text("Time:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(appointment.time)
                    .fontWeight(.medium)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text("Hospital:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(appointment.hospital)
                    .fontWeight(.medium)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "stethoscope")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text("Specialization:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(appointment.specialization)
                    .fontWeight(.medium)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text("Fee:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("LKR \(String(format: "%.2f", appointment.fee))")
                    .fontWeight(.medium)
            }
            
            Divider()
            
            HStack {
                Image(systemName: statusIcon(for: currentStatus))
                    .foregroundColor(statusColor(for: currentStatus))
                    .frame(width: 24)
                
                Text("Status:")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(currentStatus.capitalized)
                    .fontWeight(.medium)
                    .foregroundColor(statusColor(for: currentStatus))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // Status buttons to update appointment status
    private func statusButtons() -> some View {
        HStack(spacing: 15) {
            if currentStatus.lowercased() != "in progress" {
                Button(action: {
                    updateAppointmentStatus("in progress")
                }) {
                    Text("Mark as In Progress")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if currentStatus.lowercased() != "completed" {
                Button(action: {
                    updateAppointmentStatus("completed")
                }) {
                    Text("Mark as Completed")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    // Action buttons
    private func actionButtons(_ appointment: Appointment) -> some View {
        VStack(spacing: 15) {
            Button(action: {
                showingAddPrescription = true
            }) {
                HStack {
                    Image(systemName: "pills.fill")
                        .foregroundColor(.white)
                    
                    Text("Add Prescription")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            Button(action: {
                // This would typically open the phone app
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    
                    Text("Call Patient")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
        }
    }
    
    // Helper to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Helper to get status icon
    private func statusIcon(for status: String) -> String {
        switch status.lowercased() {
        case "upcoming":
            return "clock.fill"
        case "in progress":
            return "person.fill.checkmark"
        case "completed":
            return "checkmark.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    // Helper to get status color
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "upcoming":
            return .blue
        case "in progress":
            return .orange
        case "completed":
            return .green
        default:
            return .gray
        }
    }
    
    // Load appointment details from backend
    private func loadAppointmentDetails() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.fetchData(endpoint: "/appointments?doctorId=\(doctorId)") { (result: Result<[Appointment], Error>) in
            switch result {
            case .success(let appointments):
                if let appointment = appointments.first(where: { $0.id == self.appointmentId }) {
                    self.appointment = appointment
                    self.currentStatus = appointment.status
                    self.isLoading = false
                } else {
                    self.errorMessage = "Appointment not found"
                    self.isLoading = false
                }
            case .failure(let error):
                self.errorMessage = "Failed to load appointment: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    // Update appointment status
    private func updateAppointmentStatus(_ newStatus: String) {
        let updateRequest = UpdateAppointmentRequest(
            appointmentId: appointmentId,
            status: newStatus
        )
        
        NetworkManager.shared.postData(endpoint: "/update-appointment-status", body: updateRequest) { (result: Result<BookingResponse, Error>) in
            switch result {
            case .success(_):
                // Update the local status
                self.currentStatus = newStatus
                
                // Also update the appointment object if needed
                if var updatedAppointment = self.appointment {
                    // Create a new appointment with updated status
                    let newAppointment = Appointment(
                        id: updatedAppointment.id,
                        doctorId: updatedAppointment.doctorId,
                        doctorName: updatedAppointment.doctorName,
                        patientId: updatedAppointment.patientId,
                        patientName: updatedAppointment.patientName,
                        specialization: updatedAppointment.specialization,
                        hospital: updatedAppointment.hospital,
                        date: updatedAppointment.date,
                        time: updatedAppointment.time,
                        status: newStatus,
                        fee: updatedAppointment.fee
                    )
                    self.appointment = newAppointment
                }
            case .failure(let error):
                self.errorMessage = "Updated Successfully!"
            }
        }
    }
}

struct AppointmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailView(appointmentId: "1", doctorId: "4")
    }
}
