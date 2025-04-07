import SwiftUI

struct DoctorAvailabilityView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("Doctor Availability")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Dispensary or City Name", text: $searchText)
                    .font(.system(size: 14))
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Doctor list
            ScrollView {
                VStack(spacing: 20) {
                    // Doctor 1
                    DoctorCard(
                        name: "Dr. John Smith",
                        center: "Central Medical Center",
                        availability: "Now Available Doctor",
                        morningHours: "7:00 AM - 10:00 AM",
                        eveningHours: "4:00 PM - 6:00 PM",
                        isAvailable: true
                    )
                    
                    // Doctor 2
                    DoctorCard(
                        name: "Dr. Sarah Johnson",
                        center: "City Healthcare",
                        availability: "Now Available Doctor",
                        morningHours: "7:00 AM - 10:00 AM",
                        eveningHours: "4:00 PM - 6:00 PM",
                        isAvailable: true
                    )
                    
                    // Doctor 3
                    DoctorCard(
                        name: "Dr. Michael Chen",
                        center: "Metro Medical",
                        availability: "Closed",
                        morningHours: "",
                        eveningHours: "4:00 PM - 6:00 PM",
                        isAvailable: false
                    )
                }
            }
            
            Spacer()
            
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

struct DoctorCard: View {
    let name: String
    let center: String
    let availability: String
    let morningHours: String
    let eveningHours: String
    let isAvailable: Bool
    
    var body: some View {
        HStack {
            // Doctor image
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
                .padding(.trailing, 10)
            
            // Doctor info
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                Text(center)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                if isAvailable {
                    Text(availability)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                } else {
                    Text(availability)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
            }
            
            Spacer()
            
            // Hours
            VStack(alignment: .trailing, spacing: 5) {
                if !morningHours.isEmpty {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Morning: \(morningHours)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Evening: \(eveningHours)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


struct DoctorAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorAvailabilityView()
    }
}
