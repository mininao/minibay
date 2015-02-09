-----------------------------
-- Script testant toutes les procédures
-- IMPORTANT : éxécuter init.sql avant ET après toute utilisation de ce script
-----------------------------


set serveroutput on;
 
DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Signin test: should return 0');
  SELECT chabertc.signin('francis','azerty') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/

DECLARE
  output INTEGER;
BEGIN
  dbms_output.put_line('1. Signin test: should return 1');
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