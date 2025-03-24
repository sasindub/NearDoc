import SwiftUI

struct PatientDashboardView: View {
    @State private var notificationCount: Int = 3
    @State private var searchQuery = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header fixed at the top
                HeaderView(
                                    profileImageName: "profile",
                                    userName: "Jane Doe",
                                    notificationCount: notificationCount,
                                    notificationAction: {
                                        print("Notification button tapped!")
                                    },
                                    searchQuery: $searchQuery
                                )

                //MARK: - Upcoming APPT
                ScrollView {
                    VStack(spacing: 20) {
                        
                        HStack {
                            Text("Upcoming Appointments")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                // Navigate to history
                            }) {
                                Text("View History")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, -30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                UpcomingAppointmentCard(
                                    doctorName: "Dr. Saman Kumara",
                                    centerName: "MediCare Center | Kandy",
                                    dateTime: "Today, 2:30 PM",
                                    appointmentNo: "05",
                                    status: "Upcoming"
                                )
                                
                                UpcomingAppointmentCard(
                                    doctorName: "Dr. Jane Doe",
                                    centerName: "City Hospital | Colombo",
                                    dateTime: "Tomorrow, 11:00 AM",
                                    appointmentNo: "06",
                                    status: "Upcoming"
                                )
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }
                        .padding(.bottom, -20)
                        
                        //MARK: - Nearby Dispensaries
                        
                        HStack {
                            Text("Nearby Dispensaries")
                                .font(.headline)
                            Spacer()
                            
                            Text("View All")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, -30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                NearbyDispensaryCard(
                                    centerName: "MediCare Center",
                                    address: "Main Road, Kandy",
                                    availabilityText: "Doctor Available",
                                    timeSlots: "7:00 AM - 10:00 AM, 4:00 PM - 6:00 PM"
                                )
                                
                                NearbyDispensaryCard(
                                    centerName: "MediCare Center",
                                    address: "Main Road, Kandy",
                                    availabilityText: "Doctor Available",
                                    timeSlots: "7:00 AM - 10:00 AM, 4:00 PM - 6:00 PM"
                                )
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }
                        
                        //MARK: - Buttons
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                // Book Appointment action
                            }) {
                                Text("Book Appointment")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // View Medication History action
                            }) {
                                Text("View Medication History")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemGray6))
                }
                .background(Color(.systemGray6))
                
             
                BottomNavBar(activeTab: "Home")
                    .frame(height: 30)
            }
            .navigationBarHidden(true)
        }
    }
}

struct PatientDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDashboardView()
    }
}
