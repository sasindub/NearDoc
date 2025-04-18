import SwiftUI

struct AppointmentsView: View {
    let doctorId: String
    
    @State private var appointments: [Appointment] = []
    @State private var filteredAppointments: [Appointment] = []
    @State private var selectedDate = Date()
    @State private var selectedTab = 0 // 0: Upcoming, 1: In Progress, 2: Completed
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var searchText = ""
    
    private let tabs = ["Upcoming", "In Progress", "Completed"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search patients", text: $searchText)
                    .onChange(of: searchText) { newValue in
                        filterAppointments()
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top)
            
            // Date picker
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())
            .padding()
            .onChange(of: selectedDate) { _ in
                loadAppointments()
            }
            
            // Tab selector
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                        filterAppointments()
                    }) {
                        Text(tabs[index])
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == index ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == index ? .white : .gray)
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if filteredAppointments.isEmpty {
                Spacer()
                Text("No \(tabs[selectedTab].lowercased()) appointments")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                // Appointments list
                List {
                    ForEach(filteredAppointments) { appointment in
                        NavigationLink(destination: AppointmentDetailView(appointmentId: appointment.id, doctorId: doctorId)) {
                            appointmentRow(appointment)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Appointments")
        .onAppear {
            loadAppointments()
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
    
    // Appointment row view
    private func appointmentRow(_ appointment: Appointment) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(appointment.patientName)
                    .font(.headline)
                
                Text(appointment.time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Label(appointment.status.capitalized, systemImage: statusIcon(for: appointment.status))
                    .font(.caption)
                    .foregroundColor(statusColor(for: appointment.status))
            }
            
            Spacer()
            
            // Right side with appointment number and arrow
            VStack(alignment: .trailing, spacing: 5) {
                Text("#\(appointment.id)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
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
    
    // Load appointments from backend
    private func loadAppointments() {
        isLoading = true
        errorMessage = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDateString = dateFormatter.string(from: selectedDate)
        
        NetworkManager.shared.fetchData(endpoint: "/appointments?doctorId=\(doctorId)") { (result: Result<[Appointment], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let appointments):
                // Filter appointments for the selected date
                self.appointments = appointments.filter { appointment in
                    let appointmentDateString = dateFormatter.string(from: appointment.date)
                    return appointmentDateString == selectedDateString
                }
                
                self.filterAppointments()
            case .failure(let error):
                self.errorMessage = "Failed to load appointments: \(error.localizedDescription)"
            }
        }
    }
    
    // Filter appointments based on tab and search text
    private func filterAppointments() {
        let statusFilter: String
        switch selectedTab {
        case 0:
            statusFilter = "upcoming"
        case 1:
            statusFilter = "in progress"
        case 2:
            statusFilter = "completed"
        default:
            statusFilter = ""
        }
        
        filteredAppointments = appointments.filter { appointment in
            let matchesStatus = appointment.status.lowercased() == statusFilter
            let matchesSearch = searchText.isEmpty ||
                               appointment.patientName.lowercased().contains(searchText.lowercased())
            
            return matchesStatus && matchesSearch
        }
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView(doctorId: "1")
    }
}
