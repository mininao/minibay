-------------------------------------------------------------
-- Logique Stockée des utilisateurs (Connexion & Inscription)
-------------------------------------------------------------

--datation
Create Or Replace Function today Return DATE AS
todate DATE;
BEGIN
SELECT today INTO todate FROM datation WHERE ROWNUM <= 1;
return todate;
END;
/

-- signin(Pseudo,Password)
-- returns 0 if successful
-- returns 1 if pseudo is incorrect
-- returns 2 if pass is incorrect
CREATE OR REPLACE FUNCTION signin(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
useless VARCHAR2(25);
pc INTEGER;
BEGIN
  SELECT count(pseudo) INTO pc FROM USERS WHERE PSEUDO=upseudo;
  If pc = 0 Then
    Return 1;
  End If;
  SELECT pseudo INTO useless FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
  RETURN 0;
  EXCEPTION
  WHEN no_data_found THEN
  RETURN 2;
END;
/

-- signup(Pseudo,Password,FirstName,LastName,Adress,DateOfBirth,ZIP[,Email,Phone])
-- returns 0 if successful
-- returns 1 if pseudo already in use
-- returns 2 if other error
CREATE OR REPLACE FUNCTION signup(uPseudo IN VARCHAR2, uPass IN VARCHAR2, uFirst_name IN VARCHAR2, uLast_name IN VARCHAR2, uAddress IN VARCHAR2, uDate_birth IN DATE, uZip IN NUMBER, uEmail IN VARCHAR2 DEFAULT null, uPhone  IN VARCHAR2 DEFAULT null) RETURN INTEGER AS

PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

  INSERT INTO USERS(PSEUDO,PASS,FIRST_NAME,LAST_NAME,ADDRESS,ZIP,BALANCE,DATE_BIRTH,EMAIL,PHONE) VALUES (uPseudo,uPass,uFirst_name,uLast_name,uAddress,uZip,0,uDate_birth,uEmail,uPhone);
  COMMIT;
  
  RETURN 0;
  EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
  RETURN 1;
  WHEN OTHERS THEN
  dbms_output.put_line(SQLCODE);
  dbms_output.put_line(SQLERRM);
  RAISE;
  RETURN 2;
END;
/

-- balance(Pseudo,Password)
-- returns balance if user is found
-- returns -1 if pseudo or password not found
-- returns -2 if unknown error
CREATE OR REPLACE FUNCTION balance(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
ubalance NUMBER(19, 3);
BEGIN
  SELECT balance INTO ubalance FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
  RETURN ubalance;
  EXCEPTION
  WHEN no_data_found THEN
  RETURN -1;
  WHEN OTHERS THEN
  dbms_output.put_line(SQLCODE);
  dbms_output.put_line(SQLERRM);
  RETURN -2;  
END;
/


--- VIEWS (Ou fonctions retournant des collections)
Create Or Replace Type user_profile as object (
    pseudo      VARCHAR2 (25),
    pass        VARCHAR2 (100),
    last_name   VARCHAR2 (100),
    first_name  VARCHAR2 (100),
    address     VARCHAR2 (1000),
    email       VARCHAR2 (100)  ,
    phone       VARCHAR2 (25)  ,
    date_birth  DATE ,
    zip         NUMBER(10,0)  ,
    balance     NUMBER(19, 3)
);
/

-- profile(Pseudo,Password)
-- returns profile object
CREATE OR REPLACE FUNCTION profile(upseudo IN VARCHAR2) RETURN user_profile AS
uprofile user_profile;
BEGIN
  SELECT user_profile(USERS.pseudo, USERS.pass, USERS.last_name, USERS.first_name, USERS.address, USERS.email, USERS.phone, USERS.date_birth, USERS.zip, USERS.balance) INTO uprofile FROM USERS WHERE PSEUDO=upseudo;
  RETURN uprofile;
  EXCEPTION
  WHEN no_data_found THEN
  RETURN user_profile(null, null, null, null, null, null, null, null, null, null);
END;
/