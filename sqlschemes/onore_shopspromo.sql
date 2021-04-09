CREATE TABLE `onore_shopspromo` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `percentage` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `onore_shopspromo`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_shopspromo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
