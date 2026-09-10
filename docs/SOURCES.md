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

## 文档实践的定向核对

访问日期：2026-09-10。问题是现有 PRD/SDD 是否覆盖可验收需求、关键运行/部署场景和文档维护，而非寻找名称更新的一整套文件。以下是本 SOP 的直接资料核对与裁剪，不代表实证效果比较。

| 一手来源与版本 | 实际阅读范围、采用与限制 |
|---|---|
| [ISO/IEC/IEEE 29148:2018](https://www.iso.org/standard/72089.html) | 公开摘要与版本/生命周期信息：需求工程过程和信息项的范围；未读付费全文，不据此复制条款或宣称符合标准。页面仍列 2018 已发布版，并列 DIS 修订在研，草案不当现行要求 |
| [ISO/IEC/IEEE 42010:2022](https://www.iso.org/standard/74393.html) | 公开摘要与第二版信息：架构描述及其组织；摘要明确不规定开发方法、工具或文档介质，不能用它证明必须提交名为 SDD 的文件。未读全文 |
| [ISO/IEC/IEEE 29119-3:2021](https://www.iso.org/standard/79429.html) | 公开摘要与第二版信息：测试文档的范围；本轮未读其具体模板，不宣称本 TEST-PLAN 完整实现该标准 |
| [arc42 overview](https://arc42.org/overview/) 与 [质量要求说明](https://docs.arc42.org/section-10/) | 网页无固定版号；实读章节总览及第 10 节的质量场景说明。选取边界、运行、部署、质量、风险提示，以条件、刺激、响应和度量澄清验收；另读 [运行视图](https://docs.arc42.org/section-6/) 与 [部署视图](https://docs.arc42.org/section-7/) 的 Content/Form，分别采用代表性运行步骤与运行单元到设施的映射；未套用完整模板或验证架构质量 |
| [C4 diagrams](https://c4model.com/diagrams) 与 [Container 定义](https://c4model.com/abstractions/container) | 实读四层静态视图及辅助视图的选择说明、Container 定义与运行边界；来源说明无需用全四层。补读 [容器视图](https://c4model.com/diagrams/container) 与 [图形记法](https://c4model.com/diagrams/notation)，自绘导出系统的两张教学图，标明边界、类型、方向与未知技术；未盘点真实项目或评价绘图工具 |
| [MADR 4.0.0 模板](https://github.com/adr/madr/blob/4.0.0/template/adr-template.md) | 实读该版本完整模板，参考状态、背景、方案、后果与 confirmation 的内容；大部分元信息在原模板也可选，本 SOP 未导入 YAML 字段或多人审批表 |
| [Martin Fowler：Test Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html)（2023-12-11） | 实读方法说明与测试列表/失败测试—实现—重构循环，用于区分开发方法和文档名称；不是 TDD 对所有任务效率更高的证据 |
| [OpenAPI 3.2.0](https://spec.openapis.org/oas/v3.2.0.html)（2025-09-19） | 只读版本、What is the OpenAPI Specification 与文档状态；支持 HTTP 接口机器可读描述这一用途。未审计全部规范，不要求现有项目升级工具链或声称契约测试已通过 |

由这些来源推得的本地建议是保留最小充分载体，补强内容及关系；这不是来源机构对本 SOP 的认可。后续项目出现漏验收、设计无法恢复、文档冲突，或相关来源正式更新且影响现用建议时，回到对应模板和条款修订；仅有新版本号不自动更换整套文档。

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
