-------------------------------------------------------------
-- Logique Stockée des enchères ()
-------------------------------------------------------------

-- propose_auction(pseudo,password,name,description,deadline,initialPrice)
-- returns 0 if successful
-- returns 1 if wrong pseudo/password combination
-- returns 2 if unknown error
CREATE OR REPLACE FUNCTION propose_auction(pseudo IN VARCHAR2, pass IN VARCHAR2,name IN VARCHAR2, description IN VARCHAR2 DEFAULT NULL,deadline_string IN VARCHAR2, initialPrice  IN NUMBER) RETURN INTEGER AS
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  If signin(pseudo,pass) = 1 Then
    RETURN 1;
  End If;
  INSERT INTO AUCTION(SELLER_PSEUDO,NAME,DESCRIPTION,DEADLINE,INITIAL_PRICE) VALUES (pseudo,name,description,to_date(deadline_string),initialPrice);
  
  
  COMMIT;
  RETURN 0;
  
  EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line(SQLCODE);
  dbms_output.put_line(SQLERRM);
  RETURN 2;
END;
/

-- bid(pseudo,password,AuctionID,Price)
-- returns 0 if successful
-- returns 1 if wrong pseudo/password combination
-- returns 2 if proposed price too low
-- returns 3 if auction already ended
-- returns 4 if unknown error
CREATE OR REPLACE FUNCTION bid(pseudo IN VARCHAR2, pass IN VARCHAR2,name IN VARCHAR2, auction_id IN VARCHAR2 DEFAULT NULL, price  IN NUMBER) RETURN INTEGER AS
minimum_price UMBER(19, 3);
todate DATE;
auction_deadline DATE;
BEGIN
  If signin(pseudo,pass) = 1 Then
    RETURN 1;
  End If;
  
  SELECT current_price INTO minimum_price FROM auction WHERE ID=auction_id;
  If minimum_price IS NULL Then
    SELECT initial_price INTO minimum_price FROM auction WHERE ID=auction_id;
    minimum_price := minimum_price -1;
  End If;
  
  If (price
  
  SELECT today INTO todate FROM datation;
  SELECT deadline INTO auction_deadline FROM auction WHERE ID=auction_id;
  If todate > auction_deadline Then
    Return 3;
  End If;
  
  INSERT INTO AUCTION(SELLER_PSEUDO,NAME,DESCRIPTION,DEADLINE,INITIAL_PRICE) VALUES (pseudo,name,description,to_date(deadline_string),price);
  
  
  COMMIT;
  RETURN 0;
  
  EXCEPTION
  WHEN OTHERS THEN
  dbms_output.put_line(SQLCODE);
  dbms_output.put_line(SQLERRM);
  RETURN 2;
END;
/