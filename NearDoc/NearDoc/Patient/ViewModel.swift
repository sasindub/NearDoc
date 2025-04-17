//import Foundation
//
//class PatientDashboardViewModel: ObservableObject {
//    @Published var appointments: [Appointment] = []
//    @Published var dispensaries: [Dispensary] = []
//    
//    func loadDashboardData(patientID: String, zip: String) {
//        
//        APIService.shared.fetchAppointments(patientID: "67fb4947127717d718491d22") { appointments in
//            // Update published property
//            self.appointments = appointments
//        }
//        APIService.shared.fetchNearbyDispensaries(zip: "10001") { dispensaries in
//            self.dispensaries = dispensaries
//        }
////
//    }
//}
