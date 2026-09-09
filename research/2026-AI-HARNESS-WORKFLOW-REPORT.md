# 2026 AI Harness 与轻量研发工作流研究报告

- 调研日期：2026-09-05
- 面向对象：希望把 AI 纳入日常研发、但不希望引入重型流程的团队
- 基于版本：Workflow-SOP `v0.5-draft`
- 说明：本文将 AEH 理解为 Agentic Engineering Harness 类项目；借鉴其原则，不复制其完整组织结构。

## 1. 结论

现有 Workflow-SOP 的方向是正确的，并非为了写文档而写文档。它已经具备轻量工作流最重要的骨架：任务分级、Ready/Build/Loop/Align、按风险选择文档、证据型 Gate、分层权威和负向回归。

下一步不应继续增加 PRD、SDD 或评审表，而应从“文档工作流”补齐为“轻量 Harness”：

1. 用短入口和渐进披露帮助 AI 找到权威信息。
2. 用可执行检查替代只能依赖记忆的规则。
3. 用小步实现、快速反馈和可恢复检查点支撑长任务。
4. 用权限边界限制损害半径，而不是依赖频繁人工点击。
5. 用真实失败和回归用例推动流程演进，不凭感觉扩充规范。

推荐保持现有主流程，只增加三项能力：每个项目明确 `Fast Check` 与 `Full Gate`、长任务在现有任务文档中保留一个六字段检查点、每次 Harness 规则变化必须绑定失败案例与验证结果。不建议默认引入多 Agent 编排、向量记忆、复杂 DAG、独立状态数据库或全量轨迹归档。

## 2. 最新研究形成的共识

### 2.1 Harness 不是提示词集合

2026 年的共识逐渐从“优化 Prompt”转向“优化模型周围的运行环境”。OpenAI 将有效工程能力归因于仓库知识、工具、架构约束和反馈环；AHE 研究也发现，性能收益主要来自工具、中间件和长期记忆，而不是系统提示词本身。AHE 在 Terminal-Bench 2 上将 pass@1 从 69.7% 提升到 77.0%，但这是特定基准实验，不能直接等价为企业项目收益。[OpenAI Harness Engineering](https://openai.com/index/harness-engineering/)，[AHE 论文](https://arxiv.org/abs/2604.25850)

对本工作流的含义：`AGENTS.md` 和模板只能提供方向；构建、测试、静态分析、结构约束、权限控制和可复现证据才负责建立信任。

### 2.2 给 AI 地图，不给百科全书

OpenAI 报告其大型 `AGENTS.md` 方案会挤占上下文、快速腐化并难以验证，后来改为约 100 行的入口文件，加上结构化仓库文档和机械校验。开放的 AGENTS.md 规范也支持目录就近覆盖，让子项目只声明自己的差异。[OpenAI Harness Engineering](https://openai.com/index/harness-engineering/)，[AGENTS.md 开放规范](https://agents.md/)

对本工作流的含义：继续保持 `AGENTS.md` 短小，只写边界、权威入口、准确命令和禁止事项；详细流程放在 SOP/AI-PLAYBOOK，领域差异放在更近的目录，不复制全局内容。

### 2.3 指南与传感器必须成对存在

Thoughtworks 将用户侧 Harness 分为事前的 Guides 和事后的 Sensors；后者又应优先使用确定、快速的测试、类型检查和静态分析，再按需使用 AI 评审等概率性判断。只写指南会变成“规则存在但没人知道是否生效”，只做检查则会让 AI 重复踩坑。[Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html)

对本工作流的含义：每一条重要规范至少回答两个问题：AI 在行动前从哪里知道它，以及行动后由什么检查发现违反。无法自动化的语义规则才交给人工或独立 AI 评审。

### 2.4 长任务靠小步、检查点和干净状态

Anthropic 的长任务实践显示，仅依赖上下文压缩仍会丢失方向；更稳定的方法是一次处理一个功能、在会话切换前留下结构化状态、从版本历史恢复，并在继续开发前验证基础功能。其后续研究还发现，同一 Agent 容易高估自己的产出，因此在复杂或主观任务中将生成与评价分开更可靠。[Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)，[Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps)

对本工作流的含义：不需要默认新增 `progress.txt`。任务跨会话时，在现有 TASK/SPEC/DELIVERY 或任务系统中维护一个小型检查点即可；高风险或主观结果才需要独立评价上下文。

### 2.5 验证对象是整个执行结果

Agent Eval 不只是判断最终回答，还要给 Agent 真实任务、工具和环境，再用测试或评分器检查其对环境造成的最终变化。GitHub Spec Kit 的 `Spec → Plan → Tasks → Implement` 也说明规格价值在于持续驱动和检查实现，而不是生成后归档。[Anthropic Agent Evals](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)，[GitHub Spec Kit](https://github.github.com/spec-kit/)

对本工作流的含义：Align 应检查同一提交、构建、配置和测试环境上的最终行为；文档完整度不能替代可运行结果。

### 2.6 自主性必须服从损害半径

Anthropic 的权限研究显示，频繁弹窗会造成批准疲劳；更可靠的路线是安全操作默认放行、工作区内修改可追踪、跨边界或不可逆操作升级，并使用沙箱、网络限制和最小权限形成环境级约束。概率性分类器只能是纵深防御的一层。[Claude Code Auto Mode](https://www.anthropic.com/engineering/claude-code-auto-mode)，[How we contain Claude](https://www.anthropic.com/engineering/how-we-contain-claude)

对本工作流的含义：权限规则应按真实影响分级，而不是要求所有工具调用都审批；生产写入、凭据、外部发布、批量删除和不可逆迁移始终需要明确授权。

### 2.7 Harness 应通过证据演进

AHE 提出组件、经验和决策三类可观测性：知道改了哪个 Harness 部件、从失败轨迹中提炼可消费的经验、为每次修改声明可被后续结果证伪的预测。AEH 同样强调从仓库事实出发，选择与成熟度匹配的最小拓扑，并要求每个新产物说明问题、Owner、消费者和最小验证。[AHE 论文](https://arxiv.org/abs/2604.25850)，[AEH Scaffold Harness](https://github.com/ldaume/agentic-engineering-harness/blob/main/skills/engineering/scaffold-harness/SKILL.md)

对本工作流的含义：可以采用“人工治理的微演进”，但不要让 Agent 自动修改正式规则并直接生效。

### 2.8 AI 是放大器，不自动等于生产力

DORA 2025 将 AI 描述为组织能力的放大器：强工程系统会被增强，薄弱基础也会被放大。METR 在早期 2025 的成熟开源项目实验中观察到资深开发者使用当时 AI 工具反而慢 19%，到 2026 年其后续材料认为新一代工具的收益可能已经转正，但仍强调测量存在明显限制。[DORA 2025](https://dora.dev/research/2025/dora-report/)，[METR 2025 RCT](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)，[METR 2026 更新](https://metr.org/blog/2026-02-24-uplift-update/)

对本工作流的含义：不要用生成代码量、Prompt 数或 AI 使用率证明价值；应观察交付时间、返工、缺陷、评审负担和恢复成本。

## 3. 对当前 Workflow-SOP 的判断

### 应保留

- L1/L2/L3 分级，避免普通任务被完整模板拖重。
- `Ready → 条件 Build → Loop → Align → Done`，阶段少且能够回退。
- PRD/SDD/TEST-PLAN/DELIVERY 的分层权威及按条件填写。
- TDD 作为实现方法，不额外制造 TDD 报告。
- DELIVERY 绑定实际提交、构建、配置和测试环境。
- Hard Gate 需要可复现证据或独立评审。
- Gate 正反例夹具和“真实失败才能增加强制项”的演进原则。

### 当前缺口

1. 工作流已经明确“要验证”，但宿主项目如何声明快速检查与完整检查还不够标准化。
2. `CONTINUE-TASK` 是好的提示词，但长任务状态尚未形成稳定、可被下一次会话直接读取的最小记录格式。
3. 权限边界存在原则，尚缺一张足够简短的风险—动作矩阵供不同 AI 工具共同使用。
4. 流程优化已经要求证据，但还可以明确“假设—试运行—保留/回退”的小闭环。
5. 目前主要验证模板结构；真正落到业务仓库后，还需要把项目的架构边界、测试和构建命令转成 Sensors。

这些缺口不要求增加新的正式阶段，也不需要把现有流程升级成完整 AEH。

## 4. 推荐的轻量 Harness 工作流

```text
仓库 Bootstrap（每个项目一次）
        ↓
Intake / Ready
        ↓
Plan / Build（仅中高风险）
        ↓
最小行为 Loop：实现 → Fast Check → 修正
        ↓
Review / Full Gate
        ↓
Align / Done
        ↓
Learn（只有真实失败或重复摩擦才改 Harness）
```

### 4.1 Bootstrap：让项目可被理解和验证

每个业务仓库最低只要求：

- 一个短 `AGENTS.md`：边界、权威入口、Fast Check、Full Gate、禁止动作。
- 一个给人的 README：如何运行、测试和定位领域文档。
- 可执行的构建/测试/静态检查命令。
- 已有的需求、设计、代码、Schema 和测试作为本地权威，不另建平行知识库。

单仓库默认不建立中央协调器、记忆服务或多 Agent 调度层。

### 4.2 Ready：人决定意图，AI 消除可发现的不确定性

AI 先检查工程，再输出目标、非目标、AC、事实、假设、Open/Blocked、任务等级和命中的影响面。只有会改变产品意图、风险接受或验收结果的问题交还给人。

Ready Gate：`Blocked = 0`，核心 AC 可观察，AI 的写入与验证范围已明确。

### 4.3 Build：先定义验证契约，再讨论实现细节

只对公共契约、持久化、跨系统、安全、迁移或难回滚任务启用。SDD 说明关键边界，TEST-PLAN 指定阻断项和验证方式。能由 Schema、类型、测试或静态分析表达的约束不重复写成长篇规则。

Build Gate：关键风险有设计响应；阻断级 AC 有验证入口；不可逆动作有回滚或恢复路径。

### 4.4 Loop：一次只交付一个可验证行为

每个增量遵循：

```text
选择 AC/风险 → 建立失败证据 → 最小实现 → Fast Check → 重构 → 更新任务状态
```

严格 TDD 仍按适用性选择，但缺陷修复、核心规则、数据转换和稳定接口优先先写失败测试。AI 不得通过删除测试、放宽断言或改写 AC 获得绿色结果。

### 4.5 Review 与 Gate：快慢分层

| 层级 | 典型内容 | 运行时点 | 结论强度 |
| --- | --- | --- | --- |
| Fast Check | 编译、格式、lint、类型检查、相关单测 | 每个增量后 | 快速反馈，不代表可交付 |
| Full Gate | 全量测试、集成/E2E、迁移/回滚、安全与结构检查 | 合并或交付前 | 支持 Align/交付结论 |
| Semantic Review | 需求偏移、设计合理性、主观质量、未知风险 | 中高风险按需 | 人或独立评价上下文 |

确定性检查优先。只有机器难以表达的问题才使用 AI Judge；同一执行 Agent 的自评只能发现问题，不能单独证明高风险任务通过。

### 4.6 Align / Done：只汇总必要证据

继续使用 DELIVERY 作为 L3 唯一汇总。L1/L2 保留 PR/MR 中的短检查表。Align 只回答：交付了什么、基于哪个版本、哪些 AC 已通过、有什么偏移和遗留、能否合并/测试/发布。

不保存完整对话、思维链或重复日志；只保存命令、结果摘要和可定位证据。

### 4.7 Learn：人工治理的 Harness 微演进

```text
真实失败/重复摩擦
→ 提炼一个可复现案例
→ 声明最小修改及预期改善
→ 增加回归夹具或观察指标
→ 在 3～5 个同类任务试运行
→ 保留、调整或回退
```

优先级应是：测试/静态检查/工具约束，其次是简短规则，最后才是新增模板或审批。原始轨迹仅在定位失败时临时使用，沉淀的是复现案例和结论，不是海量聊天记录。

## 5. AI 使用约定

### 开始任务

1. 读取最近的 `AGENTS.md` 和当前任务权威文档。
2. 检查代码、配置、Schema、测试和版本状态。
3. 区分事实、假设、Open 和 Blocked。
4. 给出等级、当前 Gate、最小产物、AC、风险和下一增量。

### 执行任务

1. 一次处理一个可验证行为。
2. 每个增量运行 Fast Check；失败先诊断再修复。
3. 行为或设计偏移立即更新权威来源，不等最后补文档。
4. 连续失败时回到假设或设计，不无限重试同一路径。

### 完成任务

1. 运行 Full Gate，并记录实际命令、环境、版本和结果。
2. 对齐需求、设计、契约、代码和验证证据。
3. 清理临时代码、调试入口和无效文档。
4. 明确 Pass、Fail 或 Blocked；无证据不得宣布 Done。

### 权限与自主性

| 风险 | AI 默认行为 | 人的控制点 |
| --- | --- | --- |
| 只读检查、项目内可恢复修改 | 可自主执行 | 通过 diff 和测试复核 |
| 安装依赖、网络访问、外部服务读操作 | 按项目授权执行 | 限定来源、凭据和范围 |
| 外部写入、共享资源、发布与迁移 | 默认暂停 | 明确目标、环境和回滚后授权 |
| 生产数据、凭据导出、批量删除、不可逆操作 | 不得自行执行 | 必须由授权人确认并使用环境级防护 |

项目级沙箱、只读凭据和最小权限优先于“请小心”类 Prompt。

### 长任务最小检查点

跨会话或换人时，在现有任务系统、SPEC 或 DELIVERY 中追加以下六项，不默认创建新文件：

```text
目标与当前 Gate：
已完成且可验证的行为：
当前提交/构建/配置基线：
最后通过与失败的检查：
Open/Blocked：
下一最小动作：
```

## 6. 从 AEH 借什么，不借什么

### 建议借鉴

- 成熟度适配：只建设当前仓库真正缺少的能力。
- 仓库事实优先：不覆盖本地命名和现有权威来源。
- Fast Check / Full Gate：把反馈按成本和结论强度分层。
- 条件产物：计划、ADR、记忆和专门评审在出现对应风险时才建立。
- 规则的 Owner、消费者和最小验证：避免无人维护的规范。
- 长期学习：把重复错误转成检查、工具或精简规则。

### 暂不建议引入

- 默认多 Agent 团队、Supervisor、DAG 和角色矩阵。
- 每个阶段单独创建状态文件、记忆文件和审计日志。
- 向量数据库或全量 RAG；最新的多 Harness 源码研究甚至发现其样本中的主流 Coding Harness 仍主要依靠确定性检索，而非向量代码检索。该结论来自 2026 年新近 arXiv 源码研究，仍需更多复现。[Harness Engineering 源码研究](https://arxiv.org/abs/2609.00006)
- 自动把 Agent 经验升级为正式公司政策。
- 全量保存轨迹、Prompt 和中间思考。
- 为所有任务设置独立 AI Reviewer；只对高风险、主观或确定性测试不足的任务使用。

## 7. 建议的 v0.6 优化范围

建议下一版只做以下四项，不扩充正式文档数量：

1. 在项目接入说明中增加 `Fast Check`、`Full Gate` 和禁止动作三个占位项。
2. 把六字段长任务检查点合并进 `CONTINUE-TASK` 和 AI-PLAYBOOK。
3. 在 AI-PLAYBOOK 增加简短权限—风险矩阵，明确项目内修改、外部写入和不可逆操作边界。
4. 把流程反馈升级为“失败案例—修改假设—回归夹具—试运行结果”的微演进闭环。

后续只有出现证据时才考虑：项目级架构适应度测试、独立 AI Reviewer、定期文档漂移扫描或轨迹分析。

## 8. 如何判断这套流程有没有价值

按团队或迭代汇总即可，不要求每个任务新增报表：

- 从 Ready 到合并/交付的实际时间。
- 评审后返工次数和有效评审发现数。
- 逃逸缺陷、回滚和需求偏移数量。
- Fast Check/Full Gate 的耗时、误报和真实拦截数。
- 中断后恢复到可工作状态所需时间。
- AI 参与任务相对同类任务的总人力时间，而不是代码产量。

若某项模板或 Gate 连续多个周期没有参与任何决策、没有发现问题、也没有缩短交接，应删除或降为条件项。

## 9. 最终建议

Workflow-SOP 不需要变成一个新的 AI 平台。它应保持为团队与各种 AI 工具共享的“最小工程协议”：人负责意图、风险接受和最终责任；AI 负责探索、实现、运行检查和整理证据；Harness 负责把权威上下文、权限边界和反馈信号稳定地连接起来。

现阶段最有价值的投资不是更多文档，而是让每个接入项目都能回答三个问题：AI 去哪里找真相、改完后运行什么检查、什么动作必须停下来交还给人。

## 参考资料

- [OpenAI：Harness engineering: leveraging Codex in an agent-first world，2026-02-11](https://openai.com/index/harness-engineering/)
- [Anthropic：Effective harnesses for long-running agents，2025-11-26](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Anthropic：Demystifying evals for AI agents，2026-01-09](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents)
- [Anthropic：Harness design for long-running application development，2026-03-24](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- [Anthropic：How we built Claude Code auto mode，2026-03-25](https://www.anthropic.com/engineering/claude-code-auto-mode)
- [Thoughtworks/Martin Fowler：Harness engineering for coding agent users，2026-04-02](https://martinfowler.com/articles/harness-engineering.html)
- [AHE：Observability-Driven Automatic Evolution of Coding-Agent Harnesses，arXiv v4，2026-05-18](https://arxiv.org/abs/2604.25850)
- [AI Harness Engineering: A Runtime Substrate，arXiv，2026-05](https://arxiv.org/abs/2605.13357)
- [Harness Engineering: Anatomy, Architecture, and Evolution，arXiv，2026-09](https://arxiv.org/abs/2609.00006)
- [GitHub Spec Kit 文档，更新于 2026-08](https://github.github.com/spec-kit/)
- [AGENTS.md 开放规范](https://agents.md/)
- [DORA：State of AI-assisted Software Development 2025](https://dora.dev/research/2025/dora-report/)
- [METR：Early-2025 AI and experienced developer productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
- [Agentic Engineering Harness](https://github.com/drjoeshepherd/agentic-engineering-harness)
