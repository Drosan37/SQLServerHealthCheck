USE [<DBName, VARCHAR(200),DBName>];

SELECT 
	*
FROM
(
	SELECT 
		  frk.name AS ForeignKey
		, SCHEMA_NAME(frk.schema_id) AS SchemaName
		, OBJECT_NAME(frk.parent_object_id) AS TableName	
		, col.name AS ColumnName 
		, OBJECT_NAME(frk.referenced_object_id) AS TableNameRef
		, col2.name AS ColumnNameRef
	FROM sys.foreign_keys frk
	INNER JOIN sys.foreign_key_columns fcl
		ON frk.object_id = fcl.constraint_object_id
	INNER JOIN sys.columns col
		ON frk.parent_object_id = col.object_id
		AND fcl.parent_column_id = col.column_id
	INNER JOIN sys.columns col2
		ON frk.referenced_object_id = col2.object_id
		AND fcl.referenced_column_id = col2.column_id
	WHERE frk.Referenced_object_id = OBJECT_ID('<Schema.Table,VARCHAR(200),Schema.Table>','U')
) tbl
;
