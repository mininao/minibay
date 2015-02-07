#------------------------------------------------------------
#        Script MySQL.
#------------------------------------------------------------


CREATE TABLE USER(
        pseudo     Varchar (25) NOT NULL ,
        pass       Varchar (25) NOT NULL ,
        last_name  Varchar (25) NOT NULL ,
        first_name Varchar (25) NOT NULL ,
        address    Varchar (25) NOT NULL ,
        email      Varchar (25) ,
        phone      Varchar (25) ,
        date_birth Date NOT NULL ,
        zip        Int NOT NULL ,
        balance    DECIMAL (15,3)  NOT NULL ,
        PRIMARY KEY (pseudo )
)ENGINE=InnoDB;


CREATE TABLE AUCTION(
        ID            int (11) Auto_increment  NOT NULL ,
        name          Varchar (25) NOT NULL ,
        description   Varchar (25) ,
        deadline      Date NOT NULL ,
        current_price DECIMAL (15,3)  NOT NULL ,
        initial_price DECIMAL (15,3)  NOT NULL ,
        pseudo        Varchar (25) NOT NULL ,
        pseudo_USER   Varchar (25) NOT NULL ,
        PRIMARY KEY (ID )
)ENGINE=InnoDB;


CREATE TABLE MOUVEMENT(
        ID             int (11) Auto_increment  NOT NULL ,
        comment        Varchar (25) ,
        date_mouvement Date NOT NULL ,
        amout_taken    DECIMAL (15,3)  NOT NULL ,
        amout_given    DECIMAL (15,3)  NOT NULL ,
        commission     DECIMAL (15,3)  NOT NULL ,
        wire_transfer  Bool NOT NULL ,
        pseudo         Varchar (25) NOT NULL ,
        pseudo_USER    Varchar (25) NOT NULL ,
        PRIMARY KEY (ID )
)ENGINE=InnoDB;

ALTER TABLE AUCTION ADD CONSTRAINT FK_AUCTION_pseudo FOREIGN KEY (pseudo) REFERENCES USER(pseudo);
ALTER TABLE AUCTION ADD CONSTRAINT FK_AUCTION_pseudo_USER FOREIGN KEY (pseudo_USER) REFERENCES USER(pseudo);
ALTER TABLE MOUVEMENT ADD CONSTRAINT FK_MOUVEMENT_pseudo FOREIGN KEY (pseudo) REFERENCES USER(pseudo);
ALTER TABLE MOUVEMENT ADD CONSTRAINT FK_MOUVEMENT_pseudo_USER FOREIGN KEY (pseudo_USER) REFERENCES USER(pseudo);
