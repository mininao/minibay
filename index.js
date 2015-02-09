var oracledb = require('oracledb');

oracledb.getConnection(
  {
    user          : "chabertc",
    password      : "charlene2014",
    connectString : "localhost:1521"
  },
  function(err, connection)
  {
    if (err) {
      console.error(err.message);
      return;
    }
    console.log("Connexion successful");
  });