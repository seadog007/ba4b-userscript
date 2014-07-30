@echo off

node bin/version.js >> temp.txt
set version= < temp.txt
del temp.txt

set url=https://github.com/ba4b/ba4b-userscript

if exist node_modules/commonjs-everywhere/lib/command.js (
    echo Packaging ba4b-userscript.js %version%
    node node_modules/commonjs-everywhere/lib/command.js ^
        --export ba4b ^
        --root src/ ^
        --source-map dist/ba4b-userscript.js.map ^
        --output dist/ba4b-userscript.js ^
        --inline-sources ^
        ba4b-userscript.coffee
    echo. >> dist\ba4b-userscript.js
    echo // ba4b-userscript.js %version% %url% >> dist\ba4b-userscript.js
    
    
    node node_modules/commonjs-everywhere/lib/command.js ^
        --export ba4b ^
        --root src/ ^
        --source-map dist/ba4b-userscript_min.js.map ^
        --output dist/ba4b-userscript_min.js ^
        --inline-sources ^
        --minify ^
        ba4b-userscript.coffee
    echo. >> dist\ba4b-userscript_min.js
    echo // ba4b-userscript.js %version% %url% >> dist\ba4b-userscript_min.js
    
    node bin\postCompile.js 
    
    echo build done!
) else (
    echo Dependencies missing. Run npm install
)