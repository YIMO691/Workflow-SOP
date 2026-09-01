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
    'templates/DELIVERY-CHECKLIST.md',
    'templates/ALIGNMENT-GATE.md',
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

if ($issues.Count -gt 0) {
    $issues | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Validated $($markdownFiles.Count) Markdown files."
Write-Output 'Required workflow files, relative links, instruction size, and Align invariants passed.'
