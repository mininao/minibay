REVOKE ALL ON AUCTION FROM aicim;
REVOKE ALL ON MOUVEMENT FROM aicim;
REVOKE ALL ON USERS FROM aicim;
REVOKE ALL ON DATATION FROM aicim;

-- GRANT CONNECT TO aicim;
GRANT EXECUTE ON signin TO aicim;
GRANT EXECUTE ON signup TO aicim;
REVOKE EXECUTE ON transfer FROM aicim;
GRANT EXECUTE ON propose_auction TO aicim;
GRANT SELECT ON liste_ventes TO aicim;
--GRANT EXECUTE ANY PROCEDURE TO aicim;