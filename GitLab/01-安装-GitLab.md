---
title: "安装 GitLab"
description: "说明安装 GitLab Self-Managed 前的准备、流程和维护要求。"
type: how-to
group: "平台与服务"
sidebar:
  order: 1
lastUpdated: 2026-09-23
---
# 安装 GitLab

GitLab Self-Managed 是包含数据库、缓存、Web 服务和后台任务的服务器应用，不适合作为普通 Git 入门实验。生产安装前需要确定：

- 受支持的操作系统和 CPU 架构；
- 内存、存储和备份空间；
- DNS、HTTPS 证书和邮件服务；
- 升级路径、备份恢复和监控方案。

GitLab 的版本和受支持平台会持续变化，不要复制固定版本号或旧发行版命令。先查阅：

- [Linux 软件包安装文档](https://docs.gitlab.com/install/package/)
- [安装要求](https://docs.gitlab.com/install/requirements/)
- [备份和恢复](https://docs.gitlab.com/administration/backup_restore/)

## 安装流程

1. 从官方支持列表选择操作系统；
2. 配置稳定的域名和 HTTPS；
3. 按对应系统的官方步骤添加 GitLab 软件源；
4. 设置 `EXTERNAL_URL` 并安装 `gitlab-ee` 或 `gitlab-ce`；
5. 登录后立即修改初始管理员密码；
6. 在导入项目之前完成一次备份和恢复演练。

不要把真实 IP、域名、令牌或初始密码写进教程和版本库。升级时必须按 GitLab 的升级路径逐个跨越所需版本，不能假设可以直接升级到任意最新版本。
