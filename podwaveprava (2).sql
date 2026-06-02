-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 02, 2026 at 08:44 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `podwaveprava`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_ID` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_ID`, `name`, `description`) VALUES
(1, 'Technology', 'Tech news, programming, gadgets'),
(2, 'Business', 'Entrepreneurship, finance, marketing'),
(3, 'Health', 'Wellness, fitness, mental health'),
(4, 'Education', 'Learning, courses, tutorials'),
(5, 'Comedy', 'Funny stories, stand-up, humor'),
(6, 'News', 'Daily news, politics, current events'),
(7, 'True Crime', 'Crime stories and investigations');

-- --------------------------------------------------------

--
-- Table structure for table `episode`
--

CREATE TABLE `episode` (
  `ID_episode` int(11) NOT NULL,
  `podcast_ID` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `duration_seconds` int(11) DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `audio_url` varchar(500) DEFAULT NULL,
  `episode_number` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `episode`
--

INSERT INTO `episode` (`ID_episode`, `podcast_ID`, `title`, `description`, `duration_seconds`, `publish_date`, `audio_url`, `episode_number`) VALUES
(1, 1, 'Umjetna inteligencija u 2024.', 'Rasprava o AI trendovima', 2700, '2024-01-10 08:00:00', NULL, 1),
(2, 1, 'Blockchain i kriptovalute', 'Što donosi budućnost?', 3150, '2024-01-24 08:00:00', NULL, 2),
(3, 2, 'Kako pokrenuti startup', 'Intervju s uspješnim poduzetnikom', 3600, '2024-02-05 09:00:00', NULL, 1),
(4, 2, 'Marketing na društvenim mrežama', 'Strategije za rast', 2400, '2024-02-19 09:00:00', NULL, 2),
(5, 3, 'Meditacija za početnike', 'Vodič kroz mindfulness', 1800, '2024-03-01 07:00:00', NULL, 1),
(6, 3, 'Zdravlje kralježnice', 'Vježbe za uredske radnike', 2100, '2024-03-15 07:00:00', NULL, 2),
(7, 4, 'Present Simple explained', 'Gramatika za A1 razinu', 1500, '2024-04-01 10:00:00', NULL, 1),
(8, 4, 'Business English phrases', 'Koristan vokabular', 1650, '2024-04-15 10:00:00', NULL, 2),
(9, 5, 'Neuspjele poslovne ideje', 'Smiješne priče iz startup svijeta', 2700, '2024-05-05 12:00:00', NULL, 1),
(10, 6, 'Dnevne vijesti - 01.06.', 'Pregled najvažnijih vijesti', 1200, '2024-06-01 08:00:00', NULL, 1),
(11, 7, 'The Zodiac Killer', 'Tko je bio misteriozni ubojica', 4500, '2024-07-20 20:00:00', NULL, 1),
(12, 8, 'From garage to billions', 'Priča o Appleu', 3900, '2024-08-25 14:00:00', NULL, 1),
(13, 9, 'Borba protiv stresa', 'Tehnike opuštanja', 2400, '2024-09-12 08:00:00', NULL, 1),
(14, 9, 'Kako poboljšati san', 'Savjeti za bolji odmor', 2100, '2024-09-26 08:00:00', NULL, 2),
(15, 10, 'Rust vs Go - usporedba', 'Koji jezik odabrati?', 3300, '2024-10-10 09:00:00', NULL, 1),
(16, 10, 'Microservices arhitektura', 'Prednosti i mane', 3000, '2024-10-24 09:00:00', NULL, 2),
(17, 1, 'Budućnost remote rada', 'Kako se mijenja radno okruženje', 2850, '2024-02-07 08:00:00', NULL, 3),
(18, 2, 'Financiranje startupa', 'Gdje pronaći investitore?', 3450, '2024-03-05 09:00:00', NULL, 3);

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

CREATE TABLE `language` (
  `language_ID` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`language_ID`, `code`, `name`) VALUES
(1, 'hr', 'Hrvatski'),
(2, 'en', 'English'),
(3, 'sr', 'Srpski'),
(4, 'de', 'German'),
(5, 'fr', 'French');

-- --------------------------------------------------------

--
-- Table structure for table `listeninghistory`
--

CREATE TABLE `listeninghistory` (
  `ID_listening` int(11) NOT NULL,
  `user_ID` int(11) NOT NULL,
  `episode_ID` int(11) NOT NULL,
  `progress_seconds` int(11) DEFAULT 0,
  `is_completed` tinyint(1) DEFAULT 0,
  `last_played` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `listeninghistory`
--

INSERT INTO `listeninghistory` (`ID_listening`, `user_ID`, `episode_ID`, `progress_seconds`, `is_completed`, `last_played`) VALUES
(1, 3, 1, 2700, 1, '2024-01-15 20:00:00'),
(2, 3, 2, 1500, 0, '2024-01-30 19:30:00'),
(3, 4, 1, 2000, 0, '2024-01-18 21:00:00'),
(4, 6, 3, 3600, 1, '2024-02-10 18:00:00'),
(5, 6, 4, 1200, 0, '2024-02-22 17:45:00'),
(6, 7, 3, 3600, 1, '2024-02-12 20:30:00'),
(7, 3, 5, 1800, 1, '2024-03-05 08:30:00'),
(8, 9, 5, 900, 0, '2024-03-08 07:15:00'),
(9, 10, 7, 1500, 1, '2024-04-05 19:00:00'),
(10, 12, 8, 800, 0, '2024-04-18 18:30:00'),
(11, 6, 9, 2700, 1, '2024-05-10 21:00:00'),
(12, 13, 9, 2000, 0, '2024-05-15 20:00:00'),
(13, 4, 10, 1200, 1, '2024-06-02 08:15:00'),
(14, 7, 11, 3000, 0, '2024-07-25 22:00:00'),
(15, 3, 12, 3900, 1, '2024-08-28 19:30:00'),
(16, 9, 13, 2400, 1, '2024-09-15 09:00:00'),
(17, 10, 15, 3300, 1, '2024-10-12 20:00:00'),
(18, 15, 1, 2700, 1, '2024-01-25 22:00:00'),
(19, 15, 3, 3600, 1, '2024-02-20 19:00:00'),
(20, 12, 5, 1800, 1, '2024-03-12 08:00:00'),
(21, 6, 17, 2850, 1, '2024-02-10 19:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `playlist`
--

CREATE TABLE `playlist` (
  `ID_playlist` int(11) NOT NULL,
  `user_ID` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `is_public` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `playlist`
--

INSERT INTO `playlist` (`ID_playlist`, `user_ID`, `name`, `created_date`, `is_public`) VALUES
(1, 3, 'Tech favorites', '2024-02-01 10:00:00', 1),
(2, 6, 'Business must listen', '2024-02-15 14:00:00', 0),
(3, 4, 'Learning English', '2024-04-10 09:00:00', 1),
(4, 7, 'True crime night', '2024-07-30 20:00:00', 0),
(5, 9, 'Morning routine', '2024-03-20 07:00:00', 1),
(6, 10, 'Coding podcasts', '2024-10-15 08:00:00', 1),
(7, 15, 'Top picks', '2024-01-30 12:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `playlist_episode`
--

CREATE TABLE `playlist_episode` (
  `ID_playlist_episode` int(11) NOT NULL,
  `playlist_ID` int(11) NOT NULL,
  `episode_ID` int(11) NOT NULL,
  `order_position` int(11) NOT NULL,
  `added_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `playlist_episode`
--

INSERT INTO `playlist_episode` (`ID_playlist_episode`, `playlist_ID`, `episode_ID`, `order_position`, `added_at`) VALUES
(1, 1, 1, 1, '2024-02-01 10:05:00'),
(2, 1, 2, 2, '2024-02-01 10:06:00'),
(3, 1, 17, 3, '2024-02-10 09:00:00'),
(4, 2, 3, 1, '2024-02-15 14:05:00'),
(5, 2, 4, 2, '2024-02-15 14:06:00'),
(6, 2, 18, 3, '2024-03-06 10:00:00'),
(7, 3, 7, 1, '2024-04-10 09:05:00'),
(8, 3, 8, 2, '2024-04-10 09:06:00'),
(9, 4, 11, 1, '2024-07-30 20:05:00'),
(10, 5, 5, 1, '2024-03-20 07:05:00'),
(11, 5, 13, 2, '2024-09-15 08:00:00'),
(12, 5, 14, 3, '2024-09-28 07:30:00'),
(13, 6, 1, 1, '2024-10-15 08:05:00'),
(14, 6, 15, 2, '2024-10-15 08:06:00'),
(15, 6, 16, 3, '2024-10-25 09:00:00'),
(16, 7, 1, 1, '2024-01-30 12:05:00'),
(17, 7, 3, 2, '2024-01-30 12:06:00'),
(18, 7, 5, 3, '2024-01-30 12:07:00'),
(19, 7, 9, 4, '2024-05-11 20:00:00'),
(20, 7, 11, 5, '2024-07-30 21:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `podcast`
--

CREATE TABLE `podcast` (
  `ID_podcast` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `language_ID` int(11) DEFAULT NULL,
  `category_ID` int(11) DEFAULT NULL,
  `cover_image_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `podcast`
--

INSERT INTO `podcast` (`ID_podcast`, `title`, `description`, `created_date`, `language_ID`, `category_ID`, `cover_image_url`) VALUES
(1, 'Tech Talks', 'Najnovije iz svijeta tehnologije', '2023-01-15', 1, 1, 'https://i.scdn.co/image/ab6765630000ba8ac3be37c983e62204cc6a5cfe'),
(2, 'Business Insights', 'Podcast za poduzetnike', '2023-02-10', 2, 2, 'https://i.scdn.co/image/ab6765630000ba8adb030c277eadb31962a1949e'),
(3, 'Zdravlje na prvu', 'Savjeti za zdrav život', '2023-03-05', 1, 3, 'https://zdravstvo.gov.hr/userdocsimages//slike/Nacionalni%20programi,%20projekti%20i%20strategije/zdravlje.jpg?width=1500&height=1000&mode=max'),
(4, 'Learn English Fast', 'Tečaj engleskog u podcastu', '2023-04-20', 2, 4, 'https://play-lh.googleusercontent.com/I6rXDrmqIalAw4f-r1lJNB97k-K9_rzwu67bDuKUjytzShxATg2J2l913clKf01lp-0'),
(5, 'Smijeh na posao', 'Humour and fun stories', '2023-05-12', 1, 5, 'https://lidermedia.hr/media/2021/12/03/2331299/H-2331299-1245.webp?1740952855'),
(6, 'Dnevni briefing', 'Dnevne vijesti', '2023-06-01', 3, 6, 'https://static.wixstatic.com/media/d4aa87_e399358adb614063962139c5aa164038~mv2.png'),
(7, 'Murder Mystery', 'True crime stories', '2023-07-18', 2, 7, 'https://www.stuartmillersolicitors.co.uk/wp-content/uploads/2024/03/750x450_murder-for-love-jihad-min.png'),
(8, 'Startup Stories', 'Priče o startupovima', '2023-08-22', 4, 2, 'https://yt3.googleusercontent.com/ytc/AIdro_k_HCuhHp5IHIAH9_15XFmH379gxTyQUNFKwYrHShYZ-Ho=s900-c-k-c0x00ffffff-no-rj'),
(9, 'Mind & Soul', 'Mental health podcast', '2023-09-10', 1, 3, 'https://cdn.prod.website-files.com/668eb469b177d469ec268553/67101b757d3410c35bc4e152_Managing-Mental-Health-During-COVID-19.webp'),
(10, 'Code & Coffee', 'Programerski podcast', '2023-10-05', 2, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQ_Ud209s51uo3MrIhUlNPMvhrMG3_R6nHsw&s');

-- --------------------------------------------------------

--
-- Table structure for table `podcast_author`
--

CREATE TABLE `podcast_author` (
  `podcast_ID` int(11) NOT NULL,
  `user_ID` int(11) NOT NULL,
  `role` varchar(50) DEFAULT 'host'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `podcast_author`
--

INSERT INTO `podcast_author` (`podcast_ID`, `user_ID`, `role`) VALUES
(1, 1, 'host'),
(1, 2, 'co-host'),
(2, 5, 'host'),
(2, 8, 'contributor'),
(3, 1, 'host'),
(4, 11, 'host'),
(5, 2, 'host'),
(6, 14, 'host'),
(7, 8, 'host'),
(8, 1, 'contributor'),
(8, 5, 'host'),
(9, 11, 'host'),
(10, 2, 'co-host'),
(10, 14, 'host');

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `ID_review` int(11) NOT NULL,
  `user_ID` int(11) NOT NULL,
  `episode_ID` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text DEFAULT NULL,
  `review_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`ID_review`, `user_ID`, `episode_ID`, `rating`, `comment`, `review_date`) VALUES
(1, 3, 1, 5, 'Odlična epizoda, puno korisnih informacija!', '2024-01-16 10:00:00'),
(2, 4, 1, 4, 'Zanimljivo, ali malo predugo', '2024-01-17 12:00:00'),
(3, 6, 3, 5, 'Inspirativno, preporučam svim poduzetnicima', '2024-02-11 09:00:00'),
(4, 7, 3, 4, 'Dobar gost, zanimljive teme', '2024-02-13 15:00:00'),
(5, 3, 5, 5, 'Napokon netko tko objašnjava meditaciju jednostavno', '2024-03-06 11:00:00'),
(6, 9, 5, 4, 'Dobar uvod za početnike', '2024-03-09 14:00:00'),
(7, 10, 7, 5, 'Gramatika nikad lakša!', '2024-04-06 18:00:00'),
(8, 12, 8, 3, 'Malo previše osnovno za mene', '2024-04-20 10:00:00'),
(9, 6, 9, 5, 'Smijao sam se cijelu epizodu', '2024-05-11 20:00:00'),
(10, 13, 9, 4, 'Dobra zabava', '2024-05-16 19:30:00'),
(11, 4, 10, 4, 'Kratko i informativno', '2024-06-03 09:00:00'),
(12, 7, 11, 5, 'Fascinantna priča, odlično istraženo', '2024-07-26 23:00:00'),
(13, 3, 12, 5, 'Inspirativna priča o Appleu', '2024-08-29 14:00:00'),
(14, 9, 13, 5, 'Puno korisnih savjeta za stres', '2024-09-16 10:30:00'),
(15, 10, 15, 5, 'Odlična usporedba jezika', '2024-10-13 21:00:00'),
(16, 15, 1, 4, 'Dobra tema', '2024-01-26 09:00:00'),
(17, 6, 17, 5, 'Aktualno i relevantno', '2024-02-11 20:00:00'),
(18, 3, 17, 4, 'Slažem se s većinom, dobar podcast', '2024-02-12 18:00:00'),
(19, 14, 1, 4, 'Nije loše!', '2026-05-06 16:52:46'),
(20, 16, 2, 2, 'Meh !', '2026-05-06 20:48:31');

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `ID_subscription` int(11) NOT NULL,
  `user_ID` int(11) NOT NULL,
  `podcast_ID` int(11) NOT NULL,
  `subscribed_at` datetime DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`ID_subscription`, `user_ID`, `podcast_ID`, `subscribed_at`, `is_active`) VALUES
(1, 3, 1, '2024-01-01 10:00:00', 1),
(2, 4, 1, '2024-01-05 14:30:00', 1),
(3, 6, 2, '2024-02-01 09:00:00', 1),
(4, 7, 2, '2024-02-10 11:00:00', 1),
(5, 3, 3, '2024-03-01 08:00:00', 1),
(6, 9, 3, '2024-03-05 10:00:00', 1),
(7, 10, 4, '2024-04-01 12:00:00', 1),
(8, 12, 4, '2024-04-02 09:00:00', 1),
(9, 6, 5, '2024-05-01 15:00:00', 1),
(10, 13, 5, '2024-05-10 11:00:00', 1),
(11, 4, 6, '2024-06-01 07:00:00', 1),
(12, 7, 7, '2024-07-15 20:00:00', 1),
(13, 3, 8, '2024-08-20 10:00:00', 1),
(14, 9, 9, '2024-09-10 09:00:00', 1),
(15, 10, 10, '2024-10-05 08:00:00', 1),
(16, 15, 1, '2024-01-20 16:00:00', 1),
(17, 15, 2, '2024-02-15 14:00:00', 1),
(18, 12, 3, '2024-03-10 13:00:00', 1),
(19, 13, 7, '2024-07-20 21:00:00', 1),
(20, 6, 8, '2024-08-21 09:30:00', 1),
(21, 4, 9, '2024-09-11 10:15:00', 1),
(22, 7, 10, '2024-10-06 08:20:00', 1),
(25, 1, 1, '2026-05-15 08:16:19', 1),
(26, 1, 2, '2026-05-15 08:32:01', 1),
(27, 1, 3, '2026-06-02 08:13:49', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `ID_user` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_creator` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`ID_user`, `name`, `email`, `password`, `is_creator`, `created_at`) VALUES
(1, 'Marko Horvat', 'marko@email.com', 'hash123', 1, '2026-04-30 18:06:22'),
(2, 'Ana Kovačić', 'ana@email.com', 'hash456', 1, '2026-04-30 18:06:22'),
(3, 'Ivan Novak', 'ivan@email.com', 'hash789', 0, '2026-04-30 18:06:22'),
(4, 'Maja Šimić', 'maja@email.com', 'hash101', 0, '2026-04-30 18:06:22'),
(5, 'Petra Zorić', 'petra@email.com', 'hash112', 1, '2026-04-30 18:06:22'),
(6, 'Luka Babić', 'luka@email.com', 'hash131', 0, '2026-04-30 18:06:22'),
(7, 'Nina Knežević', 'nina@email.com', 'hash415', 0, '2026-04-30 18:06:22'),
(8, 'Tomislav Vuk', 'tomislav@email.com', 'hash161', 1, '2026-04-30 18:06:22'),
(9, 'Ivana Blažević', 'ivana@email.com', 'hash718', 0, '2026-04-30 18:06:22'),
(10, 'David Matić', 'david@email.com', 'hash192', 0, '2026-04-30 18:06:22'),
(11, 'Sara Lončar', 'sara@email.com', 'hash202', 1, '2026-04-30 18:06:22'),
(12, 'Filip Pavić', 'filip@email.com', 'hash222', 0, '2026-04-30 18:06:22'),
(13, 'Ema Radić', 'ema@email.com', 'hash242', 0, '2026-04-30 18:06:22'),
(14, 'Bruno Josipović', 'bruno@email.com', 'hash262', 1, '2026-04-30 18:06:22'),
(15, 'Lana Marić', 'lana@email.com', 'hash282', 0, '2026-04-30 18:06:22'),
(16, 'Roko Gašljević', 'roko@email.com', 'roko123', 0, '2026-05-06 16:36:18'),
(17, 'lovro gasljevic', 'lovro@email.com', 'lovro123', 0, '2026-05-06 16:40:01');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_ID`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `episode`
--
ALTER TABLE `episode`
  ADD PRIMARY KEY (`ID_episode`),
  ADD KEY `podcast_ID` (`podcast_ID`);

--
-- Indexes for table `language`
--
ALTER TABLE `language`
  ADD PRIMARY KEY (`language_ID`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `listeninghistory`
--
ALTER TABLE `listeninghistory`
  ADD PRIMARY KEY (`ID_listening`),
  ADD UNIQUE KEY `unique_listening` (`user_ID`,`episode_ID`),
  ADD KEY `episode_ID` (`episode_ID`);

--
-- Indexes for table `playlist`
--
ALTER TABLE `playlist`
  ADD PRIMARY KEY (`ID_playlist`),
  ADD KEY `user_ID` (`user_ID`);

--
-- Indexes for table `playlist_episode`
--
ALTER TABLE `playlist_episode`
  ADD PRIMARY KEY (`ID_playlist_episode`),
  ADD UNIQUE KEY `unique_playlist_episode` (`playlist_ID`,`episode_ID`),
  ADD KEY `episode_ID` (`episode_ID`);

--
-- Indexes for table `podcast`
--
ALTER TABLE `podcast`
  ADD PRIMARY KEY (`ID_podcast`),
  ADD KEY `language_ID` (`language_ID`),
  ADD KEY `category_ID` (`category_ID`);

--
-- Indexes for table `podcast_author`
--
ALTER TABLE `podcast_author`
  ADD PRIMARY KEY (`podcast_ID`,`user_ID`),
  ADD KEY `user_ID` (`user_ID`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`ID_review`),
  ADD UNIQUE KEY `unique_review` (`user_ID`,`episode_ID`),
  ADD KEY `episode_ID` (`episode_ID`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`ID_subscription`),
  ADD UNIQUE KEY `unique_subscription` (`user_ID`,`podcast_ID`),
  ADD KEY `podcast_ID` (`podcast_ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`ID_user`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `episode`
--
ALTER TABLE `episode`
  MODIFY `ID_episode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `language_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `listeninghistory`
--
ALTER TABLE `listeninghistory`
  MODIFY `ID_listening` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `playlist`
--
ALTER TABLE `playlist`
  MODIFY `ID_playlist` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `playlist_episode`
--
ALTER TABLE `playlist_episode`
  MODIFY `ID_playlist_episode` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `podcast`
--
ALTER TABLE `podcast`
  MODIFY `ID_podcast` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `ID_review` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `ID_subscription` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `ID_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `episode`
--
ALTER TABLE `episode`
  ADD CONSTRAINT `episode_ibfk_1` FOREIGN KEY (`podcast_ID`) REFERENCES `podcast` (`ID_podcast`) ON DELETE CASCADE;

--
-- Constraints for table `listeninghistory`
--
ALTER TABLE `listeninghistory`
  ADD CONSTRAINT `listeninghistory_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `listeninghistory_ibfk_2` FOREIGN KEY (`episode_ID`) REFERENCES `episode` (`ID_episode`) ON DELETE CASCADE;

--
-- Constraints for table `playlist`
--
ALTER TABLE `playlist`
  ADD CONSTRAINT `playlist_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE;

--
-- Constraints for table `playlist_episode`
--
ALTER TABLE `playlist_episode`
  ADD CONSTRAINT `playlist_episode_ibfk_1` FOREIGN KEY (`playlist_ID`) REFERENCES `playlist` (`ID_playlist`) ON DELETE CASCADE,
  ADD CONSTRAINT `playlist_episode_ibfk_2` FOREIGN KEY (`episode_ID`) REFERENCES `episode` (`ID_episode`) ON DELETE CASCADE;

--
-- Constraints for table `podcast`
--
ALTER TABLE `podcast`
  ADD CONSTRAINT `podcast_ibfk_1` FOREIGN KEY (`language_ID`) REFERENCES `language` (`language_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `podcast_ibfk_2` FOREIGN KEY (`category_ID`) REFERENCES `category` (`category_ID`) ON DELETE SET NULL;

--
-- Constraints for table `podcast_author`
--
ALTER TABLE `podcast_author`
  ADD CONSTRAINT `podcast_author_ibfk_1` FOREIGN KEY (`podcast_ID`) REFERENCES `podcast` (`ID_podcast`) ON DELETE CASCADE,
  ADD CONSTRAINT `podcast_author_ibfk_2` FOREIGN KEY (`user_ID`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`episode_ID`) REFERENCES `episode` (`ID_episode`) ON DELETE CASCADE;

--
-- Constraints for table `subscription`
--
ALTER TABLE `subscription`
  ADD CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`podcast_ID`) REFERENCES `podcast` (`ID_podcast`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
