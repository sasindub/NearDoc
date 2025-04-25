import SwiftUI

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @State private var upcomingAppointments: [Appointment] = []
    @State private var nearbyDoctors: [Doctor] = []
    @State private var isLoading: Bool = true
    @State private var selectedDate = Date()
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Upcoming Appointments
                    appointmentsSection
                    
                    // Date Selection
                    dateSelectionSection
                    
                    // Nearby Doctors
                    doctorsSection
                }
                .padding(.vertical)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .onAppear {
            loadData()
        }
        .navigationBarHidden(true)
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
    
    // MARK: - UI Components
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Saman Kumara")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search doctors or specialities", text: .constant(""))
                    .font(.subheadline)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var appointmentsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Upcoming Appointments")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if upcomingAppointments.isEmpty {
                HStack {
                    Spacer()
                    Text("No upcoming appointments")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(upcomingAppointments) { appointment in
                            appointmentCard(appointment)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func appointmentCard(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(appointment.doctorName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Image(systemName: "video.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    )
            }
            
            Text(appointment.specialization)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formatDate(appointment.date))
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(appointment.time)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            
            NavigationLink(destination: AppointmentDetailsView(appointmentId: appointment.id)) {
                Text("View Details")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        .frame(width: 250)
    }
    
    private var dateSelectionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Dates")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<7) { index in
                        let today = Date()
                        let day = Calendar.current.date(byAdding: .day, value: index, to: today)!
                        dateSelectionButton(for: day)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func dateSelectionButton(for day: Date) -> some View {
        Button(action: {
            selectedDate = day
            loadData(for: day)
        }) {
            VStack(spacing: 8) {
                Text(dayOfWeek(for: day))
                    .font(.caption)
                    .foregroundColor(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? .white : .gray)
                
                Text("\(dayNumber(for: day))")
                    .font(.headline)
                    .foregroundColor(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? .white : .black)
                
                Text(monthName(for: day))
                    .font(.caption)
                    .foregroundColor(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? .white : .gray)
            }
            .frame(width: 60, height: 90)
            .background(Calendar.current.isDate(day, inSameDayAs: selectedDate) ? Color.blue : Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
        }
    }
    
    private var doctorsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Nearby Doctors")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if nearbyDoctors.isEmpty {
                HStack {
                    Spacer()
                    Text("No doctors available")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
            } else {
                VStack(spacing: 15) {
                    ForEach(nearbyDoctors) { doctor in
                        doctorCard(doctor)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func doctorCard(_ doctor: Doctor) -> some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(doctor.name)
                    .font(.headline)
                
                Text(doctor.specialization)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", doctor.rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: BookAppointmentView(selectedDoctor: doctor)) {
                Text("Book")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
    
    // MARK: - Helper Functions
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: date)
    }
    
    func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    func dayNumber(for date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    // MARK: - Data Loading
    
    private func loadData(for date: Date? = nil) {
        isLoading = true
        errorMessage = ""
        
        // Fetch appointments
        NetworkManager.shared.fetchData(endpoint: "/appointments") { (result: Result<[Appointment], Error>) in
            switch result {
            case .success(let appointments):
                self.upcomingAppointments = appointments
                
                // Filter by date if provided
                if let selectedDate = date {
                    self.upcomingAppointments = self.upcomingAppointments.filter { appointment in
                        Calendar.current.isDate(appointment.date, inSameDayAs: selectedDate)
                    }
                }
                
                // Now fetch doctors
                self.fetchDoctors()
                
            case .failure(let error):
                self.isLoading = false
                self.errorMessage = "Failed to load appointments: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchDoctors() {
        NetworkManager.shared.fetchData(endpoint: "/doctors") { (result: Result<[Doctor], Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let doctors):
                self.nearbyDoctors = doctors
            case .failure(let error):
                self.errorMessage = "Failed to load doctors: \(error.localizedDescription)"
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isLoggedIn: .constant(true))
    }
}
