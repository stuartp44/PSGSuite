
<# InModuleScope PSGSuite {
    Set-PSGSuiteConfig -ConfigName 'Pester' -P12KeyPath '.\test.p12' -AppEmail 'mockapp@iam.google.com' -AdminEmail 'mockadmin@test.com' -CustomerID C10000000 -Domain 'test.com' -Preference CustomerID -ServiceAccountClientID 10000000000000000000
    Mock 'New-GoogleService' {
        [CmdletBinding()]
        $o = New-Object 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        $o.Users | Add-Member -MemberType ScriptMethod -Name List -Value {
            New-Object -TypeName PSObject | Add-Member -MemberType ScriptMethod -Name Execute -Value {@('user1','user2')} -Force -PassThru
        } -Force
        return $o
    } -ModuleName PSGSuite
    Describe 'Directory function mock tests' {
        Context 'When a Directory service is created' {
            It 'ApplicationName should be $null' {
                $service = New-GoogleService -ServiceType 'Google.Apis.Admin.Directory.directory_v1.DirectoryService' -Scope 'Mock' -User 'MockUser@test.com'
                $service.ApplicationName | Should -BeNullOrEmpty
            }
        }
    }
} #>