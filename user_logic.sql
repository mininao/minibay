-------------------------------------------------------------
-- Logique Stockée des utilisateurs (Connexion & Inscription)
-------------------------------------------------------------

-- signin(Pseudo,Password)
-- returns 0 if successful
-- returns 1 if pseudo or password not found
CREATE OR REPLACE FUNCTION signin(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
useless VARCHAR2(25);
BEGIN
  SELECT pseudo INTO useless FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
  RETURN 0;
  EXCEPTION
  WHEN no_data_found THEN
  RETURN 1;
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
  RETURN 2;
END;
/