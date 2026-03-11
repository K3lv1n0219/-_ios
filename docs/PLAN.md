# iOS 兴趣分类记账 App 首版方案

## Summary

做一个 `iPhone + SwiftUI` 的极简记账 App，目标非常明确：快速记录每笔兴趣相关支出，并清楚看到自己在不同爱好上累计花了多少钱。

首版聚焦以下范围：

- 只记录 `支出`
- 只做 `本机存储`
- 录入字段仅包含 `金额 + 日期 + 爱好`
- 首页核心价值是 `各爱好总花费统计`
- 默认分类：`F1 周边`、`滑雪`、`摄影`

## Product Goals

### Primary goal

用户能在 5 秒内记下一笔兴趣支出，并在首页立即看到每个爱好累计花费。

### Success criteria

- 首次打开 App 后无需配置即可开始记账
- 新增一笔支出操作路径不超过 2 层
- 首页能清楚展示各爱好的总支出
- 能查看某个爱好的支出明细列表
- 用户能增删改默认爱好分类

### Out of scope for v1

- 收入、转账、信用卡、账户体系
- 退款/冲销
- 预算提醒
- iCloud 同步
- 发票/照片附件
- 商家、标签、复杂备注

## Information Architecture

### 首页 Dashboard

- 展示总支出
- 展示各爱好分类累计金额
- 展示各爱好占比
- 点击分类进入详情
- 固定新增按钮

### 记一笔 Add Expense

- 金额
- 日期
- 爱好分类

### 分类明细 Category Detail

- 当前爱好累计花费
- 该分类下记录列表
- 支持编辑和删除

### 分类管理 Categories

- 新增分类
- 编辑分类名称
- 删除空分类
- 非空分类禁止删除

## Technical Approach

- UI: `SwiftUI`
- Persistence: `SwiftData`
- Platform: `iOS 17+`
- Architecture: 轻量数据驱动结构

## Data Model

### `HobbyCategory`

- `id: UUID`
- `name: String`
- `createdAt: Date`
- `isDefault: Bool`
- `sortOrder: Int`

### `ExpenseRecord`

- `id: UUID`
- `amount: Decimal`
- `date: Date`
- `category: HobbyCategory`
- `createdAt: Date`
- `updatedAt: Date`

## Validation Rules

- 分类名不能为空
- 分类名不能重复
- 金额必须大于 0
- 记录必须选择分类
- 非空分类不能删除

## Acceptance

- 默认分类能自动初始化
- 新增支出后首页统计立即更新
- 分类详情能显示对应记录
- 编辑和删除记录后统计同步变化
- 仓储和统计逻辑有测试覆盖

## Future Extensions

- 月预算
- 摄影子分类（数码 / 胶片）
- 备注、商家、票据照片
- CSV 导出
- iCloud 同步
