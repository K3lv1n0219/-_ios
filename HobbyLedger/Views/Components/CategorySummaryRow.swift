import SwiftUI

struct CategorySummaryRow: View {
    let summary: CategorySpendSummary

    private var barColor: Color {
        CategoryColorPalette.color(for: summary.categoryName)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(summary.categoryName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                Text(CurrencyFormatting.string(for: summary.totalAmount))
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 10)

                    Capsule()
                        .fill(barColor)
                        .frame(
                            width: max(12, geometry.size.width * summary.percentage),
                            height: 10
                        )
                }
            }
            .frame(height: 10)

            Text(summary.percentage, format: .percent.precision(.fractionLength(0)))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    CategorySummaryRow(
        summary: CategorySpendSummary(
            categoryId: UUID(),
            categoryName: "滑雪",
            totalAmount: 2888,
            percentage: 0.58,
            sortOrder: 1
        )
    )
    .padding()
}
