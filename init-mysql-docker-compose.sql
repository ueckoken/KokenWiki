CREATE USER 'rails'@'%' IDENTIFIED BY 'rails';
GRANT ALL ON `wiki1_development`.* TO 'rails'@'%';
GRANT ALL ON `wiki1_test`.* TO 'rails'@'%';
