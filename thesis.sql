-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 12, 2020 at 10:12 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `thesis`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `admin_username` varchar(45) NOT NULL,
  `admin_name` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `admin_phone_number` varchar(12) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `admin_image` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `admin_username`, `admin_name`, `password`, `admin_phone_number`, `address`, `admin_image`) VALUES
(1, 'thuongnt', 'Thưởng', 'mot2ba4nam7', '', 'Hưng Yên', 'thuongnt.img');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id_cart` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `cart_quantity` int(11) NOT NULL,
  `cart_total` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id_cart`, `id_user`, `cart_quantity`, `cart_total`) VALUES
(1, 1, 0, 500000);

-- --------------------------------------------------------

--
-- Table structure for table `cart_detail`
--

CREATE TABLE `cart_detail` (
  `id_cart_detail` int(11) NOT NULL,
  `id_cart` int(11) NOT NULL,
  `id_shoes` int(11) NOT NULL,
  `shoes_name` varchar(100) NOT NULL,
  `size` int(11) NOT NULL,
  `color` varchar(45) NOT NULL,
  `number_of_shoes` int(11) NOT NULL,
  `sub_price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart_detail`
--

INSERT INTO `cart_detail` (`id_cart_detail`, `id_cart`, `id_shoes`, `shoes_name`, `size`, `color`, `number_of_shoes`, `sub_price`) VALUES
(1, 1, 1, 'Giày Adidas', 42, 'Xanh Tr', 1, 200000),
(2, 1, 2, 'Giày Puma', 41, 'Đen', 1, 300000);

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `id_comment` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `uname` varchar(45) NOT NULL,
  `id_shoes` int(11) NOT NULL,
  `star` int(1) NOT NULL,
  `comments` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id_order` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `uname` varchar(45) NOT NULL,
  `order_quantity` int(11) NOT NULL,
  `total_cost` float NOT NULL,
  `time_order` varchar(45) NOT NULL,
  `order_status` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`id_order`, `id_user`, `uname`, `order_quantity`, `total_cost`, `time_order`, `order_status`) VALUES
(1, 1, 'Thưởng', 0, 700000, '20/11/2020', 'Chưa Thanh Toán');

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

CREATE TABLE `order_detail` (
  `id_order_detail` int(11) NOT NULL,
  `id_order` int(11) NOT NULL,
  `id_shoes` int(11) NOT NULL,
  `shoes_name` varchar(100) NOT NULL,
  `size` int(11) NOT NULL,
  `color` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL,
  `sub_price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`id_order_detail`, `id_order`, `id_shoes`, `shoes_name`, `size`, `color`, `quantity`, `sub_price`) VALUES
(1, 1, 1, 'Giày Adidas', 42, 'Đen', 2, 400000),
(2, 1, 2, 'Giày Puma', 42, 'Trắng', 1, 300000);

-- --------------------------------------------------------

--
-- Table structure for table `shoes`
--

CREATE TABLE `shoes` (
  `id_shoes` int(11) NOT NULL,
  `shoes_name` varchar(99) NOT NULL,
  `shoes_cost` float NOT NULL,
  `shoes_state` int(1) NOT NULL,
  `shoes_type` varchar(45) NOT NULL,
  `shoes_for_gender` varchar(10) NOT NULL,
  `discribe` varchar(900) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoes`
--

INSERT INTO `shoes` (`id_shoes`, `shoes_name`, `shoes_cost`, `shoes_state`, `shoes_type`, `shoes_for_gender`, `discribe`) VALUES
(1, 'Giày Adidas', 200000, 1, 'Thể Thao', 'Giày Nam', 'Giày Nam cao cấp, Đi êm chân ,Được ưa chuộng'),
(2, 'Giày Puma', 300000, 1, 'Thể Thao', 'Giày Đôi', 'Giày Nam cao cấp, Đi êm chân ,Được ưa chuộng');

-- --------------------------------------------------------

--
-- Table structure for table `shoes_color`
--

CREATE TABLE `shoes_color` (
  `id_shoes` int(11) NOT NULL,
  `shoes_color` varchar(45) NOT NULL,
  `shoes_image` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoes_color`
--

INSERT INTO `shoes_color` (`id_shoes`, `shoes_color`, `shoes_image`) VALUES
(1, 'Trắng', 'img1_2.png'),
(1, 'Đen', 'img1_1.png'),
(2, 'Đen', 'img2_1.png');

-- --------------------------------------------------------

--
-- Table structure for table `shoes_sale`
--

CREATE TABLE `shoes_sale` (
  `id_shoes` int(11) NOT NULL,
  `shoes_sale_percent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoes_sale`
--

INSERT INTO `shoes_sale` (`id_shoes`, `shoes_sale_percent`) VALUES
(1, 28),
(2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `shoes_size`
--

CREATE TABLE `shoes_size` (
  `id_shoes` int(11) NOT NULL,
  `35` int(11) NOT NULL,
  `36` int(11) NOT NULL,
  `37` int(11) NOT NULL,
  `38` int(11) NOT NULL,
  `39` int(11) NOT NULL,
  `40` int(11) NOT NULL,
  `41` int(11) NOT NULL,
  `42` int(11) NOT NULL,
  `43` int(11) NOT NULL,
  `44` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shoes_size`
--

INSERT INTO `shoes_size` (`id_shoes`, `35`, `36`, `37`, `38`, `39`, `40`, `41`, `42`, `43`, `44`) VALUES
(1, 1, 2, 3, 4, 0, 1, 0, 2, 2, 1),
(2, 3, 2, 1, 0, 0, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `shoes_size_color`
--

CREATE TABLE `shoes_size_color` (
  `id_shoes_size_color` int(11) NOT NULL,
  `id_shoes` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `color` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `user_uname` varchar(45) NOT NULL,
  `uname` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `user_phone_number` varchar(12) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `user_image` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `user_uname`, `uname`, `password`, `user_phone_number`, `address`, `user_image`) VALUES
(1, 'thuonghy961@gmail.com', 'Thưởng', 'mot2ba4nam7', '0987654321', 'Ngọc Thanh - Kim Động -Hưng Yên', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id_cart`);

--
-- Indexes for table `cart_detail`
--
ALTER TABLE `cart_detail`
  ADD PRIMARY KEY (`id_cart_detail`),
  ADD KEY `fk_cart_detail_1_idx` (`id_cart`),
  ADD KEY `fk_cart_detail_2_idx` (`id_shoes`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id_comment`),
  ADD KEY `fk1_comment` (`id_user`),
  ADD KEY `fk2_comment` (`id_shoes`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id_order`),
  ADD KEY `fk_order_1_idx` (`id_user`);

--
-- Indexes for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`id_order_detail`),
  ADD KEY `fk_order_detail_1_idx` (`id_order`),
  ADD KEY `fk_order_detail_2_idx` (`id_shoes`);

--
-- Indexes for table `shoes`
--
ALTER TABLE `shoes`
  ADD PRIMARY KEY (`id_shoes`);

--
-- Indexes for table `shoes_color`
--
ALTER TABLE `shoes_color`
  ADD PRIMARY KEY (`id_shoes`,`shoes_color`);

--
-- Indexes for table `shoes_sale`
--
ALTER TABLE `shoes_sale`
  ADD PRIMARY KEY (`id_shoes`);

--
-- Indexes for table `shoes_size`
--
ALTER TABLE `shoes_size`
  ADD PRIMARY KEY (`id_shoes`);

--
-- Indexes for table `shoes_size_color`
--
ALTER TABLE `shoes_size_color`
  ADD PRIMARY KEY (`id_shoes_size_color`),
  ADD KEY `fk1_shoes_size_color` (`id_shoes`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id_cart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cart_detail`
--
ALTER TABLE `cart_detail`
  MODIFY `id_cart_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `id_comment` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id_order` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `id_order_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shoes`
--
ALTER TABLE `shoes`
  MODIFY `id_shoes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart_detail`
--
ALTER TABLE `cart_detail`
  ADD CONSTRAINT `fk_cart_detail_1` FOREIGN KEY (`id_cart`) REFERENCES `cart` (`id_cart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cart_detail_2` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `fk1_comment` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk2_comment` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `fk_order_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `fk_order_detail_1` FOREIGN KEY (`id_order`) REFERENCES `order` (`id_order`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_order_detail_2` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shoes_color`
--
ALTER TABLE `shoes_color`
  ADD CONSTRAINT `shoes_color_fk` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shoes_sale`
--
ALTER TABLE `shoes_sale`
  ADD CONSTRAINT `fk_shoes_sale_1` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shoes_size`
--
ALTER TABLE `shoes_size`
  ADD CONSTRAINT `fk_shoes_size` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shoes_size_color`
--
ALTER TABLE `shoes_size_color`
  ADD CONSTRAINT `fk1_shoes_size_color` FOREIGN KEY (`id_shoes`) REFERENCES `shoes` (`id_shoes`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
