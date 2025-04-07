import SwiftUI

struct BookAppointmentView: View {
    @State private var searchText = ""
    @State private var selectedDate = 15
    @State private var selectedSession = "Morning"
    @State private var selectedTimeSlot = "09:00 AM - 10:30 AM"
    
    let dates = [15, 16, 17, 18]
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu"]
    let sessions = ["Morning", "Evening"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Navigation header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Text("Book Appointment")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 10)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Doctor or Dispensary", text: $searchText)
                    .font(.system(size: 14))
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Doctor info
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Dr. John Smith")
                        .font(.system(size: 16, weight: .semibold))
                    Text("MediCare Center")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("No. of Booked Appointments")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Text("010")
                        .font(.system(size: 12))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 10)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                }
            }
            
            // Date selection
            VStack(alignment: .leading, spacing: 15) {
                Text("Select Date")
                    .font(.system(size: 16, weight: .medium))
                
                HStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        VStack(spacing: 5) {
                            Text(daysOfWeek[index])
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text("\(dates[index])")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(width: 50, height: 50)
                        .background(selectedDate == dates[index] ? Color.blue : Color.white)
                        .foregroundColor(selectedDate == dates[index] ? .white : .black)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedDate = dates[index]
                        }
                    }
                }
            }
            
            // Session selection
            VStack(alignment: .leading, spacing: 15) {
                Text("Select Session")
                    .font(.system(size: 16, weight: .medium))
                
                HStack(spacing: 10) {
                    ForEach(sessions, id: \.self) { session in
                        Text(session)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedSession == session ? Color.blue : Color.white)
                            .foregroundColor(selectedSession == session ? .white : .blue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedSession == session ? Color.clear : Color.blue, lineWidth: 1)
                            )
                            .onTapGesture {
                                selectedSession = session
                            }
                    }
                }
            }
            
            // Available time slots
            VStack(alignment: .leading, spacing: 15) {
                Text("Available Time & Appointment No.")
                    .font(.system(size: 16, weight: .medium))
                
                HStack {
                    Text("09:00 AM - 10:30 AM")
                        .font(.system(size: 14))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text("No.011")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            // Price
            HStack {
                Text("Appointment Price")
                    .font(.system(size: 16))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Spacer()
                
                Text("LKR 150.00")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.trailing, 10)
            }
            
            // Confirm booking button
            Button(action: {}) {
                Text("Confirm Booking")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(10)
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

struct TabBarItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(text)
                .font(.system(size: 10))
        }
        .foregroundColor(Color.black.opacity(0.7))
        .frame(maxWidth: .infinity)
    }
}

struct BookAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        BookAppointmentView()
    }
}
