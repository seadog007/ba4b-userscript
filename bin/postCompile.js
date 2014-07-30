var path = require('path');
var fs = require('fs');
var head = fs.readFileSync(['src', 'ba4b-userscript.head'].join(path.sep)).toString();
var version = JSON.parse(fs.readFileSync('package.json')).version;
var body = fs.readFileSync(['dist', 'ba4b-userscript.js'].join(path.sep)).toString();
var body_min = fs.readFileSync(['dist', 'ba4b-userscript_min.js'].join(path.sep)).toString();
head = head.replace('{{version}}', version)

var file = head + '\n\n' + body;
var file_min = head + '\n\n' + body_min;

fs.writeFileSync(['dist', 'ba4b-userscript.user.js'].join(path.sep), file);
fs.writeFileSync(['dist', 'ba4b-userscript_min.user.js'].join(path.sep), file_min);