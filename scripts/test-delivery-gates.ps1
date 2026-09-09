param(
    [string]$FixtureDirectory = (Join-Path $PSScriptRoot '..\tests\workflow-gate')
)

$ErrorActionPreference = 'Stop'
$fixtureRoot = (Resolve-Path -LiteralPath $FixtureDirectory).Path
$fixtureFiles = Get-ChildItem -LiteralPath $fixtureRoot -File -Filter '*.json' | Sort-Object Name

if ($fixtureFiles.Count -eq 0) {
    throw "No workflow gate fixtures found in $fixtureRoot"
}

$allowedImplementation = @('未开始', '实现中', '已完成', '阻断')
$allowedVerification = @('未执行', '部分完成', 'Pass', 'Fail', 'Blocked')
$allowedReadiness = @('未评估', '可进入 QA', '可发布', '阻断')
$allowedAlign = @('Pass', 'Fail')
$allowedDecision = @('可合并', '可进入 QA', '可发布', '阻断')
$requiredBaseline = @('task_change', 'source_revision', 'build_artifact', 'config_schema_migration', 'test_environment')

function Get-DeliveryViolations {
    param([pscustomobject]$Delivery)

    $violations = [System.Collections.Generic.List[string]]::new()

    if ($Delivery.implementation_status -notin $allowedImplementation) {
        $violations.Add('UNKNOWN_IMPLEMENTATION_STATUS')
    }
    if ($Delivery.verification_status -notin $allowedVerification) {
        $violations.Add('UNKNOWN_VERIFICATION_STATUS')
    }
    if ($Delivery.release_readiness -notin $allowedReadiness) {
        $violations.Add('UNKNOWN_RELEASE_READINESS')
    }
    if ($Delivery.align -notin $allowedAlign) {
        $violations.Add('UNKNOWN_ALIGN')
    }
    if ($Delivery.decision -notin $allowedDecision) {
        $violations.Add('UNKNOWN_DECISION')
    }

    $blockingResults = @($Delivery.blocking_ac_results | Where-Object {
        $null -ne $_ -and -not [string]::IsNullOrWhiteSpace([string]$_)
    })
    $blockingFailures = @($blockingResults | Where-Object { $_ -ne 'Pass' })

    if ($Delivery.align -eq 'Pass' -and $blockingFailures.Count -gt 0) {
        $violations.Add('BLOCKING_AC_NOT_PASS')
    }
    if ($Delivery.verification_status -eq 'Pass' -and $blockingFailures.Count -gt 0) {
        $violations.Add('VERIFICATION_CONFLICT')
    }

    if ($Delivery.decision -ne '阻断') {
        if ($blockingResults.Count -eq 0) {
            $violations.Add('BLOCKING_AC_RESULTS_REQUIRED')
        }
        if ($Delivery.align -ne 'Pass') {
            $violations.Add('ALIGN_REQUIRED')
        }

        $missingBaseline = @()
        if ($null -eq $Delivery.baseline) {
            $missingBaseline = @($requiredBaseline)
        }
        else {
            foreach ($field in $requiredBaseline) {
                $property = $Delivery.baseline.PSObject.Properties[$field]
                if ($null -eq $property -or [string]::IsNullOrWhiteSpace([string]$property.Value)) {
                    $missingBaseline += $field
                }
            }
        }
        if ($missingBaseline.Count -gt 0) {
            $violations.Add('BASELINE_REQUIRED')
        }
    }

    if ($Delivery.decision -in @('可合并', '可进入 QA', '可发布') -and
        $Delivery.implementation_status -ne '已完成') {
        $violations.Add('IMPLEMENTATION_NOT_COMPLETE')
    }

    if ($Delivery.decision -eq '可进入 QA' -and
        $Delivery.release_readiness -notin @('可进入 QA', '可发布')) {
        $violations.Add('QA_READINESS_MISMATCH')
    }

    if ($Delivery.decision -eq '可发布') {
        if ($Delivery.verification_status -ne 'Pass') {
            $violations.Add('VERIFICATION_NOT_PASS')
        }
        if ($Delivery.release_readiness -ne '可发布') {
            $violations.Add('RELEASE_READINESS_MISMATCH')
        }
    }

    return @($violations | Sort-Object -Unique)
}

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($fixtureFile in $fixtureFiles) {
    $fixture = Get-Content -Raw -LiteralPath $fixtureFile.FullName | ConvertFrom-Json
    $actual = @(Get-DeliveryViolations -Delivery $fixture.delivery)
    $expected = @($fixture.expected_violations | Sort-Object -Unique)
    $difference = @(Compare-Object -ReferenceObject $expected -DifferenceObject $actual)

    if ($difference.Count -gt 0) {
        $failures.Add("$($fixtureFile.Name): expected [$($expected -join ', ')] but got [$($actual -join ', ')]")
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Validated $($fixtureFiles.Count) workflow gate regression fixtures."
