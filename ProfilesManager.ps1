Write-Host "================================="
Write-Host "       CrossOver Profiles        "
Write-Host "================================="

# Path to preferences file and profiles folder
$preferencesFile = "preferences.json"
$profilesFolder = ".\profiles"

# Create the profiles folder if it doesn't exist
if (-Not (Test-Path $profilesFolder)) {
    New-Item -ItemType Directory -Path $profilesFolder
}

# Function to create a profile
function Create-Profile {
    $profileName = Read-Host "Enter the profile name"
    $profilePath = "$profilesFolder\$profileName.json"
    
    Copy-Item $preferencesFile $profilePath -Force
    Write-Host "Profile created/updated: $profileName"
}

# Function to list and restore profiles
function List-Profiles {
    $profiles = Get-ChildItem -Path $profilesFolder -Filter *.json
    if ($profiles.Count -eq 0) {
        Write-Host "No profiles available."
        return
    }

    Write-Host "Available profiles:"
    for ($i = 0; $i -lt $profiles.Count; $i++) {
        Write-Host "[$($i + 1)] $($profiles[$i].Name)"
    }
    Write-Host "[0] Exit"

    $profileIndex = Read-Host "Enter the profile number to restore (or 0 to exit)"
    if ($profileIndex -eq 0) {
        return
    }
    if ($profileIndex -ge 1 -and $profileIndex -le $profiles.Count) {
        $selectedProfile = $profiles[$profileIndex - 1].FullName
        Copy-Item -Path $selectedProfile -Destination $preferencesFile -Force
        Write-Host "Profile restored: $($profiles[$profileIndex - 1].Name)"
    } else {
        Write-Host "Invalid index."
    }
}

# Main menu
function Show-Menu {
    Write-Host "1. Create profile"
    Write-Host "2. Profiles"
    Write-Host "0. Exit"
    Write-Host ""

    $choice = Read-Host "Select an option"
    switch ($choice) {
        1 { Create-Profile }
        2 { List-Profiles }
        0 { exit }
        default { Write-Host "Invalid option. Please try again." }
    }
}

# Menu loop
do {
    Show-Menu
} while ($true)
