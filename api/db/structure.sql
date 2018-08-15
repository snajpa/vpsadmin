-- MySQL dump 10.16  Distrib 10.2.13-MariaDB, for Linux (x86_64)
--
-- Host: 192.168.122.10    Database: vpsadmin
-- ------------------------------------------------------
-- Server version	10.0.34-MariaDB-wsrep

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
-- Table structure for table `api_tokens`
--

DROP TABLE IF EXISTS `api_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `valid_to` datetime DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `use_count` int(11) NOT NULL DEFAULT '0',
  `lifetime` int(11) NOT NULL,
  `interval` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2464 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset_tree_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `index` int(11) NOT NULL DEFAULT '0',
  `head` tinyint(1) NOT NULL DEFAULT '0',
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_branches_on_dataset_tree_id` (`dataset_tree_id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_resource_uses`
--

DROP TABLE IF EXISTS `cluster_resource_uses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster_resource_uses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_cluster_resource_id` int(11) NOT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `table_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  `value` decimal(40,0) NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `admin_lock_type` int(11) NOT NULL DEFAULT '0',
  `admin_limit` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_cluster_resource_uses_on_user_cluster_resource_id` (`user_cluster_resource_id`),
  KEY `cluster_resouce_use_name_search` (`class_name`,`table_name`,`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1359 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cluster_resources`
--

DROP TABLE IF EXISTS `cluster_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cluster_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `label` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `min` decimal(40,0) NOT NULL,
  `max` decimal(40,0) NOT NULL,
  `stepsize` int(11) NOT NULL,
  `resource_type` int(11) NOT NULL,
  `allocate_chain` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `free_chain` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_cluster_resources_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_actions`
--

DROP TABLE IF EXISTS `dataset_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pool_id` int(11) DEFAULT NULL,
  `src_dataset_in_pool_id` int(11) DEFAULT NULL,
  `dst_dataset_in_pool_id` int(11) DEFAULT NULL,
  `snapshot_id` int(11) DEFAULT NULL,
  `recursive` tinyint(1) NOT NULL DEFAULT '0',
  `dataset_plan_id` int(11) DEFAULT NULL,
  `dataset_in_pool_plan_id` int(11) DEFAULT NULL,
  `action` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_in_pool_plans`
--

DROP TABLE IF EXISTS `dataset_in_pool_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_in_pool_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_dataset_plan_id` int(11) NOT NULL,
  `dataset_in_pool_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dataset_in_pool_plans_unique` (`environment_dataset_plan_id`,`dataset_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_in_pools`
--

DROP TABLE IF EXISTS `dataset_in_pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_in_pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset_id` int(11) NOT NULL,
  `pool_id` int(11) NOT NULL,
  `label` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `used` int(11) NOT NULL DEFAULT '0',
  `avail` int(11) NOT NULL DEFAULT '0',
  `min_snapshots` int(11) NOT NULL DEFAULT '14',
  `max_snapshots` int(11) NOT NULL DEFAULT '20',
  `snapshot_max_age` int(11) NOT NULL DEFAULT '1209600',
  `mountpoint` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `user_namespace_map_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_dataset_in_pools_on_dataset_id_and_pool_id` (`dataset_id`,`pool_id`),
  KEY `index_dataset_in_pools_on_dataset_id` (`dataset_id`),
  KEY `index_dataset_in_pools_on_user_namespace_map_id` (`user_namespace_map_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1109 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_plans`
--

DROP TABLE IF EXISTS `dataset_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_properties`
--

DROP TABLE IF EXISTS `dataset_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pool_id` int(11) DEFAULT NULL,
  `dataset_id` int(11) DEFAULT NULL,
  `dataset_in_pool_id` int(11) DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `ancestry_depth` int(11) NOT NULL DEFAULT '0',
  `name` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `value` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `inherited` tinyint(1) NOT NULL DEFAULT '1',
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dataset_properties_on_dataset_id` (`dataset_id`),
  KEY `index_dataset_properties_on_pool_id` (`pool_id`),
  KEY `index_dataset_properties_on_dataset_in_pool_id` (`dataset_in_pool_id`),
  KEY `index_dataset_properties_on_dataset_in_pool_id_and_name` (`dataset_in_pool_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4402 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_property_histories`
--

DROP TABLE IF EXISTS `dataset_property_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_property_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset_property_id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dataset_property_histories_on_dataset_property_id` (`dataset_property_id`)
) ENGINE=InnoDB AUTO_INCREMENT=433315 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dataset_trees`
--

DROP TABLE IF EXISTS `dataset_trees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dataset_trees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset_in_pool_id` int(11) NOT NULL,
  `index` int(11) NOT NULL DEFAULT '0',
  `head` tinyint(1) NOT NULL DEFAULT '0',
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dataset_trees_on_dataset_in_pool_id` (`dataset_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `datasets`
--

DROP TABLE IF EXISTS `datasets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datasets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `full_name` varchar(1000) COLLATE utf8_czech_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_editable` tinyint(1) NOT NULL,
  `user_create` tinyint(1) NOT NULL,
  `user_destroy` tinyint(1) NOT NULL,
  `ancestry` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `ancestry_depth` int(11) NOT NULL DEFAULT '0',
  `expiration` datetime DEFAULT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `object_state` int(11) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `current_history_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_datasets_on_ancestry` (`ancestry`),
  KEY `index_datasets_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=347 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `default_lifetime_values`
--

DROP TABLE IF EXISTS `default_lifetime_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `default_lifetime_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_id` int(11) DEFAULT NULL,
  `class_name` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `direction` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  `add_expiration` int(11) DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `default_object_cluster_resources`
--

DROP TABLE IF EXISTS `default_object_cluster_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `default_object_cluster_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_id` int(11) NOT NULL,
  `cluster_resource_id` int(11) NOT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `value` decimal(40,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dns_resolvers`
--

DROP TABLE IF EXISTS `dns_resolvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dns_resolvers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `addrs` varchar(63) NOT NULL,
  `label` varchar(63) NOT NULL,
  `is_universal` tinyint(1) unsigned DEFAULT '0',
  `location_id` int(10) unsigned DEFAULT NULL,
  `ip_version` int(11) DEFAULT '4',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `environment_config_chains`
--

DROP TABLE IF EXISTS `environment_config_chains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environment_config_chains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_id` int(11) NOT NULL,
  `vps_config_id` int(11) NOT NULL,
  `cfg_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `environment_config_chains_unique` (`environment_id`,`vps_config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `environment_dataset_plans`
--

DROP TABLE IF EXISTS `environment_dataset_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environment_dataset_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_id` int(11) NOT NULL,
  `dataset_plan_id` int(11) NOT NULL,
  `user_add` tinyint(1) NOT NULL,
  `user_remove` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `environment_user_configs`
--

DROP TABLE IF EXISTS `environment_user_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environment_user_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `can_create_vps` tinyint(1) NOT NULL DEFAULT '0',
  `can_destroy_vps` tinyint(1) NOT NULL DEFAULT '0',
  `vps_lifetime` int(11) NOT NULL DEFAULT '0',
  `max_vps_count` int(11) NOT NULL DEFAULT '1',
  `default` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `environment_user_configs_unique` (`environment_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=338 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `environments`
--

DROP TABLE IF EXISTS `environments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `environments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `domain` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `maintenance_lock` int(11) NOT NULL DEFAULT '0',
  `maintenance_lock_reason` varchar(255) DEFAULT NULL,
  `can_create_vps` tinyint(1) NOT NULL DEFAULT '0',
  `can_destroy_vps` tinyint(1) NOT NULL DEFAULT '0',
  `vps_lifetime` int(11) NOT NULL DEFAULT '0',
  `max_vps_count` int(11) NOT NULL DEFAULT '1',
  `user_ip_ownership` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_snapshots`
--

DROP TABLE IF EXISTS `group_snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dataset_action_id` int(11) DEFAULT NULL,
  `dataset_in_pool_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_snapshots_unique` (`dataset_action_id`,`dataset_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_boxes`
--

DROP TABLE IF EXISTS `help_boxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_boxes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `action` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `language_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_czech_ci NOT NULL,
  `order` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_help_boxes_on_page` (`page`),
  KEY `index_help_boxes_on_action` (`action`),
  KEY `index_help_boxes_on_page_and_action` (`page`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `helpbox`
--

DROP TABLE IF EXISTS `helpbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `helpbox` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host_ip_addresses`
--

DROP TABLE IF EXISTS `host_ip_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_ip_addresses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address_id` int(11) NOT NULL,
  `ip_addr` varchar(40) COLLATE utf8_czech_ci NOT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_host_ip_addresses_on_ip_address_id_and_ip_addr` (`ip_address_id`,`ip_addr`),
  KEY `index_host_ip_addresses_on_ip_address_id` (`ip_address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=484 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incoming_payments`
--

DROP TABLE IF EXISTS `incoming_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incoming_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` varchar(3) COLLATE utf8_czech_ci NOT NULL,
  `src_amount` decimal(10,2) DEFAULT NULL,
  `src_currency` varchar(3) COLLATE utf8_czech_ci DEFAULT NULL,
  `account_name` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `user_ident` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `user_message` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `vs` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `ks` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `ss` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `transaction_type` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `comment` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_incoming_payments_on_transaction_id` (`transaction_id`),
  KEY `index_incoming_payments_on_vs` (`vs`),
  KEY `index_incoming_payments_on_ks` (`ks`),
  KEY `index_incoming_payments_on_ss` (`ss`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `integrity_checks`
--

DROP TABLE IF EXISTS `integrity_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `integrity_checks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `checked_objects` int(11) NOT NULL DEFAULT '0',
  `integral_objects` int(11) NOT NULL DEFAULT '0',
  `broken_objects` int(11) NOT NULL DEFAULT '0',
  `checked_facts` int(11) NOT NULL DEFAULT '0',
  `true_facts` int(11) NOT NULL DEFAULT '0',
  `false_facts` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `integrity_facts`
--

DROP TABLE IF EXISTS `integrity_facts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `integrity_facts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `integrity_object_id` int(11) NOT NULL,
  `name` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `expected_value` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `actual_value` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `severity` int(11) NOT NULL DEFAULT '1',
  `message` varchar(1000) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2993 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `integrity_objects`
--

DROP TABLE IF EXISTS `integrity_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `integrity_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `integrity_check_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `class_name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) DEFAULT NULL,
  `ancestry` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `ancestry_depth` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  `checked_facts` int(11) NOT NULL DEFAULT '0',
  `true_facts` int(11) NOT NULL DEFAULT '0',
  `false_facts` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2333 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_addresses`
--

DROP TABLE IF EXISTS `ip_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_addresses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_addr` varchar(40) NOT NULL,
  `max_tx` bigint(20) unsigned NOT NULL DEFAULT '39321600',
  `max_rx` bigint(20) unsigned NOT NULL DEFAULT '39321600',
  `class_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `network_id` int(11) NOT NULL,
  `order` int(11) DEFAULT NULL,
  `prefix` int(11) NOT NULL,
  `size` decimal(40,0) NOT NULL,
  `network_interface_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ip_addresses_on_class_id` (`class_id`),
  KEY `index_ip_addresses_on_user_id` (`user_id`),
  KEY `index_ip_addresses_on_network_id` (`network_id`),
  KEY `index_ip_addresses_on_network_interface_id` (`network_interface_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1096 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_recent_traffics`
--

DROP TABLE IF EXISTS `ip_recent_traffics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_recent_traffics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `protocol` int(11) NOT NULL,
  `packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `role` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfers_unique` (`ip_address_id`,`user_id`,`protocol`,`role`,`created_at`),
  KEY `index_ip_recent_traffics_on_ip_address_id` (`ip_address_id`),
  KEY `index_ip_recent_traffics_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9000 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_traffic_live_monitors`
--

DROP TABLE IF EXISTS `ip_traffic_live_monitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_traffic_live_monitors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address_id` int(11) NOT NULL,
  `packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_tcp_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_udp_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `public_other_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_tcp_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_udp_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_packets` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_bytes` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `private_other_bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL,
  `delta` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ip_traffic_live_monitors_on_ip_address_id` (`ip_address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1125 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_traffic_monthly_summaries`
--

DROP TABLE IF EXISTS `ip_traffic_monthly_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_traffic_monthly_summaries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `protocol` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  `packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_traffic_monthly_summaries_unique` (`ip_address_id`,`user_id`,`protocol`,`role`,`created_at`),
  KEY `index_ip_traffic_monthly_summaries_on_ip_address_id` (`ip_address_id`),
  KEY `index_ip_traffic_monthly_summaries_on_user_id` (`user_id`),
  KEY `index_ip_traffic_monthly_summaries_on_protocol` (`protocol`),
  KEY `index_ip_traffic_monthly_summaries_on_year` (`year`),
  KEY `index_ip_traffic_monthly_summaries_on_month` (`month`),
  KEY `index_ip_traffic_monthly_summaries_on_year_and_month` (`year`,`month`),
  KEY `ip_traffic_monthly_summaries_ip_year_month` (`ip_address_id`,`year`,`month`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ip_traffics`
--

DROP TABLE IF EXISTS `ip_traffics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip_traffics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `protocol` int(11) NOT NULL,
  `packets_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `packets_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_in` bigint(20) unsigned NOT NULL DEFAULT '0',
  `bytes_out` bigint(20) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `role` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfers_unique` (`ip_address_id`,`user_id`,`protocol`,`role`,`created_at`),
  KEY `index_ip_traffics_on_ip_address_id` (`ip_address_id`),
  KEY `index_ip_traffics_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(2) COLLATE utf8_czech_ci NOT NULL,
  `label` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_languages_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(63) NOT NULL,
  `has_ipv6` tinyint(1) NOT NULL,
  `vps_onboot` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `remote_console_server` varchar(255) NOT NULL,
  `domain` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `maintenance_lock` int(11) NOT NULL DEFAULT '0',
  `maintenance_lock_reason` varchar(255) DEFAULT NULL,
  `environment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL,
  `msg` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_logs`
--

DROP TABLE IF EXISTS `mail_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `to` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `cc` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `bcc` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `from` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `reply_to` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `return_path` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `message_id` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `in_reply_to` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `references` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `text_plain` longtext COLLATE utf8_czech_ci,
  `text_html` longtext COLLATE utf8_czech_ci,
  `mail_template_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_mail_logs_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2362 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_recipients`
--

DROP TABLE IF EXISTS `mail_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `to` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `cc` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `bcc` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_template_recipients`
--

DROP TABLE IF EXISTS `mail_template_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_template_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail_template_id` int(11) NOT NULL,
  `mail_recipient_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mail_template_recipients_unique` (`mail_template_id`,`mail_recipient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_template_translations`
--

DROP TABLE IF EXISTS `mail_template_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_template_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail_template_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `from` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `reply_to` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `return_path` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `text_plain` text COLLATE utf8_czech_ci,
  `text_html` text COLLATE utf8_czech_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mail_template_translation_unique` (`mail_template_id`,`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mail_templates`
--

DROP TABLE IF EXISTS `mail_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `label` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `template_id` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `user_visibility` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_mail_templates_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintenance_locks`
--

DROP TABLE IF EXISTS `maintenance_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maintenance_locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_maintenance_locks_on_class_name_and_row_id` (`class_name`,`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `members_payments`
--

DROP TABLE IF EXISTS `members_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_id` int(11) NOT NULL,
  `acct_m_id` int(11) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `change_from` bigint(20) NOT NULL,
  `change_to` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migration_plans`
--

DROP TABLE IF EXISTS `migration_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migration_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` int(11) NOT NULL DEFAULT '0',
  `stop_on_error` tinyint(1) NOT NULL DEFAULT '1',
  `send_mail` tinyint(1) NOT NULL DEFAULT '1',
  `user_id` int(11) DEFAULT NULL,
  `node_id` int(11) DEFAULT NULL,
  `concurrency` int(11) NOT NULL,
  `reason` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mirrors`
--

DROP TABLE IF EXISTS `mirrors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mirrors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `src_pool_id` int(11) DEFAULT NULL,
  `dst_pool_id` int(11) DEFAULT NULL,
  `src_dataset_in_pool_id` int(11) DEFAULT NULL,
  `dst_dataset_in_pool_id` int(11) DEFAULT NULL,
  `recursive` tinyint(1) NOT NULL DEFAULT '0',
  `interval` int(11) NOT NULL DEFAULT '60',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monitored_event_logs`
--

DROP TABLE IF EXISTS `monitored_event_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monitored_event_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `monitored_event_id` int(11) NOT NULL,
  `passed` tinyint(1) NOT NULL,
  `value` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monitored_event_logs_on_monitored_event_id` (`monitored_event_id`),
  KEY `index_monitored_event_logs_on_passed` (`passed`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monitored_event_states`
--

DROP TABLE IF EXISTS `monitored_event_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monitored_event_states` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `monitored_event_id` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monitored_event_states_on_monitored_event_id` (`monitored_event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monitored_events`
--

DROP TABLE IF EXISTS `monitored_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monitored_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `monitor_name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `access_level` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_report_at` datetime DEFAULT NULL,
  `saved_until` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_monitored_events_on_monitor_name` (`monitor_name`),
  KEY `index_monitored_events_on_class_name` (`class_name`),
  KEY `index_monitored_events_on_row_id` (`row_id`),
  KEY `index_monitored_events_on_state` (`state`),
  KEY `index_monitored_events_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mounts`
--

DROP TABLE IF EXISTS `mounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `src` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `dst` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `mount_opts` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `umount_opts` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `mount_type` varchar(10) COLLATE utf8_czech_ci NOT NULL,
  `user_editable` tinyint(1) NOT NULL DEFAULT '1',
  `dataset_in_pool_id` int(11) DEFAULT NULL,
  `snapshot_in_pool_id` int(11) DEFAULT NULL,
  `mode` varchar(2) COLLATE utf8_czech_ci NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `object_state` int(11) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `on_start_fail` int(11) NOT NULL DEFAULT '1',
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `master_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `current_state` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_mounts_on_vps_id` (`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `network_interfaces`
--

DROP TABLE IF EXISTS `network_interfaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_interfaces` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `name` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `kind` int(11) NOT NULL,
  `mac` varchar(17) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_network_interfaces_on_vps_id_and_name` (`vps_id`,`name`),
  UNIQUE KEY `index_network_interfaces_on_mac` (`mac`),
  KEY `index_network_interfaces_on_vps_id` (`vps_id`),
  KEY `index_network_interfaces_on_kind` (`kind`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `networks`
--

DROP TABLE IF EXISTS `networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `ip_version` int(11) NOT NULL,
  `address` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `prefix` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  `managed` tinyint(1) NOT NULL,
  `split_access` int(11) NOT NULL DEFAULT '0',
  `split_prefix` int(11) NOT NULL,
  `autopick` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_networks_on_location_id_and_address_and_prefix` (`location_id`,`address`,`prefix`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news_logs`
--

DROP TABLE IF EXISTS `news_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message` text COLLATE utf8_czech_ci NOT NULL,
  `published_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `node_current_statuses`
--

DROP TABLE IF EXISTS `node_current_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_current_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `uptime` int(11) DEFAULT NULL,
  `cpus` int(11) DEFAULT NULL,
  `total_memory` int(11) DEFAULT NULL,
  `total_swap` int(11) DEFAULT NULL,
  `vpsadmind_version` varchar(25) COLLATE utf8_czech_ci NOT NULL,
  `kernel` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `update_count` int(11) NOT NULL,
  `process_count` int(11) DEFAULT NULL,
  `cpu_user` float DEFAULT NULL,
  `cpu_nice` float DEFAULT NULL,
  `cpu_system` float DEFAULT NULL,
  `cpu_idle` float DEFAULT NULL,
  `cpu_iowait` float DEFAULT NULL,
  `cpu_irq` float DEFAULT NULL,
  `cpu_softirq` float DEFAULT NULL,
  `cpu_guest` float DEFAULT NULL,
  `loadavg` float DEFAULT NULL,
  `used_memory` int(11) DEFAULT NULL,
  `used_swap` int(11) DEFAULT NULL,
  `arc_c_max` int(11) DEFAULT NULL,
  `arc_c` int(11) DEFAULT NULL,
  `arc_size` int(11) DEFAULT NULL,
  `arc_hitpercent` float DEFAULT NULL,
  `sum_process_count` int(11) DEFAULT NULL,
  `sum_cpu_user` float DEFAULT NULL,
  `sum_cpu_nice` float DEFAULT NULL,
  `sum_cpu_system` float DEFAULT NULL,
  `sum_cpu_idle` float DEFAULT NULL,
  `sum_cpu_iowait` float DEFAULT NULL,
  `sum_cpu_irq` float DEFAULT NULL,
  `sum_cpu_softirq` float DEFAULT NULL,
  `sum_cpu_guest` float DEFAULT NULL,
  `sum_loadavg` float DEFAULT NULL,
  `sum_used_memory` int(11) DEFAULT NULL,
  `sum_used_swap` int(11) DEFAULT NULL,
  `sum_arc_c_max` int(11) DEFAULT NULL,
  `sum_arc_c` int(11) DEFAULT NULL,
  `sum_arc_size` int(11) DEFAULT NULL,
  `sum_arc_hitpercent` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_node_current_statuses_on_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51179 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `node_pubkeys`
--

DROP TABLE IF EXISTS `node_pubkeys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_pubkeys` (
  `node_id` int(11) NOT NULL,
  `key_type` enum('rsa','dsa') COLLATE utf8_czech_ci NOT NULL,
  `key` text COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`node_id`,`key_type`),
  KEY `index_node_pubkeys_on_node_id` (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `node_statuses`
--

DROP TABLE IF EXISTS `node_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `node_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `uptime` int(11) NOT NULL,
  `process_count` int(11) DEFAULT NULL,
  `cpus` int(11) DEFAULT NULL,
  `cpu_user` float DEFAULT NULL,
  `cpu_nice` float DEFAULT NULL,
  `cpu_system` float DEFAULT NULL,
  `cpu_idle` float DEFAULT NULL,
  `cpu_iowait` float DEFAULT NULL,
  `cpu_irq` float DEFAULT NULL,
  `cpu_softirq` float DEFAULT NULL,
  `cpu_guest` float DEFAULT NULL,
  `total_memory` int(11) DEFAULT NULL,
  `used_memory` int(11) DEFAULT NULL,
  `total_swap` int(11) DEFAULT NULL,
  `used_swap` int(11) DEFAULT NULL,
  `arc_c_max` int(11) DEFAULT NULL,
  `arc_c` int(11) DEFAULT NULL,
  `arc_size` int(11) DEFAULT NULL,
  `arc_hitpercent` float DEFAULT NULL,
  `loadavg` float NOT NULL,
  `vpsadmind_version` varchar(25) COLLATE utf8_czech_ci NOT NULL,
  `kernel` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_node_statuses_on_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54509 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nodes`
--

DROP TABLE IF EXISTS `nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nodes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `ip_addr` varchar(127) NOT NULL,
  `max_vps` int(11) DEFAULT NULL,
  `ve_private` varchar(255) DEFAULT '/vz/private/%{veid}/private',
  `net_interface` varchar(50) DEFAULT NULL,
  `max_tx` bigint(20) unsigned NOT NULL DEFAULT '235929600',
  `max_rx` bigint(20) unsigned NOT NULL DEFAULT '235929600',
  `maintenance_lock` int(11) NOT NULL DEFAULT '0',
  `maintenance_lock_reason` varchar(255) DEFAULT NULL,
  `cpus` int(11) NOT NULL,
  `total_memory` int(11) NOT NULL,
  `total_swap` int(11) NOT NULL,
  `role` int(11) NOT NULL,
  `hypervisor_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `location_id` (`location_id`),
  KEY `index_nodes_on_hypervisor_type` (`hypervisor_type`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `object_histories`
--

DROP TABLE IF EXISTS `object_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_session_id` int(11) DEFAULT NULL,
  `tracked_object_id` int(11) NOT NULL,
  `tracked_object_type` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `event_type` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `event_data` text COLLATE utf8_czech_ci,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_histories_tracked_object` (`tracked_object_id`,`tracked_object_type`),
  KEY `index_object_histories_on_user_id` (`user_id`),
  KEY `index_object_histories_on_user_session_id` (`user_session_id`)
) ENGINE=InnoDB AUTO_INCREMENT=700 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `object_states`
--

DROP TABLE IF EXISTS `object_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_object_states_on_class_name_and_row_id` (`class_name`,`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3112 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `os_templates`
--

DROP TABLE IF EXISTS `os_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `label` varchar(64) NOT NULL,
  `info` text,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `supported` tinyint(4) NOT NULL DEFAULT '1',
  `order` tinyint(4) NOT NULL DEFAULT '1',
  `hypervisor_type` int(11) NOT NULL DEFAULT '0',
  `vendor` varchar(255) CHARACTER SET utf8 COLLATE utf8_czech_ci DEFAULT NULL,
  `variant` varchar(255) CHARACTER SET utf8 COLLATE utf8_czech_ci DEFAULT NULL,
  `arch` varchar(255) CHARACTER SET utf8 COLLATE utf8_czech_ci DEFAULT NULL,
  `distribution` varchar(255) CHARACTER SET utf8 COLLATE utf8_czech_ci DEFAULT NULL,
  `version` varchar(255) CHARACTER SET utf8 COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_entities`
--

DROP TABLE IF EXISTS `outage_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_entities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_outage_entities_on_outage_id_and_name_and_row_id` (`outage_id`,`name`,`row_id`),
  KEY `index_outage_entities_on_outage_id` (`outage_id`),
  KEY `index_outage_entities_on_name` (`name`),
  KEY `index_outage_entities_on_row_id` (`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_handlers`
--

DROP TABLE IF EXISTS `outage_handlers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_handlers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `full_name` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `note` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_outage_handlers_on_outage_id_and_user_id` (`outage_id`,`user_id`),
  KEY `index_outage_handlers_on_outage_id` (`outage_id`),
  KEY `index_outage_handlers_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_translations`
--

DROP TABLE IF EXISTS `outage_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_translations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) DEFAULT NULL,
  `outage_update_id` int(11) DEFAULT NULL,
  `language_id` int(11) NOT NULL,
  `summary` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8_czech_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_outage_translations_on_outage_id_and_language_id` (`outage_id`,`language_id`),
  UNIQUE KEY `index_outage_translations_on_outage_update_id_and_language_id` (`outage_update_id`,`language_id`),
  KEY `index_outage_translations_on_outage_id` (`outage_id`),
  KEY `index_outage_translations_on_outage_update_id` (`outage_update_id`),
  KEY `index_outage_translations_on_language_id` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_updates`
--

DROP TABLE IF EXISTS `outage_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_updates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) NOT NULL,
  `reported_by_id` int(11) DEFAULT NULL,
  `reporter_name` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `begins_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `outage_type` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_outage_updates_on_outage_id` (`outage_id`),
  KEY `index_outage_updates_on_reported_by_id` (`reported_by_id`),
  KEY `index_outage_updates_on_state` (`state`),
  KEY `index_outage_updates_on_outage_type` (`outage_type`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_vps_mounts`
--

DROP TABLE IF EXISTS `outage_vps_mounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_vps_mounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_vps_id` int(11) NOT NULL,
  `mount_id` int(11) NOT NULL,
  `src_node_id` int(11) NOT NULL,
  `src_pool_id` int(11) NOT NULL,
  `src_dataset_id` int(11) NOT NULL,
  `src_snapshot_id` int(11) DEFAULT NULL,
  `dataset_name` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `snapshot_name` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `mountpoint` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_outage_vps_mounts_on_outage_vps_id_and_mount_id` (`outage_vps_id`,`mount_id`),
  KEY `index_outage_vps_mounts_on_outage_vps_id` (`outage_vps_id`),
  KEY `index_outage_vps_mounts_on_mount_id` (`mount_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outage_vpses`
--

DROP TABLE IF EXISTS `outage_vpses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outage_vpses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) NOT NULL,
  `vps_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `environment_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `direct` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_outage_vpses_on_outage_id_and_vps_id` (`outage_id`,`vps_id`),
  KEY `index_outage_vpses_on_outage_id` (`outage_id`),
  KEY `index_outage_vpses_on_vps_id` (`vps_id`),
  KEY `index_outage_vpses_on_user_id` (`user_id`),
  KEY `index_outage_vpses_on_environment_id` (`environment_id`),
  KEY `index_outage_vpses_on_location_id` (`location_id`),
  KEY `index_outage_vpses_on_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `outages`
--

DROP TABLE IF EXISTS `outages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `planned` tinyint(1) NOT NULL,
  `begins_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `outage_type` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_outages_on_state` (`state`),
  KEY `index_outages_on_outage_type` (`outage_type`),
  KEY `index_outages_on_planned` (`planned`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pools`
--

DROP TABLE IF EXISTS `pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `label` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `filesystem` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `role` int(11) NOT NULL,
  `refquota_check` tinyint(1) NOT NULL DEFAULT '0',
  `maintenance_lock` int(11) NOT NULL DEFAULT '0',
  `maintenance_lock_reason` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `port_reservations`
--

DROP TABLE IF EXISTS `port_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `port_reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id` int(11) NOT NULL,
  `addr` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `port` int(11) NOT NULL,
  `transaction_chain_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `port_reservation_uniqueness` (`node_id`,`port`),
  KEY `index_port_reservations_on_transaction_chain_id` (`transaction_chain_id`),
  KEY `index_port_reservations_on_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=130001 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `repeatable_tasks`
--

DROP TABLE IF EXISTS `repeatable_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repeatable_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `table_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  `minute` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `hour` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `day_of_month` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `month` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `day_of_week` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource_locks`
--

DROP TABLE IF EXISTS `resource_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource_locks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `locked_by_id` int(11) DEFAULT NULL,
  `locked_by_type` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_resource_locks_on_resource_and_row_id` (`resource`,`row_id`),
  KEY `index_resource_locks_on_locked_by_id_and_locked_by_type` (`locked_by_id`,`locked_by_type`)
) ENGINE=InnoDB AUTO_INCREMENT=625 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `snapshot_downloads`
--

DROP TABLE IF EXISTS `snapshot_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snapshot_downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `snapshot_id` int(11) DEFAULT NULL,
  `pool_id` int(11) NOT NULL,
  `secret_key` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_state` int(11) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `format` int(11) NOT NULL DEFAULT '0',
  `from_snapshot_id` int(11) DEFAULT NULL,
  `sha256sum` varchar(64) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_snapshot_downloads_on_secret_key` (`secret_key`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `snapshot_in_pool_in_branches`
--

DROP TABLE IF EXISTS `snapshot_in_pool_in_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snapshot_in_pool_in_branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snapshot_in_pool_id` int(11) NOT NULL,
  `snapshot_in_pool_in_branch_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_snapshot_in_pool_in_branches` (`snapshot_in_pool_id`,`branch_id`),
  KEY `index_snapshot_in_pool_in_branches_on_snapshot_in_pool_id` (`snapshot_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `snapshot_in_pools`
--

DROP TABLE IF EXISTS `snapshot_in_pools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snapshot_in_pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snapshot_id` int(11) NOT NULL,
  `dataset_in_pool_id` int(11) NOT NULL,
  `reference_count` int(11) NOT NULL DEFAULT '0',
  `mount_id` int(11) DEFAULT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_snapshot_in_pools_on_snapshot_id_and_dataset_in_pool_id` (`snapshot_id`,`dataset_in_pool_id`),
  KEY `index_snapshot_in_pools_on_snapshot_id` (`snapshot_id`),
  KEY `index_snapshot_in_pools_on_dataset_in_pool_id` (`dataset_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3127 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `snapshots`
--

DROP TABLE IF EXISTS `snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `dataset_id` int(11) NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `snapshot_download_id` int(11) DEFAULT NULL,
  `history_id` int(11) NOT NULL DEFAULT '0',
  `label` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_snapshots_on_dataset_id` (`dataset_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1700 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sysconfig`
--

DROP TABLE IF EXISTS `sysconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysconfig` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(75) COLLATE utf8_czech_ci NOT NULL,
  `name` varchar(75) COLLATE utf8_czech_ci NOT NULL,
  `data_type` varchar(255) COLLATE utf8_czech_ci NOT NULL DEFAULT 'Text',
  `value` text COLLATE utf8_czech_ci,
  `label` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `description` text COLLATE utf8_czech_ci,
  `min_user_level` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sysconfig_on_category_and_name` (`category`,`name`),
  KEY `index_sysconfig_on_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_chain_concerns`
--

DROP TABLE IF EXISTS `transaction_chain_concerns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_chain_concerns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_chain_id` int(11) NOT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transaction_chain_concerns_on_transaction_chain_id` (`transaction_chain_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2760 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_chains`
--

DROP TABLE IF EXISTS `transaction_chains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_chains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `type` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `state` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `progress` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `urgent_rollback` int(11) NOT NULL DEFAULT '0',
  `concern_type` int(11) NOT NULL DEFAULT '0',
  `user_session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transaction_chains_on_user_id` (`user_id`),
  KEY `index_transaction_chains_on_user_session_id` (`user_session_id`),
  KEY `index_transaction_chains_on_state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=4526 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction_confirmations`
--

DROP TABLE IF EXISTS `transaction_confirmations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_confirmations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_id` int(11) NOT NULL,
  `class_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `table_name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `row_pks` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `attr_changes` text COLLATE utf8_czech_ci,
  `confirm_type` int(11) NOT NULL,
  `done` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transaction_confirmations_on_transaction_id` (`transaction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64036 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `node_id` int(10) unsigned DEFAULT NULL,
  `vps_id` int(10) unsigned DEFAULT NULL,
  `handle` int(10) unsigned NOT NULL,
  `depends_on_id` int(11) DEFAULT NULL,
  `urgent` tinyint(1) NOT NULL DEFAULT '0',
  `priority` int(11) NOT NULL DEFAULT '0',
  `status` int(10) unsigned NOT NULL,
  `done` int(11) NOT NULL DEFAULT '0',
  `input` longtext,
  `output` text,
  `transaction_chain_id` int(11) NOT NULL,
  `reversible` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `queue` varchar(30) NOT NULL DEFAULT 'general',
  PRIMARY KEY (`id`),
  KEY `index_transactions_on_transaction_chain_id` (`transaction_chain_id`),
  KEY `index_transactions_on_depends_on_id` (`depends_on_id`),
  KEY `index_transactions_on_status` (`status`),
  KEY `index_transactions_on_done` (`done`),
  KEY `index_transactions_on_node_id` (`node_id`),
  KEY `index_transactions_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26550 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_accounts`
--

DROP TABLE IF EXISTS `user_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `monthly_payment` int(11) NOT NULL DEFAULT '0',
  `paid_until` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_accounts_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_cluster_resources`
--

DROP TABLE IF EXISTS `user_cluster_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_cluster_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `environment_id` int(11) NOT NULL,
  `cluster_resource_id` int(11) NOT NULL,
  `value` decimal(40,0) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_cluster_resource_unique` (`user_id`,`environment_id`,`cluster_resource_id`),
  KEY `index_user_cluster_resources_on_user_id` (`user_id`),
  KEY `index_user_cluster_resources_on_environment_id` (`environment_id`),
  KEY `index_user_cluster_resources_on_cluster_resource_id` (`cluster_resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=964 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mail_role_recipients`
--

DROP TABLE IF EXISTS `user_mail_role_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mail_role_recipients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `to` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_mail_role_recipients_on_user_id_and_role` (`user_id`,`role`),
  KEY `index_user_mail_role_recipients_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_mail_template_recipients`
--

DROP TABLE IF EXISTS `user_mail_template_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_mail_template_recipients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `mail_template_id` int(11) NOT NULL,
  `to` varchar(500) COLLATE utf8_czech_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_mail_template_id` (`user_id`,`mail_template_id`),
  KEY `index_user_mail_template_recipients_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespace_blocks`
--

DROP TABLE IF EXISTS `user_namespace_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespace_blocks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_namespace_id` int(11) DEFAULT NULL,
  `index` int(11) NOT NULL,
  `offset` int(10) unsigned NOT NULL,
  `size` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_namespace_blocks_on_index` (`index`),
  KEY `index_user_namespace_blocks_on_user_namespace_id` (`user_namespace_id`),
  KEY `index_user_namespace_blocks_on_offset` (`offset`)
) ENGINE=InnoDB AUTO_INCREMENT=65535 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespace_map_entries`
--

DROP TABLE IF EXISTS `user_namespace_map_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespace_map_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_namespace_map_id` int(11) NOT NULL,
  `kind` int(11) NOT NULL,
  `ns_id` int(10) unsigned NOT NULL,
  `host_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_namespace_map_entries_on_user_namespace_map_id` (`user_namespace_map_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespace_map_nodes`
--

DROP TABLE IF EXISTS `user_namespace_map_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespace_map_nodes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_namespace_map_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_namespace_map_nodes_unique` (`user_namespace_map_id`,`node_id`),
  KEY `index_user_namespace_map_nodes_on_user_namespace_map_id` (`user_namespace_map_id`),
  KEY `index_user_namespace_map_nodes_on_node_id` (`node_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespace_map_ugids`
--

DROP TABLE IF EXISTS `user_namespace_map_ugids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespace_map_ugids` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_namespace_map_id` int(11) DEFAULT NULL,
  `ugid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_namespace_map_ugids_on_ugid` (`ugid`),
  UNIQUE KEY `index_user_namespace_map_ugids_on_user_namespace_map_id` (`user_namespace_map_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10001 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespace_maps`
--

DROP TABLE IF EXISTS `user_namespace_maps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespace_maps` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_namespace_id` int(11) NOT NULL,
  `user_namespace_map_ugid_id` int(11) NOT NULL,
  `label` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_namespace_maps_on_user_namespace_map_ugid_id` (`user_namespace_map_ugid_id`),
  KEY `index_user_namespace_maps_on_user_namespace_id` (`user_namespace_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_namespaces`
--

DROP TABLE IF EXISTS `user_namespaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_namespaces` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `block_count` int(11) NOT NULL,
  `offset` int(10) unsigned NOT NULL,
  `size` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_namespaces_on_user_id` (`user_id`),
  KEY `index_user_namespaces_on_block_count` (`block_count`),
  KEY `index_user_namespaces_on_offset` (`offset`),
  KEY `index_user_namespaces_on_size` (`size`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_payments`
--

DROP TABLE IF EXISTS `user_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `incoming_payment_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `accounted_by_id` int(11) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `from_date` datetime NOT NULL,
  `to_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_user_payments_on_incoming_payment_id` (`incoming_payment_id`),
  KEY `index_user_payments_on_user_id` (`user_id`),
  KEY `index_user_payments_on_accounted_by_id` (`accounted_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_public_keys`
--

DROP TABLE IF EXISTS `user_public_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_public_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `label` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `key` text COLLATE utf8_czech_ci NOT NULL,
  `auto_add` tinyint(1) NOT NULL DEFAULT '0',
  `fingerprint` varchar(50) COLLATE utf8_czech_ci NOT NULL,
  `comment` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_public_keys_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_requests`
--

DROP TABLE IF EXISTS `user_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_requests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `api_ip_addr` varchar(127) COLLATE utf8_czech_ci NOT NULL,
  `api_ip_ptr` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `client_ip_addr` varchar(127) COLLATE utf8_czech_ci DEFAULT NULL,
  `client_ip_ptr` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `last_mail_id` int(11) NOT NULL DEFAULT '0',
  `admin_id` int(11) DEFAULT NULL,
  `admin_response` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `login` varchar(75) COLLATE utf8_czech_ci DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `org_name` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `org_id` varchar(30) COLLATE utf8_czech_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `address` text COLLATE utf8_czech_ci,
  `year_of_birth` int(11) DEFAULT NULL,
  `how` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `note` varchar(500) COLLATE utf8_czech_ci DEFAULT NULL,
  `os_template_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `currency` varchar(10) COLLATE utf8_czech_ci DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `change_reason` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `access_token` varchar(40) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_requests_on_user_id` (`user_id`),
  KEY `index_user_requests_on_type` (`type`),
  KEY `index_user_requests_on_state` (`state`),
  KEY `index_user_requests_on_admin_id` (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_session_agents`
--

DROP TABLE IF EXISTS `user_session_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_session_agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent` text COLLATE utf8_czech_ci NOT NULL,
  `agent_hash` varchar(40) COLLATE utf8_czech_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_session_agents_hash` (`agent_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `auth_type` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  `api_ip_addr` varchar(46) COLLATE utf8_czech_ci NOT NULL,
  `user_session_agent_id` int(11) DEFAULT NULL,
  `client_version` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `api_token_id` int(11) DEFAULT NULL,
  `api_token_str` varchar(100) COLLATE utf8_czech_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `last_request_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `api_ip_ptr` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  `client_ip_addr` varchar(46) COLLATE utf8_czech_ci DEFAULT NULL,
  `client_ip_ptr` varchar(255) COLLATE utf8_czech_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_sessions_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28722 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `info` text,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `level` int(10) unsigned NOT NULL,
  `login` varchar(63) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(127) DEFAULT NULL,
  `address` text,
  `mailer_enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `login_count` int(11) NOT NULL DEFAULT '0',
  `failed_login_count` int(11) NOT NULL DEFAULT '0',
  `last_request_at` datetime DEFAULT NULL,
  `current_login_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `current_login_ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_login_ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `object_state` int(11) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `password_version` int(11) NOT NULL DEFAULT '1',
  `last_activity_at` datetime DEFAULT NULL,
  `language_id` int(11) DEFAULT '1',
  `orig_login` varchar(63) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`),
  KEY `index_users_on_object_state` (`object_state`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `item_id` int(11) NOT NULL,
  `event` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `whodunnit` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `object` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_item_type_and_item_id` (`item_type`,`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36837 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_configs`
--

DROP TABLE IF EXISTS `vps_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_czech_ci NOT NULL,
  `label` varchar(50) NOT NULL,
  `config` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_consoles`
--

DROP TABLE IF EXISTS `vps_consoles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_consoles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `expiration` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vps_consoles_on_token` (`token`)
) ENGINE=MyISAM AUTO_INCREMENT=347 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_current_statuses`
--

DROP TABLE IF EXISTS `vps_current_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_current_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `is_running` tinyint(1) NOT NULL,
  `uptime` int(11) DEFAULT NULL,
  `cpus` int(11) DEFAULT NULL,
  `total_memory` int(11) DEFAULT NULL,
  `total_swap` int(11) DEFAULT NULL,
  `update_count` int(11) NOT NULL,
  `process_count` int(11) DEFAULT NULL,
  `cpu_user` float DEFAULT NULL,
  `cpu_nice` float DEFAULT NULL,
  `cpu_system` float DEFAULT NULL,
  `cpu_idle` float DEFAULT NULL,
  `cpu_iowait` float DEFAULT NULL,
  `cpu_irq` float DEFAULT NULL,
  `cpu_softirq` float DEFAULT NULL,
  `loadavg` float DEFAULT NULL,
  `used_memory` int(11) DEFAULT NULL,
  `used_swap` int(11) DEFAULT NULL,
  `sum_process_count` int(11) DEFAULT NULL,
  `sum_cpu_user` float DEFAULT NULL,
  `sum_cpu_nice` float DEFAULT NULL,
  `sum_cpu_system` float DEFAULT NULL,
  `sum_cpu_idle` float DEFAULT NULL,
  `sum_cpu_iowait` float DEFAULT NULL,
  `sum_cpu_irq` float DEFAULT NULL,
  `sum_cpu_softirq` float DEFAULT NULL,
  `sum_loadavg` float DEFAULT NULL,
  `sum_used_memory` int(11) DEFAULT NULL,
  `sum_used_swap` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vps_current_statuses_on_vps_id` (`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_features`
--

DROP TABLE IF EXISTS `vps_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_czech_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vps_features_on_vps_id_and_name` (`vps_id`,`name`),
  KEY `index_vps_features_on_vps_id` (`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1639 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_has_configs`
--

DROP TABLE IF EXISTS `vps_has_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_has_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `vps_config_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `confirmed` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vps_has_configs_on_vps_id_and_vps_config_id_and_confirmed` (`vps_id`,`vps_config_id`,`confirmed`),
  KEY `index_vps_has_configs_on_vps_id` (`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_migrations`
--

DROP TABLE IF EXISTS `vps_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `migration_plan_id` int(11) NOT NULL,
  `state` int(11) NOT NULL DEFAULT '0',
  `outage_window` tinyint(1) NOT NULL DEFAULT '1',
  `transaction_chain_id` int(11) DEFAULT NULL,
  `src_node_id` int(11) NOT NULL,
  `dst_node_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `cleanup_data` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `vps_migrations_unique` (`migration_plan_id`,`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_outage_windows`
--

DROP TABLE IF EXISTS `vps_outage_windows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_outage_windows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `weekday` int(11) NOT NULL,
  `is_open` tinyint(1) NOT NULL,
  `opens_at` int(11) DEFAULT NULL,
  `closes_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vps_outage_windows_on_vps_id_and_weekday` (`vps_id`,`weekday`)
) ENGINE=InnoDB AUTO_INCREMENT=925 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vps_statuses`
--

DROP TABLE IF EXISTS `vps_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vps_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vps_id` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `is_running` tinyint(1) NOT NULL,
  `uptime` int(11) DEFAULT NULL,
  `process_count` int(11) DEFAULT NULL,
  `cpus` int(11) DEFAULT NULL,
  `cpu_user` float DEFAULT NULL,
  `cpu_nice` float DEFAULT NULL,
  `cpu_system` float DEFAULT NULL,
  `cpu_idle` float DEFAULT NULL,
  `cpu_iowait` float DEFAULT NULL,
  `cpu_irq` float DEFAULT NULL,
  `cpu_softirq` float DEFAULT NULL,
  `loadavg` float DEFAULT NULL,
  `total_memory` int(11) DEFAULT NULL,
  `used_memory` int(11) DEFAULT NULL,
  `total_swap` int(11) DEFAULT NULL,
  `used_swap` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_vps_statuses_on_vps_id` (`vps_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31254 DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vpses`
--

DROP TABLE IF EXISTS `vpses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vpses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(63) unsigned NOT NULL,
  `hostname` varchar(255) DEFAULT 'vps',
  `os_template_id` int(10) unsigned NOT NULL DEFAULT '1',
  `info` mediumtext,
  `dns_resolver_id` int(11) DEFAULT NULL,
  `node_id` int(11) unsigned NOT NULL,
  `onboot` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `onstartall` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `config` text NOT NULL,
  `confirmed` int(11) NOT NULL DEFAULT '0',
  `dataset_in_pool_id` int(11) DEFAULT NULL,
  `maintenance_lock` int(11) NOT NULL DEFAULT '0',
  `maintenance_lock_reason` varchar(255) DEFAULT NULL,
  `object_state` int(11) NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `manage_hostname` tinyint(1) NOT NULL DEFAULT '1',
  `cpu_limit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_vpses_on_user_id` (`user_id`),
  KEY `index_vpses_on_node_id` (`node_id`),
  KEY `index_vpses_on_os_template_id` (`os_template_id`),
  KEY `index_vpses_on_dns_resolver_id` (`dns_resolver_id`),
  KEY `index_vpses_on_object_state` (`object_state`),
  KEY `index_vpses_on_dataset_in_pool_id` (`dataset_in_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=360 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-10  9:01:53
INSERT INTO schema_migrations (version) VALUES ('20140208170244');

INSERT INTO schema_migrations (version) VALUES ('20140227150154');

INSERT INTO schema_migrations (version) VALUES ('20140615185520');

INSERT INTO schema_migrations (version) VALUES ('20140815161745');

INSERT INTO schema_migrations (version) VALUES ('20140913164605');

INSERT INTO schema_migrations (version) VALUES ('20140927161625');

INSERT INTO schema_migrations (version) VALUES ('20140927161700');

INSERT INTO schema_migrations (version) VALUES ('20141105130158');

INSERT INTO schema_migrations (version) VALUES ('20141105175157');

INSERT INTO schema_migrations (version) VALUES ('20141112075438');

INSERT INTO schema_migrations (version) VALUES ('20141212180955');

INSERT INTO schema_migrations (version) VALUES ('20150126080724');

INSERT INTO schema_migrations (version) VALUES ('20150131162852');

INSERT INTO schema_migrations (version) VALUES ('20150205145349');

INSERT INTO schema_migrations (version) VALUES ('20150206154652');

INSERT INTO schema_migrations (version) VALUES ('20150218142131');

INSERT INTO schema_migrations (version) VALUES ('20150307174728');

INSERT INTO schema_migrations (version) VALUES ('20150309175827');

INSERT INTO schema_migrations (version) VALUES ('20150312171845');

INSERT INTO schema_migrations (version) VALUES ('20150528110508');

INSERT INTO schema_migrations (version) VALUES ('20150528111113');

INSERT INTO schema_migrations (version) VALUES ('20150614074218');

INSERT INTO schema_migrations (version) VALUES ('20150618124817');

INSERT INTO schema_migrations (version) VALUES ('20150625145437');

INSERT INTO schema_migrations (version) VALUES ('20150630072821');

INSERT INTO schema_migrations (version) VALUES ('20150715150147');

INSERT INTO schema_migrations (version) VALUES ('20150717065916');

INSERT INTO schema_migrations (version) VALUES ('20150728160553');

INSERT INTO schema_migrations (version) VALUES ('20150730133630');

INSERT INTO schema_migrations (version) VALUES ('20150730152316');

INSERT INTO schema_migrations (version) VALUES ('20150801090150');

INSERT INTO schema_migrations (version) VALUES ('20150801211753');

INSERT INTO schema_migrations (version) VALUES ('20150802162711');

INSERT INTO schema_migrations (version) VALUES ('20150804201125');

INSERT INTO schema_migrations (version) VALUES ('20150807152819');

INSERT INTO schema_migrations (version) VALUES ('20150811075054');

INSERT INTO schema_migrations (version) VALUES ('20150820174810');

INSERT INTO schema_migrations (version) VALUES ('20150903081103');

INSERT INTO schema_migrations (version) VALUES ('20150903120108');

INSERT INTO schema_migrations (version) VALUES ('20150904081403');

INSERT INTO schema_migrations (version) VALUES ('20150904152438');

INSERT INTO schema_migrations (version) VALUES ('20151002090440');

INSERT INTO schema_migrations (version) VALUES ('20151004115901');

INSERT INTO schema_migrations (version) VALUES ('20151015085656');

INSERT INTO schema_migrations (version) VALUES ('20151017130111');

INSERT INTO schema_migrations (version) VALUES ('20151017155120');

INSERT INTO schema_migrations (version) VALUES ('20151029155746');

INSERT INTO schema_migrations (version) VALUES ('20151029160857');

INSERT INTO schema_migrations (version) VALUES ('20151124085214');

INSERT INTO schema_migrations (version) VALUES ('20151124085559');

INSERT INTO schema_migrations (version) VALUES ('20151213173722');

INSERT INTO schema_migrations (version) VALUES ('20160109160611');

INSERT INTO schema_migrations (version) VALUES ('20160120075845');

INSERT INTO schema_migrations (version) VALUES ('20160130185329');

INSERT INTO schema_migrations (version) VALUES ('20160201072025');

INSERT INTO schema_migrations (version) VALUES ('20160203074500');

INSERT INTO schema_migrations (version) VALUES ('20160203074916');

INSERT INTO schema_migrations (version) VALUES ('20160204152946');

INSERT INTO schema_migrations (version) VALUES ('20160208123742');

INSERT INTO schema_migrations (version) VALUES ('20160214135014');

INSERT INTO schema_migrations (version) VALUES ('20160214135501');

INSERT INTO schema_migrations (version) VALUES ('20160222135554');

INSERT INTO schema_migrations (version) VALUES ('20160224195110');

INSERT INTO schema_migrations (version) VALUES ('20160229081009');

INSERT INTO schema_migrations (version) VALUES ('20160308154537');

INSERT INTO schema_migrations (version) VALUES ('20160614112222');

INSERT INTO schema_migrations (version) VALUES ('20160624185945');

INSERT INTO schema_migrations (version) VALUES ('20160627085407');

INSERT INTO schema_migrations (version) VALUES ('20160628064205');

INSERT INTO schema_migrations (version) VALUES ('20160629150716');

INSERT INTO schema_migrations (version) VALUES ('20160805144125');

INSERT INTO schema_migrations (version) VALUES ('20160819084000');

INSERT INTO schema_migrations (version) VALUES ('20160819100816');

INSERT INTO schema_migrations (version) VALUES ('20160826150804');

INSERT INTO schema_migrations (version) VALUES ('20160831111818');

INSERT INTO schema_migrations (version) VALUES ('20160902154617');

INSERT INTO schema_migrations (version) VALUES ('20160904191844');

INSERT INTO schema_migrations (version) VALUES ('20160906090554');

INSERT INTO schema_migrations (version) VALUES ('20160907135218');

INSERT INTO schema_migrations (version) VALUES ('20161115174257');

INSERT INTO schema_migrations (version) VALUES ('20170114091907');

INSERT INTO schema_migrations (version) VALUES ('20170114153715');

INSERT INTO schema_migrations (version) VALUES ('20170115092224');

INSERT INTO schema_migrations (version) VALUES ('20170115104106');

INSERT INTO schema_migrations (version) VALUES ('20170115153933');

INSERT INTO schema_migrations (version) VALUES ('20170115162128');

INSERT INTO schema_migrations (version) VALUES ('20170116135908');

INSERT INTO schema_migrations (version) VALUES ('20170117132633');

INSERT INTO schema_migrations (version) VALUES ('20170117181427');

INSERT INTO schema_migrations (version) VALUES ('20170118094034');

INSERT INTO schema_migrations (version) VALUES ('20170118160101');

INSERT INTO schema_migrations (version) VALUES ('20170120080846');

INSERT INTO schema_migrations (version) VALUES ('20170121214350');

INSERT INTO schema_migrations (version) VALUES ('20170122083340');

INSERT INTO schema_migrations (version) VALUES ('20170125153139');

INSERT INTO schema_migrations (version) VALUES ('20170130112048');

INSERT INTO schema_migrations (version) VALUES ('20170130154206');

INSERT INTO schema_migrations (version) VALUES ('20170201082030');

INSERT INTO schema_migrations (version) VALUES ('20170201093720');

INSERT INTO schema_migrations (version) VALUES ('20170203122106');

INSERT INTO schema_migrations (version) VALUES ('20170204092606');

INSERT INTO schema_migrations (version) VALUES ('20170223191015');

INSERT INTO schema_migrations (version) VALUES ('20170325151018');

INSERT INTO schema_migrations (version) VALUES ('20170408184500');

INSERT INTO schema_migrations (version) VALUES ('20170419144000');

INSERT INTO schema_migrations (version) VALUES ('20170610084155');

INSERT INTO schema_migrations (version) VALUES ('20171106154702');

INSERT INTO schema_migrations (version) VALUES ('20180412063632');

INSERT INTO schema_migrations (version) VALUES ('20180416111102');

INSERT INTO schema_migrations (version) VALUES ('20180501071844');

INSERT INTO schema_migrations (version) VALUES ('20180501145934');

INSERT INTO schema_migrations (version) VALUES ('20180503073718');

INSERT INTO schema_migrations (version) VALUES ('20180516061203');

INSERT INTO schema_migrations (version) VALUES ('20180518104840');

INSERT INTO schema_migrations (version) VALUES ('20180518140011');

INSERT INTO schema_migrations (version) VALUES ('20180524085512');

INSERT INTO schema_migrations (version) VALUES ('20180524103629');

INSERT INTO schema_migrations (version) VALUES ('20180525100900');

INSERT INTO schema_migrations (version) VALUES ('20180604115723');

INSERT INTO schema_migrations (version) VALUES ('20180715203314');

