﻿using module ..\Include.psm1

$Path = ".\Bin\Equihash-Claymore\ZecMiner64.exe"

$URI = "https://github.com/RainbowMiner/miner-binaries/releases/download/v12.6-claymoreequihash/claymore_equihash_v12.6.zip"

$Commands = [PSCustomObject]@{
    #"bitcore" = "" #Bitcore
    #"blake2s" = "" #Blake2s
    #"blakecoin" = "" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"c11" = "" #C11
    #"cryptonight" = "" #CryptoNight
    #"cryptonightv7" = "" #CryptoNightV7
    #"decred" = "" #Decred
    "equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = "" #Groestl
    #"hmq1725" = "" #HMQ1725
    #"jha" = "" #JHA
    #"keccak" = "" #Keccak
    #"lbry" = "" #Lbry
    #"lyra2v2" = "" #Lyra2RE2
    #"lyra2z" = "" #Lyra2z
    #"myr-gr" = "" #MyriadGroestl
    #"neoscrypt" = "" #NeoScrypt
    #"nist5" = "" #Nist5
    #"pascal" = "" #Pascal
    #"quark" = "" #Quark
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sib" = "" #Sib
    #"skein" = "" #Skein
    #"skunk" = "" #Skunk
    #"timetravel" = "" #Timetravel
    #"tribus" = "" #Tribus
    #"veltor" = "" #Veltor
    #"x11" = "" #X11
    #"x11evo" = "" #X11evo
    #"x17" = "" #X17
    #"yescrypt" = "" #Yescrypt
    #"xevan" = "" #Xevan
}

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | Where-Object {$Pools.$Algorithm_Norm.Protocol -eq "stratum+tcp" <#temp fix#>} | ForEach-Object {

    $Algorithm_Norm = Get-Algorithm $_

    [PSCustomObject]@{
        Type = "AMD"
        Path = $Path
        Arguments = "-r -1 -mport -13333 -zpool $($Pools.$Algorithm_Norm.Host):$($Pools.$Algorithm_Norm.Port) -zwal $($Pools.$Algorithm_Norm.User) -zpsw $($Pools.$Algorithm_Norm.Pass) -allpools 1$($Commands.$_)"
        HashRates = [PSCustomObject]@{$Algorithm_Norm = $Stats."$($Name)_$($Algorithm_Norm)_HashRate".Week }
        API = "Claymore"
        Port = 13333
        URI = $Uri
    }
}