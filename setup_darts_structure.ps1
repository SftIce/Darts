# Define base project path
$base = "E:\Darts\lib"

# Create folder structure
$folders = @(
    "$base\logic",
    "$base\screens",
    "$base\widgets"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Created folder: $folder"
    }
}

# Define files to create
$files = @(
    "$base\main.dart",
    "$base\game_selection.dart",
    "$base\logic\cricket_sa_logic.dart",
    "$base\logic\logic_501.dart",
    "$base\logic\dart_math.dart",
    "$base\screens\scoreboard_cricket_sa.dart",
    "$base\screens\scoreboard_501.dart",
    "$base\screens\full_history_screen.dart",
    "$base\widgets\dartboard_widget.dart",
    "$base\widgets\player_stats_panel.dart"
)

# Create files with placeholder content
foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        New-Item -ItemType File -Path $file -Force | Out-Null
        Add-Content -Path $file -Value "// TODO: Paste full Dart code for $([System.IO.Path]::GetFileName($file))"
        Write-Host "Created file: $file"
    } else {
        Write-Host "File already exists: $file"
    }
}

Write-Host "✅ Project structure created successfully at E:\Darts"
