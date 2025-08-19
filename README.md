# PokemonData_Analysis
## Project Overview
This project focuses on analyzing and managing Pokemon data using a fully normalized relational database built in **MySQL**. 
The goal is to design an efficient schema that captures essential Pokémon attributes (types, stats, abilities, moves, and effectiveness) while allowing 
**complex analytical queries** and battle simulations.

## Objectives

- Normalize Pokemon data into multiple related tables.
- Store Pokémon, types, abilities, stats, and move effectiveness.
- Write advanced SQL queries for insights such as top Pokémon, weaknesses, and damage multipliers.
- Extend queries towards a mini battle simulator. 

## Entities & Attributes 
### 1. Pokemon 
| Attribute    | Type        | Constraints         | Description                         |
| ------------ | ----------- | ------------------- | ----------------------------------- |
| `pokemon_id` | INT         | PK, AUTO\_INCREMENT | Unique identifier for each Pokémon. |
| `name`       | VARCHAR(50) | UNIQUE, NOT NULL    | Name of the Pokémon.                |
| `generation` | INT         | NOT NULL            | Pokémon generation (1–9).           |
| `legendary`  | BOOLEAN     | DEFAULT 0           | Whether the Pokémon is legendary.   |

### 2. Tyoes 
| Attribute   | Type        | Constraints         | Description                          |
| ----------- | ----------- | ------------------- | ------------------------------------ |
| `type_id`   | INT         | PK, AUTO\_INCREMENT | Unique identifier for each type.     |
| `type_name` | VARCHAR(20) | UNIQUE, NOT NULL    | Name of the type (Fire, Water, etc.) |

### 3. Pokemon_types
| Attribute    | Type    | Constraints           | Description                           |
| ------------ | ------- | --------------------- | ------------------------------------- |
| `pokemon_id` | INT     | PK, FK → pokemon      | References Pokémon.                   |
| `type_id`    | INT     | PK, FK → types        | References type.                      |
| `slot`       | TINYINT | CHECK (slot IN (1,2)) | 1 = Primary type, 2 = Secondary type. |

### 4. Abilities 
| Attribute      | Type        | Constraints         | Description                    |
| -------------- | ----------- | ------------------- | ------------------------------ |
| `ability_id`   | INT         | PK, AUTO\_INCREMENT | Unique identifier for ability. |
| `ability_name` | VARCHAR(50) | UNIQUE, NOT NULL    | Ability name.                  |
| `description`  | TEXT        | NULL                | Description of the ability.    |

### 5. Pokemon_abilities
| Attribute    | Type | Constraints        | Description         |
| ------------ | ---- | ------------------ | ------------------- |
| `pokemon_id` | INT  | PK, FK → pokemon   | References Pokémon. |
| `ability_id` | INT  | PK, FK → abilities | References ability. |

### 6. Stats 
| Attribute   | Type        | Constraints         | Description                      |
| ----------- | ----------- | ------------------- | -------------------------------- |
| `stat_id`   | INT         | PK, AUTO\_INCREMENT | Unique identifier for stat.      |
| `stat_name` | VARCHAR(20) | UNIQUE, NOT NULL    | Name of stat (HP, Attack, etc.). |

### 7. Pokemon_stats 
| Attribute    | Type | Constraints      | Description         |
| ------------ | ---- | ---------------- | ------------------- |
| `pokemon_id` | INT  | PK, FK → pokemon | References Pokémon. |
| `stat_id`    | INT  | PK, FK → stats   | References stat.    |
| `base_value` | INT  | NOT NULL         | Base stat value.    |

### 8. Moves
| Attribute   | Type                                | Constraints         | Description                        |
| ----------- | ----------------------------------- | ------------------- | ---------------------------------- |
| `move_id`   | INT                                 | PK, AUTO\_INCREMENT | Unique identifier for move.        |
| `move_name` | VARCHAR(50)                         | UNIQUE, NOT NULL    | Name of the move.                  |
| `move_type` | INT                                 | FK → types          | Type of the move.                  |
| `category`  | ENUM('Physical','Special','Status') | NOT NULL            | Move category.                     |
| `power`     | INT                                 | NULL                | Power of the move (if applicable). |
| `accuracy`  | DECIMAL(4,1)                        | NULL                | Accuracy percentage.               |
| `pp`        | INT                                 | NOT NULL            | Power Points (usage limit).        |

### 9. Pokemon_moves 
| Attribute      | Type        | Constraints      | Description                          |
| -------------- | ----------- | ---------------- | ------------------------------------ |
| `pokemon_id`   | INT         | PK, FK → pokemon | References Pokémon.                  |
| `move_id`      | INT         | PK, FK → moves   | References move.                     |
| `learn_method` | VARCHAR(30) | NOT NULL         | How move is learned (level-up, TM…). |

### 10. Type_effectiveness
| Attribute        | Type         | Constraints               | Description                       |
| ---------------- | ------------ | ------------------------- | --------------------------------- |
| `attacking_type` | VARCHAR(20)  | PK, FK → types.type\_name | Attacking type.                   |
| `defending_type` | VARCHAR(20)  | PK, FK → types.type\_name | Defending type.                   |
| `multiplier`     | DECIMAL(3,1) | NOT NULL                  | Damage multiplier (0, 0.5, 1, 2). |

## Relationships
| Table                                    | Relationship Type   | With               | Example                                        |
| ---------------------------------------- | ------------------- | ------------------ | ---------------------------------------------- |
| pokemon ↔ pokemon\_types ↔ types         | Many-to-Many        | Types              | Pikachu = Electric; Bulbasaur = Grass + Poison |
| pokemon ↔ pokemon\_abilities ↔ abilities | Many-to-Many        | Abilities          | Pikachu = Static, Lightning Rod                |
| pokemon ↔ pokemon\_moves ↔ moves         | Many-to-Many        | Moves              | Pikachu learns Thunderbolt, Quick Attack       |
| pokemon ↔ pokemon\_stats                 | One-to-One          | Stats              | Pikachu has base stats (HP=35, Attack=55)      |
| types ↔ type\_effectiveness ↔ types      | Many-to-Many (Self) | Battle multipliers | Fire is 2x vs Grass, 0.5x vs Water             |


## ER-Diagram
<img width="905" height="691" alt="Screenshot 2025-08-18 at 9 34 59 PM" src="https://github.com/user-attachments/assets/1d9bc88f-f72e-43cd-980c-d20bb7258b46" />

## Normalization Approach 
- **1NF (First Normal Form)**: Removed repeating groups (types, abilities, moves stored as CSV → split into separate rows).
- **2NF (Second Normal Form)**: Moved multi-valued dependencies into separate tables (pokemon_types, pokemon_abilities, etc.).
- **3NF (Third Normal Form)**: Removed transitive dependencies by introducing lookup tables (types, abilities, moves, stats).

## Conclusion
This project demonstrates how database normalization improves efficiency, scalability, and analytical capabilities.
The Pokemon database is now a powerful analytical tool that supports deep insights into Pokémon characteristics, abilities, and performance.
