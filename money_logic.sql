--------------------------------------------------------------------
-- Logique Stockée des transferts d'argent (Dépot - Transfert)
--------------------------------------------------------------------


-- transfer(receiver,sender,description,amount_sent)
-- returns 0 if successful
-- return 1 if sender has'nt enough money
-- returns 2 if unknown error
CREATE OR REPLACE FUNCTION transfer(receiver IN VARCHAR2, sender IN VARCHAR2, description IN VARCHAR2 DEFAULT NULL, amount  IN NUMBER) RETURN INTEGER AS
PRAGMA AUTONOMOUS_TRANSACTION;
commission NUMBER(19, 3);
amount_received NUMBER(19, 3);
todate DATE;
sender_balance NUMBER(19, 3);
receiver_balance NUMBER(19, 3);
BEGIN
  Select balance Into sender_balance From USERS Where PSEUDO=sender;
  Select balance Into receiver_balance From USERS Where PSEUDO=receiver;
  -- Check sender has enough
  If sender_balance < amount Then
    Return 1;
  End If;
  
  -- Calculate commission
  commission := 4 + 0.0025 * amount;
  amount_received := amount - commission; -- TOFIX : less than 4 euros auctions
  
  --Update money movements records
  SELECT today INTO todate FROM datation;
  INSERT INTO MOUVEMENT(RECEIVER_PSEUDO,SENDER_PSEUDO,DESCRIPTION,DATE_MOUVEMENT,DEPOSIT,AMOUNT_SENT,AMOUNT_RECEIVED,COMMISSION) VALUES (receiver,sender,description,todate,0,amount,amount_received,commission);
  
  --Update user's balance --TOFIX: Possibilité d'erreurs en cas de mouvements d'argents en parallèle
  Update USERS Set balance=(receiver_balance + amount_received) Where PSEUDO=receiver;
  Update USERS Set balance=(sender_balance + amount) Where PSEUDO=sender;
  
  COMMIT;
  RETURN 0;
  EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line(SQLCODE);
  dbms_output.put_line(SQLERRM);
  RETURN 2;
END;
/

-- deposit(Pseudo,Password,Amout) NOT MANDATORY IN SPECS
-- returns 0 if successful
-- returns 1 if unknown error
--CREATE OR REPLACE FUNCTION deposit(upseudo IN VARCHAR2, upass IN VARCHAR2) RETURN INTEGER AS
--PRAGMA AUTONOMOUS_TRANSACTION;
--BEGIN
--  SELECT pseudo INTO useless FROM USERS WHERE PSEUDO=upseudo AND PASS=upass;
--  RETURN 0;
--  EXCEPTION
--  WHEN others THEN
--  RETURN 1;
--END;
--/
