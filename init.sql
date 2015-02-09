 ---------------------------------------------------------------
 --        Script D'initialisation des tables  
 ---------------------------------------------------------------
 
 -- Init tables (Add them + Constraints + Foreign Keys + Auto-increments)


 -- Drop table if already exists -- see http://stackoverflow.com/questions/1799128/oracle-if-table-exists
  BEGIN -- Drop auction
     EXECUTE IMMEDIATE 'DROP TABLE AUCTION';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
 /
  BEGIN --Drop mouvement
     EXECUTE IMMEDIATE 'DROP TABLE MOUVEMENT';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
  /
  BEGIN --Drop users
     EXECUTE IMMEDIATE 'DROP TABLE USERS';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
  /
  BEGIN --Drop datation
     EXECUTE IMMEDIATE 'DROP TABLE DATATION';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
  /

-- Drop sequences
drop sequence SEQ_AUCTION_ID;
drop sequence SEQ_MOUVEMENT_ID;

  CREATE TABLE USERS (
    pseudo      VARCHAR2 (25) NOT NULL  ,
    pass        VARCHAR2 (100) NOT NULL  ,
    last_name   VARCHAR2 (100) NOT NULL  ,
    first_name  VARCHAR2 (100) NOT NULL  ,
    address     VARCHAR2 (1000) NOT NULL  ,
    email       VARCHAR2 (100)  ,
    phone       VARCHAR2 (25)  ,
    date_birth  DATE  NOT NULL  ,
    zip         NUMBER(10,0)  NOT NULL  ,
    balance     NUMBER(19, 3)  NOT NULL  ,
    CONSTRAINT USER_Pk PRIMARY KEY (pseudo)
  );
  CREATE TABLE AUCTION(
    ID             NUMBER NOT NULL ,
    name           VARCHAR2 (100) NOT NULL  ,
    description    VARCHAR2 (1000)  ,
    deadline       DATE  NOT NULL  ,
    current_price  NUMBER(19, 3)  , --null si pas encoré enchérit
    initial_price  NUMBER(19, 3)  NOT NULL  ,
    seller_pseudo         VARCHAR2 (25) NOT NULL  ,
    buyer_pseudo    VARCHAR2 (25)   ,--null si pas encoré enchérit
    CONSTRAINT AUCTION_Pk PRIMARY KEY (ID)
  );
  CREATE TABLE MOUVEMENT(
    ID              NUMBER NOT NULL ,
    description         VARCHAR2(1000),
    date_mouvement  DATE  NOT NULL  ,
    amount_received     NUMBER(19, 3)  NOT NULL ,--null if deposit
    amount_sent     NUMBER(19, 3)   ,
    commission      NUMBER(19, 3)  NOT NULL ,
    deposit   NUMBER (1) NOT NULL  ,
    receiver_pseudo    VARCHAR2 (25) NOT NULL  ,
    sender_pseudo    VARCHAR2 (25)  , --null if deposit
    CONSTRAINT MOUVEMENT_Pk PRIMARY KEY (ID) ,
    CONSTRAINT CHK_BOOLEAN_deposit CHECK (deposit IN (0,1))
  );
  CREATE TABLE datation(
    today  DATE  NOT NULL  ,
    CONSTRAINT datation_Pk PRIMARY KEY (today)
  );
  

  
  
  ALTER TABLE AUCTION ADD FOREIGN KEY (seller_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE AUCTION ADD FOREIGN KEY (buyer_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE MOUVEMENT ADD FOREIGN KEY (receiver_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE MOUVEMENT ADD FOREIGN KEY (sender_pseudo) REFERENCES USERS(pseudo);
  
  CREATE SEQUENCE Seq_AUCTION_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
  CREATE SEQUENCE Seq_MOUVEMENT_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
  
CREATE OR REPLACE TRIGGER AUCTION_ID
	BEFORE INSERT ON AUCTION 
  FOR EACH ROW 
	WHEN (NEW.ID IS NULL) 
	BEGIN
		 select Seq_AUCTION_ID.NEXTVAL INTO :NEW.ID from DUAL; 
	END;
/

CREATE OR REPLACE TRIGGER MOUVEMENT_ID
	BEFORE INSERT ON MOUVEMENT 
  FOR EACH ROW 
	WHEN (NEW.ID IS NULL) 
	BEGIN
		 select Seq_MOUVEMENT_ID.NEXTVAL INTO :NEW.ID from DUAL; 
	END;
/

-- Add Sample Data
INSERT INTO USERS(PSEUDO,PASS,FIRST_NAME,LAST_NAME,ADDRESS,ZIP,BALANCE,DATE_BIRTH) VALUES ('johnny','azerty','Johnny','Martin','78 Rue du Faubourg Saint Honoré','75001',0,to_date('23/09/1997','DD/MM/YYYY')); -- Date of birth necessary according to scpecifications

INSERT INTO USERS(PSEUDO,PASS,FIRST_NAME,LAST_NAME,ADDRESS,ZIP,BALANCE,DATE_BIRTH) VALUES ('francis','azerty','Francis','Dumas','79 Rue Francis','75002',27500,to_date('24/09/1997','DD/MM/YYYY')); -- Date of birth necessary according to scpecifications
INSERT INTO MOUVEMENT(DATE_MOUVEMENT,AMOUNT_RECEIVED,COMMISSION,DEPOSIT,RECEIVER_PSEUDO) VALUES (to_date('01/01/2013','DD/MM/YYYY'),18000,0,1,'francis');
INSERT INTO MOUVEMENT(DATE_MOUVEMENT,AMOUNT_RECEIVED,COMMISSION,DEPOSIT,RECEIVER_PSEUDO) VALUES (to_date('02/5/2013','DD/MM/YYYY'),9500,0,1,'francis');

INSERT INTO USERS(PSEUDO,PASS,FIRST_NAME,LAST_NAME,ADDRESS,ZIP,BALANCE,DATE_BIRTH) VALUES ('estelle','azerty','Estelle','Lefebvre','80 Rue Estelle','75003',30000,to_date('25/09/1997','DD/MM/YYYY')); -- Date of birth necessary according to scpecifications
INSERT INTO MOUVEMENT(DATE_MOUVEMENT,AMOUNT_RECEIVED,COMMISSION,DEPOSIT,RECEIVER_PSEUDO) VALUES (to_date('01/03/2013','DD/MM/YYYY'),30000,0,1,'estelle');

INSERT INTO AUCTION(NAME,DEADLINE,INITIAL_PRICE,SELLER_PSEUDO,BUYER_PSEUDO,CURRENT_PRICE) VALUES ('Harley Davidson',TO_DATE('25/05/2013','DD/MM/YYYY'),25000,'johnny','francis',26000); -- Date of submission not mandatory accorting to specs
INSERT INTO AUCTION(NAME,DEADLINE,INITIAL_PRICE,SELLER_PSEUDO,BUYER_PSEUDO,CURRENT_PRICE) VALUES ('Audi A3',TO_DATE('01/07/2013','DD/MM/YYYY'),12900,'francis','estelle',12900);

INSERT INTO DATATION VALUES (to_date('25/06/2013','DD/MM/YYYY'));
COMMIT;






