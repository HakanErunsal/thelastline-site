# Regenerate assets/press/downloads/*.zip from repo assets.
# Run from repo root: powershell -File scripts/build-press-kits.ps1

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path $PSScriptRoot -Parent
$OutDir = Join-Path $RepoRoot "assets/press/downloads"
$StageRoot = Join-Path $env:TEMP "tll-press-kit-build"
$PackageName = "TheLastLine_PressKit_2026-07"
$KitRoot = Join-Path $RepoRoot "scripts/press-kit"

function Ensure-Dir($p) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
function Copy-Asset($from, $to) { Ensure-Dir (Split-Path $to -Parent); Copy-Item $from $to -Force }

function Add-Common($base) {
  Ensure-Dir "$base/00_README"
  Copy-Asset "$KitRoot/PressKit_README.txt" "$base/00_README/README.txt"
  Copy-Asset "$KitRoot/Fact_Sheet_EN.txt" "$base/00_README/Fact_Sheet_EN.txt"
  Copy-Asset "$KitRoot/Fact_Sheet_TR.txt" "$base/00_README/Fact_Sheet_TR.txt"
  Copy-Asset "$KitRoot/Usage_and_Credits.txt" "$base/00_README/Usage_and_Credits.txt"
}

function Add-Assets($base) {
  Ensure-Dir "$base/01_Logos/App_Icon"
  Copy-Asset "$RepoRoot/assets/press/TLL_AppIcon_512x512.png" "$base/01_Logos/App_Icon/TLL_AppIcon_512x512.png"
  Copy-Asset "$RepoRoot/assets/press/TLL_AppIcon_1024x1024.png" "$base/01_Logos/App_Icon/TLL_AppIcon_1024x1024.png"
  Ensure-Dir "$base/02_Key_Art/16x9"
  Copy-Asset "$RepoRoot/assets/images/thelastline_flamethrower-9e99aa.jpg" "$base/02_Key_Art/16x9/TLL_KeyArt_TheDrop_Clean_1920x888.jpg"
  Ensure-Dir "$base/03_Screenshots/Gameplay_UI"
  $map = [ordered]@{
    "thelastline_horde_arena-3d5bf4.jpg" = "TLL_Screenshot_01_MillhavenHorde_1920x888.jpg"
    "thelastline_flamethrower-9e99aa.jpg" = "TLL_Screenshot_02_TheDropHelicopter_1920x888.jpg"
    "thelastline_mobile_hud-d352c1.jpg" = "TLL_Screenshot_03_MobileHUD_1920x888.jpg"
    "thelastline_subway-3fb115.jpg" = "TLL_Screenshot_04_SubwayPlatform_1920x888.jpg"
    "thelastline_boss_chainsaw-9bb2bd.jpg" = "TLL_Screenshot_05_BossEncounter_1920x888.jpg"
    "thelastline_loadout-44bcfb.jpg" = "TLL_Screenshot_06_Loadout_1920x888.jpg"
    "thelastline_forest_night-7511c6.jpg" = "TLL_Screenshot_07_ForestNight_1920x888.jpg"
  }
  foreach ($entry in $map.GetEnumerator()) {
    Copy-Asset "$RepoRoot/assets/images/$($entry.Key)" "$base/03_Screenshots/Gameplay_UI/$($entry.Value)"
  }
  Copy-Item "$KitRoot/Asset_Manifest.csv" "$base/00_README/Asset_Manifest.csv" -Force
}

if (Test-Path $StageRoot) { Remove-Item $StageRoot -Recurse -Force }
Ensure-Dir $OutDir

$lite = "$StageRoot/lite/$PackageName"
Add-Common $lite
Add-Assets $lite
if (Test-Path "$OutDir/PressKit_Lite.zip") { Remove-Item "$OutDir/PressKit_Lite.zip" -Force }
Compress-Archive -Path "$lite/*" -DestinationPath "$OutDir/PressKit_Lite.zip" -CompressionLevel Optimal

Remove-Item "$StageRoot/lite" -Recurse -Force
$full = "$StageRoot/full/$PackageName"
Add-Common $full
Add-Assets $full
Copy-Asset "$RepoRoot/assets/images/thelastline_app_icon.png" "$full/01_Logos/App_Icon/thelastline_app_icon_source_512.png"
if (Test-Path "$OutDir/PressKit_Images_Full.zip") { Remove-Item "$OutDir/PressKit_Images_Full.zip" -Force }
Compress-Archive -Path "$full/*" -DestinationPath "$OutDir/PressKit_Images_Full.zip" -CompressionLevel Optimal

Remove-Item "$StageRoot/full" -Recurse -Force
$broll = "$StageRoot/broll/TheLastLine_B-Roll_2026-07"
Ensure-Dir "$broll/00_README"
Ensure-Dir "$broll/01_Official_Trailer"
Ensure-Dir "$broll/02_Gameplay_Clips"
Copy-Asset "$KitRoot/B-Roll_README.txt" "$broll/00_README/README.txt"
Copy-Asset "$KitRoot/Usage_and_Credits.txt" "$broll/00_README/Usage_and_Credits.txt"
Copy-Asset "$RepoRoot/assets/video/thelastline_trailer-f901bd.mp4" "$broll/01_Official_Trailer/TLL_Trailer_Official_1080p_EN.mp4"
Copy-Asset "$RepoRoot/assets/video/thelastline_lod_demo-05517a.mp4" "$broll/02_Gameplay_Clips/TLL_Gameplay_LODDemo_1080p.mp4"
if (Test-Path "$OutDir/B-Roll_Pack.zip") { Remove-Item "$OutDir/B-Roll_Pack.zip" -Force }
Compress-Archive -Path "$broll/*" -DestinationPath "$OutDir/B-Roll_Pack.zip" -CompressionLevel Optimal

Remove-Item $StageRoot -Recurse -Force
Get-ChildItem $OutDir -Filter *.zip | Format-Table Name, @{ N = "MB"; E = { [math]::Round($_.Length / 1MB, 2) } }
