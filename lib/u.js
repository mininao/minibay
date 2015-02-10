var sync = require('synchronize');
var inquirer = require("inquirer");
var util = require('util');

module.exports.promptSync = function promptSync(questions){
  var response;
  try {
    sync.await(inquirer.prompt(questions, sync.defer()));
  } catch (err) {
    response = err;
  }
  return response;

}

module.exports.l = function(object){
  console.log(util.inspect(object,{colors:true}))
}

module.exports.fatal = function(error){
  console.log(chalk.red(error))
  process.exit(1);
}
module.exports.cls = function() {
  process.stdout.write('\033c'); // Clear the console
}