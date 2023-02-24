CREATE DATABASE WomenTennis;
USE WomenTennis;

-- PLAYER
CREATE TABLE country(
code CHAR(3) not null,
country_name VARCHAR(50),
PRIMARY KEY (code)
);


CREATE TABLE player (
id INTEGER not null,
first_name VARCHAR(30),
last_name VARCHAR(30),
country_code CHAR(3),
tournament_playing_in_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (country_code) REFERENCES country(code),
FOREIGN KEY (tournament_playing_in_id) REFERENCES tournament(id)
);


INSERT INTO country
(code, country_name)
VALUES
('POL', 'Poland'),
('JAP', 'Japan'),
('TUN', 'Tunisia'),
('USA', 'United_States'),
('GBR', 'United_Kingdom'),
('CHE', 'Switzerland'),
('CAN', 'Canada'),
('KAZ', 'Kazakhstan');

INSERT INTO player 
(id, first_name, last_name, country_code, tournament_playing_in_id)
VALUES
(1, 'Iga', 'Swietek', 'POL', 1),
(2, 'Naomi', 'Osaka', 'JAP', 5),
(3, 'Ons', 'Jabeur',  'TUN', 1),
(4, 'Coco', 'Gauff', 'USA', 2),
(5, 'Emma', 'Raducanu',  'GBR', 1),
(6, 'Belinda', 'Bencic',  'CHE', 3),
(7, 'Leylah', 'Fernandez', 'CAN', 4),
(8, 'Elena', 'Rybakina',  'KAZ', 4);



-- TOURNAMENT

CREATE TABLE tournament_type(
id INTEGER not null,
tournament_type VARCHAR(30),
PRIMARY KEY (id)
);


CREATE TABLE tournament(
id INTEGER not null,
tournament_name VARCHAR(100),
location VARCHAR(50),
number_of_rounds INTEGER,
tournament_type_id INTEGER,
surface VARCHAR(20),
PRIMARY KEY (id),
FOREIGN KEY (tournament_type_id) REFERENCES tournament_type(id)
);

CREATE TABLE playing_category(
id INTEGER not null,
category_name VARCHAR(50),
PRIMARY KEY (id)
);

CREATE TABLE tournament_playing_category(
id INTEGER not null,
tournament_id INTEGER,
playing_category_id INTEGER,
PRIMARY KEY (id),
FOREIGN KEY (tournament_id) REFERENCES tournament(id),
FOREIGN KEY (playing_category_id) REFERENCES playing_category(id)
);


INSERT INTO tournament_type
(id, tournament_type)
VALUES
(1, 'Grand_Slam'),
(2, 'WTA_250');



INSERT INTO tournament
(id, tournament_name, location, tournament_type_id, surface)
VALUES
(1, 'Wimbledon_2022', 'London', 1, 'Grass'),
(2, 'French_Open_2022', 'Paris', 1, 'Clay'),
(3, 'US_Open_2022', 'NewYork', 1, 'Hard_Court'),
(4, 'Australia_Open_2022', 'Melbourne', 1, 'Hard_Court'),
(5, 'Japan_Open_2022', 'Osaka', 2, 'Hard_Court');




INSERT INTO playing_category
(id, category_name)
VALUES
(1, 'Men_Single'),
(2, 'Men_Double'),
(3, 'Women_Single'),
(4, 'Women_Double'),
(5, 'Mixed_Double');

INSERT INTO tournament_playing_category
(id, tournament_id, playing_category_id)
VALUES
(1, 1, 3),
(2, 2, 3),
(3, 3, 3),
(4, 4, 3),
(5, 5, 3);


-- Join player and country table to see the full country name
SELECT player.first_name, player.last_name, player.country_code, country.country_name
FROM player
INNER JOIN country
ON country.code = player.country_code;


-- Stored procedure (Who are playing in Wimbledon 2022 ?)
DELIMITER //
CREATE PROCEDURE GetWimbledonPlayer()
BEGIN
    SELECT player.first_name, player.last_name, player.tournament_playing_in_id, tournament.tournament_name
FROM player
INNER JOIN tournament
ON player.tournament_playing_in_id = tournament.id
where tournament.id = 1;
END //
    
DELIMITER ;

CALL GetWimbledonPlayer;

-- Query with Subquery (Which tournament got three players and who are those player?)


SELECT
    distinct player.first_name, player.last_name
FROM
    player
WHERE 
player.tournament_playing_in_id IN (

SELECT
    player.tournament_playing_in_id
FROM
    player
GROUP BY player.tournament_playing_in_id
HAVING COUNT(*) = 3);

-- Create view and join player and country tables to see the full country name

CREATE VIEW player_country
AS
SELECT player.first_name, player.last_name, player.country_code, country.country_name
FROM player
INNER JOIN country
ON country.code = player.country_code;

SELECT *
FROM player_country;
