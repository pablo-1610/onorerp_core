CREATE TABLE `onore_shopspromo` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `percentage` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `onore_shopspromo` (`id`, `code`, `percentage`) VALUES
(1, 'NOUVEAU', 80);

ALTER TABLE `onore_shopspromo`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_shopspromo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

CREATE TABLE `onore_shopsitems` (
  `id` int(11) NOT NULL,
  `label` varchar(40) NOT NULL,
  `item` varchar(90) NOT NULL,
  `price` int(10) NOT NULL,
  `category` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `onore_shopsitems` (`id`, `label`, `item`, `price`, `category`) VALUES
(1, 'Pain', 'bread', 650, 'Nourriture');

ALTER TABLE `onore_shopsitems`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_shopsitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

CREATE TABLE `onore_ojapfood` (
  `id` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `onore_ojapfood` (`id`, `item`, `label`) VALUES
(1, 'bread', 'Pain');

ALTER TABLE `onore_ojapfood`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_ojapfood`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

CREATE TABLE `onore_houses` (
  `id` int(11) NOT NULL,
  `owner` varchar(80) NOT NULL,
  `ownerInfo` varchar(255) NOT NULL DEFAULT 'none',
  `infos` text NOT NULL,
  `inventory` text NOT NULL,
  `createdAt` text NOT NULL,
  `createdBy` varchar(80) NOT NULL,
  `street` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `onore_houses` (`id`, `owner`, `ownerInfo`, `infos`, `inventory`, `createdAt`, `createdBy`, `street`) VALUES
(25, 'license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'Pablo Barillas', '{\"name\":\"tt\",\"price\":\"1\",\"entry\":{\"x\":73.45698547363281,\"y\":-1027.4248046875,\"z\":29.47572708129882},\"selectedInterior\":2}', '[]', '1617560427', 'license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'Elgin Avenue');

ALTER TABLE `onore_houses`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
COMMIT;


CREATE TABLE `onore_cockatoosfood` (
  `id` int(11) NOT NULL,
  `item` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `onore_cockatoosfood`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `onore_cockatoosfood`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;


ALTER TABLE `jobs` ADD `usePabloSystem` INT(1) NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD `vip` INT(1) NOT NULL DEFAULT '0';
