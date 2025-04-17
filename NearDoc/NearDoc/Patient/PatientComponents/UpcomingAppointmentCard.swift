//import SwiftUI
//
//// MARK: - UpcomingAppointmentCard (Refined)
//struct UpcomingAppointmentCard: View {
//    let doctorName: String
//    let centerName: String
//    let dateTime: String
//    let appointmentNo: String
//    let status: String
//    
//    var body: some View {
//        
//        VStack(alignment: .leading, spacing: 8) {
//            
//            HStack{
//                VStack{
//                    // Doctor & Center Info
//                    Text(doctorName)
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                    Text(centerName)
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//                Text(status)
//                    .font(.caption2)
//                    .foregroundColor(.blue)
//                    .padding(4)
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(50)
//            }
//            
//            Divider()
//            
//            // Date, Time and Status
//            HStack {
//                Image(systemName: "calendar")
//                    .foregroundColor(.blue)
//                    .font(.system(size: 15))
//                    
//                Text(dateTime)
//                    .font(.system(size: 13))
//                Spacer()
//                
//                //Appointment Number
//                Text("APPT No:")
//                    .font(.system(size: 13))
//                    .foregroundColor(.red)
//                Text(appointmentNo)
//                    .font(.system(size: 13))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.red)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(Color.red.opacity(0.2))
//                    .cornerRadius(6)
//                
//            }
//         
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
//        .frame(width: 298) // Fixed width for the card
//    }
//}
//
//// MARK: - Preview
//struct UpcomingAppointmentCard_Previews: PreviewProvider {
//    static var previews: some View {
//        UpcomingAppointmentCard(
//            doctorName: "Dr. Saman Kumara",
//            centerName: "MediCare Center | Kandy",
//            dateTime: "Tommorow, 11:30 AM",
//            appointmentNo: "05",
//            status: "Upcoming"
//        )
//        .previewLayout(.sizeThatFits) // Better preview sizing
//        .padding() 
//        .background(Color.gray.opacity(0.2))
//    }
//}
