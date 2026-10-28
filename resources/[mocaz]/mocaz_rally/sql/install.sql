CREATE TABLE IF NOT EXISTS mocaz_rally_results (
 id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 identifier VARCHAR(80) NOT NULL,
 stage_id VARCHAR(48) NOT NULL,
 time_ms INT UNSIGNED NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id), KEY idx_stage_time (stage_id,time_ms), KEY idx_identifier_stage (identifier,stage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mocaz_rally_personal_bests (
 identifier VARCHAR(80) NOT NULL,
 stage_id VARCHAR(48) NOT NULL,
 best_time_ms INT UNSIGNED NOT NULL,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (identifier,stage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
