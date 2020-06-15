-- Trigger de INSTEAD OF - Substituir transa��o pelo conte�do do gatilho.

CREATE TRIGGER utg_verifReducImv
	ON imovel INSTEAD OF UPDATE AS
	BEGIN
		DECLARE @VALORANT FLOAT, @VALORNOVO FLOAT 
		
		SET @VALORANT = (SELECT valor FROM deleted)
		SET @VALORNOVO = (SELECT valor FROM inserted)

		IF @VALORNOVO < @VALORANT * 0.9
			BEGIN
				PRINT 'Erro! N�o pode haver redu��o superior a 10%'
				ROLLBACK
			END
		ELSE 
			BEGIN
				UPDATE imovel SET valor = @VALORNOVO 
					WHERE codImovel = (SELECT codImovel FROM inserted)
			END
	END