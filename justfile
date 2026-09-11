alias r := release

release:
    #! pwsh

    $ver = get-content $pwd\version
    git add -A
    git commit -m "release: $ver"
    git push
    git tag -a "v$ver" -m "v$ver" -f
    git push --tags -f
