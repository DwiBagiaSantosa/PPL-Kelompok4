-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2023 at 11:29 PM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 7.4.20

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
(1, 'Ball', 0),
(2, 'Jersey', 7),
(3, 'Shoes', 4),
(4, 'Whistle', 9),
(5, 'Foul Flag', 5),
(6, 'Scoreboard', 5),
(7, 'Knee Pads', 5);

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
(1, 4, 1, 4, '2023-06-22', '2023-06-22', 'Returned'),
(2, 2, 2, 10, '2023-06-21', '2023-06-30', 'Returned'),
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
(22, 2, 1, 8, '2023-06-21', '2023-06-30', 'Borrowed');

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
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, '1207050030', 'test123', 0),
(2, '1207050044', 'test123', 0),
(3, 'admin', 'admin', 1);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `pinjam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`items_id`) REFERENCES `items` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
