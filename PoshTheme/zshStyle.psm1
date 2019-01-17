#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # write virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "($(Get-VirtualEnvName)) " -ForegroundColor $sl.Colors.EnvironmentColor
    }

    # write start symbol
    $prompt += Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.StartSymbol

    # write current folder name
    $dir = $((get-item $pwd).Name)
    $prompt += Write-Prompt -Object " $dir" -ForegroundColor $sl.Colors.Path

    # write branchname
    $status = Get-VCSStatus
    if ($status) {
      $branchName = git rev-parse --abbrev-ref HEAD
      $prompt += Write-Prompt -Object " branch:(" -ForegroundColor $sl.Colors.BranchTitle
      $prompt += Write-Prompt -Object "$branchName" -ForegroundColor $sl.Colors.BranchName
      $prompt += Write-Prompt -Object ")" -ForegroundColor $sl.Colors.BranchTitle
    }

    $foregroundColor = $sl.Colors.PromptIndicator
    $indicatorSymbol = $sl.PromptSymbols.PromptIndicatorSymbol

    # check for elevated prompt
    If (Test-Administrator) {
        $foregroundColor = $sl.Colors.AdministratorSymbolColor
        $indicatorSymbol = $sl.PromptSymbols.AdministratorSymbol
    }

    # check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $foregroundColor = $sl.Colors.PromptIndicatorFailed
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

$sl.PromptSymbols.StartSymbol = [char]::ConvertFromUtf32(0x2794) # ➔
$sl.PromptSymbols.PromptIndicatorSymbol = [char]::ConvertFromUtf32(0x2718) # ✘
$sl.PromptSymbols.AdministratorSymbol = [char]::ConvertFromUtf32(0x265A) # ♚

$sl.Colors.StartSymbol = [ConsoleColor]::DarkRed
$sl.Colors.Path = [ConsoleColor]::DarkGreen
$sl.Colors.BranchTitle = [ConsoleColor]::DarkBlue
$sl.Colors.BranchName = [ConsoleColor]::DarkRed
$sl.Colors.EnvironmentColor = [ConsoleColor]::White
$sl.Colors.AdministratorSymbolColor = [ConsoleColor]::Yellow
$sl.Colors.PromptIndicator = [ConsoleColor]::DarkYellow
$sl.Colors.PromptIndicatorFailed = [ConsoleColor]::Red
