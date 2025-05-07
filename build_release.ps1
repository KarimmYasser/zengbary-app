flutter build apk --release
Copy-Item "build\app\outputs\flutter-apk\app-release.apk" -Destination "app-release.apk" -Force
Write-Output "✅ APK copied to project root."
