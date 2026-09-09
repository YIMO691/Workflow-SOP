$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$markdownFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

$issues = [System.Collections.Generic.List[string]]::new()

foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName

    if ([string]::IsNullOrWhiteSpace($content)) {
        $issues.Add("Empty Markdown file: $($file.FullName)")
        continue
    }

    if ($content -notmatch '(?m)^# ') {
        $issues.Add("Missing H1 heading: $($file.FullName)")
    }

    $fenceCount = ([regex]::Matches($content, '(?m)^```')).Count
    if ($fenceCount % 2 -ne 0) {
        $issues.Add("Unmatched code fence: $($file.FullName)")
    }

    foreach ($match in [regex]::Matches($content, '\[[^\]]*\]\(([^)]+)\)')) {
        $link = $match.Groups[1].Value.Trim()
        if ($link -match '^(https?://|mailto:|#)') {
            continue
        }

        $linkPath = (($link -split '#', 2)[0]).Trim('<', '>')
        if (-not $linkPath) {
            continue
        }

        $candidate = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $linkPath))
        if (-not (Test-Path -LiteralPath $candidate)) {
            $issues.Add("Broken relative link: $($file.FullName) -> $link")
        }
    }
}

$requiredFiles = @(
    'README.md',
    'SOP.md',
    'TASK-LEVELS.md',
    'START-HERE.md',
    'AGENTS.md',
    'AI-PLAYBOOK.md',
    'DOCUMENTATION-GUIDE.md',
    'CODE-GUIDE.md',
    'AGENT-WORKSPACE.md',
    'templates/DELIVERY-CHECKLIST.md',
    'templates/DELIVERY.md',
    'templates/ALIGNMENT-GATE.md',
    'templates/FORMAL-FEATURE/README.md',
    'examples/L3-complex-feature/DELIVERY.md',
    'scripts/test-delivery-gates.ps1',
    'tests/workflow-gate/README.md',
    'prompts/NEW-TASK.md',
    'prompts/CONTINUE-TASK.md',
    'prompts/ALIGN-GATE.md',
    '.github/PULL_REQUEST_TEMPLATE.md'
)

foreach ($relativePath in $requiredFiles) {
    $candidate = Join-Path $repoRoot $relativePath
    if (-not (Test-Path -LiteralPath $candidate)) {
        $issues.Add("Missing required file: $relativePath")
    }
}

$agentsPath = Join-Path $repoRoot 'AGENTS.md'
if ((Test-Path -LiteralPath $agentsPath) -and (Get-Item -LiteralPath $agentsPath).Length -ge 32768) {
    $issues.Add('AGENTS.md exceeds the default 32 KiB project instruction limit.')
}

$sop = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'SOP.md')
if ($sop.IndexOf('## 8. Align') -lt 0 -or $sop.IndexOf('## 9. Done') -lt 0 -or
    $sop.IndexOf('## 8. Align') -gt $sop.IndexOf('## 9. Done')) {
    $issues.Add('SOP must place Align before Done.')
}

$alignPrompt = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'prompts/ALIGN-GATE.md')
if ($alignPrompt -notmatch '无法访问必要实现或测试证据') {
    $issues.Add('Align prompt must fail when executable evidence is unavailable.')
}

$formalTemplates = @(
    'templates/PRD.md',
    'templates/SDD.md',
    'templates/TEST-PLAN.md',
    'templates/DELIVERY.md'
)

foreach ($relativePath in $formalTemplates) {
    $content = Get-Content -Raw -LiteralPath (Join-Path $repoRoot $relativePath)
    if ($content -notmatch '\[必填\]') {
        $issues.Add("Formal template must mark required sections: $relativePath")
    }
}

$testPlan = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'templates/TEST-PLAN.md')
if ($testPlan -notmatch '实际执行结果统一写入 `DELIVERY\.md`') {
    $issues.Add('TEST-PLAN must route actual execution results to DELIVERY.md.')
}
if ($testPlan -notmatch '阻断发布' -or
    $testPlan -notmatch '# 8\. 测试准入、暂停/恢复与退出条件 \[必填\]') {
    $issues.Add('TEST-PLAN must identify blocking coverage and test entry/exit conditions.')
}

$prd = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'templates/PRD.md')
if ($prd -notmatch '# 6\. 质量与约束要求 \[条件必填\]' -or
    $prd -notmatch 'Confirmed/Assumed/Open/Blocked' -or
    $prd -notmatch '受影响端与跨端行为') {
    $issues.Add('PRD must cover measurable quality requirements and classify assumptions/open items.')
}

$sdd = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'templates/SDD.md')
if ($sdd -notmatch '设计驱动、约束与责任边界' -or
    $sdd -notmatch '权威 Owner 与读写边界') {
    $issues.Add('SDD must support design drivers and authoritative ownership boundaries.')
}

$delivery = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'templates/DELIVERY.md')
if ($delivery -notmatch '# 2\. 交付基线 \[必填\]' -or
    $delivery -notmatch '# 9\. Align Gate \[必填\]' -or
    $delivery -notmatch '# 10\. 最终交付决定 \[必填\]') {
    $issues.Add('DELIVERY must contain the required Align Gate and final delivery decision.')
}
if ($delivery -notmatch '实现状态：`未开始 / 实现中 / 已完成 / 阻断`' -or
    $delivery -notmatch '验证状态：`未执行 / 部分完成 / Pass / Fail / Blocked`' -or
    $delivery -notmatch '发布就绪：`未评估 / 可进入 QA / 可发布 / 阻断`') {
    $issues.Add('DELIVERY must keep implementation, verification, and release readiness separate.')
}

$formalEntry = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'templates/FORMAL-FEATURE/README.md')
if ($formalEntry -notmatch 'draft/review/approved/superseded' -or
    $formalEntry -notmatch '`status` 只描述文档生命周期') {
    $issues.Add('Formal feature package must define the document lifecycle status vocabulary.')
}

$taskLevels = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'TASK-LEVELS.md')
if ($taskLevels -notmatch '`DELIVERY\.md`：[^\r\n]*最终实现[^\r\n]*Align[^\r\n]*唯一汇总') {
    $issues.Add('L3 minimum artifacts must include DELIVERY.md.')
}

if ($taskLevels -notmatch 'FAST' -or $taskLevels -notmatch 'STANDARD' -or $taskLevels -notmatch 'CRITICAL') {
    $issues.Add('Task levels must define risk-based FAST, STANDARD, and CRITICAL verification profiles.')
}

$documentationGuide = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'DOCUMENTATION-GUIDE.md')
if ($documentationGuide -notmatch 'PRD 保持一份' -or $documentationGuide -notmatch 'CLIENT-SDD\.md' -or $documentationGuide -notmatch 'SERVER-SDD\.md') {
    $issues.Add('Documentation guide must keep one PRD and define Client/Server SDD usage.')
}

$codeGuide = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'CODE-GUIDE.md')
if ($codeGuide -notmatch '不强制每个方法都写 Big-O' -or $codeGuide -notmatch '外部调用次数') {
    $issues.Add('Code guide must avoid blanket complexity comments and cover I/O cost signals.')
}

$agentWorkspace = Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'AGENT-WORKSPACE.md')
if ($agentWorkspace -notmatch '00_CONTROL' -or $agentWorkspace -notmatch '30_EVIDENCE' -or $agentWorkspace -notmatch '_scratch') {
    $issues.Add('AgentWorkspace guide must separate control, evidence, and disposable scratch data.')
}

if ($issues.Count -gt 0) {
    $issues | ForEach-Object { Write-Error $_ }
    exit 1
}

$gateOutput = & (Join-Path $repoRoot 'scripts/test-delivery-gates.ps1')
$gateSucceeded = $?
$gateOutput | Write-Output
if (-not $gateSucceeded) {
    exit 1
}

Write-Output "Validated $($markdownFiles.Count) Markdown files."
Write-Output 'Required files, links, template contracts, Align invariants, and workflow gate regressions passed.'
