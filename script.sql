--         table creation script
--         Important!!! Please create a database called 'database' first!
--         Important!!! Please copy the codes in order, otherwise an error will be reported.

SET FOREIGN KEY CHECK = 0;

DROP TABLE IF EXISTS `patient_basic_information`;
CREATE TABLE `patient_basic_information`  (
  `mobile_no` varchar(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sex` varchar(10) NOT NULL,
  `age` int(5) NOT NULL,
  PRIMARY KEY (`mobile_no`) USING BTREE,
  INDEX `mobile_no`(`mobile_no`) USING BTREE
);


DROP TABLE IF EXISTS `virus_information`;
CREATE TABLE `virus_information`  (
  `virus_id` varchar(10) NOT NULL,
  `virus_name` varchar(50) NOT NULL,
  `virus_description` text NOT NULL,
  PRIMARY KEY (`virus_id`) USING BTREE
);


DROP TABLE IF EXISTS `risk_level_list`;
CREATE TABLE `risk_level_list`  (
  `risk_level` int(5) NOT NULL,
  `risk_level_name` varchar(10) NOT NULL,
  PRIMARY KEY (`risk_level`) USING BTREE
);


DROP TABLE IF EXISTS `judge_district_risk`;
CREATE TABLE `judge_district_risk`  (
  `district_no` int(10) NOT NULL AUTO_INCREMENT,
  `district_name` varchar(100) NOT NULL,
  `risk_level` int(5) NOT NULL,
  PRIMARY KEY (`district_no`) USING BTREE,
  INDEX `risk_level`(`risk_level`) USING BTREE,
  INDEX `district_name`(`district_name`) USING BTREE,
  CONSTRAINT `judge_district_risk_ibfk_1` FOREIGN KEY (`risk_level`) REFERENCES `risk_level_list` (`risk_level`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `district_bs_list`;
CREATE TABLE `district_bs_list`  (
  `district_bs_no` varchar(10) NOT NULL,
  `district_name` varchar(100) NOT NULL,
  `region` varchar(10) NOT NULL,
  PRIMARY KEY (`district_bs_no`) USING BTREE,
  INDEX `district_name`(`district_name`) USING BTREE,
  CONSTRAINT `district_bs_list_ibfk_1` FOREIGN KEY (`district_name`) REFERENCES `judge_district_risk` (`district_name`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `history_tracking`;
CREATE TABLE `history_tracking`  (
  `history_tracking_id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile_no` varchar(15) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gps_location` varchar(200) NOT NULL,
  `connected_time` datetime NOT NULL,
  `disconnected_time` datetime NOT NULL,
  `district_bs_no` varchar(10) NOT NULL,
  PRIMARY KEY (`history_tracking_id`) USING BTREE,
  INDEX `district_bs_no`(`district_bs_no`) USING BTREE,
  CONSTRAINT `history_tracking_ibfk_1` FOREIGN KEY (`district_bs_no`) REFERENCES `district_bs_list` (`district_bs_no`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `hospital_list`;
CREATE TABLE `hospital_list`  (
  `hospital_id` int(11) NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(200) NOT NULL,
  `hospital_gps_location` varchar(200) NOT NULL,
  `district_bs_no` varchar(10) NOT NULL,
  PRIMARY KEY (`hospital_id`) USING BTREE,
  INDEX `district_bs_no`(`district_bs_no`) USING BTREE,
  CONSTRAINT `hospital_list_ibfk_1` FOREIGN KEY (`district_bs_no`) REFERENCES `district_bs_list` (`district_bs_no`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `person_current_location`;
CREATE TABLE `person_current_location`  (
  `mobile_no` varchar(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `gps_location` varchar(200) NOT NULL,
  `district_bs_no` varchar(10) NOT NULL,
  PRIMARY KEY (`mobile_no`) USING BTREE,
  INDEX `person_current_location1_ibfk_1`(`district_bs_no`) USING BTREE,
  CONSTRAINT `person_current_location_ibfk_1` FOREIGN KEY (`district_bs_no`) REFERENCES `district_bs_list` (`district_bs_no`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `doctor_list`;
CREATE TABLE `doctor_list`  (
  `doctor_id` int(11) NOT NULL,
  `doctor_name` varchar(50) NOT NULL,
  `work_hospital_id` int(11) NOT NULL,
  PRIMARY KEY (`doctor_id`) USING BTREE,
  INDEX `doctor_list_ibfk_1`(`work_hospital_id`) USING BTREE,
  CONSTRAINT `doctor_list_ibfk_1` FOREIGN KEY (`work_hospital_id`) REFERENCES `hospital_list` (`hospital_id`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `patient_cure_information`;
CREATE TABLE `patient_cure_information`  (
  `mobile_no` varchar(15) NOT NULL,
  `sample_type_id` varchar(10) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `sample_collect_time` datetime NOT NULL,
  `sample_test_time` datetime NOT NULL,
  `sample_report_time` datetime NOT NULL,
  PRIMARY KEY (`mobile_no`) USING BTREE,
  INDEX `sample_type_id`(`sample_type_id`) USING BTREE,
  INDEX `doctor_id`(`doctor_id`) USING BTREE,
  CONSTRAINT `patient_cure_information_ibfk_1` FOREIGN KEY (`sample_type_id`) REFERENCES `virus_information` (`virus_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_cure_information_ibfk_2` FOREIGN KEY (`mobile_no`) REFERENCES `patient_basic_information` (`mobile_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_cure_information_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_list` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `patient_test_information`;
CREATE TABLE `patient_test_information`  (
  `num` int(11) NOT NULL AUTO_INCREMENT,
  `mobile_no` varchar(15) NOT NULL,
  `sample_type_id` varchar(10) NOT NULL,
  `sample_result` varchar(10) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `sample_collect_time` datetime NOT NULL,
  `sample_test_time` datetime NOT NULL,
  `sample_report_time` datetime NOT NULL,
  PRIMARY KEY (`num`) USING BTREE,
  INDEX `patient_test_information_ibfk_2`(`sample_type_id`) USING BTREE,
  INDEX `patient_test_information_ibfk_1`(`mobile_no`) USING BTREE,
  INDEX `patient_test_information_ibfk_3`(`doctor_id`) USING BTREE,
  CONSTRAINT `patient_test_information_ibfk_2` FOREIGN KEY (`sample_type_id`) REFERENCES `virus_information` (`virus_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_test_information_ibfk_1` FOREIGN KEY (`mobile_no`) REFERENCES `patient_basic_information` (`mobile_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patient_test_information_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctor_list` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE
);




--         Important use cases
--  !!! both test data and SELECT statements are needed

--  All the test data:
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('12555812470', 'Zhongli', 'male', 25);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('13252155887', 'Wuxiangzhibing', 'male', 21);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('13626192177', 'Kevin', 'male', 20);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('15305045857 ', 'Huoshilaimu', 'male', 11);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('16406019403', 'Caoshilaimu', 'female', 10);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('1763059086', 'Leiniao', 'female', 21);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('20695282222', 'female', 'Qiqi', 20);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('233636', 'Mark', 'male', 31);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('26827877043 ', 'Keli', 'female', 17);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('41265152774', 'Qiuqiuwang', 'male', 25);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('47029460746', 'Xifenglang', 'male', 30);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('49206528032', 'Xingqiu', 'male', 20);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('55525507966', 'Wuxiangzhifeng', 'male', 18);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('70915870657', 'Babala', 'female', 18);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('72530750739', 'Leishilaimu', 'male', 10);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('79059729316', 'Huanglongyidou', 'male', 20);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('80766943391', 'Qiuqiuren', 'male', 11);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('81918316107', 'Shuishilaimu', 'female', 9);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('90747767631', 'Xiao', 'male', 24);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('93209071135', 'Ganyu', 'female', 21);
INSERT INTO `database`.`patient_basic_information` (`mobile_no`, `name`, `sex`, `age`) VALUES ('93871558168 ', 'Hutao', 'female', 22);

INSERT INTO `database`.`virus_information` (`virus_id`, `virus_name`, `virus_description`) VALUES ('virus1', 'Coughid-21', '*Coughid-21 is a newly identified type of virus this year, all patients tested to be positive should rest well and void going outside');
INSERT INTO `database`.`virus_information` (`virus_id`, `virus_name`, `virus_description`) VALUES ('virus2', 'Coughid-19', '*Coughid-19 is a newly identified type of virus this year, all patients tested to be positive should rest well and void going outside');

INSERT INTO `database`.`risk_level_list` (`risk_level`, `risk_level_name`) VALUES (1, 'low');
INSERT INTO `database`.`risk_level_list` (`risk_level`, `risk_level_name`) VALUES (2, 'mid');
INSERT INTO `database`.`risk_level_list` (`risk_level`, `risk_level_name`) VALUES (3, 'high');

INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (1, 'Centre Lukewarm Hillside', 3);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (2, 'Glow Sand district', 2);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (3, 'Lenny town', 3);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (4, 'Raspberry town', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (5, 'Bunny Tail district', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (6, 'Godlyland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (7, 'Farrellland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (8, 'Morrisland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (9, 'Perryland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (10, 'Cookland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (11, 'Kiwiland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (12, 'Roderickland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (13, 'Nicholasland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (14, 'Leslieland', 1);
INSERT INTO `database`.`judge_district_risk` (`district_no`, `district_name`, `risk_level`) VALUES (15, 'Earlland', 1);

INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C1', 'Godlyland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C2', 'Godlyland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C3', 'Godlyland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C4', 'Farrellland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C5', 'Centre Lukewarm Hillside', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C6', 'Centre Lukewarm Hillside', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C7', 'Farrellland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('C8', 'Farrellland', 'center');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E1', 'Morrisland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E2', 'Morrisland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E3', 'Morrisland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E4', 'Perryland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E5', 'Perryland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E6', 'Perryland', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E7', 'Glow Sand district', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('E8', 'Glow Sand district', 'east');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N1', 'Cookland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N2', 'Cookland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N3', 'Cookland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N4', 'Kiwiland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N5', 'Kiwiland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N6', 'Kiwiland', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N7', 'Lenny town', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('N8', 'Lenny town', 'north');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S1', 'Roderickland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S2', 'Roderickland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S3', 'Roderickland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S4', 'Nicholasland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S5', 'Nicholasland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S6', 'Nicholasland', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S7', 'Raspberry town', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('S8', 'Raspberry town', 'south');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W1', 'Leslieland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W2', 'Leslieland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W3', 'Leslieland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W4', 'Earlland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W5', 'Earlland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W6', 'Earlland', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W7', 'Bunny Tail district', 'west');
INSERT INTO `database`.`district_bs_list` (`district_bs_no`, `district_name`, `region`) VALUES ('W8', 'Bunny Tail district', 'west');

INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (1, '233636', 'Mark', '$GPGGA,082006.000,3852.9276,N,11527.4283,E,1,08,1.0,20.6,M,,,,0000*35', '2021-10-09 19:00:00', '1999-09-09 00:00:00', 'C1');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (2, '13252155887', 'Wuxiangzhibing', '$GPGGA,082006.000,3852.9277,N,11527.4287,E,1,08,1.0,20.6,M,,,,0000*37', '2021-10-07 21:34:26', '1999-09-09 00:00:00', 'C1');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (3, '1763059086', 'Leiniao', '$GPGGA,082006.000,3852.9275,N,11527.4285,E,1,08,1.0,20.6,M,,,,0000*34', '2021-10-01 00:00:02', '2021-10-03 00:49:14', 'C4');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (4, '1763059086', 'Leiniao', '$GPGGA,082006.000,3852.9276,N,11527.4286,E,1,08,1.0,20.6,M,,,,0000*34', '2021-10-03 00:49:14', '1999-09-09 00:00:00', 'C5');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (5, '233636', 'Mark', '$GPGGA,082006.000,3852.9277,N,11527.4284,E,1,08,1.0,20.6,M,,,,0000*36', '2021-09-01 02:23:11', '2021-10-01 12:34:23', 'C4');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (6, '233636', 'Mark', '$GPGGA,082006.000,3852.9278,N,11527.4285,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-01 12:34:23', '2021-10-09 19:00:00', 'C5');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (7, '41265152774', 'Qiuqiuwang', '$GPGGA,082006.000,3852.9274,N,11527.4284,E,1,08,1.0,20.6,M,,,,0000*36', '2021-09-16 21:59:08', '2021-10-08 00:00:00', 'C6');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (8, '41265152774', 'Qiuqiuwang', '$GPGGA,082006.000,3852.9275,N,11527.4285,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-08 00:00:00', '2021-10-24 15:19:56', 'C8');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (9, '55525507966', 'Wuxiangzhifeng', '$GPGGA,082006.000,3852.9276,N,11527.4286,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-09 00:00:59', '1999-09-09 00:00:00', 'E1');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (10, '80766943391', 'Qiuqiuren', '$GPGGA,082006.000,3852.9277,N,11527.4287,E,1,08,1.0,20.6,M,,,,0000*35', '2021-10-11 01:01:02', '1999-09-09 00:00:00', 'E4');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (11, '80766943391', 'Qiuqiuren', '$GPGGA,082006.000,3852.9278,N,11527.4288,E,1,08,1.0,20.6,M,,,,0000*34', '2021-10-10 15:02:38', '2021-10-11 01:01:02', 'N4');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (12, '47029460746', 'Xifenglang', '$GPGGA,082006.000,3852.9279,N,11527.4289,E,1,08,1.0,20.6,M,,,,0000*34', '2021-10-03 02:02:02', '1999-09-09 00:00:00', 'C5');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (13, '72530750739', 'Leishilaimu', '$GPGGA,082006.000,3852.9280,N,11527.4290,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-04 15:12:46', '1999-09-09 00:00:00', 'C6');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (14, '13252155887', 'Wuxiangzhibing', '$GPGGA,082006.000,3852.9280,N,11527.4290,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-10 15:17:42', '1999-09-09 00:00:00', 'C1');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (15, '41265152774', 'Qiuqiuwang', '$GPGGA,082006.000,3852.9285,N,11527.4293,E,1,08,1.0,20.6,M,,,,0000*36', '2021-10-24 15:19:56', '1999-09-09 00:00:00', 'C7');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (16, '47029460746', 'Xifenglang', '$GPGGA,082006.000,3852.9279,N,11527.4289,E,1,08,1.0,20.6,M,,,,0000*36', '2021-09-30 02:02:02', '2021-10-03 02:02:02', 'W1');
INSERT INTO `database`.`history_tracking` (`history_tracking_id`, `mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (17, '72530750739', 'Leishilaimu', '$GPGGA,082006.000,3852.9280,N,11527.4290,E,1,08,1.0,20.6,M,,,,0000*39', '2021-09-01 15:12:46', '2021-10-04 15:12:46', 'W5');

INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (1, 'hospital1', '$GPGGA,082006.000,3852.0100,N,11527.0100,E,1,08,1.0,20.6,M,,,,0000*35', 'C1');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (2, 'hospital2', '$GPGGA,082006.000,3852.0200,N,11527.0200,E,1,08,1.0,20.6,M,,,,0000*35', 'C4');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (3, 'hospital3', '$GPGGA,082006.000,3852.0300,N,11527.0300,E,1,08,1.0,20.6,M,,,,0000*35', 'E1');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (4, 'hospital4', '$GPGGA,082006.000,3852.0400,N,11527.0400,E,1,08,1.0,20.6,M,,,,0000*35', 'E4');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (5, 'hospital5', '$GPGGA,082006.000,3852.0500,N,11527.0500,E,1,08,1.0,20.6,M,,,,0000*35', 'C5');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (6, 'hospital6', '$GPGGA,082006.000,3852.0600,N,11527.0600,E,1,08,1.0,20.6,M,,,,0000*35', 'C6');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (7, 'hospital7', '$GPGGA,082006.000,3852.0700,N,11527.0700,E,1,08,1.0,20.6,M,,,,0000*35', 'N1');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (8, 'hospital8', '$GPGGA,082006.000,3852.0800,N,11527.0800,E,1,08,1.0,20.6,M,,,,0000*35', 'N4');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (9, 'hospital9', '$GPGGA,082006.000,3852.0900,N,11527.0900,E,1,08,1.0,20.6,M,,,,0000*35', 'S1');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (10, 'hospital10', '$GPGGA,082006.000,3852.1000,N,11527.1000,E,1,08,1.0,20.6,M,,,,0000*35', 'S4');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (11, 'hospital11', '$GPGGA,082006.000,3852.1100,N,11527.1100,E,1,08,1.0,20.6,M,,,,0000*35', 'W1');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (12, 'hospital12', '$GPGGA,082006.000,3852.1200,N,11527.1200,E,1,08,1.0,20.6,M,,,,0000*35', 'W4');
INSERT INTO `database`.`hospital_list` (`hospital_id`, `hospital_name`, `hospital_gps_location`, `district_bs_no`) VALUES (13, 'hospital13', '$GPGGA,082006.000,3852.0100,N,11527.1300,E,1,08,1.0,20.6,M,,,,0000*35', 'S7');

INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('13252155887', 'Wuxiangzhibing', '$GPGGA,082006.000,3852.9277,N,11527.4287,E,1,08,1.0,20.6,M,,,,0000*37', 'C1');
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('1763059086', 'Leiniao', '$GPGGA,082006.000,3852.9275,N,11527.4285,E,1,08,1.0,20.6,M,,,,0000*34', 'C5');
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('233636', 'Mark', '$GPGGA,082006.000,3852.9276,N,11527.4283,E,1,08,1.0,20.6,M,,,,0000*35', 'C1');
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('41265152774', 'Qiuqiuwang', '$GPGGA,082006.000,3852.9274,N,11527.4284,E,1,08,1.0,20.6,M,,,,0000*36', 'C8');
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('55525507966', 'Wuxiangzhifeng', '$GPGGA,082006.000,3852.9276,N,11527.4286,E,1,08,1.0,20.6,M,,,,0000*36', 'E1');
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES ('80766943391', 'Qiuqiuren', '$GPGGA,082006.000,3852.9277,N,11527.4287,E,1,08,1.0,20.6,M,,,,0000*35', 'E4');

INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1100100507, 'Elliott', 5);
INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1100100608, 'Simon', 6);
INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1100600101, 'Halbert', 1);
INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1100700205, 'Earthy', 2);
INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1200800304, 'Just', 3);
INSERT INTO `database`.`doctor_list` (`doctor_id`, `doctor_name`, `work_hospital_id`) VALUES (1200900406, 'Igor', 4);

INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('13252155887', 'virus2', 1100600101, '2021-10-17 12:19:41', '2021-10-17 16:18:46', '2021-10-17 18:29:39');
INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('233636', 'virus2', 1100600101, '2021-10-26 11:16:32', '2021-10-26 15:17:45', '2021-10-26 19:30:00');
INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('41265152774', 'virus2', 1100100507, '2021-11-02 11:36:37', '2021-11-02 11:36:49', '2021-11-01 11:36:53');
INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('47029460746', 'virus1', 1100100507, '2021-10-07 17:29:52', '2021-10-07 18:30:02', '2021-10-07 19:30:16');
INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('72530750739', 'virus1', 1100100608, '2021-10-11 17:38:29', '2021-10-11 18:37:59', '2021-10-11 19:39:15');
INSERT INTO `database`.`patient_cure_information` (`mobile_no`, `sample_type_id`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES ('80766943391', 'virus1', 1200900406, '2021-10-11 01:23:00', '2021-10-11 23:52:00', '2021-10-11 23:59:11');

INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (1, '13626192177', 'virus1', 'negative', 1100600101, '2021-10-26 08:00:00', '2021-10-26 17:00:00', '2021-10-26 20:00:00');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (2, '70915870657', 'virus1', 'negative', 1100600101, '2021-11-01 08:03:55', '2021-11-01 17:12:18', '2021-11-01 20:02:34');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (3, '12555812470', 'virus1', 'negative', 1100600101, '2021-11-01 08:06:35', '2021-11-01 17:34:03', '2021-11-01 20:23:43');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (4, '90747767631', 'virus1', 'negative', 1100700205, '2021-11-01 07:00:00', '2021-11-01 16:03:54', '2021-11-01 17:13:04');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (5, '93871558168', 'virus1', 'negative', 1100700205, '2021-11-01 07:01:05', '2021-11-01 16:04:45', '2021-11-01 17:34:04');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (6, '20695282222', 'virus1', 'negative', 1100700205, '2021-11-01 07:04:04', '2021-11-01 16:23:56', '2021-11-01 17:44:45');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (7, '93209071135', 'virus1', 'negative', 1200800304, '2021-11-01 09:12:01', '2021-11-01 18:03:35', '2021-11-01 21:04:35');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (8, '49206528032', 'virus1', 'negative', 1200800304, '2021-11-01 09:22:12', '2021-11-01 18:04:34', '2021-11-01 21:15:45');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (9, '26827877043', 'virus1', 'negative', 1200800304, '2021-11-01 09:25:53', '2021-11-01 18:29:45', '2021-11-01 21:29:10');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (10, '93871558168', 'virus1', 'negative', 1100700205, '2021-10-03 00:00:00', '2021-10-03 13:23:43', '2021-10-03 15:32:34');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (11, '93871558168', 'virus1', 'negative', 1100700205, '2021-10-04 00:00:00', '2012-10-04 15:23:27', '2021-10-03 15:45:38');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (12, '93871558168', 'virus1', 'negative', 1100700205, '2021-10-05 00:00:00', '2021-10-05 23:46:33', '2021-10-05 23:59:59');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (13, '80766943391', 'virus1', 'negative', 1200900406, '2021-10-03 01:00:00', '2021-10-03 14:44:44', '2021-10-03 19:55:55');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (14, '80766943391', 'virus1', 'positive', 1200900406, '2021-10-04 01:23:00', '2021-10-04 23:52:00', '2021-10-04 23:59:11');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (15, '47029460746', 'virus1', 'positive', 1100100507, '2021-10-04 17:29:52', '2021-10-04 18:30:02', '2021-10-04 19:30:16');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (16, '72530750739', 'virus1', 'positive', 1100100608, '2021-10-04 17:38:29', '2021-10-04 18:38:59', '2021-10-04 19:00:15');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (17, '16406019403', 'virus1', 'negative', 1100100507, '2021-10-04 17:42:10', '2021-10-04 18:42:22', '2021-10-04 19:42:28');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (18, '15305045857', 'virus1', 'negative', 1100100608, '2021-10-03 17:44:36', '2021-10-03 18:44:45', '2021-10-03 19:00:53');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (19, '81918316107', 'virus1', 'negative', 1100100507, '2021-10-05 18:17:47', '2021-10-05 18:18:57', '2021-10-05 18:20:09');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (20, '233636', 'virus2', 'positive', 1100600101, '2021-10-09 11:16:32', '2021-10-09 15:17:45', '2021-10-09 19:30:00');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (21, '13252155887', 'virus2', 'positive', 1100600101, '2021-10-10 12:19:41', '2021-10-10 16:18:46', '2021-10-10 18:29:39');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (22, '1763059086', 'virus2', 'negative', 1100100507, '2021-10-11 11:21:17', '2021-10-11 13:21:32', '2021-10-11 16:21:42');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (23, '41265152774', 'virus2', 'positive', 1100100507, '2021-10-24 11:22:50', '2021-10-24 14:23:02', '2021-10-24 16:23:14');
INSERT INTO `database`.`patient_test_information` (`num`, `mobile_no`, `sample_type_id`, `sample_result`, `doctor_id`, `sample_collect_time`, `sample_test_time`, `sample_report_time`) VALUES (24, '79059729316', 'virus2', 'negative', 1100600101, '2021-12-11 19:15:58', '2021-12-11 20:16:03', '2021-12-11 21:16:10');


-- use case 1
select
    distinct a.mobile_no
from
    (select * from history_tracking order by connected_time desc) a
where
    a.district_bs_no = any(
    select
        district_bs_no from district_bs_list
    where
        district_name = any(
        select
            district_name
        from
            district_bs_list
        where
            district_bs_no = any(
            select
                district_bs_no
            from
                history_tracking
            where
                mobile_no = 233636
            and (disconnected_time = "1999-09-09 00:00:00" or disconnected_time between "2021-10-07 19:30:00" and "2021-10-09 19:30:00")
            )
        )
    );

-- use case 2
INSERT INTO `database`.`person_current_location` (`mobile_no`, `name`, `gps_location`, `district_bs_no`) VALUES (14352311111, 'Paul','$GPGGA,082006.000,3852.9234,N,11527.4258,E,1,08,1.0,20.6,M,,,,0000*76', 'N1');
INSERT INTO `database`.`history_tracking` (`mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (14352311111, 'Paul', '$GPGGA,082006.000,3852.9234,N,11527.4258,E,1,08,1.0,20.6,M,,,,0000*76', '2021-11-01 18:19:00', '1999-09-09 00:00:00', 'N1');
UPDATE `database`.`person_current_location` SET `name` = 'Paul', `gps_location` = '$GPGGA,082006.000,3852.9234,N,11527.4258,E,1,08,1.0,20.6,M,,,,0000*76', `district_bs_no` = 'N4' WHERE `mobile_no` = 14352311111;
UPDATE `database`.`history_tracking` SET `mobile_no` = '14352311111', `name` = 'Paul', `gps_location` = '$GPGGA,082006.000,3852.9234,N,11527.4258,E,1,08,1.0,20.6,M,,,,0000*76', `connected_time` = '2021-11-01 18:19:00', `disconnected_time` = '2021-11-01 19:19:00', `district_bs_no` = 'N1' WHERE `history_tracking_id` = 18;
INSERT INTO `database`.`history_tracking` (`mobile_no`, `name`, `gps_location`, `connected_time`, `disconnected_time`, `district_bs_no`) VALUES (14352311111, 'Paul', '$GPGGA,082006.000,3852.9234,N,11527.4160,E,1,08,1.0,20.6,M,,,,0000*76', '2021-11-01 19:19:00', '1999-09-09 00:00:00', 'N4');

-- use case 3
select
    a.avgtime, b.work_hospital_id
from
    (select
        doctor_id, avg(timestampdiff(MINUTE, sample_test_time, sample_report_time)) as avgtime, substr(doctor_id, 7, 2) as hospital_no
    from
        patient_test_information
    group by
        substr(doctor_id, 7, 2)
    order by
        avgtime asc
    limit 1) a
left join
    	doctor_list b
on
    a.doctor_id = b.doctor_id;

-- use case 4
select
    mobile_no, count(*) as number
from
    patient_test_information
where
    sample_collect_time between “2021-10-03 00:00:00” and “2021-10-05 00:00:00”
group by
    mobile_no
having
    number = 2;

-- use case 5
select
    a.district_name, b.risk_level_name
from
    (select * from judge_district_risk limit 5) a
left join
    risk_level_list b
on
    a.risk_level = b.risk_level
order by
    a.risk_level desc;

-- use case 6
select
    a.mobile_no, b.name
from
    (
    select
        t1.*, t2.district_bs_no
    from
        patient_test_information t1
    left join
        hospital_list t2
    on
        substr(t1.doctor_id, 7, 2) = t2.hospital_id
    ) a
left join
    patient_basic_information b
on
    a.mobile_no = b.mobile_no
where
    a.sample_result = “positive” and a.sample_report_time like “2021-10-04 __:__:__”
and
    a.district_bs_no = any(
    select
        district_bs_no
    from
        district_bs_list
    where
        district_name = “Centre Lukewarm Hillside”
    );

-- use case 7
select
    (a.count - b.count) as increasement
from
    ((select count(mobile_no) as count
    from
        (
        select
            t1.*, t2.district_bs_no
        from
            patient_test_information t1
        left join
            hospital_list t2
        on
            substr(t1.doctor_id, 7, 2) = t2.hospital_id
        ) m
    where
        m.sample_result = "positive" and m.sample_report_time like "2021-10-05 __:__:__"
    and 
        m.district_bs_no = any(
        select
            district_bs_no
        from
            district_bs_list
        where
            district_name = "Centre Lukewarm Hillside")) as a,
    (select count(mobile_no) as count
    from
        (
        select
            t1.*, t2.district_bs_no
        from
            patient_test_information t1
        left join
            hospital_list t2
        on
            substr(t1.doctor_id, 7, 2) = t2.hospital_id
        ) n
    where
        n.sample_result = "positive" and n.sample_report_time like "2021-10-04 __:__:__"
    and 
        n.district_bs_no = any(
        select
            district_bs_no
        from
            district_bs_list
        where
            district_name = "Centre Lukewarm Hillside")) as b);

-- use case 8
select
    t1.numbefore / t2.numafter as rate
from
    (
    select
        count(distinct a.mobile_no) as numbefore
    from
        (select * from history_tracking order by connected_time desc) a
    where
        a.district_bs_no = any(
        select
            district_bs_no from district_bs_list
        where
            district_name = any(
            select
                district_name
            from
                district_bs_list
            where
                district_bs_no = any(
                select
                    district_bs_no
                from
                    history_tracking
                where
                    mobile_no = 233636 and (disconnected_time = "1999-09-09 00:00:00" or disconnected_time between "2021-10-07 19:30:00" and "2021-10-09 19:30:00")
                )
            )
        )
    and
        a.mobile_no != 233636
    ) t1,
    (
    select
        count(distinct mobile_no) as numafter
    from
        patient_test_information
    where
        mobile_no = any(
        select
            a.mobile_no
        from
            (select * from history_tracking order by connected_time desc) a
        where
            a.district_bs_no = any(
            select
                district_bs_no from district_bs_list
            where
                district_name = any(
                select
                    district_name
                from
                    district_bs_list
                where
                    district_bs_no = any(
                    select
                        district_bs_no
                    from
                        history_tracking
                    where
                        mobile_no = 233636 and (disconnected_time = "1999-09-09 00:00:00" or disconnected_time between "2021-10-07 19:30:00" and "2021-10-09 19:30:00")
                    )
                )
            )
        and
            a.mobile_no != 233636
        )
    and
        sample_result = "positive"
    and
        sample_report_time between "2021-10-09 19:30:00" and "2021-10-23 19:30:00"
    ) t2;




--          Extended use cases
--  !!! both test data and SELECT statements are needed

--  All the test data have been inserted in 'Important use cases'.


-- use case 1
select
	(case
when
substr(a.hospital_gps_location, 31, 10) = substr(b.hospital_gps_location, 31, 10)
then
	'true'
else
	'false'
end) as whether_longitude_equal,
	(case
when
substr(a.hospital_gps_location, 19, 9) = substr(b.hospital_gps_location, 19, 9)
then
	'true'
else
	'false'
end) as whether_latitude_equal
from
	(select * from hospital_list where hospital_name = 'hospital1') a,
	(select * from hospital_list where hospital_name = 'hospital13') b; 

-- use case 2
select
    distinct t1.district_name
from
    district_bs_list t1
where
    district_bs_no = any(
    select
        distinct b.district_bs_no
    from
        (select * from patient_test_information where sample_result = "positive") a
    left join
        history_tracking b
    on
        a.mobile_no = b.mobile_no
    where
        (b.disconnected_time = "1999-09-09 00:00:00")
    or
        timestampdiff(hour, b.connected_time, b.disconnected_time) >= 24
    );

select
    t2.district_name
from
    district_bs_list t2
where
    district_bs_no = any(
    select
        distinct c.district_bs_no
    from
        (select * from patient_test_information where sample_result = "positive") d
    left join
        history_tracking c
    on
        d.mobile_no = c.mobile_no
    where
        timestampdiff(hour, c.connected_time, c.disconnected_time) < 24
    and
        c.disconnected_time != "1999-09-09 00:00:00"
    );

-- use case 3
update
	judge_district_risk
set
	risk_level = 3
where
	district_name = any(
	select
		distinct t1.district_name
	from
		district_bs_list t1
	where
		district_bs_no = any(
		select
			distinct b.district_bs_no
		from
			(select * from patient_test_information where sample_result = "positive") a
		left join
			history_tracking b
		on
			a.mobile_no = b.mobile_no
		where
			(b.disconnected_time = "1999-09-09 00:00:00")
		or
			timestampdiff(hour, b.connected_time, b.disconnected_time) >= 24
		)
);

update
	judge_district_risk
set
	risk_level = 2
where
	district_name = any(
	select
		t2.district_name
	from
		district_bs_list t2
	where
		district_bs_no = any(
		select
			distinct c.district_bs_no
		from
(select * from patient_test_information where sample_result = "positive") d
		left join
			history_tracking c
		on
			d.mobile_no = c.mobile_no
		where
timestampdiff(hour, c.connected_time, c.disconnected_time) < 24
		and
			c.disconnected_time != "1999-09-09 00:00:00"
		)
	);

-- use case 4
select
hospital_name, (substr(hospital_gps_location, 19, 9) - 3852.0110) as northdiff,
	(substr(hospital_gps_location, 31, 10) - 11527.0110) as eastdiff
from
	hospital_list
order by
	northdiff asc, eastdiff asc
limit 1;

-- use case 5
select
    a.mobile_no, (timestampdiff(HOUR, b.sample_report_time, a.sample_report_time)) as mintimediff
from
    patient_cure_information a
left join
    (select * from patient_test_information where sample_result = "positive") b
on
    a.mobile_no = b.mobile_no
order by
    mintimediff asc
limit 1;

-- use case 6
select 
	mobile_no, name
from
	history_tracking
where
	disconnected_time > "2021-10-11 00:00:00"
and
	district_bs_no = any(
	select
		distinct b.district_bs_no
	from
(select * from patient_test_information where sample_result = "positive") a
left join
		history_tracking b
	on
		a.mobile_no = b.mobile_no
	where
		(b.disconnected_time = "1999-09-09 00:00:00")
	or
timestampdiff(hour, b.connected_time, b.disconnected_time) >= 24
); 

-- use case 7
select
	c.name, c.district_name
from
	(
	select
		b.name, a.district_name, b.mobile_no
	from
		district_bs_list a
	right join
		person_current_location b
	on
		a.district_bs_no = b.district_bs_no
	where
		b.name = any(
		select
			name
		from
			history_tracking
		where
			disconnected_time > "2021-10-11 00:00:00"
		)
	) c
left join
	history_tracking d
on
	c.mobile_no = d.mobile_no
where
	d.district_bs_no = any(
		select
			district_bs_no
		from
			district_bs_list
		where
			district_name = any(
			select
				t2.district_name
			from
				district_bs_list t2
			where
				district_bs_no = any(
				select
					distinct c.district_bs_no
				from
(select * from patient_test_information where sample_result = "positive") d
				left join
					history_tracking c
				on
					d.mobile_no = c.mobile_no
				where
timestampdiff(hour, c.connected_time, c.disconnected_time) < 24
				and
					c.disconnected_time != "1999-09-09 00:00:00"
				)
		)
	);

-- use case 8
select
mobile_no, hospital_no
from
(select *, substr(doctor_id, 7, 2) as hospital_no from patient_test_information) a
where
a.sample_result = "negative"
and	
a.hospital_no = any(select substr(doctor_id, 7, 2) as hospital_no from patient_cure_information group by hospital_no)
and
mobile_no != any(select mobile_no from patient_cure_information);

-- use case 9
select
	a.mobile_no, b.district_name
from
	(
	select
		mobile_no, district_bs_no
	from
		history_tracking
	where
		mobile_no = any(
		select
			mobile_no
		from
			(select
				m.*, n.district_bs_no
			from
				(select
					*, substr(doctor_id, 7, 2) as hospital_no
				from
					patient_test_information
				) m
			left join
				hospital_list n
			on
				m.hospital_no = n.hospital_id
			) t1
		where
t1.sample_result = "positive" and sample_report_time like "2021-10-04 __:__:__"
		and 
			t1.district_bs_no = any(
			select
				district_bs_no
			from
				district_bs_list
			where
				district_name = "Centre Lukewarm Hillside"
			)
		)
	and
		disconnected_time != "1999-09-09 00:00:00"
	) a
left join
	district_bs_list b
on
	a.district_bs_no = b.district_bs_no;

-- use case 10
select
	b.hospital_no, MAX(b.totalnum) as totalnum
from
	(
	select
		a.hospital_no, count(distinct a.mobile_no) as totalnum
	from
		(
		select
			*, substr(doctor_id, 7, 2) as hospital_no
		from
			patient_test_information
		) a
	group by
		a.hospital_no
	order by
		totalnum desc
	) b;
