import SwiftUI

struct AppointmentDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingPrescription: Bool = false
    @State private var appointment: Appointment?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String = ""
    
    // ID of the appointment to display
    var appointmentId: String?
    
    // Mock appointment data if no ID is provided
    let mockAppointmentData = (
        doctorName: "Dr. John Smith",
        specialization: "Medicine Center",
        hospital: "MedicalOne Center",
        date: Date(),
        time: "10:30 AM",
        fee: 120.00
    )
    
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
                
                Text("Appointment Details")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding()
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Doctor Info Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing: 15) {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text(appointment?.doctorName.prefix(1) ?? "J")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                    )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(appointment?.doctorName ?? mockAppointmentData.doctorName)
                                        .font(.headline)
                                    
                                    Text(appointment?.specialization ?? mockAppointmentData.specialization)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Message action
                                }) {
                                    Image(systemName: "message.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    // Call action
                                }) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Appointment No")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("#\(appointment?.id ?? "1234")")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("Appointment Type")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("In Person")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Date, Time & Location
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Date, Time & Location")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                        .frame(width: 25)
                                    
                                    Text("Date")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(formattedDate(appointment?.date ?? mockAppointmentData.date))
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                        .frame(width: 25)
                                    
                                    Text("Time")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(appointment?.time ?? mockAppointmentData.time)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                        .frame(width: 25)
                                    
                                    Text("Location")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Text(appointment?.hospital ?? mockAppointmentData.hospital)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Image(systemName: "building.2")
                                            .font(.system(size: 18))
                                            .foregroundColor(.blue)
                                            .frame(width: 25)
                                        
                                        Text("Hospital")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text(appointment?.hospital ?? mockAppointmentData.hospital)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .padding(.leading, 25)
                                    
                                    Text("123 Healthcare Plaza, Suite A\nMedical City, MC 12345")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 25)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // Appointment Fee
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Appointment Fee")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("LKR\(String(format: "%.2f", appointment?.fee ?? mockAppointmentData.fee))")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                HStack(spacing: 15) {
                    Button(action: {
                        // Cancel appointment action
                    }) {
                        Text("Cancel Appointment")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        showingPrescription = true
                    }) {
                        Text("Checkout Prescription")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .sheet(isPresented: $showingPrescription) {
            // Prescription view would go here
            VStack {
                Text("Prescription Details")
                    .font(.title)
                    .padding()
                
                Text("No active prescriptions for this appointment.")
                    .foregroundColor(.gray)
                    .padding()
                
                Button(action: {
                    showingPrescription = false
                }) {
                    Text("Close")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            loadAppointmentDetails()
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
    
    // Helper function to format date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Load appointment details from backend
    private func loadAppointmentDetails() {
        // If no appointment ID was provided, use mock data
        if appointmentId == nil {
            // Use mock data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
            return
        }
        
        // Otherwise, fetch appointment data from the backend
        isLoading = true
        
        NetworkManager.shared.fetchData(endpoint: "/appointments") { (result: Result<[Appointment], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let appointments):
                if let id = self.appointmentId, let appointment = appointments.first(where: { $0.id == id }) {
                    self.appointment = appointment
                } else {
                    self.errorMessage = "Appointment not found"
                }
            case .failure(let error):
                self.errorMessage = "Failed to load appointment details: \(error.localizedDescription)"
            }
        }
    }
}

struct AppointmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailsView()
    }
}
