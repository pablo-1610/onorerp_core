INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `usePabloSystem`) VALUES ('ojap', 'O\'Jap', '1', '1');
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES (NULL, 'ojap', '0', 'recruit', 'Recrue', '150', '{}', '{}'), (NULL, 'ojap', '1', 'member', 'Employé', '1500', '{}', '{}'), (NULL, 'ojap', '2', 'boss', 'Patron', '1', '{}', '{}');
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES ('society_ojap', 'O\'Jap', '1');
INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES (NULL, 'society_ojap', '10000', NULL);
INSERT INTO `addon_inventory` (`id`, `name`, `label`, `shared`) VALUES (NULL, 'society_ojap', 'O\'Jap', '1');