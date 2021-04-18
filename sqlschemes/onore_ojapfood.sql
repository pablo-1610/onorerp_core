CREATE TABLE `onore_ojapfood` (
  `id` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `onore_ojapfood`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_ojapfood`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
