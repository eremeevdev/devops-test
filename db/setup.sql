CREATE DATABASE IF NOT EXISTS appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE appdb;

CREATE TABLE IF NOT EXISTS texts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content VARCHAR(500) NOT NULL
);

INSERT INTO texts (content) VALUES
    ('Hello from the Go backend!'),
    ('This is a random text for the DevOps interview.'),
    ('Good luck with the deployment!'),
    ('Nginx is waiting for you.');
