#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # write username
    $user = [System.Environment]::UserName
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object "$user " -ForegroundColor $sl.Colors.UserName
    }

    # write username symbol
    $prompt += Write-Prompt -Object $sl.PromptSymbols.UserNameSymbol -ForegroundColor $sl.Colors.UserName

    # write current folder name [foldername]
    $dir = $((get-item $pwd).Name)
    $prompt += Write-Prompt -Object " [$dir]" -ForegroundColor $sl.Colors.Path

    # write just simple branchname (branch:branchname)
    $status = Get-VCSStatus
    if ($status) {
      $branchName = git rev-parse --abbrev-ref HEAD
      $prompt += Write-Prompt -Object "(branch:$branchName)" -ForegroundColor $sl.Colors.BranchName
    }

    # write virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object ' (inside env:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName)) " -ForegroundColor $themeInfo.VirtualEnvForegroundColor
    }

    # check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.AdministratorSymbol)" -ForegroundColor $sl.Colors.AdministratorSymbolColor
    }

    # check the last command state and indicate if failed
    $foregroundColor = $sl.Colors.PromptIndicator
    $indicatorSymbol = $sl.PromptSymbols.RightSymbol
    If ($lastCommandFailed) {
        $foregroundColor = $sl.Colors.PromptIndicatorFailed
        $indicatorSymbol = $sl.PromptSymbols.WrongSymbol
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Write-Prompt -Object ' '
    $prompt += Write-Prompt -Object $indicatorSymbol -ForegroundColor $foregroundColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings #local settings

$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::Red

# (0x03d6 -> ϖ) (0x0489 -> ҉) (0x231B -> ⌛) (0x10E2 -> ტ) (0x20AA -> ₪) (0xA562 -> ꕢ)
# (0x2714 -> ✔) (0x2718 -> ✘) (0x1A10 -> ᨐ) (0x25CF -> ●) (0x2600 -> ☀) (0x2601 -> ☁)
# (0x2615 -> ☕) (0x2646 -> ♆) (0x265A -> ♚) (0x2665 -> ♥) (0x266C -> ♬) (0x2E19 -> ⸙)
# For More Symbol: http://www.fileformat.info/info/charset/UTF-32/list.htm?start=8192
$sl.PromptSymbols.UserNameSymbol = ':p'
# $sl.PromptSymbols.UserNameSymbol = [char]::ConvertFromUtf32(0x1A10) # ᨐ
$sl.PromptSymbols.RightSymbol = [char]::ConvertFromUtf32(0x2714) # ✔
$sl.PromptSymbols.WrongSymbol = [char]::ConvertFromUtf32(0x2718) # ✘
$sl.PromptSymbols.AdministratorSymbol = [char]::ConvertFromUtf32(0x265A) # ♚

$sl.Colors.UserName = [ConsoleColor]::Cyan
$sl.Colors.Path = [ConsoleColor]::White
$sl.Colors.BranchName = [ConsoleColor]::Red
$sl.Colors.AdministratorSymbolColor = [ConsoleColor]::Yellow
$sl.Colors.PromptIndicator = [ConsoleColor]::Green
$sl.Colors.PromptIndicatorFailed = [ConsoleColor]::Red
