# HobbyLedger

一个围绕个人爱好消费设计的 iOS 记账 App。

`HobbyLedger` 的目标不是替代通用财务软件，而是把“兴趣消费”这件事单独做好：你可以快速记录每一笔和爱好相关的支出，并持续看到自己在不同兴趣上累计花了多少钱。

这个项目会持续迭代。当前仓库是首版基础能力，后续会继续扩展预算、趋势分析、子分类、导出和同步等功能。

## 项目定位

适合这样的使用场景：

- 记录 `F1 周边`、`滑雪`、`摄影` 等兴趣消费
- 快速知道自己在每个爱好上已经投入了多少
- 把零散购买行为沉淀成长期可回看的个人消费记录

这个产品更接近“兴趣账本”，而不是“家庭总账”。

## 当前版本

当前实现的是 `v1 基础版`，重点是先把核心记账闭环做稳定：

- 按爱好分类记录支出
- 默认分类：`F1 周边`、`滑雪`、`摄影`
- 首页展示总支出和各爱好累计花费
- 展示各爱好消费占比
- 查看单个分类的消费明细
- 新增、编辑、删除支出
- 新增、编辑、删除分类
- 非空分类禁止删除，避免历史记录失联
- 本机持久化存储，使用 `SwiftData`

## 设计原则

- 录入足够快：尽量减少每笔支出的输入成本
- 分类优先：围绕“爱好”组织数据，而不是围绕账户体系
- 统计直接：打开首页就能回答“我在每个爱好上花了多少钱”
- 迭代渐进：先把最小闭环做扎实，再继续扩展高级能力

## 技术栈

- `SwiftUI`
- `SwiftData`
- `iOS 17+`
- `XCTest`

## 项目结构

- `HobbyLedger/`
  - App 源码
- `HobbyLedgerTests/`
  - 单元测试
- `docs/PLAN.md`
  - 首版产品方案与范围定义

## 开发状态

目前仓库已经具备：

- 可在 Xcode 中直接运行
- 可在 iOS Simulator 上完成构建
- 已包含基础单元测试

当前更适合作为持续迭代的基础版本，而不是“功能已经全部完成”的最终产品。

## 本地运行

### 使用 Xcode

1. 打开 `HobbyLedger.xcodeproj`
2. 选择一个 iPhone Simulator
3. 运行 `HobbyLedger` scheme

### 使用命令行构建

```bash
xcodebuild build \
  -project HobbyLedger.xcodeproj \
  -scheme HobbyLedger \
  -destination 'platform=iOS Simulator,name=iPhone 16e'
```

## 测试

```bash
xcodebuild test \
  -project HobbyLedger.xcodeproj \
  -scheme HobbyLedger \
  -destination 'platform=iOS Simulator,name=iPhone 16e'
```

## 产品方案

首版完整方案见 [docs/PLAN.md](docs/PLAN.md)。

如果后续版本继续扩展，建议把新的迭代目标继续沉淀到 `docs/` 目录，例如：

- `docs/ROADMAP.md`
- `docs/V2.md`
- `docs/V3.md`

## 计划中的迭代方向

下面这些方向已经在预期范围内，后续会逐步推进：

- 月预算与超支提醒
- 摄影子分类，例如 `数码 / 胶片`
- 更丰富的统计维度与趋势图
- 备注、商家、票据照片
- CSV 导出
- iCloud 同步
- 更完整的视觉设计和 App Icon

## 仓库维护建议

如果这个仓库后续会长期更新，建议采用下面这种节奏：

1. 把每次要做的功能先写进 `docs/`
2. 按功能拆小提交，保持 commit message 清晰
3. 每完成一个阶段，就同步更新 README 的“当前版本”和“计划中的迭代方向”

这样仓库首页会一直反映项目的真实状态，而不是只停留在第一次提交时的描述。
