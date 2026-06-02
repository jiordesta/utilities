# Configuration
$startDate = Get-Date "2021-01-01"
$endDate = Get-Date "2026-06-03"

# Probabilities
$weekdayCommitChance = 0.85  # 85%
$weekendCommitChance = 0.20  # 20%

$currentDate = $startDate

while ($currentDate -le $endDate) {

    $isWeekend = $currentDate.DayOfWeek -in @("Saturday", "Sunday")

    if ($isWeekend) {
        $shouldCommit = (Get-Random -Minimum 0 -Maximum 100) -lt ($weekendCommitChance * 100)
    }
    else {
        $shouldCommit = (Get-Random -Minimum 0 -Maximum 100) -lt ($weekdayCommitChance * 100)
    }

    if ($shouldCommit) {

        $commitCount = Get-Random -Minimum 1 -Maximum 8

        for ($i = 1; $i -le $commitCount; $i++) {

            $hour = Get-Random -Minimum 8 -Maximum 23
            $minute = Get-Random -Minimum 0 -Maximum 60
            $second = Get-Random -Minimum 0 -Maximum 60

            $commitDate = Get-Date `
                -Year $currentDate.Year `
                -Month $currentDate.Month `
                -Day $currentDate.Day `
                -Hour $hour `
                -Minute $minute `
                -Second $second

            $gitDate = $commitDate.ToString("yyyy-MM-dd HH:mm:ss")

            $env:GIT_AUTHOR_DATE = $gitDate
            $env:GIT_COMMITTER_DATE = $gitDate

            git commit --allow-empty -m "chore: update $(Get-Random)"
        }

        Write-Host "$($currentDate.ToString('yyyy-MM-dd')) -> $commitCount commits"
    }

    $currentDate = $currentDate.AddDays(1)
}

Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue

Write-Host "Done!"