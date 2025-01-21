-- 一時テーブルを作成して結果を格納
CREATE TABLE #TableSizes (
    DatabaseName NVARCHAR(128),
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128),
    RowCounts BIGINT,
    DataSizeMB FLOAT,
    IndexSizeMB FLOAT,
    TotalSizeMB FLOAT
);

-- すべてのデータベースに対してテーブルサイズを取得
EXEC sp_MSforeachdb '
USE [?];
IF DB_ID(''?'') > 4 -- システムデータベースを除外
BEGIN
    INSERT INTO #TableSizes
    SELECT
        DB_NAME() AS DatabaseName,
        s.name AS SchemaName,
        t.name AS TableName,
        p.rows AS RowCounts,
        CAST(au.data_pages * 8 / 1024.0 AS FLOAT) AS DataSizeMB,
        CAST((au.used_pages - au.data_pages) * 8 / 1024.0 AS FLOAT) AS IndexSizeMB,
        CAST(au.used_pages * 8 / 1024.0 AS FLOAT) AS TotalSizeMB
    FROM
        sys.tables t
    INNER JOIN
        sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN
        sys.indexes i ON t.object_id = i.object_id AND i.type <= 1
    INNER JOIN
        sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN
        sys.allocation_units au ON p.partition_id = au.container_id
    WHERE
        t.is_ms_shipped = 0 -- システムテーブルを除外
    GROUP BY
        s.name, t.name, p.rows, au.data_pages, au.used_pages
END
';

-- 結果を表示
SELECT *
FROM #TableSizes
ORDER BY DatabaseName, SchemaName, TableName;

-- 一時テーブルを削除
DROP TABLE #TableSizes;
