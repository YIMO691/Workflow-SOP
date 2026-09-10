# 来源、旧入口与历史基线

本轮以 Workflow-SOP 的既有内容为基础重新整理，保留工程质量经验，减少工具耦合和重复规则。它是改编后的公司试行工作方法，不宣称已验证全公司 ROI，也不引入新的运行系统。

## 固定来源

| 来源 | 使用内容与边界 |
|---|---|
| [Workflow-SOP 整理前基线](https://github.com/YIMO691/Workflow-SOP/tree/60ccde7bb1c05b90cb55c5ec603f14366d27ae64) | 原 SOP、代码/注释/分端规范、轻量记录和恢复经验；本轮不保留其固定 Gate 状态协议 |
| [Ares 流程讨论基线](https://github.com/YIMO691/ares-ai-engineering-harness/tree/f425027a31263cb4842c4c86f1d0448a8e89c2c3) | Context 来源、关键决策、直接协作、真实验证和模型自主原则；未导入 Web、CLI、数据库、Agent Framework 或 Change Lens 实现 |

来源仓库为私有，链接需要相应权限；本文件不扩大原内容的访问、复制或许可范围。本批按用户要求采用下列知识研究中的有限建议；知识库保留论证与证据边界，本 SOP 维护执行约定，其他研究与运行能力未自动接入。

## 2026-09-10 的学习采用

| 来源与固定位置 | 采用内容与限制 |
|---|---|
| [RR-025：规格澄清与变更](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-025_SPEC_CLARIFICATION_AND_CHANGE.md) | 事实/目标区分、当前增量的实施条件与变更影响；本 SOP 不引入 Ares 专属 Ready/Run 状态 |
| [RR-026：Superpowers](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-026_SUPERPOWERS_WORKFLOW.md) | 计划与规格冲突、完整任务审阅、恢复身份；局部辅助脚本观察不证明 Agent 运行失败 |
| [RR-027：需求技能与切片](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-027_REQUIREMENT_SKILLS_AND_SLICING.md) | 场景辨义、依赖提问、行为切片与迁移例外；静态分析和未执行教学例子，不是效率验证 |
| [RR-020：超时与验收](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-020_TIMEOUT_RECOVERY_AND_ACCEPTANCE.md) | 修正收藏示例中结果未知与明确失败的混淆；一次读取不能证明迟到写入不会发生 |
| [Superpowers 固定源](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/README.md) | v6.3.0；推荐子集、实读范围与差异见 [推荐卡](../skills/SUPERPOWERS.md) |
| [Matt Pocock 固定源](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/README.md) | 需求/领域建模、规格与切片、测试与审阅；见 [推荐卡](../skills/MATT_POCOCK.md) |
| [FlameMida 固定源](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/skills/requirement-analysis/SKILL.md) | 需求设计与现行条款；见 [推荐卡](../skills/REQUIREMENT_ANALYSIS.md)，目录介绍不替代正文 |

本批直接复核推荐涉及的固定原文及版本，以自写说明、模板提示与教学例子落地；没有整包复制技能、安装插件或运行业务。研究报告所在 PR 的纳入状态不改变本 SOP 的试行定位；公司适用性仍需实际采用反馈。原始许可证与第三方声明继续由各固定来源解释，不因推荐扩大再分发权限。

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
