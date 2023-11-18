import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            GeometryReader {
                geometry in
                ZStack {
                    Color.mint.edgesIgnoringSafeArea(.top)
                    VStack {
                        HStack{
                            Image(systemName: "staroflife.fill")
                                .symbolRenderingMode(.palette)
                                .font(.system(size: 40, weight: .regular))
                                .foregroundStyle(.red)
                            Text("frolik.")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding([.top], 90)
                    Spacer()
                    VStack (spacing: 20) {
                        NavigationLink(destination: CalcGD_View()) {
                            CardView(icon: "drop.fill", title: "GD Calculator", subtitle: "Detailed dosage calculation")
                        }
                        .buttonStyle(PlainButtonStyle())
                        NavigationLink(destination: CalcAD_View()) {
                            CardView(icon: "pills.fill", title: "Formula 2", subtitle: "Another detailed calculation")
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        
                    }
                    .padding(30)
                    .padding(.bottom, 50)
                    .background() // Card background color
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .frame(height: geometry.size.height / 1)
                    .offset(y: geometry.size.height / 4)
                }
            }
            .accentColor(.mint)
        }
    }
}

// Card view remains the same
struct CardView: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.mint)
                .imageScale(.large)
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background() // Card background color
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

// Preview provider
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
