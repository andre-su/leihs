# ************************************************************
# Database: leihs2_test
# Generation Time: 2014-01-21 09:03:33 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table access_rights
# ------------------------------------------------------------

DROP TABLE IF EXISTS `access_rights`;

CREATE TABLE `access_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `suspended_until` date DEFAULT NULL,
  `deleted_at` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `suspended_reason` text COLLATE utf8_unicode_ci,
  `role` enum('customer','group_manager','lending_manager','inventory_manager','admin') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_access_rights_on_suspended_until` (`suspended_until`),
  KEY `index_access_rights_on_deleted_at` (`deleted_at`),
  KEY `index_access_rights_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_on_user_id_and_inventory_pool_id_and_deleted_at` (`user_id`,`inventory_pool_id`,`deleted_at`),
  KEY `index_access_rights_on_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table accessories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accessories`;

CREATE TABLE `accessories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_accessories_on_model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table accessories_inventory_pools
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accessories_inventory_pools`;

CREATE TABLE `accessories_inventory_pools` (
  `accessory_id` int(11) DEFAULT NULL,
  `inventory_pool_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_accessories_inventory_pools` (`accessory_id`,`inventory_pool_id`),
  KEY `index_accessories_inventory_pools_on_inventory_pool_id` (`inventory_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `addresses`;

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_addresses_on_street_and_zip_code_and_city_and_country_code` (`street`,`zip_code`,`city`,`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table attachments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `attachments`;

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) DEFAULT NULL,
  `is_main` tinyint(1) DEFAULT '0',
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attachments_on_model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table authentication_systems
# ------------------------------------------------------------

DROP TABLE IF EXISTS `authentication_systems`;

CREATE TABLE `authentication_systems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `class_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table buildings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `buildings`;

CREATE TABLE `buildings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table contract_lines
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contract_lines`;

CREATE TABLE `contract_lines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ItemLine',
  `item_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '1',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `returned_date` date DEFAULT NULL,
  `option_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `purpose_id` int(11) DEFAULT NULL,
  `returned_to_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contract_lines_on_start_date` (`start_date`),
  KEY `index_contract_lines_on_end_date` (`end_date`),
  KEY `index_contract_lines_on_option_id` (`option_id`),
  KEY `fk_contract_lines_contract_id` (`contract_id`),
  KEY `fk_contract_lines_item_id` (`item_id`),
  KEY `fk_contract_lines_model_id` (`model_id`),
  KEY `index_contract_lines_on_returned_date_and_contract_id` (`returned_date`,`contract_id`),
  KEY `index_contract_lines_on_type_and_contract_id` (`type`,`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table contracts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contracts`;

CREATE TABLE `contracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `handed_over_by_user_id` int(11) DEFAULT NULL,
  `status` enum('unsubmitted','submitted','rejected','approved','signed','closed') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_contracts_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_contracts_on_user_id` (`user_id`),
  KEY `index_contracts_on_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table database_authentications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `database_authentications`;

CREATE TABLE `database_authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_verification_required` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_groups_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_groups_on_is_verification_required` (`is_verification_required`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table groups_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups_users`;

CREATE TABLE `groups_users` (
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_groups_users_on_user_id_and_group_id` (`user_id`,`group_id`),
  KEY `index_groups_users_on_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table histories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `histories`;

CREATE TABLE `histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `type_const` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `target_id` int(11) NOT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_histories_on_target_type_and_target_id` (`target_type`,`target_id`),
  KEY `index_histories_on_type_const` (`type_const`),
  KEY `index_histories_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table holidays
# ------------------------------------------------------------

DROP TABLE IF EXISTS `holidays`;

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_holidays_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_holidays_on_start_date_and_end_date` (`start_date`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table images
# ------------------------------------------------------------

DROP TABLE IF EXISTS `images`;

CREATE TABLE `images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) DEFAULT NULL,
  `is_main` tinyint(1) DEFAULT '0',
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_images_on_model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table inventory_pools
# ------------------------------------------------------------

DROP TABLE IF EXISTS `inventory_pools`;

CREATE TABLE `inventory_pools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `contact_details` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contract_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contract_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_contract_note` text COLLATE utf8_unicode_ci,
  `shortname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `color` text COLLATE utf8_unicode_ci,
  `print_contracts` tinyint(1) DEFAULT '1',
  `opening_hours` text COLLATE utf8_unicode_ci,
  `address_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_inventory_pools_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table inventory_pools_model_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `inventory_pools_model_groups`;

CREATE TABLE `inventory_pools_model_groups` (
  `inventory_pool_id` int(11) DEFAULT NULL,
  `model_group_id` int(11) DEFAULT NULL,
  KEY `index_inventory_pools_model_groups_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_inventory_pools_model_groups_on_model_group_id` (`model_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `serial_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `invoice_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `last_check` date DEFAULT NULL,
  `retired` date DEFAULT NULL,
  `retired_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `is_broken` tinyint(1) DEFAULT '0',
  `is_incomplete` tinyint(1) DEFAULT '0',
  `is_borrowable` tinyint(1) DEFAULT '0',
  `needs_permission` tinyint(1) DEFAULT '0',
  `inventory_pool_id` int(11) DEFAULT NULL,
  `is_inventory_relevant` tinyint(1) DEFAULT '0',
  `responsible` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `insurance_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `name` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `properties` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_items_on_inventory_code` (`inventory_code`),
  KEY `index_items_on_inventory_pool_id` (`inventory_pool_id`),
  KEY `index_items_on_retired` (`retired`),
  KEY `index_items_on_is_borrowable` (`is_borrowable`),
  KEY `index_items_on_is_broken` (`is_broken`),
  KEY `index_items_on_is_incomplete` (`is_incomplete`),
  KEY `index_items_on_location_id` (`location_id`),
  KEY `index_items_on_owner_id` (`owner_id`),
  KEY `index_items_on_parent_id_and_retired` (`parent_id`,`retired`),
  KEY `index_items_on_model_id_and_retired_and_inventory_pool_id` (`model_id`,`retired`,`inventory_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table languages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `languages`;

CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locale_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default` tinyint(1) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_languages_on_name` (`name`),
  KEY `index_languages_on_active_and_default` (`active`,`default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table locations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `locations`;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shelf` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `building_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locations_on_building_id` (`building_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table model_group_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `model_group_links`;

CREATE TABLE `model_group_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ancestor_id` int(11) DEFAULT NULL,
  `descendant_id` int(11) DEFAULT NULL,
  `direct` tinyint(1) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_model_group_links_on_ancestor_id` (`ancestor_id`),
  KEY `index_model_group_links_on_direct` (`direct`),
  KEY `index_on_descendant_id_and_ancestor_id_and_direct` (`descendant_id`,`ancestor_id`,`direct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table model_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `model_groups`;

CREATE TABLE `model_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_model_groups_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table model_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `model_links`;

CREATE TABLE `model_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_group_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_model_links_on_model_id_and_model_group_id` (`model_id`,`model_group_id`),
  KEY `index_model_links_on_model_group_id_and_model_id` (`model_group_id`,`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table models
# ------------------------------------------------------------

DROP TABLE IF EXISTS `models`;

CREATE TABLE `models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `manufacturer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `internal_description` text COLLATE utf8_unicode_ci,
  `info_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rental_price` decimal(8,2) DEFAULT NULL,
  `maintenance_period` int(11) DEFAULT '0',
  `is_package` tinyint(1) DEFAULT '0',
  `technical_detail` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `hand_over_note` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_models_on_is_package` (`is_package`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table models_compatibles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `models_compatibles`;

CREATE TABLE `models_compatibles` (
  `model_id` int(11) DEFAULT NULL,
  `compatible_id` int(11) DEFAULT NULL,
  KEY `index_models_compatibles_on_compatible_id` (`compatible_id`),
  KEY `index_models_compatibles_on_model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table notifications
# ------------------------------------------------------------

DROP TABLE IF EXISTS `notifications`;

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table numerators
# ------------------------------------------------------------

DROP TABLE IF EXISTS `numerators`;

CREATE TABLE `numerators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table options
# ------------------------------------------------------------

DROP TABLE IF EXISTS `options`;

CREATE TABLE `options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `inventory_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_options_on_inventory_pool_id` (`inventory_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table partitions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `partitions`;

CREATE TABLE `partitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) DEFAULT NULL,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_partitions_on_model_id_and_inventory_pool_id_and_group_id` (`model_id`,`inventory_pool_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table partitions_with_generals
# ------------------------------------------------------------

DROP VIEW IF EXISTS `partitions_with_generals`;

CREATE TABLE `partitions_with_generals` (
   `model_id` INT(11) NULL DEFAULT NULL,
   `inventory_pool_id` INT(11) NULL DEFAULT NULL,
   `group_id` INT(11) NULL DEFAULT NULL,
   `quantity` DECIMAL(33) NULL DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table properties
# ------------------------------------------------------------

DROP TABLE IF EXISTS `properties`;

CREATE TABLE `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model_id` int(11) DEFAULT NULL,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_properties_on_model_id` (`model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table purposes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `purposes`;

CREATE TABLE `purposes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table running_lines
# ------------------------------------------------------------

DROP VIEW IF EXISTS `running_lines`;

CREATE TABLE `running_lines` (
   `id` INT(11) NOT NULL DEFAULT '0',
   `type` VARCHAR(255) NOT NULL DEFAULT 'ItemLine',
   `inventory_pool_id` INT(11) NULL DEFAULT NULL,
   `model_id` INT(11) NULL DEFAULT NULL,
   `quantity` INT(11) NULL DEFAULT '1',
   `start_date` DATE NULL DEFAULT NULL,
   `end_date` DATE NULL DEFAULT NULL,
   `is_late` INT(1) NULL DEFAULT NULL,
   `unavailable_from` DATE NULL DEFAULT NULL,
   `concat_group_ids` LONGBLOB NULL DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table schema_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schema_migrations`;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table settings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `settings`;

CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `smtp_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smtp_port` int(11) DEFAULT NULL,
  `smtp_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `local_currency_string` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contract_terms` text COLLATE utf8_unicode_ci,
  `contract_lending_party_string` text COLLATE utf8_unicode_ci,
  `email_signature` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deliver_order_notifications` tinyint(1) DEFAULT NULL,
  `user_image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ldap_config` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_delivery_method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smtp_username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smtp_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table suppliers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `suppliers`;

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authentication_system_id` int(11) DEFAULT '1',
  `unique_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `badge_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `extended_info` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `settings` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_users_on_authentication_system_id` (`authentication_system_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table visit_lines
# ------------------------------------------------------------

DROP VIEW IF EXISTS `visit_lines`;

CREATE TABLE `visit_lines` (
   `visit_id` VARCHAR(86) NULL DEFAULT NULL,
   `inventory_pool_id` INT(11) NULL DEFAULT NULL,
   `user_id` INT(11) NULL DEFAULT NULL,
   `status` ENUM('unsubmitted','submitted','rejected','approved','signed','closed') NOT NULL,
   `action` VARCHAR(9) NOT NULL DEFAULT '',
   `date` DATE NULL DEFAULT NULL,
   `quantity` INT(11) NULL DEFAULT '1',
   `contract_line_id` INT(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM;



# Dump of table visits
# ------------------------------------------------------------

DROP VIEW IF EXISTS `visits`;

CREATE TABLE `visits` (
   `id` VARCHAR(86) NULL DEFAULT NULL,
   `inventory_pool_id` INT(11) NULL DEFAULT NULL,
   `user_id` INT(11) NULL DEFAULT NULL,
   `status` ENUM('unsubmitted','submitted','rejected','approved','signed','closed') NOT NULL,
   `action` VARCHAR(9) NOT NULL DEFAULT '',
   `date` DATE NULL DEFAULT NULL,
   `quantity` DECIMAL(32) NULL DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table workdays
# ------------------------------------------------------------

DROP TABLE IF EXISTS `workdays`;

CREATE TABLE `workdays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_pool_id` int(11) DEFAULT NULL,
  `monday` tinyint(1) DEFAULT '1',
  `tuesday` tinyint(1) DEFAULT '1',
  `wednesday` tinyint(1) DEFAULT '1',
  `thursday` tinyint(1) DEFAULT '1',
  `friday` tinyint(1) DEFAULT '1',
  `saturday` tinyint(1) DEFAULT '0',
  `sunday` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_workdays_on_inventory_pool_id` (`inventory_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;





# Replace placeholder table for partitions_with_generals with correct view syntax
# ------------------------------------------------------------

DROP TABLE `partitions_with_generals`;

CREATE VIEW `partitions_with_generals`
AS SELECT
   `partitions`.`model_id` AS `model_id`,
   `partitions`.`inventory_pool_id` AS `inventory_pool_id`,
   `partitions`.`group_id` AS `group_id`,
   `partitions`.`quantity` AS `quantity`
FROM `partitions` union select `i`.`model_id` AS `model_id`,`i`.`inventory_pool_id` AS `inventory_pool_id`,NULL AS `group_id`,(count(`i`.`id`) - ifnull((select sum(`p`.`quantity`) from `partitions` `p` where ((`p`.`model_id` = `i`.`model_id`) and (`p`.`inventory_pool_id` = `i`.`inventory_pool_id`)) group by `p`.`inventory_pool_id`,`p`.`model_id`),0)) AS `quantity` from `items` `i` where (isnull(`i`.`retired`) and (`i`.`is_borrowable` = 1) and isnull(`i`.`parent_id`)) group by `i`.`inventory_pool_id`,`i`.`model_id`;


# Replace placeholder table for visit_lines with correct view syntax
# ------------------------------------------------------------

DROP TABLE `visit_lines`;

CREATE VIEW `visit_lines`
AS SELECT
   hex(concat(if((`c`.`status` = 'approved'),`cl`.`start_date`,
   `cl`.`end_date`),`c`.`inventory_pool_id`,
   `c`.`user_id`,
   `c`.`status`)) AS `visit_id`,
   `c`.`inventory_pool_id` AS `inventory_pool_id`,
   `c`.`user_id` AS `user_id`,
   `c`.`status` AS `status`,if((`c`.`status` = 'approved'),'hand_over','take_back') AS `action`,if((`c`.`status` = 'approved'),`cl`.`start_date`,
   `cl`.`end_date`) AS `date`,
   `cl`.`quantity` AS `quantity`,
   `cl`.`id` AS `contract_line_id`
FROM (`contract_lines` `cl` join `contracts` `c` on((`cl`.`contract_id` = `c`.`id`))) where ((`c`.`status` in ('approved','signed')) and isnull(`cl`.`returned_date`)) order by if((`c`.`status` = 'approved'),`cl`.`start_date`,`cl`.`end_date`);


# Replace placeholder table for running_lines with correct view syntax
# ------------------------------------------------------------

DROP TABLE `running_lines`;

CREATE VIEW `running_lines`
AS SELECT
   `contract_lines`.`id` AS `id`,
   `contract_lines`.`type` AS `type`,
   `contracts`.`inventory_pool_id` AS `inventory_pool_id`,
   `contract_lines`.`model_id` AS `model_id`,
   `contract_lines`.`quantity` AS `quantity`,
   `contract_lines`.`start_date` AS `start_date`,
   `contract_lines`.`end_date` AS `end_date`,((`contract_lines`.`end_date` < curdate()) and (`contracts`.`status` = 'signed')) AS `is_late`,if((`contract_lines`.`item_id` is not null),curdate(),if((`contract_lines`.`start_date` > curdate()),`contract_lines`.`start_date`,curdate())) AS `unavailable_from`,group_concat(`groups_users`.`group_id` separator ',') AS `concat_group_ids`
FROM ((`contract_lines` join `contracts` on((`contracts`.`id` = `contract_lines`.`contract_id`))) left join `groups_users` on((`groups_users`.`user_id` = `contracts`.`user_id`))) where ((`contract_lines`.`type` = 'ItemLine') and isnull(`contract_lines`.`returned_date`) and (`contracts`.`status` <> 'rejected') and ((`contracts`.`status` <> 'unsubmitted') or (`contracts`.`updated_at` >= (utc_timestamp() - interval 30 minute))) and ((`contract_lines`.`end_date` >= curdate()) or (`contract_lines`.`item_id` is not null))) group by `contract_lines`.`id`;


# Replace placeholder table for visits with correct view syntax
# ------------------------------------------------------------

DROP TABLE `visits`;

CREATE VIEW `visits`
AS SELECT
   hex(concat(`visit_lines`.`date`,
   `visit_lines`.`inventory_pool_id`,
   `visit_lines`.`user_id`,
   `visit_lines`.`status`)) AS `id`,
   `visit_lines`.`inventory_pool_id` AS `inventory_pool_id`,
   `visit_lines`.`user_id` AS `user_id`,
   `visit_lines`.`status` AS `status`,
   `visit_lines`.`action` AS `action`,
   `visit_lines`.`date` AS `date`,sum(`visit_lines`.`quantity`) AS `quantity`
FROM `visit_lines` group by `visit_lines`.`user_id`,`visit_lines`.`status`,`visit_lines`.`date`,`visit_lines`.`inventory_pool_id`;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
