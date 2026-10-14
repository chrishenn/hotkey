function compile {
    $ErrorActionPreference = 'Stop'
    $ahdir = "$( scoop prefix autohotkey )"
    $ahk2exe = "$ahdir\Compiler\Ahk2Exe.exe"
    $base = Resolve-Path "$ahdir\v2\autohotkey64.exe"

    $arg = @()
    $arg += "/base '$base'"
    if ($env:INPUTS_IN) {
        $in = Resolve-Path $env:INPUTS_IN
        $arg += "/in '$in'"
    }
    if ($env:INPUTS_ICON) {
        $icon = Resolve-Path $env:INPUTS_ICON
        $arg += "/icon '$icon'"
    }
    if ($env:INPUTS_OUT) {
        $out = Join-Path $pwd $env:INPUTS_OUT
        New-Item $( Split-Path $out ) -Force -ItemType Directory > $null
        $arg += "/out '$out'"
    }
    if ($env:INPUTS_CP) {
        $arg += "/cp $env:INPUTS_CP"
    }
    if ($env:INPUTS_COMPRESS) {
        $arg += "/compress $env:INPUTS_COMPRESS"
    }
    if ($env:INPUTS_RESOURCEID) {
        $arg += "/resourceid $env:INPUTS_RESOURCEID"
    }

    $arg = $arg -join ' '
    Invoke-Expression "$ahk2exe $arg" | Out-String -OutVariable output
    $binary = $output.Split([Environment]::NewLine).Where({ $_.contains('exe') })
    echo "binary=$binary" >> $GITHUB_OUTPUT
}

function compile_old {
    $ErrorActionPreference = 'Stop'
    $ahdir = "$(scoop prefix autohotkey)"
    $base = "$ahdir\v2\autohotkey64.exe"
    $ahk2exe = "$ahdir\Compiler\Ahk2Exe.exe"

    $args = @()
    $with = @{
      'in' = "$env:INPUTS_IN"
      'out' = "$env:INPUTS_OUT"
      'icon' = "$env:INPUTS_ICON"
      'cp' = "$env:INPUTS_CP"
      'base' = "$base"
      'compress' = "$env:INPUTS_COMPRESS"
      'resourceid' = "$env:INPUTS_RESOURCEID"
    }

    ForEach ($key in @($with.Keys)) {
      If (![string]::IsNullOrEmpty($with["$key"])) {
        $is_path = $true

        Switch ($key) {
          { @('in', 'icon', 'base') -contains $_} {
            $with["$key"] = Resolve-Path -Path $with["$key"]
          }
          { @('out') -contains $_ } {
            $with["$key"] = Join-Path $pwd $with["$key"]
            New-Item $(Split-Path -Path $with["$key"]) -Force -ItemType Directory > $null
          }
          default { $is_path = $false }
        }

        If ($is_path) {
          $args += "/$key '$($with["$key"])'"
        } Else {
          $args += "/$key $($with["$key"])"
        }
      }
    }

    Invoke-Expression "$ahk2exe $($args -join ' ')" | Out-String -OutVariable output

    $binary = $output.Split([Environment]::NewLine).Where({ $_.contains('exe') })
    echo "binary=$binary" >> $GITHUB_OUTPUT
    echo "::notice ::Successfully compiled as: ${binary}."
}
