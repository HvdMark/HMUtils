<#
    .SYNOPSIS
    This Cmdlet is used to get a hash of a string

    .DESCRIPTION
    This Cmdlet is used to get a hash of a string

    .EXAMPLE
    Get-Hash

    .NOTES
    Author: H. van der Mark
    Email : Herby@vandermark.org

    .LINK
    https://github.com/HvdMark/HMUtils/
#>

Function ReturnHash
{
    param
    (
        [string]$Cleartext,
        [string]$Algo
    )
    # Convert input to byte array
    $AsciiBytes = [System.Text.Encoding]::UTF8.GetBytes($Cleartext)

    if ($Algo -eq "MD4") { $HashProvider = [System.Security.Cryptography.MD4]::Create() }
    if ($Algo -eq "MD5") { $HashProvider = [System.Security.Cryptography.MD5]::Create() }
    if ($Algo -eq "SHA") { $HashProvider = [System.Security.Cryptography.SHA1]::Create() }
    if ($Algo -eq "SHA1") { $HashProvider = [System.Security.Cryptography.SHA1]::Create() }
    if ($Algo -eq "SHA256") { $HashProvider = [System.Security.Cryptography.SHA256]::Create() }
    if ($Algo -eq "SHA384") { $HashProvider = [System.Security.Cryptography.SHA384]::Create() }
    if ($Algo -eq "SHA512") { $HashProvider = [System.Security.Cryptography.SHA512]::Create() }

    $Bytes = $HashProvider.ComputeHash($AsciiBytes)
    $Hash = -Join ($Bytes | ForEach-Object { '{0:x2}' -f $_ })
    
    return "{0,-20}: {1}" -f $Algo, $Hash
}

# https://github.com/LarrysGIT/MD4-powershell/blob/master/md4.ps1
function Get-MD4
{
    PARAM(
        [String]$String,
        [Byte[]]$bArray,
        [Switch]$UpperCase
    )
    
    # Author: Larry.Song@outlook.com
    # Reference: https://tools.ietf.org/html/rfc1320
    # MD4('abc'): a448017aaf21d8525fc10ae87aa6729d
    $Array = [byte[]]@()
    if ($String)
    {
        $Array = [byte[]]@($String.ToCharArray() | ForEach-Object { [int]$_ })
    }
    if ($bArray)
    {
        $Array = $bArray
    }
    # padding 100000*** to length 448, last (64 bits / 8) 8 bytes fill with original length
    # at least one (512 bits / 8) 64 bytes array
    $M = New-Object Byte[] (([math]::Floor($Array.Count / 64) + 1) * 64)
    # copy original byte array, start from index 0
    $Array.CopyTo($M, 0)
    # padding bits 1000 0000
    $M[$Array.Count] = 0x80
    # padding bits 0000 0000 to fill length (448 bits /8) 56 bytes
    # Default value is 0 when creating a new byte array, so, no action
    # padding message length to the last 64 bits
    @([BitConverter]::GetBytes($Array.Count * 8)).CopyTo($M, $M.Count - 8)

    # message digest buffer (A,B,C,D)
    $A = [Convert]::ToUInt32('0x67452301', 16)
    $B = [Convert]::ToUInt32('0xefcdab89', 16)
    $C = [Convert]::ToUInt32('0x98badcfe', 16)
    $D = [Convert]::ToUInt32('0x10325476', 16)
    
    # There is no unsigned number shift in C#, have to define one.
    Add-Type -TypeDefinition @'
public class Shift
{
  public static uint Left(uint a, int b)
    {
        return ((a << b) | (((a >> 1) & 0x7fffffff) >> (32 - b - 1)));
    }
}
'@

    # define 3 auxiliary functions
    function FF([uint32]$X, [uint32]$Y, [uint32]$Z)
    {
        (($X -band $Y) -bor ((-bnot $X) -band $Z))
    }
    function GG([uint32]$X, [uint32]$Y, [uint32]$Z)
    {
        (($X -band $Y) -bor ($X -band $Z) -bor ($Y -band $Z))
    }
    function HH([uint32]$X, [uint32]$Y, [uint32]$Z)
    {
        ($X -bxor $Y -bxor $Z)
    }
    # processing message in one-word blocks
    for ($i = 0; $i -lt $M.Count; $i += 64)
    {
        # Save a copy of A/B/C/D
        $AA = $A
        $BB = $B
        $CC = $C
        $DD = $D

        # Round 1 start
        $A = [Shift]::Left(($A + (FF -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 0)..($i + 3)], 0)) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (FF -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 4)..($i + 7)], 0)) -band [uint32]::MaxValue, 7)
        $C = [Shift]::Left(($C + (FF -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 8)..($i + 11)], 0)) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (FF -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 12)..($i + 15)], 0)) -band [uint32]::MaxValue, 19)

        $A = [Shift]::Left(($A + (FF -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 16)..($i + 19)], 0)) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (FF -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 20)..($i + 23)], 0)) -band [uint32]::MaxValue, 7)
        $C = [Shift]::Left(($C + (FF -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 24)..($i + 27)], 0)) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (FF -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 28)..($i + 31)], 0)) -band [uint32]::MaxValue, 19)

        $A = [Shift]::Left(($A + (FF -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 32)..($i + 35)], 0)) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (FF -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 36)..($i + 39)], 0)) -band [uint32]::MaxValue, 7)
        $C = [Shift]::Left(($C + (FF -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 40)..($i + 43)], 0)) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (FF -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 44)..($i + 47)], 0)) -band [uint32]::MaxValue, 19)

        $A = [Shift]::Left(($A + (FF -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 48)..($i + 51)], 0)) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (FF -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 52)..($i + 55)], 0)) -band [uint32]::MaxValue, 7)
        $C = [Shift]::Left(($C + (FF -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 56)..($i + 59)], 0)) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (FF -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 60)..($i + 63)], 0)) -band [uint32]::MaxValue, 19)
        # Round 1 end
        # Round 2 start
        $A = [Shift]::Left(($A + (GG -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 0)..($i + 3)], 0) + 0x5A827999) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (GG -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 16)..($i + 19)], 0) + 0x5A827999) -band [uint32]::MaxValue, 5)
        $C = [Shift]::Left(($C + (GG -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 32)..($i + 35)], 0) + 0x5A827999) -band [uint32]::MaxValue, 9)
        $B = [Shift]::Left(($B + (GG -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 48)..($i + 51)], 0) + 0x5A827999) -band [uint32]::MaxValue, 13)

        $A = [Shift]::Left(($A + (GG -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 4)..($i + 7)], 0) + 0x5A827999) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (GG -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 20)..($i + 23)], 0) + 0x5A827999) -band [uint32]::MaxValue, 5)
        $C = [Shift]::Left(($C + (GG -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 36)..($i + 39)], 0) + 0x5A827999) -band [uint32]::MaxValue, 9)
        $B = [Shift]::Left(($B + (GG -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 52)..($i + 55)], 0) + 0x5A827999) -band [uint32]::MaxValue, 13)

        $A = [Shift]::Left(($A + (GG -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 8)..($i + 11)], 0) + 0x5A827999) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (GG -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 24)..($i + 27)], 0) + 0x5A827999) -band [uint32]::MaxValue, 5)
        $C = [Shift]::Left(($C + (GG -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 40)..($i + 43)], 0) + 0x5A827999) -band [uint32]::MaxValue, 9)
        $B = [Shift]::Left(($B + (GG -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 56)..($i + 59)], 0) + 0x5A827999) -band [uint32]::MaxValue, 13)

        $A = [Shift]::Left(($A + (GG -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 12)..($i + 15)], 0) + 0x5A827999) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (GG -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 28)..($i + 31)], 0) + 0x5A827999) -band [uint32]::MaxValue, 5)
        $C = [Shift]::Left(($C + (GG -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 44)..($i + 47)], 0) + 0x5A827999) -band [uint32]::MaxValue, 9)
        $B = [Shift]::Left(($B + (GG -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 60)..($i + 63)], 0) + 0x5A827999) -band [uint32]::MaxValue, 13)
        # Round 2 end
        # Round 3 start
        $A = [Shift]::Left(($A + (HH -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 0)..($i + 3)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (HH -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 32)..($i + 35)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 9)
        $C = [Shift]::Left(($C + (HH -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 16)..($i + 19)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (HH -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 48)..($i + 51)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 15)

        $A = [Shift]::Left(($A + (HH -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 8)..($i + 11)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (HH -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 40)..($i + 43)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 9)
        $C = [Shift]::Left(($C + (HH -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 24)..($i + 27)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (HH -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 56)..($i + 59)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 15)

        $A = [Shift]::Left(($A + (HH -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 4)..($i + 7)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (HH -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 36)..($i + 39)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 9)
        $C = [Shift]::Left(($C + (HH -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 20)..($i + 23)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (HH -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 52)..($i + 55)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 15)

        $A = [Shift]::Left(($A + (HH -X $B -Y $C -Z $D) + [BitConverter]::ToUInt32($M[($i + 12)..($i + 15)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 3)
        $D = [Shift]::Left(($D + (HH -X $A -Y $B -Z $C) + [BitConverter]::ToUInt32($M[($i + 44)..($i + 47)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 9)
        $C = [Shift]::Left(($C + (HH -X $D -Y $A -Z $B) + [BitConverter]::ToUInt32($M[($i + 28)..($i + 31)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 11)
        $B = [Shift]::Left(($B + (HH -X $C -Y $D -Z $A) + [BitConverter]::ToUInt32($M[($i + 60)..($i + 63)], 0) + 0x6ED9EBA1) -band [uint32]::MaxValue, 15)
        # Round 3 end
        # Increment start
        $A = ($A + $AA) -band [uint32]::MaxValue
        $B = ($B + $BB) -band [uint32]::MaxValue
        $C = ($C + $CC) -band [uint32]::MaxValue
        $D = ($D + $DD) -band [uint32]::MaxValue
        # Increment end
    }
    # Output start
    $A = ('{0:x8}' -f $A) -ireplace '^(\w{2})(\w{2})(\w{2})(\w{2})$', '$4$3$2$1'
    $B = ('{0:x8}' -f $B) -ireplace '^(\w{2})(\w{2})(\w{2})(\w{2})$', '$4$3$2$1'
    $C = ('{0:x8}' -f $C) -ireplace '^(\w{2})(\w{2})(\w{2})(\w{2})$', '$4$3$2$1'
    $D = ('{0:x8}' -f $D) -ireplace '^(\w{2})(\w{2})(\w{2})(\w{2})$', '$4$3$2$1'
    # Output end

    if ($UpperCase)
    {
        return "{0,-20}: {1}" -f "MD4", "$A$B$C$D".ToUpper()
        #return "$A$B$C$D".ToUpper()
    }
    else
    {
        return "{0,-20}: {1}" -f "MD4", "$A$B$C$D"
        #return "$A$B$C$D"
    }
}

function Get-Hash
{
    param 
    (
        [Parameter(Mandatory = $true)]
        [string]$ClearString,

        [switch]$All,
        [switch]$MD4,
        [switch]$MD5,
        [switch]$Sha,
        [switch]$Sha1,
        [switch]$Sha256,
        [switch]$Sha384,
        [switch]$Sha512
    )


    # Enforce mutual exclusivity: Either -All or specific algorithms
    if ($All -and ($sha -or $Sha1 -or $Sha256 -or $Sha384 -or $Sha512 -or $MD4 -or $MD5))
    {
        Write-Error "You cannot use -All together with specific hash flags like -Sha1, -Sha256, MD4, or -MD5."
        return
    }

    if (-not $All -and -not ($sha -or $Sha1 -or $Sha256 -or $Sha384 -or $Sha512 -or $MD4 -or $MD5))
    {
        Write-Error "You must specify either -All or at least one of -Sha1, -Sha256, MD4, or -MD5."
        return
    }

    if ([string]::IsNullOrEmpty($ClearString))
    {
        Write-Warning "You must enter a string to hash with an algorithm"
        Write-Warning "Get-Hash <string> <Algo>"
        Write-Warning "Where Algo is:"
        Write-Warning "-All     : Output all hashes"
        Write-Warning "<switch> : -SHA -SHA1 -SHA256 -SHA384 -SHA512 -MD4, -MD5"
    }

    Write-Host

    if ($All -or $Sha) { ReturnHash $ClearString "SHA" }
    if ($All -or $Sha1) { ReturnHash $ClearString "SHA1" }
    if ($All -or $Sha256) { ReturnHash $ClearString "SHA256" }
    if ($All -or $Sha384) { ReturnHash $ClearString "SHA384" }
    if ($All -or $Sha512) { ReturnHash $ClearString "SHA512" }
    if ($All -or $MD4) { Get-MD4 -string $ClearString }
    if ($All -or $MD5) { ReturnHash $ClearString "MD5" }
    

}