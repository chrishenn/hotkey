param (
    [switch] $install,
    [switch] $pre_uninstall,
    [switch] $uninstall
)

import-module chplib -force

function install {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        rprop $key $exe.basename 'String' $exe.fullname

        if (shell_interactive) {
            & $exe.fullname
        }
    }
    if (-not (shell_interactive)) {
        write-host ''
        write-host ''
        write-host -f y "Installing from non-interactive shell: binaries will run at next login"
        write-host ''
    }
    # startup registry entries - don't wait to launch on boot
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize'
    rprop $key 'WaitForIdleState' 'DWORD' 0
    rprop $key 'StartupDelayInMSec' 'DWORD' 1
}

function pre_uninstall {
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        if (get-process -name $exe.basename -ea 0) {
            stop-process -name $exe.basename -ea 0
            wait-process -name $exe.basename -ea 0
            start-sleep 0.5
        }
    }
}

function uninstall {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        rp $key $exe.basename
    }
}

function main {
    if ($install) {
        install
    } elseif ($pre_uninstall) {
        pre_uninstall
    } elseif ($uninstall) {
        uninstall
    }
}
main
