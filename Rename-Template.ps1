param(
    [Parameter(Mandatory=$true)]
    [string]$NewName
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Template Renamer Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($NewName -match '[^a-zA-Z0-9_.-]') {
    Write-Host "Error: El nombre solo puede contener letras, numeros, guiones y puntos." -ForegroundColor Red
    exit 1
}

$currentDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($currentDir)) {
    $currentDir = Get-Location
}

Write-Host "Directorio: $currentDir" -ForegroundColor Yellow
Write-Host "Nuevo nombre: $NewName" -ForegroundColor Yellow
Write-Host ""

# Step 1: Rename directories
Write-Host "[1/4] Renombrando carpetas..." -ForegroundColor Green
$dirs = Get-ChildItem -Path $currentDir -Directory -Recurse | Where-Object { $_.Name -like "*BackendTemplate*" }
foreach ($dir in $dirs) {
    $newDirName = $dir.Name -replace "BackendTemplate", $NewName
    $newDirPath = Join-Path $dir.Parent.FullName $newDirName
    Write-Host "  Renombrando: $($dir.Name) -> $newDirName" -ForegroundColor White
    Rename-Item -Path $dir.FullName -NewName $newDirName -Force
}

# Rename root directories if they contain BackendTemplate
$rootDirs = Get-ChildItem -Path $currentDir -Directory | Where-Object { $_.Name -like "*BackendTemplate*" }
foreach ($dir in $rootDirs) {
    $newDirName = $dir.Name -replace "BackendTemplate", $NewName
    $newDirPath = Join-Path $dir.Parent.FullName $newDirName
    Write-Host "  Renombrando: $($dir.Name) -> $newDirName" -ForegroundColor White
    Rename-Item -Path $dir.FullName -NewName $newDirName -Force
}

Write-Host ""

# Step 2: Rename files
Write-Host "[2/4] Renombrando archivos..." -ForegroundColor Green
$files = Get-ChildItem -Path $currentDir -File -Recurse -Include *.cs,*.csproj,*.sln,*.json | Where-Object { $_.Name -like "*BackendTemplate*" }
foreach ($file in $files) {
    $newFileName = $file.Name -replace "BackendTemplate", $NewName
    Write-Host "  Renombrando: $($file.Name) -> $newFileName" -ForegroundColor White
    Rename-Item -Path $file.FullName -NewName $newFileName -Force
}

Write-Host ""

# Step 3: Replace content in files
Write-Host "[3/4] Reemplazando contenido en archivos..." -ForegroundColor Green
$allFiles = Get-ChildItem -Path $currentDir -File -Recurse -Include *.cs,*.csproj,*.sln,*.json,*.md,*.ps1
foreach ($file in $allFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match "BackendTemplate") {
        $newContent = $content -replace "BackendTemplate", $NewName
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline -Force
        Write-Host "  Actualizado: $($file.Name)" -ForegroundColor White
    }
}

Write-Host ""

# Step 4: Rename solution file
Write-Host "[4/4] Verificando archivo de solucion..." -ForegroundColor Green
$slnFiles = Get-ChildItem -Path $currentDir -Filter *.sln
foreach ($sln in $slnFiles) {
    if ($sln.Name -like "*BackendTemplate*") {
        $newSlnName = $sln.Name -replace "BackendTemplate", $NewName
        Write-Host "  Renombrando solucion: $($sln.Name) -> $newSlnName" -ForegroundColor White
        Rename-Item -Path $sln.FullName -NewName $newSlnName -Force
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Proceso completado!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ahora puedes:" -ForegroundColor Yellow
Write-Host "1. Abrir el archivo .sln" -ForegroundColor White
Write-Host "2. Ejecutar 'dotnet build' para verificar" -ForegroundColor White
Write-Host "3. Ejecutar 'dotnet run' para probar" -ForegroundColor White
