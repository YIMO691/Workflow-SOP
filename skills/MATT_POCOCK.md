# Matt Pocock：澄清、领域建模与行为切片

推荐方式：按问题选用方法。固定提交 `3cca18b368ae95cdbdebbff572ccafa662551015`（2026-09-04），2026-09-10 核对 main 未变。官方 [README](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/README.md)、[许可证](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/LICENSE)；没有整体安装或在业务项目中验证效果。

## 名称与选择

这里常说的“grillwithme”对应的正式入口是 **grill-me** 或 **grill-with-docs**：前者调用可复用访谈纪律 grilling，后者还组合 domain-modeling。它们不是同名的两个安装包。

| 固定技能 | 适用问题 | 带回现有任务的结果 |
|---|---|---|
| [grill-me](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/productivity/grill-me/SKILL.md) / [grilling](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/productivity/grilling/SKILL.md) | 有关键取舍，需要把想法问清 | 目标、决定、剩余依赖；事实由执行者先查 |
| [grill-with-docs](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/grill-with-docs/SKILL.md) / [domain-modeling](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/domain-modeling/SKILL.md) | 同一业务词在需求和代码里含义不同 | 用具体场景厘清术语，少量真正重要的决定留理由 |
| [to-spec](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/to-spec/SKILL.md) | 对话已有共识，需要合成规格 | 业务目标、范围、设计与测试选择；无需再次访谈 |
| [to-tickets](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/to-tickets/SKILL.md) | 规格清楚，但任务只按技术层分组 | 端到端行为切片、验收与真实依赖；广泛迁移可用扩展/迁移/收缩 |
| [tdd](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/tdd/SKILL.md) / [code-review](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/code-review/SKILL.md) | 测试易碎，或代码规范与规格符合性混在一起 | 可观察接口的行为检查、有独立依据的预期，以及分清两类问题的审阅意见 |
| [wayfinder](https://github.com/mattpocock/skills/blob/3cca18b368ae95cdbdebbff572ccafa662551015/skills/engineering/wayfinder/SKILL.md) | 工作跨多个会话，当前连路线都不清楚 | 依赖决定与剩余问题的索引；已有路线图就复用 |

初次只需理解前两行；需求清楚后再按需要选拆分或验证方法。没有必要把全部技能串成强制链。

## 与本 SOP 的差异

当前 grilling 会把前提已明确的问题按轮组织，不能用旧印象概括为永远一次一题。本 SOP 的停止条件与提问取舍集中在 [需求澄清](../docs/WORKFLOW.md#用场景澄清再决定是否继续提问)，不要求穷尽所有未来产品分支。

原版 to-spec 会发布到配置的任务跟踪系统，并仍要求确认测试接口；to-tickets 也有任务发布与审批约定。采用本卡时，结果回现有 SPEC/任务；不会因此自动新建 Issue、标签或外部发布。原版 domain-modeling 有 CONTEXT.md / ADR 的具体布局，本项目已有等价资料时引用即可。

tdd 的测试接口与重构节奏、code-review 的并行角色是作者的组织选择，本 SOP 按风险选验证。特别要核对待审版本：原版 code-review 使用已提交 HEAD 的差异，不能假定它覆盖未提交工作；评审范围见 [工程规则](../docs/ENGINEERING_RULES.md#评审与清理)。不引入默认每任务两个代理的制度。

## 阅读与证据边界

需求、领域建模、规格、切片、实施与审阅范围见 [RR-027](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-027_REQUIREMENT_SKILLS_AND_SLICING.md)。原文可证明这些方法怎样要求 Agent 工作，不能证明执行遵从率或生产效率。`in-progress` 中的 loop-me 等实验条目没有纳入当前推荐链。

后续复查访谈轮次、规格交接、切片/兼容例外及未提交改动审阅；新名字或更多技能不自动成为新工作阶段。[返回技能选择](README.md)。
