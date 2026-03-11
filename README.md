# HobbyLedger

一个面向个人兴趣消费的 iOS 记账 App。

它不是通用财务软件，而是一个轻量的兴趣账本，重点解决这件事：
快速记下每笔与爱好相关的支出，并清楚看到自己在不同爱好上累计花了多少钱。

## 当前功能

- 按爱好分类记录支出
- 默认分类：`F1 周边`、`滑雪`、`摄影`
- 首页展示总支出和各爱好累计花费
- 查看单个爱好的消费明细
- 新增、编辑、删除支出
- 新增、编辑、删除分类
- 非空分类禁止删除，避免历史记录失联
- 本机持久化存储，使用 SwiftData

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
  - 产品方案与实现范围

## 本地运行

1. 用 Xcode 打开 `HobbyLedger.xcodeproj`
2. 选择一个 iPhone Simulator
3. 运行 `HobbyLedger` scheme

也可以用命令行：

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

完整方案见 [docs/PLAN.md](docs/PLAN.md)。
