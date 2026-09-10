# 来源、旧入口与历史基线

本轮以 Workflow-SOP 的既有内容为基础重新整理，保留工程质量经验，减少工具耦合和重复规则。它是改编后的公司试行工作方法，不宣称已验证全公司 ROI，也不引入新的运行系统。

## 固定来源

| 来源 | 使用内容与边界 |
|---|---|
| [Workflow-SOP 整理前基线](https://github.com/YIMO691/Workflow-SOP/tree/60ccde7bb1c05b90cb55c5ec603f14366d27ae64) | 原 SOP、代码/注释/分端规范、轻量记录和恢复经验；本轮不保留其固定 Gate 状态协议 |
| [Ares 流程讨论基线](https://github.com/YIMO691/ares-ai-engineering-harness/tree/f425027a31263cb4842c4c86f1d0448a8e89c2c3) | Context 来源、关键决策、直接协作、真实验证和模型自主原则；未导入 Web、CLI、数据库、Agent Framework 或 Change Lens 实现 |

来源仓库为私有，链接需要相应权限；本文件不扩大原内容的访问、复制或许可范围。独立 ares-ai-software-engineering 知识库未自动接入。

## 旧入口去向

| 旧路径 | 当前入口 |
|---|---|
| SOP.md / TASK-LEVELS.md | [WORKFLOW](WORKFLOW.md) 的过程、文档选择和结果判断 |
| AI-PLAYBOOK.md / AGENT-WORKSPACE.md | [AI_COLLABORATION](AI_COLLABORATION.md) 的自主执行、项目边界和恢复 |
| CODE-GUIDE.md / DOCUMENTATION-GUIDE.md | [ENGINEERING_RULES](ENGINEERING_RULES.md) 及 [模板入口](../templates/README.md) |
| START-HERE.md / prompts/ | [README 快速开始](../README.md#从这里开始) 和 AI 协作说明 |
| FORMAL-FEATURE / ALIGNMENT-GATE 模板 | [模板选择](../templates/README.md)，交付对齐合入原有交付记录 |

旧路径从本分支主线移出，依赖旧路径的项目在采纳本版本时需更新引用；继续使用旧规范的项目可固定上面的旧 commit，不自动切换。L1/L2/L3 仅保留为文档规模简称，FAST/STANDARD/CRITICAL 不再是通用核心协议。

## 历史内容

旧 [研究](https://github.com/YIMO691/Workflow-SOP/tree/60ccde7bb1c05b90cb55c5ec603f14366d27ae64/research)、[试运行](https://github.com/YIMO691/Workflow-SOP/tree/60ccde7bb1c05b90cb55c5ec603f14366d27ae64/pilots)、[Gate 模拟器与夹具](https://github.com/YIMO691/Workflow-SOP/tree/60ccde7bb1c05b90cb55c5ec603f14366d27ae64/tests/workflow-gate) 留在该 Git 基线，不在新主线重复存放归档副本。

本轮移除模拟 Gate 的代码与对固定字段/措辞的 CI 要求。现有 CI 只查文档；这不授权业务项目跳过自己的测试、安全、审查或发布规则。没有重写 Git 历史、删除上游仓库、发布标签或宣布公司正式制度生效。

需要恢复旧内容时，可以在独立检出中读取固定基线，或通过新的提交/PR 恢复选定文件；不使用 force push 改写共享历史。历史版本说明保留在 [CHANGELOG](../CHANGELOG.md)。
