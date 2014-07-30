#!/bin/bash

version=$(node bin/version.js)

url=https://github.com/ba4b/ba4b-userscript

if [ -f node_modules/commonjs-everywhere/lib/command.js ];then
    echo Packaging ba4b-userscript.js ${version}
    nodejs node_modules/commonjs-everywhere/lib/command.js \
        --export ba4b \
        --root src/ \
        --source-map dist/ba4b-userscript.js.map \
        --output dist/ba4b-userscript.js \
        --inline-sources \
        ba4b-userscript.coffee
    echo -e "\n" >> dist/ba4b-userscript.js
    echo -n // ba4b-userscript.js ${version} ${url} >> dist/ba4b-userscript.js
    
    nodejs bin/postCompile.js 
    
    echo build done!
else
    echo Dependencies missing. Run npm install
fi