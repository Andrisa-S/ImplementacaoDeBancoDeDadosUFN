CREATE DATABASE DB_Temporal;

GO
USE DB_Temporal;

CREATE TABLE Inventario_Carros(
	id INT IDENTITY PRIMARY KEY,
	Ano INT,
	Marca VARCHAR(40),
	Modelo VARCHAR(40),
	Cor VARCHAR(10),
	Quilometragem INT,
	Disponivel BIT NOT NULL DEFAULT 1,
	--Diferenças:
	SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH
(
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.InventarioCarros)
)