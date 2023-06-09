-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 04, 2023 at 05:41 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fabbis`
--

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `nama`, `quantity`) VALUES
(1, 'Ball', 44),
(2, 'Jersey', 15),
(3, 'Shoes', 4),
(4, 'Whistle', 5),
(5, 'Foul Flag', 5),
(6, 'Scoreboard', 5);

-- --------------------------------------------------------

--
-- Table structure for table `peminjaman`
--

CREATE TABLE `peminjaman` (
  `pinjam_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `qty` int(25) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `status` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `peminjaman`
--

INSERT INTO `peminjaman` (`pinjam_id`, `items_id`, `user_id`, `qty`, `borrow_date`, `return_date`, `status`) VALUES
(3, 1, 1, 4, '2023-06-19', '2023-06-23', 'Returned'),
(4, 3, 2, 12, '2023-06-19', '2023-06-13', 'Returned'),
(5, 2, 2, 5, '2023-06-20', '2023-06-29', 'Returned'),
(6, 2, 2, 5, '2023-06-20', '2023-06-29', 'Returned'),
(7, 2, 1, 5, '2023-06-20', '2023-06-30', 'Returned'),
(8, 2, 1, 5, '2023-06-20', '2023-06-30', 'Returned'),
(9, 2, 1, 5, '2023-06-20', '2023-06-30', 'Returned'),
(10, 1, 2, 5, '2023-06-20', '2023-06-30', 'Returned'),
(11, 3, 2, 8, '2023-06-20', '2023-07-07', 'Returned'),
(12, 1, 2, 6, '2023-06-20', '2023-07-07', 'Returned'),
(13, 4, 1, 6, '2023-06-20', '2023-06-29', 'Returned'),
(14, 6, 1, 10, '2023-06-20', '2023-06-30', 'Returned'),
(15, 5, 2, 5, '2023-06-20', '2023-06-30', 'Returned'),
(16, 5, 1, 5, '2023-06-20', '2023-07-01', 'Returned'),
(17, 3, 1, 3, '2023-06-20', '2023-06-30', 'Returned'),
(18, 4, 2, 5, '2023-06-20', '2023-06-30', 'Returned'),
(19, 2, 2, 5, '2023-06-20', '2023-06-30', 'Returned'),
(20, 4, 2, 5, '2023-06-20', '2023-06-30', 'Returned'),
(21, 1, 1, 4, '2023-06-01', '2023-06-03', 'Borrowed'),
(27, 1, 1, 4, '2023-06-23', '2023-06-22', 'Returned'),
(28, 1, 15, 4, '2023-06-21', '2023-06-22', 'Returned'),
(29, 8, 15, 5, '2023-06-21', '2023-06-22', 'Returned'),
(30, 4, 2, 5, '2023-06-29', '2023-06-30', 'Borrowed'),
(31, 4, 1, 4, '2023-07-03', '2023-07-04', 'Borrowed'),
(32, 1, 0, 10, '2023-07-04', '2023-07-05', 'Borrowed'),
(33, 13, 0, 10, '2023-07-04', '2023-07-05', 'Borrowed'),
(34, 6, 0, 0, '2023-07-04', '2023-07-05', 'Borrowed'),
(35, 1, 3, 10, '2023-07-04', '2023-07-13', 'Returned');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `items_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `user_id`, `items_id`, `qty`, `date`) VALUES
(17, 1, 1, 1, '2023-06-10 23:01:55'),
(18, 1, 2, 1, '2023-06-10 23:04:45'),
(19, 2, 5, 1, '2023-06-17 18:14:30'),
(20, 2, 6, 1, '2023-06-17 18:14:41'),
(21, 2, 1, 1, '2023-06-17 18:45:57'),
(22, 1, 3, 1, '2023-06-17 19:11:54'),
(23, 1, 5, 1, '2023-06-17 19:12:05');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `password`, `role`) VALUES
(0, 'admin', 'admin', 'admin', 1),
(2, 'Dwi Bagia Santosa', '1207050030', 'test123', 0),
(3, 'Fatih Fauzan', '1207050037', 'test123', 0),
(4, 'Jessy Fauziah', '1207050137', 'test123', 0),
(5, 'Frinadi Syauqi', '1207050041', 'test123', 0),
(6, 'Dani Ali Kinan', '1207050139', 'test123', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`pinjam_id`),
  ADD KEY `items_id` (`items_id`,`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `user_id` (`user_id`,`items_id`),
  ADD KEY `items_id` (`items_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `pinjam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
