param([Parameter(Mandatory)][string]$ScratchRoot)
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if (-not [IO.Path]::IsPathFullyQualified($ScratchRoot)) { throw 'ScratchRoot must be absolute.' }
$scratch = (Resolve-Path -LiteralPath $ScratchRoot).Path
$comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
if ($scratch.Equals($repoRoot, $comparison) -or $scratch.StartsWith($repoRoot + [IO.Path]::DirectorySeparatorChar, $comparison)) {
    throw 'ScratchRoot must be outside the repository.'
}
# Each run owns a new directory; fixtures never overwrite or delete caller files.
$runRoot = [IO.Path]::GetFullPath((Join-Path $scratch ('workflow-validator-' + [guid]::NewGuid().ToString('N'))))
[void](New-Item -ItemType Directory -Path $runRoot)
$validator = Join-Path $PSScriptRoot 'validate-workflow.ps1'
$pwsh = (Get-Process -Id $PID).Path
$entries = @('README.md','AGENTS.md','CONTRIBUTING.md','templates/SPEC.md','docs/WORKFLOW.md',
    'docs/ENGINEERING_RULES.md','docs/AI_COLLABORATION.md','docs/SOURCES.md','templates/README.md',
    'templates/PROJECT-RULES.md','templates/CLIENT.md','templates/SERVER.md','templates/VERIFICATION.md')

function Write-FixtureFile([string]$CaseRoot, [string]$RelativePath, [string]$Content) {
    $absolute = [IO.Path]::GetFullPath((Join-Path $CaseRoot $RelativePath))
    if (-not $absolute.StartsWith($runRoot + [IO.Path]::DirectorySeparatorChar, $comparison)) { throw 'Fixture escaped run directory.' }
    [void](New-Item -ItemType Directory -Path ([IO.Path]::GetDirectoryName($absolute)) -Force)
    [IO.File]::WriteAllText($absolute, $Content.Replace("`r`n", "`n"), [Text.UTF8Encoding]::new($false))
}

$validReadme = @'
# Package

[target](docs/WORKFLOW.md#中文-api)
[same page](#duplicate-1)
[collision](#duplicate-1-1)
[root relative](/docs/WORKFLOW.md#中文-api)
[encoded](docs/space%20name.md#%E4%B8%AD%E6%96%87)
[angle](<docs/space name.md#中文>)
[with title](docs/WORKFLOW.md#中文-api "description")
[emphasis](#helpful-section)
[identifier](#foo_bar)
[custom](#custom-id)

## Duplicate
## Duplicate
## Duplicate-1
## _Helpful_ **Section**
## `foo_bar`
<a name="custom-id"></a>

`[literal](missing.md#absent)` and ``[literal](missing.md)``
<!-- [comment](missing.md)
```text
-->
````markdown
# Not a heading
[literal](missing.md#absent)
```
````
~~~text
[literal](missing.md)
~~~
'@
$cases = @(
    @{ Name = 'valid'; Expected = 0; Files = @{ 'README.md' = $validReadme; 'docs/WORKFLOW.md' = "# Workflow`n`n## 中文 API ###`n"; 'docs/space name.md' = "# 中文`n" } },
    @{ Name = 'missing-client'; Expected = 1; Omit = 'templates/CLIENT.md'; Error = 'Missing current entry' },
    @{ Name = 'missing-server'; Expected = 1; Omit = 'templates/SERVER.md'; Error = 'Missing current entry' },
    @{ Name = 'missing-verification'; Expected = 1; Omit = 'templates/VERIFICATION.md'; Error = 'Missing current entry' },
    @{ Name = 'broken-file'; Expected = 1; Files = @{ 'README.md' = "# Package`n[bad](missing.md)`n" }; Error = 'Broken relative link' },
    @{ Name = 'broken-cross-anchor'; Expected = 1; Files = @{ 'README.md' = "# Package`n[bad](docs/WORKFLOW.md#absent)`n" }; Error = 'Broken Markdown anchor' },
    @{ Name = 'broken-self-anchor'; Expected = 1; Files = @{ 'README.md' = "# Package`n[bad](#absent)`n" }; Error = 'Broken Markdown anchor' },
    @{ Name = 'renamed-heading'; Expected = 1; Files = @{ 'README.md' = "# Package`n[old](docs/WORKFLOW.md#original)`n"; 'docs/WORKFLOW.md' = "# Workflow`n## Renamed`n" }; Error = 'Broken Markdown anchor' },
    @{ Name = 'nonexistent-duplicate'; Expected = 1; Files = @{ 'README.md' = "# Package`n## Repeat`n[bad](#repeat-1)`n" }; Error = 'Broken Markdown anchor' },
    @{ Name = 'empty-markdown'; Expected = 1; Files = @{ 'docs/WORKFLOW.md' = '' }; Error = 'Empty Markdown' },
    @{ Name = 'multiple-h1'; Expected = 1; Files = @{ 'README.md' = "# One`n# Two`n" }; Error = 'Expected one H1' },
    @{ Name = 'unclosed-fence'; Expected = 1; Files = @{ 'README.md' = '# Package' + "`n" + '```text' + "`n" }; Error = 'Unclosed code fence' }
)
$results = [System.Collections.Generic.List[object]]::new()
foreach ($case in $cases) {
    $caseRoot = [IO.Path]::GetFullPath((Join-Path $runRoot $case.Name))
    foreach ($entry in $entries) {
        if ($entry -eq $case.Omit) { continue }
        $content = "# Fixture`n"
        if ($case.Files -and $case.Files.ContainsKey($entry)) { $content = $case.Files[$entry] }
        Write-FixtureFile $caseRoot $entry $content
    }
    if ($case.Files) {
        foreach ($entry in $case.Files.Keys) {
            if ($entry -notin $entries) { Write-FixtureFile $caseRoot $entry $case.Files[$entry] }
        }
    }
    $output = (& $pwsh -NoProfile -File $validator -Root $caseRoot 2>&1 | Out-String)
    $actual = $LASTEXITCODE
    $passed = $actual -eq $case.Expected -and (-not $case.Error -or $output.Contains($case.Error))
    $results.Add(@{ case = $case.Name; expected = $case.Expected; actual = $actual; passed = $passed; output = $output.Trim() })
    Write-Output "$($case.Name): $(if ($passed) { 'PASS' } else { 'FAIL' })"
}
$report = [IO.Path]::GetFullPath((Join-Path $runRoot 'results.json'))
[IO.File]::WriteAllText($report, ($results | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))
Write-Output "Regression evidence: $report"
if (@($results | Where-Object { -not $_.passed }).Count) { exit 1 }
Write-Output "Passed $($results.Count) validator regression cases."
# Expected failures leave LASTEXITCODE=1; CI dot-sourcing must receive the suite result.
exit 0
