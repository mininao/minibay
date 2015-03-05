var config = require('./config.js');
var inquirer = require("inquirer");
var chalk = require('chalk');
var sync = require('synchronize');
var util = require('util');
var _ = require('lodash');
var oracledb = require('oracledb');
var Table = require('cli-table');
var moment = require('moment');
moment.locale('fr');

var u = require('./lib/u.js'); // utility functions

u.cls()

sync(oracledb, 'getConnection')
var answer,valid,pseudo,password;
sync.fiber(function () {
  console.log(chalk.cyan("Connecting to DB..."));

  connection = oracledb.getConnection(config.dbconfig);

  console.log(chalk.green("Connected !"));
  

  sign()
  //pseudo = "francis";
  //password="azerty";
  // Utilisateur maintenant connecté, affichage des enchères en cours
 
  
  // Let's get the database date
  
  var dbOriginalDate = sync.await(connection.execute("SELECT chabertc.today() FROM dual",{},{outFormat: oracledb.ARRAY},sync.defer())).rows[0][0]
  var dbDate = moment(dbOriginalDate);
   while(!exit) {
      u.cls()
  console.log(chalk.cyan("Bienvenue, " + pseudo + ". Voici les enchères du " + dbDate.format("Do MMMM YYYY") + ":"))
  
  var auctionTable = new Table({
    head: ['No', 'Nom','Prix actuel','Vendu par','Prix original','Temps restant']
  });

  
  var auctionList = sync.await(connection.execute("SELECT * FROM chabertc.liste_ventes",{},{outFormat: oracledb.OBJECT},sync.defer()))
  auctionList = auctionList.rows;

  
  _.each(auctionList,function(row){
    var auctionTimeLeft = moment.duration(moment(row.DEADLINE).diff(dbDate));
    if(!_.isNull(row.CURRENT_PRICE))
      auctionTable.push([row.ID,row.NAME,row.CURRENT_PRICE + " €",row.SELLER_PSEUDO,row.INITIAL_PRICE + " €",auctionTimeLeft.humanize()]);
    else
      auctionTable.push([row.ID,row.NAME,row.INITIAL_PRICE + " €",row.SELLER_PSEUDO,row.INITIAL_PRICE + " €",auctionTimeLeft.humanize()]);

  });

  console.log(auctionTable.toString());
  
  var currentBalance = sync.await(connection.execute("SELECT chabertc.balance(:pseudo,:password) FROM dual",[pseudo,password],{outFormat: oracledb.ARRAY},sync.defer())).rows[0][0]
  
  console.log(chalk.cyan("Votre compte est actuellement crédité de " + chalk.bold(currentBalance + " €")))
  
  var exit=false;
 
    answer = u.promptSync([
      {
        type: "list",
        name: "menu",
        message: "Menu principal",
        choices: ["Enchérir", "Proposer une enchère", "Mon compte" ,"Quitter"]
        }
      ]);

    if(answer.menu == "Enchérir"){
      bid(auctionList,currentBalance);
    } else if(answer.menu == "Proposer une enchère") {
      propose()
    } else if(answer.menu == "Mon compte") {
      profile()
    } else if(answer.menu == "Quitter") {
      u.cls();
      console.log(chalk.magenta.bold("Merci d'avoir utilisé minibay, à bientôt !"));
      exit = true;
    }
  }
  
});


var bid = function(auctionList,currentBalance){
  var answer = u.promptSync([{
    type:"input",
    name:"auctionId",
    message:"Sur quelle enchère voulez-vous enchérir ?",
    validate:function(no){
      var numero = parseInt(no)
      var ok = _.findIndex(auctionList, { 'ID': numero }) > -1;
      if(!ok) return "Numéro d'enchère non valide";
      else return true;
    }
  }]);
  
  var auctionId = parseInt(answer.auctionId);
  var auction = auctionList[_.findIndex(auctionList, { 'ID': auctionId })];
  var answer = u.promptSync([{
    type:"input",
    name:"price",
    message:"L'enchère coute actuellement " + chalk.bold(auction.CURRENT_PRICE + " €") + ", combien souhaitez-vous enchérir ?" ,
    validate:function(no){
      if(parseFloat(no) <= auction.CURRENT_PRICE) return "Veuillez enchérir plus que le prix actuel";
      if(parseFloat(no) > currentBalance) return "Vous ne disposez pas d'assez d'argent pour enchérir cette somme";
      return true;
    }
  }]);
  var price = parseFloat(answer.price);
  var answer = u.promptSync([{
    type:"confirm",
    name:"do",
    message:"Enchérir " + chalk.bold(price + " €") + " sur l'enchère \"" + auction.NAME +"\" ?"
  }]);
  if(answer.do) {
    var qres = sync.await(connection.execute("SELECT chabertc.bid(:pseudo,:password,:auctionid,:price) FROM dual",[pseudo,password,auctionId,price],{outFormat: oracledb.ARRAY},sync.defer())).rows[0][0]
    if(qres == 0) {
      console.log(chalk.green.bold("Vous avez enchérit avec succès !"))
    } else {
      u.fatal("Erreur inconnue lors de l'enchère.")
    }
  }
}

var propose =function(){
      var answer = u.promptSync([ // TODO : Check user input
      {type:"input",name:"name",message:"Entrez un nom pour l'enchère"},
      {type:"input",name:"price",message:"Entrez un prix"},
      {type:"input",name:"desc",message:"Entrez une description"},
      {type:"input",name:"deadline",message:"Entrez une date limite au format JJ/MM/AAAA"}
    ]);
  answer.price = parseFloat(answer.price);
  var confirm = u.promptSync([{
    type:"confirm",
    name:"do",
    message:"Créer l'enchère \"" + chalk.cyan(answer.name) + "\" à " + chalk.cyan(answer.price + " €") +  " ?"
  }]);
  if(confirm.do) {
    
    var qres = sync.await(connection.execute("SELECT chabertc.propose_auction(:pseudo,:password,:name,:description,to_date(:deadline,'DD/MM/YYYY'),:price) FROM dual",
                                             [pseudo,password,answer.name,answer.desc,answer.deadline,answer.price],{outFormat: oracledb.ARRAY},sync.defer())).rows[0][0]
    if(qres == 0) {
      console.log(chalk.green.bold("Vous avez créé une enchère avec succès !"))
    } else {
      u.fatal("Erreur inconnue lors de l'enchère.")
    }
  }
}

var profile = function(){
  var currentBalance = sync.await(connection.execute("SELECT chabertc.balance(:pseudo,:password) FROM dual",[pseudo,password],{outFormat: oracledb.ARRAY},sync.defer())).rows[0][0]
  u.cls()
  console.log(chalk.cyan("Bonjour, " + pseudo + ". Vous disposez actuellement de  " + currentBalance + " €"))
  
  var mTable = new Table({
    head: ['Type', 'Commentaire','Montant','Transféré avec','Comission de minibay','Date']
  });

  
  var mList = sync.await(connection.execute("SELECT * FROM table(chabertc.get_mouvements(:pseudo,:password))",[pseudo,password],{outFormat: oracledb.OBJECT},sync.defer()))
  mList = mList.rows;

  
  _.each(mList,function(row){
    var mDate = moment(row.DATE_MOUVEMENT);
    if(_.isNull(row.DESCRIPTION)) row.DESCRIPTION = ""
    if(row.DEPOSIT == 1)
      mTable.push(["Dépot",row.DESCRIPTION,row.AMOUNT_RECEIVED + " €","-","0 €",mDate.format("Do MMMM YYYY")]);
    else if(row.RECEIVER_PSEUDO == pseudo)
      mTable.push(["Vente",row.DESCRIPTION,row.AMOUNT_RECEIVED + " €",row.SENDER_PSEUDO,row.COMMISSION + " €",mDate.format("Do MMMM YYYY")]);
    else if(row.SENDER_PSEUDO == pseudo)
      mTable.push(["Achat",row.DESCRIPTION,(0 - row.AMOUNT_RECEIVED) + " €",row.RECEIVER_PSEUDO,"0 €",mDate.format("Do MMMM YYYY")]);

  });
  console.log(mTable.toString());
  var cont = false;
  while (!cont) {
  var confirm = u.promptSync([{
    type:"confirm",
    name:"do",
    message:"Retour au menu principal ?"
  }]);
  if(confirm.do) {
    cont = true;
  }
  }

}

var sign = function(){
  answer = u.promptSync([
    {
      type: "list",
      name: "sign",
      message: "Bienvenue dans minibay !",
      choices: ["Connexion", "Inscription"]
      }
    ]);
  valid = false;
  if(answer.sign == "Connexion") {
    while(!valid) {
      pseudo = u.promptSync([{type:"input",name:"pseudo",message:"Quel est votre nom d'utilisateur ?"}]).pseudo;
      //valisate pseudo
      var qres = sync.await(connection.execute("SELECT chabertc.signin(:pseudo,null) FROM dual",{pseudo:pseudo},{outFormat: oracledb.ARRAY},sync.defer()))
      valid = qres.rows[0][0] == 2;
      if(!valid) console.log(chalk.red("Ce nom d'utilisateur n'existe pas"))
    }
    valid = false;
    while(!valid) {
      password = u.promptSync([{type:"password",name:"password",message:"Quel est votre mot de passe"}]).password;
      //valisate pseudo
      var qres = sync.await(connection.execute("SELECT chabertc.signin(:pseudo,:password) FROM dual",{pseudo:pseudo,password:password},{outFormat: oracledb.ARRAY},sync.defer()))
      valid = qres.rows[0][0] == 0;
      if(!valid) console.log(chalk.red("Ce mot de passe est incorrect"))
    }
    console.log(chalk.green("Connexion réussie !"))
    
  } else {
    answer = u.promptSync([ // TODO : Check user input, filter email&phone to null if empty
      {type:"input",name:"pseudo",message:"Nom d'utilisateur",validate:function(pseudo){
        var done = this.async();
        connection.execute("SELECT chabertc.signin(:pseudo,null) FROM dual",{pseudo:pseudo},{outFormat: oracledb.ARRAY},function(err,qres){
          var pseudok = qres.rows[0][0] != 2;
          if(!pseudok)
            done("Pseudo déjà utilisé");
          else
            done(true);
        });
      }},
      {type:"password",name:"password",message:"Mot de passe"},
      {type:"input",name:"firstName",message:"Prénom"},
      {type:"input",name:"lastName",message:"Nom"},
      {type:"input",name:"address",message:"Adresse du domicile"},
      {type:"input",name:"zip",message:"Code postal du domicile"},
      {type:"input",name:"dob",message:"Date de naissance au format JJ/MM/AAAA"},
      {type:"input",name:"email",message:"Email (facultatif)"},
      {type:"input",name:"phone",message:"Numéro de téléhpone (facultatif)"}
    ]);
/*    answer = { pseudo: 'gege',
  password: 'gegepass',
  firstName: 'gerard',
  lastName: 'boubou',
  address: '14 re',
  zip: '44500',
  dob: '13/02/1990',
  email: '',
  phone: '' };*/
    pseudo = answer.pseudo;
    password = answer.password;
    //Insertion en bdd
    var qres = sync.await(connection.execute("SELECT chabertc.signup(:pseudo,:password,:firstName,:lastName,:adress,to_date(:dateOfBirth,'DD/MM/YYYY'),:ZIP,:email,:phone) FROM dual",
                                             [answer.pseudo, answer.password, answer.firstName, answer.lastName, answer.address, answer.dob, answer.zip, answer.email, answer.phone],
                                             {outFormat: oracledb.ARRAY},sync.defer()));
    if(qres.rows[0][0] == 0) 
      console.log(chalk.green("Inscription réussie, vous êtes maintenant connecté !"))
    else {
      u.fatal("Erreur d'inscription inconnue :(");
    }
  }  
}