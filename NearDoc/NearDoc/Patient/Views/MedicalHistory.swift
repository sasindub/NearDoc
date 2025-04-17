//import SwiftUI
//
//struct MedicationHistoryView: View {
//    var body: some View {
//        VStack(spacing: 0) {
//            // Header
//            HStack {
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(.black)
//                Text("Medication History")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.black)
//                Spacer()
//            }
//            .padding()
//            .background(Color.white)
//            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//
//            ScrollView {
//                VStack(spacing: 20) {
//                    PrescriptionCard(
//                        imageName: "person1",
//                        name: "Dr. John Smith",
//                        specialty: "Cardiologist",
//                        description: "Regular checkup and blood pressure medication review",
//                        date: "Jan 15, 2025",
//                        showDownload: true
//                    )
//                    PrescriptionCard(
//                        imageName: "person1",
//                        name: "Dr. Sarah Johnson",
//                        specialty: "General Physician",
//                        description: "Flu symptoms and throat infection treatment",
//                        date: "Dec 28, 2024",
//                        showDownload: false
//                    )
//                    PrescriptionCard(
//                        imageName: "person1",
//                        name: "Dr. Michael Chen",
//                        specialty: "Dermatologist",
//                        description: "Skin allergy treatment and medication review",
//                        date: "Dec 15, 2024",
//                        showDownload: true
//                    )
//                }
//                .padding()
//            }
//            
//            // Bottom Navigation Bar
//            HStack {
//                BottomTabItem(icon: "house", label: "Home", isSelected: false)
//                BottomTabItem(icon: "calendar", label: "Appointments", isSelected: false)
//                BottomTabItem(icon: "pills", label: "Medications", isSelected: true)
//                BottomTabItem(icon: "building.2", label: "Dispensaries", isSelected: false)
//            }
//            .padding(.horizontal, 10)
//            .padding(.top, 12)
//            .padding(.bottom, 24)
//            .background(Color.white.shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -2))
//        }
//        .background(Color(red: 245/255, green: 249/255, blue: 248/255).ignoresSafeArea())
//    }
//}
//
//struct PrescriptionCard: View {
//    var imageName: String
//    var name: String
//    var specialty: String
//    var description: String
//    var date: String
//    var showDownload: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack(alignment: .top) {
//                Image(imageName)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .clipShape(Circle())
//                VStack(alignment: .leading) {
//                    Text(name)
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.black)
//                    Text(specialty)
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//                Text(date)
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//            }
//
//            Text(description)
//                .font(.system(size: 14))
//                .foregroundColor(.black)
//
//            if showDownload {
//                Button(action: {}) {
//                    HStack {
//                        Image(systemName: "arrow.down.to.line.alt")
//                        Text("Download Prescription")
//                    }
//                    .padding(.vertical, 10)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .font(.system(size: 14, weight: .semibold))
//                    .cornerRadius(8)
//                }
//            } else {
//                Text("No Prescription Available")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(.red)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
//    }
//}
//
//struct BottomTabItem: View {
//    var icon: String
//    var label: String
//    var isSelected: Bool
//
//    var body: some View {
//        VStack(spacing: 4) {
//            Image(systemName: icon)
//                .font(.system(size: 20, weight: .medium))
//                .foregroundColor(isSelected ? .blue : .gray)
//            Text(label)
//                .font(.system(size: 12, weight: .medium))
//                .foregroundColor(isSelected ? .blue : .gray)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct MedicationHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        MedicationHistoryView()
//    }
//}
