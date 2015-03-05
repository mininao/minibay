var oracledb = require('oracledb');

var connect = function(dbconfig) {
  
}
module.exports.connect = connect;

var function executeSync(connection,sql,bindParams,options){
    var res
      sync.fiber(function () {
        var toto = sync.await(connection.execute("SELECT chabertc.signin(:pseudo,null) FROM dual",{pseudo:pseudo},{outFormat: oracledb.OBJECT},sync.defer()))
      });
}
//var toto = sync.await(connection.execute("SELECT chabertc.signin(:pseudo,null) INTO output FROM dual",{pseudo:pseudo},{outFormat: oracledb.OBJECT},sync.defer()))