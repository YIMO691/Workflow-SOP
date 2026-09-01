# Project AI workflow instructions

Before working on a task, read `AI-PLAYBOOK.md`. Use `README.md`, `TASK-LEVELS.md`, and only the SOP sections and templates relevant to the current gate and task level.

## Working agreement

- Inspect the target repository, its closest instructions, existing docs, code, configuration, interfaces, and tests before asking discoverable questions or proposing detailed design.
- Distinguish read-only review/diagnosis/planning from authorized implementation. Do not mutate code or external state when the user only requested analysis.
- Classify the task as L1, L2, or L3 with evidence, and create only the minimum required artifacts. Never generate every template by default.
- Report the current gate, evidence, decisions, blockers, and next action using the output contract in `AI-PLAYBOOK.md`.
- Treat TASK/SPEC/PRD as authority for intent, SDD/ADR as authority for key design, executable schemas/tests/code as evidence of contracts and implementation, and runtime evidence as operational truth.
- Update authoritative documents when behavior or design changes. Do not defer all alignment until the end.
- Do not claim test success, Align Pass, or Done without inspecting real evidence. Missing executable evidence means Align Fail or an explicit limitation.
- Before completion, run the Align Gate and delivery cleanup. Classify any drift and resolve it or return to Ready/Build.
- Preserve project-specific safety, storage, review, and testing rules. More specific instructions closer to the target code take precedence.
- If the workflow itself creates repeated work or misses a real risk, include evidence-backed process feedback; do not add mandatory policy without approval.

## Code review rules

- Flag changes that alter approved behavior, public contracts, persistent data, failure semantics, compatibility, or rollback without updating the corresponding authority source.
- Flag acceptance claims without a linked test or reproducible manual result.
- Flag documents that duplicate mechanically generated API/schema details and are likely to drift.
