import SwiftUI

struct DoctorAvailabilityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    @State private var doctors: [DoctorAvailability] = []
    @State private var filteredDoctors: [DoctorAvailability] = []
    @State private var isLoading: Bool = true
    @State private var showingBookingScreen: Bool = false
    @State private var selectedDoctor: DoctorAvailability? = nil
    
    // Mock data model
    struct DoctorAvailability: Identifiable {
        var id: String
        var name: String
        var specialization: String
        var hospital: String
        var rating: Double
        var availability: String
        var time: String
        var isAvailableToday: Bool
    }
    
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
                
                Text("Doctor Availability")
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "bell")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding()
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Professionals or Specialty", text: $searchText)
                    .onChange(of: searchText) { newValue in
                        filterDoctors()
                    }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredDoctors) { doctor in
                            DoctorAvailabilityCard(doctor: doctor) {
                                selectedDoctor = doctor
                                showingBookingScreen = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .onAppear {
            loadDoctors()
        }
        .sheet(isPresented: $showingBookingScreen) {
            if let _ = selectedDoctor {
                BookAppointmentView()
            }
        }
    }
    
    // Mock backend integration for doctor data
    private func loadDoctors() {
        isLoading = true
        
        // Simulate network call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Generate mock doctors
            self.doctors = [
                DoctorAvailability(
                    id: "1",
                    name: "Dr. John Smith",
                    specialization: "Medicine Center",
                    hospital: "MedicalOne Center",
                    rating: 4.5,
                    availability: "Mon, Tues, Wed",
                    time: "10:00 AM - 5:00 PM",
                    isAvailableToday: true
                ),
                DoctorAvailability(
                    id: "2",
                    name: "Dr. Sarah Johnson",
                    specialization: "Heart Center",
                    hospital: "CardioHealth Hospital",
                    rating: 4.8,
                    availability: "Tues, Wed, Thurs",
                    time: "09:00 AM - 3:00 PM",
                    isAvailableToday: false
                ),
                DoctorAvailability(
                    id: "3",
                    name: "Dr. Michael Chen",
                    specialization: "Neurology",
                    hospital: "Brain & Spine Center",
                    rating: 4.7,
                    availability: "Mon, Wed, Fri",
                    time: "11:00 AM - 6:00 PM",
                    isAvailableToday: true
                ),
                DoctorAvailability(
                    id: "4",
                    name: "Dr. Susan Taylor",
                    specialization: "Dermatology",
                    hospital: "SkinCare Clinic",
                    rating: 4.2,
                    availability: "Mon, Thurs, Fri",
                    time: "09:30 AM - 4:30 PM",
                    isAvailableToday: true
                )
            ]
            
            self.filteredDoctors = self.doctors
            self.isLoading = false
        }
    }
    
    // Filter doctors based on search text
    private func filterDoctors() {
        if searchText.isEmpty {
            filteredDoctors = doctors
        } else {
            filteredDoctors = doctors.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.specialization.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// Doctor card component
struct DoctorAvailabilityCard: View {
    let doctor: DoctorAvailabilityView.DoctorAvailability
    let onBookTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
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
                        
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 5, height: 5)
                        
                        Text("1.5 km away")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(doctor.availability)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(doctor.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(doctor.isAvailableToday ? "Available Today" : "Not Available Today")
                        .font(.caption)
                        .foregroundColor(doctor.isAvailableToday ? .green : .red)
                }
            }
            
            Button(action: onBookTapped) {
                Text("Book Appointment")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
    }
}

struct DoctorAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorAvailabilityView()
    }
}
