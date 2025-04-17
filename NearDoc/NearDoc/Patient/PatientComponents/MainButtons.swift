//import SwiftUI
//
//// MARK: - CustomButton Component
//struct CustomButton: View {
//    // MARK: Properties
//    let title: String
//    let action: () -> Void
//    let foregroundColor: Color
//    let backgroundColor: Color
//    let borderColor: Color?
//    let borderWidth: CGFloat
//    let fontSize: CGFloat
//    let width: CGFloat?
//    let height: CGFloat?
//    let cornerRadius: CGFloat
//    
//    // MARK: Body
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.system(size: fontSize))
//                .fontWeight(.semibold)
//                .foregroundColor(foregroundColor)
//                .frame(maxWidth: width ?? .infinity,
//                      minHeight: height)
//                .padding()
//                .background(backgroundColor)
//                .cornerRadius(cornerRadius)
//                .overlay(
//                    borderColor != nil ?
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                            .stroke(borderColor ?? .clear, lineWidth: borderWidth)
//                        : nil
//                )
//        }
//    }
//}
//
//// MARK: - Preview Provider
//struct CustomButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 16) {
//            CustomButton(
//                title: "Book Appointment",
//                action: {},
//                foregroundColor: .white,
//                backgroundColor: .blue,
//                borderColor: nil,
//                borderWidth: 0,
//                fontSize: 17,
//                width: nil,
//                height: nil,
//                cornerRadius: 10
//            )
//            
//            CustomButton(
//                title: "View Medication History",
//                action: {},
//                foregroundColor: .blue,
//                backgroundColor: .clear,
//                borderColor: .blue,
//                borderWidth: 2,
//                fontSize: 17,
//                width: nil,
//                height: nil,
//                cornerRadius: 10
//            )
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .previewLayout(.sizeThatFits)
//    }
//}
