import SwiftUI

struct SetAvailabilityView: View {
    let doctorId: String
    @State private var morningAvailable: Bool = true
    @State private var morningStart: String = "08:00 AM"
    @State private var morningEnd: String = "12:00 PM"
    @State private var eveningAvailable: Bool = false
    @State private var eveningStart: String = "04:00 PM"
    @State private var eveningEnd: String = "08:00 PM"
    @State private var maxAppointments: Int = 8
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("Dr. James Wilson")
                    Text("Cardiologist")
                        .font(.caption).foregroundColor(.gray)
                }
                Spacer()
            }
            HStack {
                Toggle("Morning Session", isOn: $morningAvailable)
                Spacer()
                Text(morningStart).foregroundColor(.gray)
                Text("-")
                Text(morningEnd).foregroundColor(.gray)
            }
            HStack {
                Toggle("Evening Session", isOn: $eveningAvailable)
                Spacer()
                Text(eveningStart).foregroundColor(.gray)
                Text("-")
                Text(eveningEnd).foregroundColor(.gray)
            }
            HStack {
                Text("Maximum Appointments")
                Spacer()
                TextField("", value: $maxAppointments, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .frame(width: 40)
                Text("/ day")
            }
            .padding(.vertical)
            
            Button("Save Changes") {
                // Save to backend
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Spacer()
        }
        .padding()
        .navigationTitle("Manage Availability")
    }
}

struct SetAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        SetAvailabilityView(doctorId: "4")
    }
}
