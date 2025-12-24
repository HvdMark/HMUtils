<#
    .SYNOPSIS
    Get User details

    .DESCRIPTION
    Get the user information

    .PARAMETER Identity (Alias sAMAcountName)
    User

    .EXAMPLE
    Get-UserInformation <SamAccountName>
    "JaneDoe" | Get-UserInformation

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>
function Get-User
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('SAMAccountName')][String]$Identity
    )

    begin
    {
        $Props = @(
            'AccountExpirationDate', 'AccountLockoutTime', 'BadLogonCount', 'badPwdCount',
            'Company', 'CannotChangePassword', 'Deleted', 'Department', 'Description',
            'DisplayName', 'EmailAddress', 'EmployeeID', 'EmployeeNumber', 'Enabled', 'Fax',
            'GivenName', 'LastBadPasswordAttempt', 'LastLogonDate', 'LockedOut', 'lockoutTime',
            'logonCount', 'LogonWorkstations', 'mail', 'Manager', 'MobilePhone', 'Modified',
            'Name', 'ObjectGUID', 'objectSid', 'Office', 'OfficePhone',
            'PasswordExpired', 'PasswordLastSet', 'PasswordNeverExpires',
            'SamAccountName', 'SID', 'Surname', 'telephoneNumber', 'Title',
            'whenChanged', 'whenCreated'
        )
    }

    process
    {
        try
        {
            # Get the userobject
            $User = Get-ADUser -Identity $Identity -Properties $Props -ErrorAction Stop

            # Get the Manager (if filled in)
            $ManagerName = $null
            if ($User.Manager)
            {
                try
                {
                    $ManagerName = (Get-ADUser -Identity $User.Manager -Properties DisplayName).DisplayName
                }
                catch
                {
                    $ManagerName = $null
                }
            }

            # Get the group membership
            $GroupMembership = Get-ADPrincipalGroupMembership $User -ErrorAction Stop |
            Select-Object -ExpandProperty Name |
            Sort-Object

            # Plave everyting into a PsCustomOpbject
            [PSCustomObject]@{
                FullName               = $User.Name
                FirstName              = $User.GivenName
                LastName               = $User.Surname
                Title                  = $User.Title
                EmployeeID             = $User.EmployeeID
                EmployeeNo             = $User.EmployeeNumber
                Description            = $User.Description
                EmailAddress           = $User.EmailAddress
                Phone                  = $User.TelephoneNumber
                Mobile                 = $User.MobilePhone
                Company                = $User.Company
                Office                 = $User.Office
                Department             = $User.Department
                Manager                = $ManagerName

                SAMAccountName         = $User.SamAccountName
                Enabled                = $User.Enabled
                LogonCount             = $User.logonCount
                LastLogonDate          = $User.LastLogonDate
                ExpirationDate         = $User.AccountExpirationDate
                LockedOut              = $User.LockedOut
                LockoutTime            = $User.LockoutTime
                AccountLockoutTime     = $User.AccountLockoutTime
                PasswordExpired        = $User.PasswordExpired
                PasswordLastSet        = $User.PasswordLastSet
                PasswordNeverExpires   = $User.PasswordNeverExpires
                LastBadPasswordAttempt = $User.LastBadPasswordAttempt
                BadLogonCount          = $User.BadLogonCount
                BadPwdCount            = $User.BadPwdCount
                CannotChangePassword   = $User.CannotChangePassword

                ObjectGUID             = $User.ObjectGUID
                SID                    = $User.SID
                AccountCreated         = $User.whenCreated
                AccountLastChanged     = $User.whenChanged

                GroupMembership        = $GroupMembership -join ', '
            }
        }
        catch
        {
            Write-Error "$($_.Exception.Message)"
        }
    }
}
