CREATE OR REPLACE FUNCTION check_user(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
useless VARCHAR2(25);
BEGIN
  SELECT pseudo INTO useless FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
  IF SQL%NOTFOUND THEN
    RETURN 0;
  ELSE
    RETURN 1;
  END IF;
END;
/

CREATE OR REPLACE FUNCTION check_user(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
useless VARCHAR2(25);
BEGIN
  SELECT pseudo INTO useless FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
  IF SQL%NOTFOUND THEN
    RETURN 0;
  ELSE
    RETURN 1;
  END IF;
END;
/