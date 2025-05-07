#!/bin/bash
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk ./app-release.apk
echo "✅ New APK copied to project root as app-release.apk"