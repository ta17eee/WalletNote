import SwiftUI

struct PremiumShortcutsView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                
                Text("プレミアム会員特典")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                FeatureCard(
                    icon: "nosign",
                    title: "広告なし",
                    color: .green
                )
                
                FeatureCard(
                    icon: "sparkles",
                    title: "特別機能",
                    color: .blue
                )
                
                FeatureCard(
                    icon: "crown.fill",
                    title: "優先サポート",
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    PremiumShortcutsView()
        .padding()
        .background(Color(.systemGroupedBackground))
}
