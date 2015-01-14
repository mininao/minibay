 ---------------------------------------------------------------
 --        Script Oracle.  
 ---------------------------------------------------------------
drop table AUCTION cascade constraint purge;
drop table BID cascade constraint purge;
drop table USERS cascade constraint purge;

drop sequence MOUVEMENT_ID;
drop sequence AUCTION_ID;
drop sequence BID_ID;
CREATE TABLE USERS(
	pseudo      VARCHAR2 (25) NOT NULL  ,
	pass        VARCHAR2 (25) NOT NULL  ,
	last_name   VARCHAR2 (25) NOT NULL  ,
	first_name  VARCHAR2 (25) NOT NULL  ,
	address     VARCHAR2 (25) NOT NULL  ,
	email       VARCHAR2 (25)  ,
	phone       VARCHAR2 (25)  ,
	zip         NUMBER(10,0)  NOT NULL  ,
	date_birth  DATE  NOT NULL  ,
	balance     NUMBER(19, 3)  NOT NULL  ,
	CONSTRAINT USERS_Pk PRIMARY KEY (pseudo)
);
CREATE TABLE AUCTION(
	ID             NUMBER NOT NULL ,
	name           VARCHAR2 (25) NOT NULL  ,
	description    VARCHAR2 (25)  ,
	deadline       DATE  NOT NULL  ,
	current_price  NUMBER(19, 3)  NOT NULL  ,
	initial_price  NUMBER(19, 3)  NOT NULL  ,
	seller_pseudo  VARCHAR2 (25) NOT NULL  ,
	CONSTRAINT AUCTION_Pk PRIMARY KEY (ID)
);
CREATE TABLE BID(
	ID          NUMBER NOT NULL ,
	price       NUMBER(10,0)  NOT NULL  ,
	auction_ID  NUMBER(10,0)  NOT NULL  ,
	active      NUMBER (1) NOT NULL  ,
	ID_AUCTION  NUMBER(10,0)  NOT NULL  ,
	bidder_pseudo      VARCHAR2 (25) NOT NULL  ,
	CONSTRAINT BID_Pk PRIMARY KEY (ID) ,
	CONSTRAINT CHK_BOOLEAN_active CHECK (active IN (0,1))
);
CREATE TABLE MOUVEMENT(
	ID              NUMBER NOT NULL ,
	comment         VARCHAR2 (25)  ,
	date_mouvement  DATE  NOT NULL  ,
	amout_taken     NUMBER(10,0)  NOT NULL  ,
	amout_given     NUMBER(10,0)  NOT NULL  ,
	commission      NUMBER(10,0)  NOT NULL  ,
	wire_transfer   NUMBER (1) NOT NULL  ,
	to_pseudo         VARCHAR2 (25) NOT NULL  ,
	from_pseudo     VARCHAR2 (25) NOT NULL  ,
	CONSTRAINT MOUVEMENT_Pk PRIMARY KEY (ID) ,
	CONSTRAINT CHK_BOOLEAN_wire_transfer CHECK (wire_transfer IN (0,1))
);




ALTER TABLE AUCTION ADD FOREIGN KEY (seller_pseudo) REFERENCES USERS(pseudo);
ALTER TABLE BID ADD FOREIGN KEY (ID_AUCTION) REFERENCES AUCTION(ID);
ALTER TABLE BID ADD FOREIGN KEY (bidder_pseudo) REFERENCES USERS(pseudo);
ALTER TABLE MOUVEMENT ADD FOREIGN KEY (to_pseudo) REFERENCES USERS(pseudo);
ALTER TABLE MOUVEMENT ADD FOREIGN KEY (from_pseudo) REFERENCES USERS(pseudo);

CREATE SEQUENCE Seq_AUCTION_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_BID_ID START WITH 1 INCREMENT BY 1 NOCYCLE;
CREATE SEQUENCE Seq_MOUVEMENT_ID START WITH 1 INCREMENT BY 1 NOCYCLE;


CREATE OR REPLACE TRIGGER AUCTION_ID
	BEFORE INSERT ON AUCTION 
  FOR EACH ROW 
	WHEN (NEW.ID IS NULL) 
	BEGIN
		 select Seq_AUCTION_ID.NEXTVAL INTO :NEW.ID from DUAL; 
	END;
/
CREATE OR REPLACE TRIGGER BID_ID
	BEFORE INSERT ON BID 
  FOR EACH ROW 
	WHEN (NEW.ID IS NULL) 
	BEGIN
		 select Seq_BID_ID.NEXTVAL INTO :NEW.ID from DUAL; 
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

COMMIT;
