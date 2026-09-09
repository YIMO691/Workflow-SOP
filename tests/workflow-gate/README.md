# Workflow Gate 回归夹具

这些 JSON 夹具验证交付状态之间的关键一致性，而不是评判文档写作质量。它们用于防止以下 false-green：

- Align 为 Fail 却声明可交付。
- 阻断级 AC 未通过却声明 Align Pass。
- 没有任何阻断级 AC 结果却声明可交付。
- 未记录交付基线却声明可合并、进入 QA 或发布。
- 实现、验证或发布就绪状态与最终决定矛盾。

运行：

```powershell
pwsh ./scripts/test-delivery-gates.ps1
```

新增 Gate 规则时必须同时提供能够通过的基准和应被拒绝的夹具。普通业务内容仍由相关人员和实际证据评审，脚本不能替代语义审查。
