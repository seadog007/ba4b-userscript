var path = require('path');
var fs = require('fs');
var head = fs.readFileSync(['src', 'ba4b-userscript.head'].join(path.sep)).toString();
var version = JSON.parse(fs.readFileSync('package.json')).version;
var body = fs.readFileSync(['dist', 'ba4b-userscript.js'].join(path.sep)).toString();

head = head.replace('{{version}}', version)
var file = head + '\n\n' + body;

fs.writeFileSync(['dist', 'ba4b-userscript.user.js'].join(path.sep), file);