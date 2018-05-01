-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE `SENTRY_DB_PRIVILEGE` (
  `DB_PRIVILEGE_ID` BIGINT NOT NULL,
  `PRIVILEGE_SCOPE` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `SERVER_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `DB_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
  `TABLE_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
  `COLUMN_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
  `URI` VARCHAR(4000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
  `ACTION` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL,
  `WITH_GRANT_OPTION` CHAR(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE` (
  `ROLE_ID` BIGINT  NOT NULL,
  `ROLE_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_GROUP` (
  `GROUP_ID` BIGINT  NOT NULL,
  `GROUP_NAME` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `CREATE_TIME` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP` (
  `ROLE_ID` BIGINT NOT NULL,
  `DB_PRIVILEGE_ID` BIGINT NOT NULL,
  `GRANTOR_PRINCIPAL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `SENTRY_ROLE_GROUP_MAP` (
  `ROLE_ID` BIGINT NOT NULL,
  `GROUP_ID` BIGINT NOT NULL,
  `GRANTOR_PRINCIPAL` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `SENTRY_VERSION` (
  `VER_ID` BIGINT NOT NULL,
  `SCHEMA_VERSION` VARCHAR(127) NOT NULL,
  `VERSION_COMMENT` VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD CONSTRAINT `SENTRY_DB_PRIV_PK` PRIMARY KEY (`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE`
  ADD CONSTRAINT `SENTRY_ROLE_PK` PRIMARY KEY (`ROLE_ID`);

ALTER TABLE `SENTRY_GROUP`
  ADD CONSTRAINT `SENTRY_GROUP_PK` PRIMARY KEY (`GROUP_ID`);

ALTER TABLE `SENTRY_VERSION`
  ADD CONSTRAINT `SENTRY_VERSION` PRIMARY KEY (`VER_ID`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD UNIQUE `SENTRY_DB_PRIV_PRIV_NAME_UNIQ` (`SERVER_NAME`,`DB_NAME`,`TABLE_NAME`,`COLUMN_NAME`,`URI`(250),`ACTION`,`WITH_GRANT_OPTION`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_SERV_IDX` (`SERVER_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_DB_IDX` (`DB_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_TBL_IDX` (`TABLE_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_COL_IDX` (`COLUMN_NAME`);

ALTER TABLE `SENTRY_DB_PRIVILEGE`
  ADD INDEX `SENTRY_PRIV_URI_IDX` (`URI`);

ALTER TABLE `SENTRY_ROLE`
  ADD CONSTRAINT `SENTRY_ROLE_ROLE_NAME_UNIQUE` UNIQUE (`ROLE_NAME`);

ALTER TABLE `SENTRY_GROUP`
  ADD CONSTRAINT `SENTRY_GRP_GRP_NAME_UNIQUE` UNIQUE (`GROUP_NAME`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SENTRY_ROLE_DB_PRIVILEGE_MAP_PK` PRIMARY KEY (`ROLE_ID`,`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SENTRY_ROLE_GROUP_MAP_PK` PRIMARY KEY (`ROLE_ID`,`GROUP_ID`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RLE_DB_PRV_MAP_SN_RLE_FK`
  FOREIGN KEY (`ROLE_ID`) REFERENCES `SENTRY_ROLE`(`ROLE_ID`);

ALTER TABLE `SENTRY_ROLE_DB_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RL_DB_PRV_MAP_SN_DB_PRV_FK`
  FOREIGN KEY (`DB_PRIVILEGE_ID`) REFERENCES `SENTRY_DB_PRIVILEGE`(`DB_PRIVILEGE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SEN_ROLE_GROUP_MAP_SEN_ROLE_FK`
  FOREIGN KEY (`ROLE_ID`) REFERENCES `SENTRY_ROLE`(`ROLE_ID`);

ALTER TABLE `SENTRY_ROLE_GROUP_MAP`
  ADD CONSTRAINT `SEN_ROLE_GROUP_MAP_SEN_GRP_FK`
  FOREIGN KEY (`GROUP_ID`) REFERENCES `SENTRY_GROUP`(`GROUP_ID`);

INSERT INTO SENTRY_VERSION (VER_ID, SCHEMA_VERSION, VERSION_COMMENT) VALUES (1, '1.5.0-cdh5-2', 'Sentry release version 1.5.0-cdh5-2');

-- Generic Model
-- Table SENTRY_GM_PRIVILEGE for classes [org.apache.sentry.provider.db.service.model.MSentryGMPrivilege]
CREATE TABLE `SENTRY_GM_PRIVILEGE`
(
    `GM_PRIVILEGE_ID` BIGINT NOT NULL,
    `ACTION` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    `COMPONENT_NAME` VARCHAR(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    `CREATE_TIME` BIGINT NOT NULL,
    `WITH_GRANT_OPTION` CHAR(1) NOT NULL,
    `RESOURCE_NAME_0` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_NAME_1` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_NAME_2` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_NAME_3` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_TYPE_0` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_TYPE_1` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_TYPE_2` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `RESOURCE_TYPE_3` VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '__NULL__',
    `SCOPE` VARCHAR(128) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    `SERVICE_NAME` VARCHAR(64) BINARY CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD CONSTRAINT `SENTRY_GM_PRIVILEGE_PK` PRIMARY KEY (`GM_PRIVILEGE_ID`);
-- Constraints for table SENTRY_GM_PRIVILEGE for class(es) [org.apache.sentry.provider.db.service.model.MSentryGMPrivilege]
ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD UNIQUE `GM_PRIVILEGE_UNIQUE` (`COMPONENT_NAME`,`SERVICE_NAME`,`RESOURCE_NAME_0`,`RESOURCE_TYPE_0`,`RESOURCE_NAME_1`,`RESOURCE_TYPE_1`,`RESOURCE_NAME_2`,`RESOURCE_TYPE_2`,`RESOURCE_NAME_3`,`RESOURCE_TYPE_3`,`ACTION`,`WITH_GRANT_OPTION`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_COMP_IDX` (`COMPONENT_NAME`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_SERV_IDX` (`SERVICE_NAME`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_RES0_IDX` (`RESOURCE_NAME_0`,`RESOURCE_TYPE_0`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_RES1_IDX` (`RESOURCE_NAME_1`,`RESOURCE_TYPE_1`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_RES2_IDX` (`RESOURCE_NAME_2`,`RESOURCE_TYPE_2`);

ALTER TABLE `SENTRY_GM_PRIVILEGE`
  ADD INDEX `SENTRY_GM_PRIV_RES3_IDX` (`RESOURCE_NAME_3`,`RESOURCE_TYPE_3`);

-- Table SENTRY_ROLE_GM_PRIVILEGE_MAP for join relationship
CREATE TABLE `SENTRY_ROLE_GM_PRIVILEGE_MAP`
(
    `ROLE_ID` BIGINT NOT NULL,
    `GM_PRIVILEGE_ID` BIGINT NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

ALTER TABLE `SENTRY_ROLE_GM_PRIVILEGE_MAP`
  ADD CONSTRAINT `SENTRY_ROLE_GM_PRIVILEGE_MAP_PK` PRIMARY KEY (`ROLE_ID`,`GM_PRIVILEGE_ID`);

-- Constraints for table SENTRY_ROLE_GM_PRIVILEGE_MAP
ALTER TABLE `SENTRY_ROLE_GM_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RLE_GM_PRV_MAP_SN_RLE_FK`
  FOREIGN KEY (`ROLE_ID`) REFERENCES `SENTRY_ROLE`(`ROLE_ID`);

ALTER TABLE `SENTRY_ROLE_GM_PRIVILEGE_MAP`
  ADD CONSTRAINT `SEN_RL_GM_PRV_MAP_SN_DB_PRV_FK`
  FOREIGN KEY (`GM_PRIVILEGE_ID`) REFERENCES `SENTRY_GM_PRIVILEGE`(`GM_PRIVILEGE_ID`);

-- Table AUTHZ_PATHS_SNAPSHOT_ID for class [org.apache.sentry.provider.db.service.model.MAuthzPathsSnapshotId]
CREATE TABLE `AUTHZ_PATHS_SNAPSHOT_ID`
(
    `AUTHZ_SNAPSHOT_ID` BIGINT NOT NULL,
    CONSTRAINT `AUTHZ_SNAPSHOT_ID_PK` PRIMARY KEY (`AUTHZ_SNAPSHOT_ID`)
)ENGINE=INNODB;

-- Table `AUTHZ_PATHS_MAPPING` for classes [org.apache.sentry.provider.db.service.model.MAuthzPathsMapping]
CREATE TABLE `AUTHZ_PATHS_MAPPING`
(
    `AUTHZ_OBJ_ID` BIGINT NOT NULL AUTO_INCREMENT,
    `AUTHZ_OBJ_NAME` VARCHAR(384) BINARY CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
    `CREATE_TIME_MS` BIGINT NOT NULL,
    `AUTHZ_SNAPSHOT_ID` BIGINT NOT NULL,
    CONSTRAINT `AUTHZ_PATHS_MAPPING_PK` PRIMARY KEY (`AUTHZ_OBJ_ID`)
) ENGINE=INNODB;

-- Constraints for table `AUTHZ_PATHS_MAPPING` for class(es) [org.apache.sentry.provider.db.service.model.MAuthzPathsMapping]
CREATE UNIQUE INDEX `AUTHZOBJNAMEID` ON `AUTHZ_PATHS_MAPPING` (`AUTHZ_OBJ_NAME`, `AUTHZ_SNAPSHOT_ID`);

-- Table `AUTHZ_PATH` for classes [org.apache.sentry.provider.db.service.model.MPath]
CREATE TABLE `AUTHZ_PATH` (
    `PATH_ID` BIGINT NOT NULL,
    `PATH_NAME` VARCHAR(4000) CHARACTER SET utf8 COLLATE utf8_bin,
    `AUTHZ_OBJ_ID` BIGINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Constraints for table `AUTHZ_PATH`
ALTER TABLE `AUTHZ_PATH`
  ADD CONSTRAINT `AUTHZ_PATH_PK` PRIMARY KEY (`PATH_ID`);

ALTER TABLE `AUTHZ_PATH`
  ADD CONSTRAINT `AUTHZ_PATH_FK`
  FOREIGN KEY (`AUTHZ_OBJ_ID`) REFERENCES `AUTHZ_PATHS_MAPPING`(`AUTHZ_OBJ_ID`);

CREATE INDEX `AUTHZ_PATH_FK_IDX` ON `AUTHZ_PATH` (`AUTHZ_OBJ_ID`);

-- Table `SENTRY_PERM_CHANGE` for classes [org.apache.sentry.provider.db.service.model.MSentryPermChange]
CREATE TABLE `SENTRY_PERM_CHANGE`
(
    `CHANGE_ID` BIGINT NOT NULL,
    `CREATE_TIME_MS` BIGINT NOT NULL,
    `PERM_CHANGE` VARCHAR(4000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    CONSTRAINT `SENTRY_PERM_CHANGE_PK` PRIMARY KEY (`CHANGE_ID`)
) ENGINE=INNODB;

-- Table `SENTRY_PATH_CHANGE` for classes [org.apache.sentry.provider.db.service.model.MSentryPathChange]
CREATE TABLE `SENTRY_PATH_CHANGE`
(
    `CHANGE_ID` BIGINT NOT NULL,
    `NOTIFICATION_HASH` CHAR(40) NOT NULL,
    `CREATE_TIME_MS` BIGINT NOT NULL,
    `PATH_CHANGE` longtext CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    CONSTRAINT `SENTRY_PATH_CHANGE_PK` PRIMARY KEY (`CHANGE_ID`)
) ENGINE=INNODB;

-- Constraints for table SENTRY_PATH_CHANGE for class [org.apache.sentry.provider.db.service.model.MSentryPathChange]
CREATE UNIQUE INDEX `NOTIFICATION_HASH_INDEX` ON `SENTRY_PATH_CHANGE` (`NOTIFICATION_HASH`);

-- Table SENTRY_HMS_NOTIFICATION_ID for classes [org.apache.sentry.provider.db.service.model.MSentryHmsNotification]
CREATE TABLE `SENTRY_HMS_NOTIFICATION_ID`
(
    `NOTIFICATION_ID` BIGINT NOT NULL
)ENGINE=INNODB;

CREATE INDEX `SENTRY_HMS_NOTIF_ID_INDEX` ON `SENTRY_HMS_NOTIFICATION_ID` (`NOTIFICATION_ID`);