CREATE DATABASE IF NOT EXISTS `wiki1_development`;
CREATE DATABASE IF NOT EXISTS `wiki1_test`;

CREATE USER 'rails'@'%' IDENTIFIED BY 'rails';
GRANT ALL ON `wiki1_development`.* TO 'rails'@'%';
GRANT ALL ON `wiki1_test`.* TO 'rails'@'%';
