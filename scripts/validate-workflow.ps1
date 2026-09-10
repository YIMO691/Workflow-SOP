param([string]$Root = (Join-Path $PSScriptRoot '..'))
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path -LiteralPath $Root).Path
$issues = [System.Collections.Generic.List[string]]::new()
$pathComparer = if ($IsWindows) { [StringComparer]::OrdinalIgnoreCase } else { [StringComparer]::Ordinal }
$documents = [System.Collections.Generic.Dictionary[string, object]]::new($pathComparer)
$files = @(Get-ChildItem -LiteralPath $repoRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })
$linkCount = 0
$anchorCount = 0

function Get-HeadingSlug([string]$Heading) {
    # Ordinary ATX inline formatting; literal underscores in identifiers are retained.
    $plain = [regex]::Replace($Heading, '\[([^\]]+)\]\([^)]+\)', '$1')
    $plain = [regex]::Replace($plain, '<[^>]+>', '')
    $plain = [Net.WebUtility]::HtmlDecode($plain)
    $plain = [regex]::Replace($plain, '(?<![\p{L}\p{N}_])_{1,3}(.+?)_{1,3}(?![\p{L}\p{N}_])', '$1')
    $plain = [regex]::Replace($plain.Trim().ToLowerInvariant(), '[^\p{L}\p{M}\p{N}_\- ]', '')
    return $plain.Replace(' ', '-')
}

# Collect heading IDs before resolving links to later files.
foreach ($file in $files) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    if ([string]::IsNullOrWhiteSpace($content)) {
        $issues.Add("Empty Markdown: $($file.FullName)")
        continue
    }
    $headingIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $customIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $links = [System.Collections.Generic.List[object]]::new()
    $fence = $null
    $headings = 0
    $lineNumber = 0
    $inComment = $false
    foreach ($sourceLine in ($content -split "`n")) {
        $lineNumber++
        $line = $sourceLine.TrimEnd("`r")
        if ($null -ne $fence) {
            if ($line -match '^ {0,3}(`{3,}|~{3,})\s*$') {
                $marker = $Matches[1]
                if ($marker[0] -eq $fence[0] -and $marker.Length -ge $fence.Length) { $fence = $null }
            }
            continue
        }
        if ($inComment) {
            $end = $line.IndexOf('-->')
            if ($end -lt 0) { continue }
            $line = $line.Substring($end + 3)
            $inComment = $false
        }
        $line = [regex]::Replace($line, '<!--.*?-->', '')
        $start = $line.IndexOf('<!--')
        if ($start -ge 0) { $line = $line.Substring(0, $start); $inComment = $true }
        if ($line -match '^ {0,3}(`{3,}|~{3,})(.*)$') { $fence = $Matches[1]; continue }
        if ($line -match '^ {0,3}(#{1,6})(?:[ \t]+(.*)|$)') {
            if ($Matches[1].Length -eq 1) { $headings++ }
            $heading = [regex]::Replace([string]$Matches[2], '[ \t]+#+[ \t]*$', '')
            $baseSlug = Get-HeadingSlug $heading
            $slug = $baseSlug
            $suffix = 0
            while (-not $headingIds.Add($slug)) { $suffix++; $slug = "$baseSlug-$suffix" }
        }
        # Markdown inside inline code is not a navigation target.
        $prose = [regex]::Replace($line, '(?<!`)(`+)(?!`)(.*?)\1(?!`)', '')
        foreach ($match in [regex]::Matches($prose, '<a\b[^>]*\b(?:id|name)\s*=\s*["'']([^"'']+)["''][^>]*>')) {
            [void]$customIds.Add($match.Groups[1].Value)
        }
        foreach ($match in [regex]::Matches($prose, '\[[^\]]*\]\((<[^>]+>|[^)]+)\)')) {
            $target = $match.Groups[1].Value.Trim()
            if ($target.StartsWith('<')) { $target = $target.Substring(1, $target.IndexOf('>') - 1) }
            else { $target = [regex]::Replace($target, '\s+["''].*["'']$', '') }
            $links.Add(@{ Target = $target; Line = $lineNumber })
        }
    }
    if ($headings -ne 1) { $issues.Add("Expected one H1: $($file.FullName)") }
    if ($null -ne $fence) { $issues.Add("Unclosed code fence: $($file.FullName)") }
    $documents[$file.FullName] = @{ Headings = $headingIds; Custom = $customIds; Links = $links }
}

foreach ($file in $files) {
    if (-not $documents.ContainsKey($file.FullName)) { continue }
    foreach ($link in $documents[$file.FullName].Links) {
        $target = $link.Target
        if ($target -match '^(?:[a-zA-Z][a-zA-Z0-9+.-]*:|//)') { continue }
        $parts = $target -split '#', 2
        $path = [Uri]::UnescapeDataString($parts[0])
        $candidate = if (-not $path) { $file.FullName }
            elseif ($path.StartsWith('/')) { [IO.Path]::GetFullPath((Join-Path $repoRoot $path.TrimStart('/'))) }
            else { [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $path)) }
        $location = "$($file.FullName):$($link.Line)"
        if ($path) { $linkCount++ }
        if (-not (Test-Path -LiteralPath $candidate)) {
            $issues.Add("Broken relative link: $location -> $target")
            continue
        }
        # Non-Markdown fragments (for example source line references) are out of scope.
        if ($parts.Count -eq 2 -and $parts[1] -and [IO.Path]::GetExtension($candidate) -eq '.md') {
            $anchorCount++
            $anchor = [Uri]::UnescapeDataString($parts[1])
            if (-not $documents.ContainsKey($candidate) -or
                (-not $documents[$candidate].Headings.Contains($anchor) -and -not $documents[$candidate].Custom.Contains($anchor))) {
                $issues.Add("Broken Markdown anchor: $location -> $target")
            }
        }
    }
}

foreach ($entry in @('README.md','AGENTS.md','CONTRIBUTING.md','templates/SPEC.md','docs/WORKFLOW.md',
    'docs/ENGINEERING_RULES.md','docs/AI_COLLABORATION.md','docs/SOURCES.md','templates/README.md','templates/PROJECT-RULES.md',
    'templates/CLIENT.md','templates/SERVER.md','templates/VERIFICATION.md')) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $entry) -PathType Leaf)) { $issues.Add("Missing current entry: $entry") }
}
if ($issues.Count -gt 0) {
    $issues | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}
Write-Output "Validated $($files.Count) Markdown files, $linkCount relative file links and $anchorCount Markdown anchors."
Write-Output 'Documentation checks only; no business acceptance or release verdict is inferred.'
