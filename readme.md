# Hotkey

My windows hotkeys

# Dev

```pwsh
# manually bump the version file. then:
$ver = get-content $pwd\version
git add -A
git commit -am "release: $ver"
git push
git tag -a "v$ver" -m "v$ver" 
git push --tags
```


## Notes

Possible github actions to use. These seem to break often

- https://github.com/CCCC-L/Action-Ahk2Exe
    - CCCC-L/Action-Ahk2Exe@main  
- https://github.com/marketplace/actions/compile-autohotkey-script 
    - cennis91/action-ahk2exe@main
- https://github.com/tamo/action-Ahk2Exe
    - tamo/action-Ahk2Exe@main