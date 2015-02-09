set serveroutput on;
DECLARE
  output INTEGER;
BEGIN
  SELECT chabertc.check_user('francis','azerty') INTO output FROM dual;
  dbms_output.put_line(output);
END;
/