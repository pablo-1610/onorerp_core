CREATE TABLE `onore_shopsitems` (
  `id` int(11) NOT NULL,
  `label` varchar(40) NOT NULL,
  `item` varchar(90) NOT NULL,
  `price` int(10) NOT NULL,
  `category` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `onore_shopsitems`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_shopsitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
