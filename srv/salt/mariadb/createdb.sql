create database books;
use books;
CREATE TABLE books (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(1024));
GRANT ALL ON books.* TO books@localhost IDENTIFIED BY 'salainen';
INSERT INTO books(name) VALUES ("Kirja");

