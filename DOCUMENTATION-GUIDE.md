# Markdown 文档与 Client/Server 分端规范

## 1. 目标

文档用于留下代码无法可靠表达的意图、边界、关键决定、验证结论和交接信息。正式留痕统一使用 Markdown，并与对应任务、分支和 PR/MR 一起版本管理。

## 2. 最小书写规则

- 一个功能使用同一个 `FEAT/TASK-ID`；文件名稳定，标题表达内容。
- 开头只保留必要元数据：ID、状态、Owner、更新时间和关联任务/PR。
- 先写结论，再写原因；规则和 AC 使用可观察、可验证的句子。
- 只记录无法从代码、Schema、配置或测试中直接还原的信息；机械字段链接权威定义，不手工复制。
- 不用手工版本表代替 Git 历史。重大方案变化写 ADR，最终实施差异写当前等级的交付记录，L3 使用 DELIVERY。
- 不适用章节删除或写 `N/A：原因`，不得为了完整感填充无效内容。

## 3. Client/Server 的权威划分

PRD 保持一份，统一产品目标、业务规则和验收标准，不拆成 Client PRD 与 Server PRD。技术设计和验证按受影响端拆分：

| 内容 | 推荐位置 |
| --- | --- |
| 用户目标、完整业务流程、统一 AC | `PRD.md` 或 `SPEC.md` |
| 界面状态、输入、生命周期、本地数据、资源与端侧性能 | `CLIENT-SDD.md` 或 SPEC 的 Client 小节 |
| 领域规则、持久化、事务、并发、幂等、安全与可观测性 | `SERVER-SDD.md` 或 SPEC 的 Server 小节 |
| 请求/响应、错误码、版本与兼容 | Proto/OpenAPI/Schema 等可执行定义；两端 SDD 引用同一基线 |
| Client、Server、联调和端到端验证 | L1/L2：现有任务或 SPEC；L3：TEST-PLAN 与 DELIVERY 中的分端记录 |
| 最终交付与 Align 结论 | L1：任务/PR；L2：SPEC 或关联 PR；L3：一份 `DELIVERY.md` |

只影响一端时只创建该端 SDD。两端设计都很少时可使用一份 `SDD.md`，并在 `side` 标记为 `shared`；只有两端都存在独立复杂度时才拆为 `CLIENT-SDD.md` 与 `SERVER-SDD.md`。

## 4. 推荐目录

```text
docs/features/FEAT-XXXX/
├── README.md
├── PRD.md
├── CLIENT-SDD.md       # 按需
├── SERVER-SDD.md       # 按需
├── TEST-PLAN.md
├── DELIVERY.md
└── ADR/                # 重大决定才创建
```

L1 和 L2 不必建立上述目录；分别使用 TASK 和单份 SPEC 即可。

## 5. 清晰度自检

- 新人能否在几分钟内说清目标、范围、受影响端和下一步？
- Client 与 Server 是否引用同一个业务规则、AC 和契约基线？
- 文档是否写了“为什么”和约束，而不是逐行复述代码？
- 状态、结果和证据是否只有一个汇总位置？
- 改动最终行为后，PRD/SPEC、SDD、测试和 DELIVERY 是否已同步？
