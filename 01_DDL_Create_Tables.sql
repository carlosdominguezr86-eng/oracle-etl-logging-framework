-- ============================================================================
-- SCRIPT: CREACIÓN DE TABLAS DE AUDITORÍA Y CONTROL DE ERRORES EN ORACLE
-- ============================================================================

CREATE TABLE etl_process_execution_log (
    execution_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    process_name       VARCHAR2(100) NOT NULL,
    source_system      VARCHAR2(50),
    target_system      VARCHAR2(50),
    start_time         TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    end_time           TIMESTAMP,
    status             VARCHAR2(20) DEFAULT 'RUNNING' CHECK (status IN ('RUNNING', 'SUCCESS', 'FAILED', 'WARNING')),
    rows_inserted      NUMBER DEFAULT 0,
    rows_updated       NUMBER DEFAULT 0,
    rows_deleted       NUMBER DEFAULT 0,
    rows_rejected      NUMBER DEFAULT 0,
    user_name          VARCHAR2(50) DEFAULT USER
);

CREATE TABLE etl_error_log (
    error_id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    execution_id       NUMBER REFERENCES etl_process_execution_log(execution_id),
    error_code         NUMBER,
    error_message      VARCHAR2(4000),
    error_backtrace    CLOB,
    error_time         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE etl_process_execution_log IS 'Registro principal de auditoría para ejecuciones de pipeline ETL en Oracle.';
COMMENT ON TABLE etl_error_log IS 'Captura de errores en tiempo de ejecución con trazabilidad completa.';
