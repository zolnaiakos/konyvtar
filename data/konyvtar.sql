-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2026. Okt 13. 11:02
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `konyvtar`
--
CREATE DATABASE IF NOT EXISTS `konyvtar` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `konyvtar`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `kolcsonzesek`
--

CREATE TABLE `kolcsonzesek` (
  `id` int(11) NOT NULL,
  `konyvId` int(11) DEFAULT NULL,
  `olvasoId` int(11) DEFAULT NULL,
  `datum` varchar(512) DEFAULT NULL,
  `visszahozva` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `kolcsonzesek`
--

INSERT INTO `kolcsonzesek` (`id`, `konyvId`, `olvasoId`, `datum`, `visszahozva`) VALUES
(1, 2, 1, '2026-09-01', 'true'),
(2, 3, 1, '2026-09-15', 'false'),
(3, 5, 2, '2026-09-20', 'false');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `konyvek`
--

CREATE TABLE `konyvek` (
  `id` int(11) NOT NULL,
  `cim` varchar(512) DEFAULT NULL,
  `szerzo_id` int(11) NOT NULL,
  `ev` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `konyvek`
--

INSERT INTO `konyvek` (`id`, `cim`, `szerzo_id`, `ev`) VALUES
(1, 'A Pál utcai fiúk', 1, 1906),
(2, 'Egri csillagok', 2, 1899),
(3, 'Tüskevár', 3, 1957),
(4, 'Vuk', 3, 1965),
(5, 'Abigél', 4, 1970),
(6, 'A kőszívű ember fiai', 5, 1869);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `olvasok`
--

CREATE TABLE `olvasok` (
  `id` int(11) NOT NULL,
  `nev` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `olvasok`
--

INSERT INTO `olvasok` (`id`, `nev`) VALUES
(1, 'Kiss Anna'),
(2, 'Nagy Péter'),
(3, 'Szabó Lili');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szerzok`
--

CREATE TABLE `szerzok` (
  `id` int(11) NOT NULL,
  `szerzo` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `szerzok`
--

INSERT INTO `szerzok` (`id`, `szerzo`) VALUES
(1, 'Molnár Ferenc'),
(2, 'Gárdonyi Géza'),
(3, 'Fekete István'),
(4, 'Szabó Magda'),
(5, 'Jókai Mór');

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `kolcsonzesek`
--
ALTER TABLE `kolcsonzesek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_konyvek` (`konyvId`),
  ADD KEY `fk_olvasok` (`olvasoId`);

--
-- A tábla indexei `konyvek`
--
ALTER TABLE `konyvek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_szerzok` (`szerzo_id`);

--
-- A tábla indexei `olvasok`
--
ALTER TABLE `olvasok`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `szerzok`
--
ALTER TABLE `szerzok`
  ADD PRIMARY KEY (`id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `kolcsonzesek`
--
ALTER TABLE `kolcsonzesek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `konyvek`
--
ALTER TABLE `konyvek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `olvasok`
--
ALTER TABLE `olvasok`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT a táblához `szerzok`
--
ALTER TABLE `szerzok`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `kolcsonzesek`
--
ALTER TABLE `kolcsonzesek`
  ADD CONSTRAINT `fk_konyvek` FOREIGN KEY (`konyvId`) REFERENCES `konyvek` (`id`),
  ADD CONSTRAINT `fk_olvasok` FOREIGN KEY (`olvasoId`) REFERENCES `olvasok` (`id`);

--
-- Megkötések a táblához `konyvek`
--
ALTER TABLE `konyvek`
  ADD CONSTRAINT `fk_szerzok` FOREIGN KEY (`szerzo_id`) REFERENCES `szerzok` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
