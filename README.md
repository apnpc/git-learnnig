# README

## 目的

本课程旨在为初学者提供一个全面而简洁的介绍，让你快速掌握 Git 的基本概念和使用方法。无论你是一名软件开发新手、项目经理还是对版本控制感兴趣的任何人，本课程都将为你建立起坚实的Git基础。

主打的就是一个简单，每个小节都涉及到 Git 的核心知识，并有相关的实验，相信你在阅读完后会对 Git 有一个比较全面的认识。

## 注意事项

1. 本教程基于 Windows 10 操作系统，Git 版本 version 2.40.1.windows.1
2. 必须动手，请按照实验内容自己敲一遍；
3. 请配合 Git 官方书籍 [《Git pro》](https://git-scm.com/book/zh/v2)查缺补漏；
4. 命令展示说明

```PowerShell
# 这条是注释
$ 这条是命令
  这条是命令的输出内容
```

## 图谱

```mermaid
graph TD
  A[仓库] --> B[提交]
  A --> C[分支]
  A --> D[远程管理]
  C --> E[主分支]
  C --> F[开发分支]
  C --> G[功能分支]
  C --> H[发布分支]
  C --> I[热修复分支]
  B --> J[哈希值]
  B --> K[日志信息]
  B --> L[作者和时间]
  C --> M[合并]
  D --> N[克隆]
  D --> O[推送]
  D --> P[拉取]
  E --> Q[版本回退]
  F --> Q
  G --> Q
  H --> Q
  I --> Q
  M --> R[解决代码冲突]
  M --> S[处理自动合并和手动合并]
  T[工作流程] --> U[Git Flow]
  T --> V[GitHub Flow]
  T --> W[Trunk Based Development]
  X[命令行界面] --> A
  Y[图形用户界面] --> A
  Z[IDE 集成] --> A
  1[仓库] --> 2[工作区]
1[仓库] --> 3[暂存区]
1[仓库] --> 4[版本库]


```
