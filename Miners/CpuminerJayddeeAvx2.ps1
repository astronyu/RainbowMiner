﻿using module ..\Include.psm1

$Path = ".\Bin\CPU-JayDDee\cpuminer-avx2.exe"
$Uri = "https://github.com/JayDDee/cpuminer-opt/files/1996977/cpuminer-opt-3.8.8.1-windows.zip"
$Port = "502{0:d2}"

$Devices = $Devices.CPU
if (-not $Devices -or $Config.InfoOnly) {return} # No CPU present in system

$Commands = [PSCustomObject]@{
    ### CPU PROFITABLE ALGOS AS OF 06/03/2018
    ### these algorithms are profitable algorithms on supported pools
    "allium" = "" #Garlicoin
    "cryptonightv7" = "" #CryptoNightV7XMR
    "hmq1725" = "" #HMQ1725
    "lyra2z" = "" #Lyra2z, ZCoin
    "m7m" = "" #m7m
    "x12" = "" #x12
    "yescrypt" = "" #Yescrypt
    "yescryptr16" = "" #yescryptr16, YENTEN

    ### MAYBE PROFITABLE ALGORITHMS - NOT MINEABLE IN SUPPORTED POOLS AS OF 06/03/2018
    ### these algorithms are not mineable on supported pools but may be profitable
    ### once/if support begins. They should be classified accordingly when or if
    ### an algo becomes supported by one of the pools.
    "anime" = "" #Anime 
    "argon2" = "" #Argon2
    "argon2d-crds" = "" #Argon2Credits
    "argon2d-dyn" = "" #Argon2Dynamic
    "argon2d-uis" = "" #Argon2Unitus
    #"axiom" = "" #axiom
    "bastion" = "" #bastion
    "bmw" = "" #bmw
    "deep" = "" #deep
    "drop" = "" #drop    
    "fresh" = "" #fresh
    "heavy" = "" #heavy
    "jha" = "" #JHA
    "lyra2z330" = "" #lyra2z330
    "pentablake" = "" #pentablake
    "pluck" = "" #pluck
    "scryptjane:nf" = "" #scryptjane:nf
    "shavite3" = "" #shavite3
    "skein2" = "" #skein2
    "veltor" = "" #Veltor
    "yescryptr8" = "" #yescryptr8
    "yescryptr32" = "" #yescryptr32, WAVI
    "zr5" = "" #zr5

    #GPU or ASIC - never profitable 23/04/2018
    #"bitcore" = "" #Bitcore
    #"blake" = "" #blake
    #"blakecoin" = "" #Blakecoin
    #"blake2s" = "" #Blake2s
    #"cryptolight" = "" #cryptolight
    #"cryptonight" = "" #CryptoNight
    #"c11" = "" #C11
    #"decred" = "" #Decred
    #"dmd-gr" = "" #dmd-gr
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = "" #Groestl
    #"keccak" = "" #Keccak
    #"keccakc" = "" #keccakc
    #"lbry" = "" #Lbry
    #"lyra2v2" = "" #Lyra2RE2
    #"lyra2h" = "" #lyra2h
    #"lyra2re" = "" #lyra2re
    #"myr-gr" = "" #MyriadGroestl
    #"neoscrypt" = "" #NeoScrypt
    #"nist5" = "" #Nist5
    #"pascal" = "" #Pascal
    #"phi1612" = "" #phi1612
    #"scrypt:N" = "" #scrypt:N
    #"sha256d" = "" #sha256d
    #"sha256t" = "" #sha256t
    #"sib" = "" #Sib
    #"skunk" = "" #Skunk
    #"skein" = "" #Skein
    #"timetravel" = "" #Timetravel
    #"tribus" = "" #Tribus
    #"vanilla" = "" #BlakeVanilla
    #"whirlpoolx" = "" #whirlpoolx
    #"x11evo" = "" #X11evo
    #"x13" = "" #x13
    #"x13sm3" = "" #x13sm3
    #"x14" = "" #x14
    #"x15" = "" #x15
    #"x16r" = "" #x16r
    #"x16s" = "" #X16s
    #"x17" = "" #X17
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Devices | Select-Object Vendor, Model -Unique | ForEach-Object {
    $Miner_Device = $Devices | Where-Object Vendor -EQ $_.Vendor | Where-Object Model -EQ $_.Model
    $Miner_Port = $Port -f ($Miner_Device | Select-Object -First 1 -ExpandProperty Index)
    $Miner_Model = $_.Model
    $Miner_Name = (@($Name) + @($Miner_Device.Name | Sort-Object) | Select-Object) -join '-'

    $DeviceIDsAll = Get-GPUIDs $Miner_Device -join ','

    $Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.(Get-Algorithm $_).Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {
        [PSCustomObject]@{
            Name = $Miner_Name
            DeviceName = $Miner_Device.Name
            DeviceModel = $Miner_Model
            Path = $Path
            Arguments = "-b $($Miner_Port) -a $_ -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
            HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Miner_Name)_$(Get-Algorithm $_)_HashRate".Week}
            API = "Ccminer"
            Port = $Miner_Port
            URI = $Uri
        }
    }
}
