-- 一時テーブルの作成
IF OBJECT_ID('tempdb..#TableSizes') IS NOT NULL
    DROP TABLE #TableSizes;

CREATE TABLE #TableSizes (
    DatabaseName NVARCHAR(128),
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128),
    TotalSizeMB DECIMAL(18, 2),
    UsedSizeMB DECIMAL(18, 2),
    UnusedSizeMB DECIMAL(18, 2)
);

-- 各データベースからテーブルのサイズ情報を取得し、一時テーブルに挿入
EXEC sp_MSforeachdb 
'USE [?];
INSERT INTO #TableSizes (DatabaseName, SchemaName, TableName, TotalSizeMB, UsedSizeMB, UnusedSizeMB)
SELECT 
    DB_NAME() AS DatabaseName,
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(a.total_pages) * 8 / 1024 AS TotalSizeMB,
    SUM(a.used_pages) * 8 / 1024 AS UsedSizeMB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 AS UnusedSizeMB
FROM 
    sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY 
    s.name, t.name;';

-- 統合されたレコードセットを出力
SELECT * FROM #TableSizes
ORDER BY DatabaseName, TotalSizeMB DESC;

-- 一時テーブルの削除
DROP TABLE #TableSizes;
