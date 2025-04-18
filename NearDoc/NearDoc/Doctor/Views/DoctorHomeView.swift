import SwiftUI

struct DoctorHomeView: View {
    let doctorId: String
    @State private var doctorName: String = "Dr. James Wilson"
    @State private var doctorSpecialty: String = "Cardiologist"
    @State private var totalAppointments: Int = 12
    @State private var todayEarnings: Double = 3300.00
    @State private var morningAvailable: Bool = true
    @State private var eveningAvailable: Bool = false
    @State private var appointmentsToday: [AppointmentPreview] = []
    @State private var notifications: [NotificationPreview] = []
    
    // Sample models for preview data
    struct AppointmentPreview: Identifiable {
        let id = UUID()
        let patientName: String
        let time: String
        let status: String
    }
    
    struct NotificationPreview: Identifiable {
        let id = UUID()
        let title: String
        let time: String
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Doctor profile header
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Text("JW")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(doctorName)
                            .font(.headline)
                        Text("Monday, Jan 18, 2025")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Settings icon in the design
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                // Stats cards
                HStack(spacing: 10) {
                    // Appointments card
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        
                        Text("Appointments")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(totalAppointments)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 2)
                    
                    // Earnings card
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.green)
                        
                        Text("Today's Earnings")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("LKR \(String(format: "%.2f", todayEarnings))")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 2)
                }
                
                // Availability section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Availability")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        
                        Text("Morning (9:00 AM - 12:00 PM)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Toggle("", isOn: $morningAvailable)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        
                        Text("Evening (4:00 PM - 8:00 PM)")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Toggle("", isOn: $eveningAvailable)
                            .labelsHidden()
                    }
                    
                    NavigationLink(destination: SetAvailabilityView(doctorId: doctorId)) {
                        HStack {
                            Spacer()
                            Text("Manage Availability")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4)
                
                // Upcoming appointments section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Upcoming Appointments")
                            .font(.headline)
                        
                        Spacer()
                        
                        NavigationLink(destination: AppointmentsView(doctorId: doctorId)) {
                            Text("View all")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    ForEach(getAppointments()) { appointment in
                        HStack {
                            Circle()
                                .fill(getStatusColor(appointment.status))
                                .frame(width: 8, height: 8)
                            
                            Text(appointment.patientName)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text(appointment.time)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            NavigationLink(destination: AppointmentDetailView(appointmentId: "1", doctorId: doctorId)) {
                                Text("View")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        if appointment.id != getAppointments().last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4)
                
                // Notifications section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Notifications")
                            .font(.headline)
                        
                        Spacer()
                        
                        NavigationLink(destination: DoctorNotificationsView(doctorId: doctorId)) {
                            Text("View all")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    ForEach(getNotifications()) { notification in
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.orange)
                            
                            Text(notification.title)
                                .font(.subheadline)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(notification.time)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            // You would typically load data from your backend here
            // For now, we're using the sample data
        }
    }
    
    // Helper to get status color
    private func getStatusColor(_ status: String) -> Color {
        switch status {
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
    
    // Sample data for preview
    private func getAppointments() -> [AppointmentPreview] {
        return [
            AppointmentPreview(patientName: "Sarah Johnson", time: "10:30 AM", status: "upcoming"),
            AppointmentPreview(patientName: "Michael Smith", time: "11:00 AM", status: "in progress"),
            AppointmentPreview(patientName: "Emma Davis", time: "02:00 PM", status: "upcoming")
        ]
    }
    
    private func getNotifications() -> [NotificationPreview] {
        return [
            NotificationPreview(title: "New appointment booked", time: "5m ago"),
            NotificationPreview(title: "Appointment #16 completed successfully", time: "1h ago")
        ]
    }
}

struct DoctorHomeView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorHomeView(doctorId: "4")
    }
}
