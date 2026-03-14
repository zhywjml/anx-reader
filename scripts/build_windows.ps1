param(
    [string]$arch="x64"
)

flutter clean
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs

flutter build windows --release --target-platform windows-$arch

$buildPath = "build\windows\$arch\runner\Release"

Remove-Item "D:\inno" -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "D:\inno"

Copy-Item -Path "$buildPath\*" -Destination "D:\inno" -Recurse
Copy-Item -Path "windows\runner\resources\app_icon.ico" -Destination "D:\inno\logo.ico"

Copy-Item -Path "scripts\windows\$arch\*" -Destination "D:\inno" -Recurse -ErrorAction SilentlyContinue

Remove-Item "D:\inno-result" -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "D:\inno-result"

7z a -tzip "D:\inno-result\app.zip" "D:\inno\*"

New-Item -ItemType Directory -Force -Path "build\windows\unsigned"
Copy-Item "D:\inno-result\app.zip" "build\windows\unsigned\app.zip"

Write-Output "Generated Windows $arch zip!"
