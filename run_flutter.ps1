# Run this script from your project root (E:\Darts)

Write-Host "Select target to run:"
Write-Host "1. Windows Desktop"
Write-Host "2. Edge Browser"
$choice = Read-Host "Enter choice (1 or 2)"

switch ($choice) {
    "1" {
        Write-Host "🚀 Launching Flutter app on Windows Desktop..."
        flutter run -d windows
    }
    "2" {
        Write-Host "🌐 Launching Flutter app in Edge Browser..."
        flutter run -d edge
    }
    default {
        Write-Host "❌ Invalid choice. Please enter 1 or 2."
    }
}
