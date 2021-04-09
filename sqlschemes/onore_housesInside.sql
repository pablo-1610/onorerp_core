CREATE TABLE `onore_housesInside` (
  `license` varchar(80) NOT NULL,
  `houseID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `onore_housesInside`
  ADD PRIMARY KEY (`license`);
