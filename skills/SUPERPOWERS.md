# Superpowers：计划、排查与完成依据

推荐方式：选取相关方法，整套自动流程需项目另行适配。读取基线为 v6.3.0 / `b36e0829c6d0140e93cfef2ca599b1b07d4a7797`（2026-08-12），2026-09-10 核对 main 仍为此提交。官方 [README](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/README.md)、[许可证](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/LICENSE)；本卡不复制或分发上游技能正文。

## 推荐的部分

| 技能与固定原文 | 何时有帮助 | 输入与期望产物 |
|---|---|---|
| [brainstorming](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/skills/brainstorming/SKILL.md) | 需要区分可行性探索、已有流程的小改动和新设计 | 问题、现状、范围 → 必要设计与选择理由 |
| [writing-plans](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/skills/writing-plans/SKILL.md) | 任务之间有接口依赖，执行者缺必要上下文 | 当前规格与工程事实 → 增量、全局约束、接口与验证安排 |
| [systematic-debugging](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/skills/systematic-debugging/SKILL.md) | 症状不稳定或多次猜测修补无效 | 症状、可重现条件、实际错误 → 能区分原因的检查与修复 |
| [verification-before-completion](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/skills/verification-before-completion/SKILL.md) | 准备声称修复或交付，需要核对依据 | 当前改动与 AC → 实际结果、适用版本与缺口 |

例如收藏刷新后状态不对，先用排查方法定位请求、持久化、读取与迟到响应，再按本项目测试/评审要求修复。不要因选择了排查技能就重新访谈整个功能。输入可能含敏感信息时只提供允许披露的最小事实。

## 与本 SOP 的差异

- 源技能有较强的设计批准、完整代码计划、TDD 和流程要求；本 SOP 的文档与实施条件以 [完整流程](../docs/WORKFLOW.md) 为准。计划只是实现依据，仍需核对当前规格。
- 完成技能要求在当前消息重新执行验证；本 SOP 按源码、环境与影响范围判断证据适用性。借鉴它的证据核对方法，不把已适用的检查机械重跑一遍。
- subagent-driven-development 的 SDD 指子代理驱动开发；不等于规格驱动开发，也不同于设计文档 SDD。它的固定返工上限不能替代验收缺口处理，本卡不推荐把完整子代理编排设成默认。
- 阅读中发现诊断示例可能输出环境变量值，不能直接照抄成只检查配置状态。恢复辅助目录按计划文件名派生的隔离也有边界，恢复时按 [AI 协作](../docs/AI_COLLABORATION.md#中断与交接) 核对实际身份。

## 阅读与证据边界

已读相关工作流技能、维护 PR 和辅助脚本的范围见 [RR-026](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-026_SUPERPOWERS_WORKFLOW.md)。知识研究曾局部执行目录 helper，确认不同路径同名计划共用目录；没有运行 Agent，不能推断产品一定误读任务。此 SOP 采用没有新增外部运行或收益测试。

后续复查发布版的设计门槛、任务审阅、恢复身份及完成证据规则；未发布 dev 差异不自动作为本卡当前行为。[返回技能选择](README.md)。
