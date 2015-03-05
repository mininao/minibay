-----------------------------
-- Script testant toutes les procédures
-- IMPORTANT : éxécuter init.sql avant ET après toute utilisation de ce script
-----------------------------


set serveroutput on;
 
 
 -- USER_LOGIC.SQL TESTS
 -- singup, signin
DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('-------- BEGIN TESTS --------');
  dbms_output.put_line('1. Signin test: should return 0');
  SELECT chabertc.signin('francis','azerty') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Signin test: should return 1');
  SELECT chabertc.signin('fransssscis','papapapa') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Signin test: should return 2');
  SELECT chabertc.signin('francis','papapapa') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Signup test: should return 0');
  SELECT chabertc.signup('tester','azertest','Gerard','Dumont','190 Rue du cheval',to_date('22/12/1902','DD/MM/YYYY'),93250,'tester@example.com','0123456789') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Signup test: should return 1');
  SELECT chabertc.signup('tester','x','x','x','x',to_date('22/12/1902','DD/MM/YYYY'),93250,'x@x.x','x') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Signup test: should return 0');
  SELECT chabertc.signup('tester2','x','x','x','x',to_date('22/12/1902','DD/MM/YYYY'),93250) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/


DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('3. Balance test: should return 27500');
  SELECT chabertc.balance('francis','azerty') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('3. Balance test: should return -1');
  SELECT chabertc.balance('francis','pipo') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output user_profile;
BEGIN
  dbms_output.put_line('4. Profile test: should return "francis et 79 Rue Francis  et 75002"');
  SELECT chabertc.profile('francis') INTO output FROM dual;
  dbms_output.put_line(output.pseudo || ' et ' || output.address || '  et ' || output.zip);
END;
/


 -- AUCTION_LOGIC.SQL TESTS
 -- 
 
 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Propose Auction test: should return 0');
  SELECT chabertc.propose_auction('francis','azerty','Bouteille de coca','Bouteille originale dessinée par picasso','15/6/2015',1000) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 
 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Bid test: should return 0');
  SELECT chabertc.bid('estelle','azerty',1,30000) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Bid test: should return 1');
  SELECT chabertc.bid('estelle','xxxx',1,30000) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Bid test: should return 2');
  SELECT chabertc.bid('estelle','azerty',1,200) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Bid test: should return 4');
  SELECT chabertc.bid('estelle','azerty',99999,30000) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('2. Bid test: should return 5');
  SELECT chabertc.bid('estelle','azerty',1,999999) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

-- Test view liste_ventes
SELECT * FROM chabertc.liste_ventes;

  -- MONEY_LOGIC.SQL TESTS
 -- 
 
 DECLARE -- TEST TO BE TESTED AS DBA
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Transfer test: should return 0 | EXECUTE AS DBA');
  SELECT chabertc.transfer('estelle','francis','description du transfert',500) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

 DECLARE -- TEST TO BE TESTED AS DBA
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Transfer test: should return 0 | EXECUTE AS DBA');
  SELECT chabertc.transfer('francis','estelle','description du transfert',1000) INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

BEGIN
  dbms_output.put_line('2. Mouvements list test : should return the list of franciss mouvements');
END;
/
SELECT * FROM table(chabertc.get_mouvements('francis','azerty'));