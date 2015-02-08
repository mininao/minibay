 ---------------------------------------------------------------
 --        Script D'initialisation des tables  
 ---------------------------------------------------------------
 
 -- Init tables procedure (Add them + Constraints + Foreign Keys + Auto-increments)


 -- Drop table if already exists -- see http://stackoverflow.com/questions/1799128/oracle-if-table-exists
  BEGIN
     EXECUTE IMMEDIATE 'DROP TABLE AUCTION';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
 
  BEGIN --Drop bid
     EXECUTE IMMEDIATE 'DROP TABLE BID';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;

  BEGIN --Drop users
     EXECUTE IMMEDIATE 'DROP TABLE USERS';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
  
  BEGIN --Drop datation
     EXECUTE IMMEDIATE 'DROP TABLE DATATION';
  EXCEPTION
     WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
           RAISE;
        END IF;
  END;
  
  CREATE TABLE USERS (
    pseudo      VARCHAR2 (25) NOT NULL  ,
    pass        VARCHAR2 (25) NOT NULL  ,
    last_name   VARCHAR2 (25) NOT NULL  ,
    first_name  VARCHAR2 (25) NOT NULL  ,
    address     VARCHAR2 (25) NOT NULL  ,
    email       VARCHAR2 (25)  ,
    phone       VARCHAR2 (25)  ,
    date_birth  DATE  NOT NULL  ,
    zip         NUMBER(10,0)  NOT NULL  ,
    balance     NUMBER(19, 3)  NOT NULL  ,
    CONSTRAINT USER_Pk PRIMARY KEY (pseudo)
  );
  CREATE TABLE AUCTION(
    ID             NUMBER NOT NULL ,
    name           VARCHAR2 (25) NOT NULL  ,
    description    VARCHAR2 (25)  ,
    deadline       DATE  NOT NULL  ,
    current_price  NUMBER(19, 3)  NOT NULL  ,
    initial_price  NUMBER(19, 3)  NOT NULL  ,
    seller_pseudo         VARCHAR2 (25) NOT NULL  ,
    buyer_pseudo    VARCHAR2 (25) NOT NULL  ,
    CONSTRAINT AUCTION_Pk PRIMARY KEY (ID)
  );
  CREATE TABLE MOUVEMENT(
    ID              NUMBER NOT NULL ,
    acomment         VARCHAR2 (25)   ,
    date_mouvement  DATE  NOT NULL  ,
    amout_taken     NUMBER(19, 3)   ,
    amout_given     NUMBER(19, 3)  NOT NULL  ,
    commission      NUMBER(19, 3)  NOT NULL  ,
    wire_transfer   NUMBER (1) NOT NULL  ,
    taker_pseudo    VARCHAR2 (25) NOT NULL  ,
    giver_pseudo    VARCHAR2 (25) NOT NULL  ,
    CONSTRAINT MOUVEMENT_Pk PRIMARY KEY (ID) ,
    CONSTRAINT CHK_BOOLEAN_wire_transfer CHECK (wire_transfer IN (0,1))
  );
  CREATE TABLE datation(
    today  DATE  NOT NULL  ,
    CONSTRAINT datation_Pk PRIMARY KEY (today)
  );
  

  
  
  ALTER TABLE AUCTION ADD FOREIGN KEY (seller_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE AUCTION ADD FOREIGN KEY (buyer_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE MOUVEMENT ADD FOREIGN KEY (taker_pseudo) REFERENCES USERS(pseudo);
  ALTER TABLE MOUVEMENT ADD FOREIGN KEY (giver_pseudo) REFERENCES USERS(pseudo);
  
  CREATE SEQUENCE Seq_AUCTION_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
  CREATE SEQUENCE Seq_MOUVEMENT_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
  
  

COMMIT;






