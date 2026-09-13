$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$modJsonPath = Join-Path $repoRoot 'mod.json'
$nameScriptPath = Join-Path $repoRoot 'scripts/name.lua'
$sourcePatterns = @('*.lua', '*.ps1')
$expectedNameLists = @(
    'NAME_LIST_ENGLISH',
    'NAME_LIST_FRENCH',
    'NAME_LIST_GERMAN',
    'NAME_LIST_ITALIAN',
    'NAME_LIST_NORSE',
    'NAME_LIST_PLAYER',
    'NAME_LIST_SPANISH',
    'NAME_LIST_VILLAGE'
)

$modJson = Get-Content -Raw -Path $modJsonPath | ConvertFrom-Json

if ($modJson.Version -ne '1.1.0') {
    throw "Expected mod.json version 1.1.0, found '$($modJson.Version)'."
}

$nameScript = Get-Content -Raw -Path $nameScriptPath -Encoding UTF8

foreach ($nameList in $expectedNameLists) {
    if ($nameScript -notmatch [regex]::Escape($nameList)) {
        throw "Missing current Foundation name list override target '$nameList'."
    }
}

if ($nameScript -notmatch 'GENERATED_NAME_COUNT\s*=\s*5000') {
    throw 'The generated name count must stay at 5000 per gender.'
}

$sourceFiles = Get-ChildItem -Path $repoRoot -Recurse -Include $sourcePatterns -File |
    Where-Object { $_.FullName -notmatch '\\.git\\' }

foreach ($sourceFile in $sourceFiles) {
    $lineCount = (Get-Content -Path $sourceFile.FullName).Count
    if ($lineCount -gt 500) {
        throw "Source file '$($sourceFile.FullName)' has $lineCount lines; limit is 500."
    }
}

Write-Host 'Mod validation passed.'
