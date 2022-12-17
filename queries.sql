/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered=TRUE AND escape_attempts<3;
SELECT date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg>10.5;
SELECT * FROM animals WHERE neutered=TRUE;
SELECT * FROM animals WHERE NOT name='Gabumon';
SELECT * FROM animals WHERE weight_kg>=10.4 AND weight_kg<=17.3; /*.. OR ..*/ SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;  

-- TRANSACTIONS
BEGIN;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth>'2022-01-01'; 
SAVEPOINT SP1;
UPDATE animals SET weight_kg=weight_kg*(-1);
ROLLBACK TO SP1;
UPDATE animals SET weight_kg=weight_kg*(-1) WHERE weight_kg<0;
COMMIT;
SELECT * from animals ORDER BY id ASC;

SELECT COUNT(id) from animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts=0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) AS escape_num FROM animals  GROUP BY neutered; 
SELECT species, MIN(weight_kg) AS Min_Weight, MAX(weight_kg) AS Max_Weight FROM animals GROUP BY species; 
SELECT species, AVG(escape_attempts) AS Average_Escapes FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'  GROUP BY species;  


-- JOINING TABLE'S DATA

SELECT A.name, O.full_name, O.age FROM animals AS A JOIN owners AS O ON A.owner_id=O.id WHERE O.full_name='Melody Pond' ;
SELECT  A.id, A.name, S.name FROM animals AS A JOIN species AS S ON A.species_id=S.id WHERE S.name='Pokemon';
SELECT O.full_name AS Owner, A.name AS Pet_name FROM owners As O LEFT JOIN animals AS A ON O.id=A.owner_id GROUP BY O.full_name, A.name ORDER BY O.full_name;
SELECT species.name AS species, COUNT(animals.species_id) FROM animals JOIN species ON animals.species_id=species.id GROUP BY species.name; 
SELECT animals.name Pet_name, owners.full_name Owner, species.name FROM animals JOIN species ON animals.species_id=species.id JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Jennifer Orwell' AND species.name='Digimon';
SELECT animals.name, animals.escape_attempts, owners.full_name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Dean Winchester' AND animals.escape_attempts=0;
SELECT owners.full_name, owners.age, COUNT(name) as number_of_pets FROM animals JOIN owners ON animals.owner_id=owners.id GROUP BY owners.full_name, owners.age ORDER BY number_of_pets DESC;
