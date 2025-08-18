create database pokemon_data;
use pokemon_data;

create table pokemon (pokemon_id int  primary key , name varchar(100) not null, base_experience int, height int , weight int);

insert into pokemon (pokemon_id, name, base_experience, height, weight)
select distinct id, name, base_experience, height, weight
from pokemon_data;

select * from pokemon;

create table types( type_id int auto_increment primary key , type_name varchar(50) unique not null );

INSERT INTO types (type_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(types, ',', n.n), ',', -1)) AS type_name
FROM pokemon_data
JOIN (
  SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
) n
ON CHAR_LENGTH(types) - CHAR_LENGTH(REPLACE(types, ',', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(types, ',', n.n), ',', -1)) <> ''
AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(types, ',', n.n), ',', -1)) NOT IN (
  SELECT type_name FROM types
);

select * from types;

CREATE TABLE pokemon_types (
    pokemon_id INT,
    type_id INT,
    PRIMARY KEY (pokemon_id, type_id),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY (type_id) REFERENCES Types(type_id)
);

INSERT INTO pokemon_types (pokemon_id, type_id)
SELECT DISTINCT p.id, t.type_id
FROM pokemon_data p
JOIN (
  SELECT id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(types, ',', n.n), ',', -1)) AS type_name
  FROM pokemon_data
  JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
  ) n
  ON CHAR_LENGTH(types) - CHAR_LENGTH(REPLACE(types, ',', '')) >= n.n - 1
) pt
  ON p.id = pt.id
JOIN Types t ON t.type_name = pt.type_name;

select * from pokemon_types;

create table abilities ( ability_id INT PRIMARY KEY AUTO_INCREMENT, ability_name VARCHAR(100) UNIQUE NOT NULL);

create table pokemon_abilities ( pokemon_id INT, ability_id INT, PRIMARY KEY (pokemon_id, ability_id), 
FOREIGN KEY (pokemon_id) REFERENCES pokemon(pokemon_id),
FOREIGN KEY (ability_id) REFERENCES abilities(ability_id) );

INSERT INTO abilities (ability_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(abilities, ',', n.n), ',', -1)) AS ability_name
FROM pokemon_data 
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
) n
ON CHAR_LENGTH(abilities) - CHAR_LENGTH(REPLACE(abilities, ',', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(abilities, ',', n.n), ',', -1)) <> ''
  AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(abilities, ',', n.n), ',', -1)) NOT IN (
      SELECT ability_name FROM abilities
  );

INSERT INTO pokemon_abilities (pokemon_id, ability_id)
SELECT DISTINCT p.pokemon_id, a.ability_id
FROM (
    SELECT id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(abilities, ',', n.n), ',', -1)) AS ability_name
    FROM pokemon_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
    ) n
    ON CHAR_LENGTH(abilities) - CHAR_LENGTH(REPLACE(abilities, ',', '')) >= n.n - 1
) pa
JOIN Pokemon p ON p.pokemon_id = pa.id   
JOIN Abilities a ON a.ability_name = pa.ability_name;

select * from abilities;
select * from pokemon_abilities;

CREATE TABLE moves (
    move_id INT PRIMARY KEY AUTO_INCREMENT,
    move_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE pokemon_moves (
    pokemon_id INT,
    move_id INT,
    PRIMARY KEY (pokemon_id, move_id),
    FOREIGN KEY (pokemon_id) REFERENCES Pokemon(pokemon_id),
    FOREIGN KEY (move_id) REFERENCES Moves(move_id)
);
INSERT INTO moves (move_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(moves, ',', n.n), ',', -1)) AS move_name
FROM pokemon_data
JOIN (
  SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) n
ON CHAR_LENGTH(moves) - CHAR_LENGTH(REPLACE(moves, ',', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(moves, ',', n.n), ',', -1)) <> ''
AND TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(moves, ',', n.n), ',', -1)) NOT IN (
  SELECT move_name FROM moves
);

INSERT INTO pokemon_moves (pokemon_id, move_id)
SELECT DISTINCT p.id, m.move_id
FROM pokemon_data p
JOIN (
  SELECT id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(moves, ',', n.n), ',', -1)) AS move_name
  FROM pokemon_data
  JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  ) n
  ON CHAR_LENGTH(moves) - CHAR_LENGTH(REPLACE(moves, ',', '')) >= n.n - 1
) pm
  ON p.id = pm.id
JOIN Moves m ON m.move_name = pm.move_name;

select * from moves;
select * from pokemon_moves;

CREATE TABLE stats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    stat_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE pokemon_stats (
    pokemon_id INT,
    stat_id INT,
    stat_value INT,
    PRIMARY KEY (pokemon_id, stat_id),
    FOREIGN KEY (pokemon_id) REFERENCES pokemon(pokemon_id),
    FOREIGN KEY (stat_id) REFERENCES stats(stat_id)
);

INSERT INTO stats (stat_name)
SELECT DISTINCT TRIM(SUBSTRING_INDEX(stat_pair, '=', 1)) AS stat_name
FROM (
  SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(stats, ',', n.n), ',', -1)) AS stat_pair
  FROM pokemon_data
  JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
  ) n
  ON CHAR_LENGTH(stats) - CHAR_LENGTH(REPLACE(stats, ',', '')) >= n.n - 1
) s
WHERE stat_pair <> ''
AND TRIM(SUBSTRING_INDEX(stat_pair, '=', 1)) NOT IN (SELECT stat_name FROM stats);


INSERT INTO pokemon_stats (pokemon_id, stat_id, stat_value)
SELECT p.pokemon_id, s.stat_id, CAST(TRIM(SUBSTRING_INDEX(stat_pair, '=', -1)) AS UNSIGNED)
FROM (
  SELECT id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(stats, ',', n.n), ',', -1)) AS stat_pair
  FROM pokemon_data
  JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
  ) n
  ON CHAR_LENGTH(stats) - CHAR_LENGTH(REPLACE(stats, ',', '')) >= n.n - 1
) ps
JOIN Pokemon p ON p.pokemon_id = ps.id
JOIN Stats s ON s.stat_name = TRIM(SUBSTRING_INDEX(stat_pair, '=', 1));

select * from stats;
select * from pokemon_stats;
drop table pokemon_data;


-- Find the Top 5 Strongest Pokémon by Total Stats
 
SELECT p.name AS pokemon_name, SUM(ps.stat_value) AS total_stats
FROM Pokemon p
JOIN Pokemon_Stats ps ON p.pokemon_id = ps.pokemon_id
GROUP BY p.pokemon_id, p.name
ORDER BY total_stats DESC
LIMIT 5;

-- Find All Pokémon that Know a Specific Move
SELECT p.name
FROM Pokemon p
JOIN Pokemon_Moves pm ON p.pokemon_id = pm.pokemon_id
JOIN Moves m ON pm.move_id = m.move_id
WHERE m.move_name = 'Thunderbolt';

-- Average Stat Value by Pokémon Type

SELECT t.type_name, s.stat_name, AVG(ps.stat_value) AS avg_stat
FROM Pokemon p
JOIN Pokemon_Types pt ON p.pokemon_id = pt.pokemon_id
JOIN Types t ON pt.type_id = t.type_id
JOIN Pokemon_Stats ps ON p.pokemon_id = ps.pokemon_id
JOIN Stats s ON ps.stat_id = s.stat_id
GROUP BY t.type_name, s.stat_name
ORDER BY t.type_name, s.stat_name;

-- Find Pokémon With the Best "Offense-to-Defense" Ratio
SELECT p.name,
       MAX(CASE WHEN s.stat_name = 'attack' THEN ps.stat_value END) AS attack,
       MAX(CASE WHEN s.stat_name = 'defense' THEN ps.stat_value END) AS defense,
       ROUND(
         MAX(CASE WHEN s.stat_name = 'attack' THEN ps.stat_value END) * 1.0 /
         MAX(CASE WHEN s.stat_name = 'defense' THEN ps.stat_value END), 2
       ) AS atk_def_ratio
FROM Pokemon p
JOIN Pokemon_Stats ps ON p.pokemon_id = ps.pokemon_id
JOIN Stats s ON ps.stat_id = s.stat_id
GROUP BY p.pokemon_id, p.name
ORDER BY atk_def_ratio DESC
LIMIT 10;


-- Pokémon With the Most Versatile Movepool
SELECT p.name, COUNT(DISTINCT pm.move_id) AS move_count
FROM Pokemon p
JOIN Pokemon_Moves pm ON p.pokemon_id = pm.pokemon_id
GROUP BY p.pokemon_id, p.name
ORDER BY move_count DESC
LIMIT 10;

-- Fastest Pokémon That Can Learn a Specific Move
SELECT p.name, ps.stat_value AS speed
FROM Pokemon p
JOIN Pokemon_Stats ps ON p.pokemon_id = ps.pokemon_id
JOIN Stats s ON ps.stat_id = s.stat_id
JOIN Pokemon_Moves pm ON p.pokemon_id = pm.pokemon_id
JOIN Moves m ON pm.move_id = m.move_id
WHERE s.stat_name = 'speed' AND m.move_name = 'Earthquake'
ORDER BY ps.stat_value DESC
LIMIT 5;


-- Create Type Effectiveness Table
CREATE TABLE type_effectiveness (
    attacking_type VARCHAR(20),
    defending_type VARCHAR(20),
    multiplier DECIMAL(3,1),
    PRIMARY KEY (attacking_type, defending_type)
);

-- Insert all 18 types effectiveness in one go
INSERT INTO type_effectiveness (attacking_type, defending_type, multiplier) VALUES
-- Normal
('Normal','Rock',0.5), ('Normal','Ghost',0.0), ('Normal','Steel',0.5),
('Normal','Normal',1), ('Normal','Fire',1), ('Normal','Water',1), ('Normal','Grass',1), ('Normal','Electric',1),
('Normal','Ice',1), ('Normal','Fighting',1), ('Normal','Poison',1), ('Normal','Ground',1), ('Normal','Flying',1),
('Normal','Psychic',1), ('Normal','Bug',1), ('Normal','Dragon',1), ('Normal','Dark',1), ('Normal','Fairy',1),

-- Fire
('Fire','Grass',2), ('Fire','Ice',2), ('Fire','Bug',2), ('Fire','Steel',2),
('Fire','Fire',0.5), ('Fire','Water',0.5), ('Fire','Rock',0.5), ('Fire','Dragon',0.5),
('Fire','Normal',1), ('Fire','Electric',1), ('Fire','Fighting',1), ('Fire','Poison',1), ('Fire','Ground',1),
('Fire','Flying',1), ('Fire','Psychic',1), ('Fire','Ghost',1), ('Fire','Dark',1), ('Fire','Fairy',1),

-- Water
('Water','Fire',2), ('Water','Ground',2), ('Water','Rock',2),
('Water','Water',0.5), ('Water','Grass',0.5), ('Water','Dragon',0.5),
('Water','Normal',1), ('Water','Electric',1), ('Water','Ice',1), ('Water','Fighting',1), ('Water','Poison',1),
('Water','Flying',1), ('Water','Psychic',1), ('Water','Bug',1), ('Water','Ghost',1), ('Water','Dark',1), ('Water','Steel',1), ('Water','Fairy',1),

-- Grass
('Grass','Water',2), ('Grass','Ground',2), ('Grass','Rock',2),
('Grass','Fire',0.5), ('Grass','Grass',0.5), ('Grass','Poison',0.5), ('Grass','Flying',0.5), ('Grass','Bug',0.5), ('Grass','Dragon',0.5), ('Grass','Steel',0.5),
('Grass','Normal',1), ('Grass','Electric',1), ('Grass','Ice',1), ('Grass','Fighting',1), ('Grass','Psychic',1), ('Grass','Ghost',1), ('Grass','Dark',1), ('Grass','Fairy',1),

-- Electric
('Electric','Water',2), ('Electric','Flying',2),
('Electric','Electric',0.5), ('Electric','Grass',0.5), ('Electric','Dragon',0.5),
('Electric','Ground',0.0),
('Electric','Normal',1), ('Electric','Fire',1), ('Electric','Ice',1), ('Electric','Fighting',1), ('Electric','Poison',1),
('Electric','Psychic',1), ('Electric','Bug',1), ('Electric','Rock',1), ('Electric','Ghost',1), ('Electric','Dark',1), ('Electric','Steel',1), ('Electric','Fairy',1),

-- Ice
('Ice','Grass',2), ('Ice','Ground',2), ('Ice','Flying',2), ('Ice','Dragon',2),
('Ice','Fire',0.5), ('Ice','Water',0.5), ('Ice','Ice',0.5), ('Ice','Steel',0.5),
('Ice','Normal',1), ('Ice','Electric',1), ('Ice','Fighting',1), ('Ice','Poison',1), ('Ice','Psychic',1), ('Ice','Bug',1), ('Ice','Rock',1), ('Ice','Ghost',1), ('Ice','Dark',1), ('Ice','Fairy',1),

-- Fighting
('Fighting','Normal',2), ('Fighting','Ice',2), ('Fighting','Rock',2), ('Fighting','Dark',2), ('Fighting','Steel',2),
('Fighting','Poison',0.5), ('Fighting','Flying',0.5), ('Fighting','Psychic',0.5), ('Fighting','Bug',0.5), ('Fighting','Fairy',0.5),
('Fighting','Ghost',0.0),
('Fighting','Fire',1), ('Fighting','Water',1), ('Fighting','Grass',1), ('Fighting','Electric',1), ('Fighting','Dragon',1),

-- Poison
('Poison','Grass',2), ('Poison','Fairy',2),
('Poison','Poison',0.5), ('Poison','Ground',0.5), ('Poison','Rock',0.5), ('Poison','Ghost',0.5),
('Poison','Steel',0.0),
('Poison','Normal',1), ('Poison','Fire',1), ('Poison','Water',1), ('Poison','Electric',1), ('Poison','Ice',1), ('Poison','Flying',1), ('Poison','Psychic',1), ('Poison','Bug',1), ('Poison','Dragon',1), ('Poison','Dark',1),

-- Ground
('Ground','Fire',2), ('Ground','Electric',2), ('Ground','Poison',2), ('Ground','Rock',2), ('Ground','Steel',2),
('Ground','Grass',0.5), ('Ground','Bug',0.5),
('Ground','Flying',0.0),
('Ground','Normal',1), ('Ground','Water',1), ('Ground','Ice',1), ('Ground','Fighting',1), ('Ground','Psychic',1), ('Ground','Ghost',1), ('Ground','Dragon',1), ('Ground','Dark',1), ('Ground','Fairy',1),

-- Flying
('Flying','Grass',2), ('Flying','Fighting',2), ('Flying','Bug',2),
('Flying','Electric',0.5), ('Flying','Rock',0.5), ('Flying','Steel',0.5),
('Flying','Normal',1), ('Flying','Fire',1), ('Flying','Water',1), ('Flying','Ice',1), ('Flying','Poison',1), ('Flying','Ground',1), ('Flying','Psychic',1), ('Flying','Ghost',1), ('Flying','Dragon',1), ('Flying','Dark',1), ('Flying','Fairy',1),

-- Psychic
('Psychic','Fighting',2), ('Psychic','Poison',2),
('Psychic','Psychic',0.5), ('Psychic','Steel',0.5),
('Psychic','Dark',0.0),
('Psychic','Normal',1), ('Psychic','Fire',1), ('Psychic','Water',1), ('Psychic','Grass',1), ('Psychic','Electric',1), ('Psychic','Ice',1), ('Psychic','Ground',1), ('Psychic','Flying',1), ('Psychic','Bug',1), ('Psychic','Rock',1), ('Psychic','Ghost',1), ('Psychic','Dragon',1), ('Psychic','Fairy',1),

-- Bug
('Bug','Grass',2), ('Bug','Psychic',2), ('Bug','Dark',2),
('Bug','Fire',0.5), ('Bug','Fighting',0.5), ('Bug','Poison',0.5), ('Bug','Flying',0.5), ('Bug','Ghost',0.5), ('Bug','Steel',0.5), ('Bug','Fairy',0.5),
('Bug','Normal',1), ('Bug','Water',1), ('Bug','Electric',1), ('Bug','Ice',1), ('Bug','Rock',1), ('Bug','Dragon',1),

-- Rock
('Rock','Fire',2), ('Rock','Ice',2), ('Rock','Flying',2), ('Rock','Bug',2),
('Rock','Fighting',0.5), ('Rock','Ground',0.5), ('Rock','Steel',0.5),
('Rock','Normal',1), ('Rock','Water',1), ('Rock','Grass',1), ('Rock','Electric',1), ('Rock','Poison',1), ('Rock','Psychic',1), ('Rock','Ghost',1), ('Rock','Dragon',1), ('Rock','Dark',1), ('Rock','Fairy',1),

-- Ghost
('Ghost','Psychic',2), ('Ghost','Ghost',2),
('Ghost','Dark',0.5),
('Ghost','Normal',0.0),
('Ghost','Fire',1), ('Ghost','Water',1), ('Ghost','Grass',1), ('Ghost','Electric',1), ('Ghost','Ice',1), ('Ghost','Fighting',1), ('Ghost','Poison',1), ('Ghost','Ground',1), ('Ghost','Flying',1), ('Ghost','Bug',1), ('Ghost','Rock',1), ('Ghost','Dragon',1), ('Ghost','Steel',1), ('Ghost','Fairy',1),

-- Dragon
('Dragon','Dragon',2),
('Dragon','Steel',0.5),
('Dragon','Fairy',0.0),
('Dragon','Normal',1), ('Dragon','Fire',1), ('Dragon','Water',1), ('Dragon','Grass',1), ('Dragon','Electric',1), ('Dragon','Ice',1), ('Dragon','Fighting',1), ('Dragon','Poison',1), ('Dragon','Ground',1), ('Dragon','Flying',1), ('Dragon','Psychic',1), ('Dragon','Bug',1), ('Dragon','Rock',1), ('Dragon','Ghost',1), ('Dragon','Dark',1),

-- Dark
('Dark','Psychic',2), ('Dark','Ghost',2),
('Dark','Fighting',0.5), ('Dark','Dark',0.5), ('Dark','Fairy',0.5),
('Dark','Normal',1), ('Dark','Fire',1), ('Dark','Water',1), ('Dark','Grass',1), ('Dark','Electric',1), ('Dark','Ice',1), ('Dark','Poison',1), ('Dark','Ground',1), ('Dark','Flying',1), ('Dark','Bug',1), ('Dark','Rock',1), ('Dark','Dragon',1), ('Dark','Steel',1),

-- Steel
('Steel','Rock',2), ('Steel','Ice',2), ('Steel','Fairy',2),
('Steel','Fire',0.5), ('Steel','Water',0.5), ('Steel','Electric',0.5), ('Steel','Steel',0.5),
('Steel','Normal',1), ('Steel','Grass',1), ('Steel','Fighting',1), ('Steel','Poison',1), ('Steel','Ground',1), ('Steel','Flying',1), ('Steel','Psychic',1), ('Steel','Bug',1), ('Steel','Ghost',1), ('Steel','Dragon',1), ('Steel','Dark',1),

-- Fairy
('Fairy','Fighting',2), ('Fairy','Dragon',2), ('Fairy','Dark',2),
('Fairy','Fire',0.5), ('Fairy','Poison',0.5), ('Fairy','Steel',0.5),
('Fairy','Normal',1), ('Fairy','Water',1), ('Fairy','Grass',1), ('Fairy','Electric',1), ('Fairy','Ice',1), ('Fairy','Ground',1), ('Fairy','Flying',1), ('Fairy','Psychic',1), ('Fairy','Bug',1), ('Fairy','Rock',1), ('Fairy','Ghost',1);

-- Find type weaknesses of a Pokémon
SELECT atk.type_name AS attacking_type, te.multiplier
FROM pokemon p
JOIN pokemon_types pt ON p.pokemon_id = pt.pokemon_id   
JOIN types def ON pt.type_id = def.type_id
JOIN type_effectiveness te ON te.defending_type = def.type_name
JOIN types atk ON te.attacking_type = atk.type_name
WHERE p.name = 'Pikachu'
ORDER BY te.multiplier DESC;

-- type effectiveness against a specific Pokémon

SELECT atk.type_name AS attacking_type, 
       ROUND(AVG(te.multiplier),2) AS total_effectiveness
FROM pokemon p
JOIN pokemon_types pt ON p.pokemon_id = pt.pokemon_id
JOIN types def ON pt.type_id = def.type_id
JOIN type_effectiveness te ON te.defending_type = def.type_name
JOIN types atk ON te.attacking_type = atk.type_name
WHERE p.name = 'Charizard'
GROUP BY atk.type_name
ORDER BY total_effectiveness DESC;


-- Get effectiveness multiplier
SELECT atk.type_name AS attacking_type,
       def.type_name AS defending_type,
       te.multiplier
FROM types atk
JOIN type_effectiveness te ON atk.type_name = te.attacking_type
JOIN types def ON def.type_name = te.defending_type
WHERE atk.type_name = 'Electric'  
  AND def.type_name IN (
      SELECT t.type_name
      FROM pokemon p
      JOIN pokemon_types pt ON p.pokemon_id = pt.pokemon_id
      JOIN types t ON pt.type_id = t.type_id
      WHERE p.name = 'Charizard'   
  );

-- Find the most common abilities across Pokémon

SELECT a.ability_name, COUNT(*) AS num_pokemon
FROM pokemon_abilities pa
JOIN abilities a ON pa.ability_id = a.ability_id
GROUP BY a.ability_name
ORDER BY num_pokemon DESC
LIMIT 10;



