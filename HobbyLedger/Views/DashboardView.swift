import SwiftData
import SwiftUI

struct DashboardView: View {
    @Query(sort: [SortDescriptor(\HobbyCategory.sortOrder), SortDescriptor(\HobbyCategory.createdAt)])
    private var categories: [HobbyCategory]

    @Query(sort: [SortDescriptor(\ExpenseRecord.date, order: .reverse), SortDescriptor(\ExpenseRecord.createdAt, order: .reverse)])
    private var expenses: [ExpenseRecord]

    @State private var showingAddExpense = false
    @State private var showingCategoryManagement = false

    private var stats: DashboardStatsService {
        DashboardStatsService(categories: categories, expenses: expenses)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if expenses.isEmpty {
                        emptyState
                    } else {
                        dashboardContent
                    }
                }
                .navigationTitle("兴趣账本")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("分类") {
                            showingCategoryManagement = true
                        }
                    }
                }

                addButton
            }
            .sheet(isPresented: $showingAddExpense) {
                AddEditExpenseView()
            }
            .sheet(isPresented: $showingCategoryManagement) {
                NavigationStack {
                    CategoryManagementView()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "tray.and.arrow.down.fill")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("开始记录你的兴趣消费")
                    .font(.title3.bold())

                Text("把 F1 周边、滑雪、摄影这些花费集中记下来，很快就能知道自己在每个爱好上花了多少钱。")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button("记第一笔") {
                showingAddExpense = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    private var dashboardContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                totalCard

                VStack(alignment: .leading, spacing: 14) {
                    Text("按爱好汇总")
                        .font(.headline)

                    ForEach(stats.spentByCategory) { summary in
                        if let category = categories.first(where: { $0.id == summary.categoryId }) {
                            NavigationLink {
                                CategoryDetailView(category: category)
                            } label: {
                                CategorySummaryRow(summary: summary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 96)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var totalCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("总支出")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(CurrencyFormatting.string(for: stats.totalSpent))
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("首页只显示已发生支出的分类。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var addButton: some View {
        Button {
            showingAddExpense = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.primary)
                )
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 10)
    }
}

#Preview {
    DashboardView()
        .modelContainer(AppContainer.preview)
}
