mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 5.7.15, for Linux (x86_64)
--
-- Host: trapumdb    Database: trapum_web
-- ------------------------------------------------------
-- Server version	5.7.15

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

--
-- Table structure for table `affiliation`
--

DROP TABLE IF EXISTS `affiliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `fullname` varchar(128) DEFAULT NULL,
  `address` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fullname` (`fullname`),
  UNIQUE KEY `ix_affiliation_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `affiliations`
--

DROP TABLE IF EXISTS `affiliations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliations` (
  `user_id` int(11) NOT NULL,
  `affiliation_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`affiliation_id`),
  KEY `affiliation_id` (`affiliation_id`),
  CONSTRAINT `affiliations_ibfk_1` FOREIGN KEY (`affiliation_id`) REFERENCES `affiliation` (`id`),
  CONSTRAINT `affiliations_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `beam`
--

DROP TABLE IF EXISTS `beam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `beam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pointing_id` int(11) NOT NULL,
  `on_target` tinyint(1) NOT NULL,
  `ra` varchar(20) DEFAULT NULL,
  `dec` varchar(20) DEFAULT NULL,
  `coherent` tinyint(1) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_beam_pointing_id` (`pointing_id`),
  CONSTRAINT `beam_ibfk_1` FOREIGN KEY (`pointing_id`) REFERENCES `pointing` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30822 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `beamformer_configuration`
--

DROP TABLE IF EXISTS `beamformer_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `beamformer_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `centre_frequency` float DEFAULT NULL,
  `bandwidth` float DEFAULT NULL,
  `incoherent_nchans` int(11) DEFAULT NULL,
  `incoherent_tsamp` float DEFAULT NULL,
  `incoherent_antennas` text,
  `coherent_nchans` int(11) DEFAULT NULL,
  `coherent_tsamp` float DEFAULT NULL,
  `coherent_antennas` text,
  `configuration_authority` varchar(64) DEFAULT NULL,
  `receiver` varchar(20) DEFAULT NULL,
  `metainfo` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_product`
--

DROP TABLE IF EXISTS `data_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pointing_id` int(11) NOT NULL,
  `beam_id` int(11) NOT NULL,
  `processing_id` int(11) DEFAULT NULL,
  `file_type_id` int(11) NOT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `filepath` varchar(255) NOT NULL,
  `filehash` varchar(100) DEFAULT NULL,
  `available` tinyint(1) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  `upload_date` datetime NOT NULL,
  `modification_date` datetime NOT NULL,
  `metainfo` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `_full_file_path` (`filename`,`filepath`),
  KEY `ix_data_product_beam_id` (`beam_id`),
  KEY `ix_data_product_file_type_id` (`file_type_id`),
  KEY `ix_data_product_id` (`id`),
  KEY `ix_data_product_pointing_id` (`pointing_id`),
  KEY `ix_data_product_processing_id` (`processing_id`),
  CONSTRAINT `data_product_ibfk_1` FOREIGN KEY (`beam_id`) REFERENCES `beam` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `data_product_ibfk_2` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `data_product_ibfk_3` FOREIGN KEY (`pointing_id`) REFERENCES `pointing` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `data_product_ibfk_4` FOREIGN KEY (`processing_id`) REFERENCES `processing` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=220920 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_action`
--

DROP TABLE IF EXISTS `file_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_action` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` varchar(64) NOT NULL,
  `is_destructive` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_action_request`
--

DROP TABLE IF EXISTS `file_action_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_action_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_product_id` int(11) NOT NULL,
  `action_id` int(11) NOT NULL,
  `requested_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_file_action_request_action_id` (`action_id`),
  KEY `ix_file_action_request_data_product_id` (`data_product_id`),
  CONSTRAINT `file_action_request_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `file_action` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `file_action_request_ibfk_2` FOREIGN KEY (`data_product_id`) REFERENCES `data_product` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hardware`
--

DROP TABLE IF EXISTS `hardware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hardware` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `metainfo` text,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `membership_role`
--

DROP TABLE IF EXISTS `membership_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `membership_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_membership_role_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `membership_roles`
--

DROP TABLE IF EXISTS `membership_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `membership_roles` (
  `user_id` int(11) NOT NULL,
  `membership_role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`membership_role_id`),
  KEY `membership_role_id` (`membership_role_id`),
  CONSTRAINT `membership_roles_ibfk_1` FOREIGN KEY (`membership_role_id`) REFERENCES `membership_role` (`id`),
  CONSTRAINT `membership_roles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `memberships`
--

DROP TABLE IF EXISTS `memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memberships` (
  `user_id` int(11) NOT NULL,
  `working_group_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`working_group_id`),
  KEY `working_group_id` (`working_group_id`),
  CONSTRAINT `memberships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `memberships_ibfk_2` FOREIGN KEY (`working_group_id`) REFERENCES `working_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pipeline`
--

DROP TABLE IF EXISTS `pipeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pipeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` varchar(100) DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  `arguments_json` text,
  `notes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pointing`
--

DROP TABLE IF EXISTS `pointing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pointing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_id` int(11) NOT NULL,
  `bf_config_id` int(11) NOT NULL,
  `observation_length` float DEFAULT NULL,
  `utc_start` datetime NOT NULL,
  `sb_id` text NOT NULL,
  `mkat_pid` text NOT NULL,
  `beam_shape` text,
  PRIMARY KEY (`id`),
  KEY `ix_pointing_bf_config_id` (`bf_config_id`),
  KEY `ix_pointing_target_id` (`target_id`),
  CONSTRAINT `pointing_ibfk_1` FOREIGN KEY (`bf_config_id`) REFERENCES `beamformer_configuration` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `pointing_ibfk_2` FOREIGN KEY (`target_id`) REFERENCES `target` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing`
--

DROP TABLE IF EXISTS `processing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pipeline_id` int(11) NOT NULL,
  `hardware_id` int(11) DEFAULT NULL,
  `arguments_id` int(11) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `process_status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_processing_arguments_id` (`arguments_id`),
  KEY `ix_processing_hardware_id` (`hardware_id`),
  KEY `ix_processing_pipeline_id` (`pipeline_id`),
  CONSTRAINT `processing_ibfk_1` FOREIGN KEY (`arguments_id`) REFERENCES `processing_arguments` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `processing_ibfk_2` FOREIGN KEY (`hardware_id`) REFERENCES `hardware` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `processing_ibfk_3` FOREIGN KEY (`pipeline_id`) REFERENCES `pipeline` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46677 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing_arguments`
--

DROP TABLE IF EXISTS `processing_arguments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing_arguments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `arguments_json` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing_inputs`
--

DROP TABLE IF EXISTS `processing_inputs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing_inputs` (
  `dp_id` int(11) NOT NULL,
  `processing_id` int(11) NOT NULL,
  PRIMARY KEY (`dp_id`,`processing_id`),
  KEY `processing_id` (`processing_id`),
  CONSTRAINT `processing_inputs_ibfk_1` FOREIGN KEY (`dp_id`) REFERENCES `data_product` (`id`),
  CONSTRAINT `processing_inputs_ibfk_2` FOREIGN KEY (`processing_id`) REFERENCES `processing` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing_request`
--

DROP TABLE IF EXISTS `processing_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pipeline_id` int(11) NOT NULL,
  `arguments_id` int(11) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `dispatcher_args_json` text,
  `dispatched_at` datetime DEFAULT NULL,
  `dispatched_to` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_processing_request_arguments_id` (`arguments_id`),
  KEY `ix_processing_request_pipeline_id` (`pipeline_id`),
  KEY `ix_processing_request_user_id` (`user_id`),
  CONSTRAINT `processing_request_ibfk_1` FOREIGN KEY (`arguments_id`) REFERENCES `processing_arguments` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `processing_request_ibfk_2` FOREIGN KEY (`pipeline_id`) REFERENCES `pipeline` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `processing_request_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing_request_beams`
--

DROP TABLE IF EXISTS `processing_request_beams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing_request_beams` (
  `beam_id` int(11) NOT NULL,
  `processing_request_id` int(11) NOT NULL,
  PRIMARY KEY (`beam_id`,`processing_request_id`),
  KEY `processing_request_id` (`processing_request_id`),
  CONSTRAINT `processing_request_beams_ibfk_1` FOREIGN KEY (`beam_id`) REFERENCES `beam` (`id`),
  CONSTRAINT `processing_request_beams_ibfk_2` FOREIGN KEY (`processing_request_id`) REFERENCES `processing_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `processing_request_processings`
--

DROP TABLE IF EXISTS `processing_request_processings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processing_request_processings` (
  `processing_id` int(11) NOT NULL,
  `processing_request_id` int(11) NOT NULL,
  PRIMARY KEY (`processing_id`,`processing_request_id`),
  KEY `processing_request_id` (`processing_request_id`),
  CONSTRAINT `processing_request_processings_ibfk_1` FOREIGN KEY (`processing_id`) REFERENCES `processing` (`id`),
  CONSTRAINT `processing_request_processings_ibfk_2` FOREIGN KEY (`processing_request_id`) REFERENCES `processing_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `working_group_id` int(11) DEFAULT NULL,
  `coordinator_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_project_name` (`name`),
  KEY `coordinator_user_id` (`coordinator_user_id`),
  KEY `working_group_id` (`working_group_id`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`coordinator_user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `project_ibfk_2` FOREIGN KEY (`working_group_id`) REFERENCES `working_group` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `target`
--

DROP TABLE IF EXISTS `target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `target` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `source_name` varchar(64) DEFAULT NULL,
  `ra` varchar(20) DEFAULT NULL,
  `dec` varchar(20) DEFAULT NULL,
  `region` varchar(20) DEFAULT NULL,
  `semi_major_axis` float DEFAULT NULL,
  `semi_minor_axis` float DEFAULT NULL,
  `position_angle` float DEFAULT NULL,
  `metainfo` text,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `ix_target_project_id` (`project_id`),
  CONSTRAINT `target_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `fullname` varchar(64) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  `administrator` tinyint(1) DEFAULT NULL,
  `token` varchar(32) DEFAULT NULL,
  `token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_user_email` (`email`),
  UNIQUE KEY `ix_user_token` (`token`),
  UNIQUE KEY `ix_user_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `working_group`
--

DROP TABLE IF EXISTS `working_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `working_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(120) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `chair_user_id` int(11) DEFAULT NULL,
  `outreach_liaison_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_working_group_name` (`name`),
  KEY `chair_user_id` (`chair_user_id`),
  KEY `outreach_liaison_user_id` (`outreach_liaison_user_id`),
  CONSTRAINT `working_group_ibfk_1` FOREIGN KEY (`chair_user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `working_group_ibfk_2` FOREIGN KEY (`outreach_liaison_user_id`) REFERENCES `user` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-08-27  9:12:42
pod "mysql2" deleted
