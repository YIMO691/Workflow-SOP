# spec-dev：复杂需求设计的参考

推荐方式：有设计空间的跨模块需求可参考其分析方法，整套插件不是本 SOP 默认配置。固定 v8.1.0 / `095eb40b94aceea7322332c5b00903776cdabd01`（2026-08-27），2026-09-10 核对 main 未变。

入口来自 [Smithery requirement-analysis](https://smithery.ai/skills/FlameMida/requirement-analysis)，正文依据固定的 [requirement-analysis](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/skills/requirement-analysis/SKILL.md)。目录简介曾描述九阶段实施，当前正文的需求设计是八步并交接 writing-plans，不能只看目录简介决定采用方式。

## 什么时候有帮助

需求涉及多模块、既有契约与方案取舍时，先核对项目事实，再比较不同方案能交付什么，最后用具体行为场景写出验收。需要输入原始需求、已确认范围、当前契约与可访问的工程事实；产物是现有 SPEC 中的方案理由、关键场景与仍待决定事项。

特别值得参考：区分探索与承诺交付、事实先查、术语以场景澄清、旧规格的取代与保留关系、每条行为怎样被实际观察。明确的小修不必因此进入完整设计管线。

## 与本 SOP 的差异

- 原版逐题澄清并有多道方案/设计/规格确认；本 SOP 的实际授权、问题依赖与开始条件以 [WORKFLOW](../docs/WORKFLOW.md) 为准。已有决定继续使用。
- 原版包含指定代理数量、目录、每计划固定分文件、进度表与守卫；本 SOP 复用原生工具和既有任务记录，不因为参考需求方法自动引入这些配置。
- [设计原则](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/skills/writing-plans/references/design-principles.md) 倾向不留兼容垫片，但保留产品/部署规则中的当前合同。实际旧端与迁移按 [工程规则](../docs/ENGINEERING_RULES.md#设计契约与分端协作) 决定，不能截取一句“不兼容”忽略线上消费者。
- [漂移守卫](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/guardrail/check-spec-drift.mjs) 的同改文件判断不证明行为一致；[eval 定义](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/skills/requirement-analysis/evals/evals.json) 也不是已执行结果。此处不安装守卫或按模板生成通过记录。

## 阅读与证据边界

已读需求入口、澄清、规格场景、计划与执行的相关部分，及守卫主流程与 eval 输入/期望，详见 [RR-027](https://github.com/YIMO691/ares-ai-software-engineering/blob/86d9dd6cc30c3378b2fc1614a0031197d8f223f5/03_REFERENCE_RESEARCH/09_CROSS_RESEARCH/RR-027_REQUIREMENT_SKILLS_AND_SLICING.md)。没有运行插件、守卫或模型评估。主 [LICENSE](https://github.com/FlameMida/spec-dev/blob/095eb40b94aceea7322332c5b00903776cdabd01/LICENSE) 为 MIT，并含第三方声明；本卡仅保留来源链接与自写摘要。

后续复查小修分流、确认/交接、规格取代和守卫边界；只调整受影响的采用建议。[返回技能选择](README.md)。
