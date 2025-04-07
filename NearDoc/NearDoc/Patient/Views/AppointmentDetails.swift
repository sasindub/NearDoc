import SwiftUI

struct AppointmentDetailsView: View {
    @State private var selectedTab = "Upcoming"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Text("Appointment Details")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading, 8)
                Spacer()
            }
            
            // Tab selection
            HStack {
                Text("Upcoming")
                    .font(.system(size: 14))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Capsule().fill(Color.green.opacity(0.2)))
                    .foregroundColor(.green)
                Spacer()
            }
            
            // Doctor info card
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Dr. John Smith")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Medicare Center")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Appointment details
            VStack(spacing: 20) {
                // Appointment number
                HStack {
                    Text("Appointment No")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("0001")
                        .font(.system(size: 14))
                }
                
                Divider()
                
                // Date
                HStack {
                    Text("Date")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("23 April, 2025")
                        .font(.system(size: 14))
                }
                
                Divider()
                
                // Time
                HStack {
                    Text("Time")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("10:30 AM")
                        .font(.system(size: 14))
                }
                
                Divider()
                
                // Medical Center
                HStack {
                    Text("Medical Center")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("MediCare")
                        .font(.system(size: 14))
                }
                
                Divider()
                
                // Location
                HStack(alignment: .top) {
                    Text("Location")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Medical Center, Floor 3")
                            .font(.system(size: 14))
                        Text("123 Healthcare,")
                            .font(.system(size: 14))
                        Text("Kandy, 10001")
                            .font(.system(size: 14))
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 10) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.down.doc.fill")
                            .foregroundColor(.white)
                        Text("Download Prescription")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                        Text("Cancel Appointment")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.red)
                    .cornerRadius(10)
                }
            }
            
            // Tab bar
            HStack {
                TabBarItem(icon: "house.fill", text: "Home")
                TabBarItem(icon: "calendar", text: "Appointments")
                TabBarItem(icon: "pills.fill", text: "Medications")
                TabBarItem(icon: "building.fill", text: "Dispensaries")
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
    }
}


struct AppointmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailsView()
    }
}
