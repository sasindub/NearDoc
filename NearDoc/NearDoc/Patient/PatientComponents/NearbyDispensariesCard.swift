import SwiftUI

// MARK: - NearbyDispensaryCard Component
struct NearbyDispensaryCard: View {
    // MARK: Properties
    let centerName: String
    let address: String
    let availabilityText: String
    let timeSlots: String
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header Section
            HStack(alignment: .center) {
                // Icon
                Image(systemName: "building.2.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                
                // Name and Address
                VStack(alignment: .leading, spacing: 2) {
                    Text(centerName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(address)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Availability Badge
                Text(availabilityText)
                    .font(.caption2)
                    .foregroundColor(.green)
                    .padding(6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(50)
            }
            
            Divider()
            
            // Time Slots with Icon
            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(timeSlots)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
        }
        .padding()
        .padding(.vertical, 6)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        
    }
}

// MARK: - Preview Provider
struct NearbyDispensaryCard_Previews: PreviewProvider {
    static var previews: some View {
        NearbyDispensaryCard(
            centerName: "Green Leaf Dispensary",
            address: "123 Main St, Boulder, CO 80302",
            availabilityText: "Doctor Available",
            timeSlots: "9:00 AM - 9:00 PM   |   10:00 AM - 10:00 PM"
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGray6))
    }
}
