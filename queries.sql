/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered=TRUE AND escape_attempts<3;
SELECT date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg>10.5;
SELECT * FROM animals WHERE neutered=TRUE;
SELECT * FROM animals WHERE NOT name='Gabumon';
SELECT * FROM animals WHERE weight_kg>=10.4 AND weight_kg<=17.3; /*.. OR ..*/ SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;  

-- .................... TRANSACTIONS ....................
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


-- ..................... AGREGATE FUNCTIONS QUERIES .......................

SELECT COUNT(id) from animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts=0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) AS escape_num FROM animals  GROUP BY neutered; 
SELECT species, MIN(weight_kg) AS Min_Weight, MAX(weight_kg) AS Max_Weight FROM animals GROUP BY species; 
SELECT species, AVG(escape_attempts) AS Average_Escapes FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'  GROUP BY species;  


--  ....................... OWNER AND SPECIES TABLE QUERIES USING 'JOIN' ......................

--  What animals belong to Melody Pond?
SELECT A.name, O.full_name, O.age FROM animals AS A JOIN owners AS O ON A.owner_id=O.id WHERE O.full_name='Melody Pond' ;

-- List of all animals that are pokemon (their type is Pokemon).
SELECT  A.id, A.name, S.name FROM animals AS A JOIN species AS S ON A.species_id=S.id WHERE S.name='Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT O.full_name AS Owner, A.name AS Pet_name FROM owners As O LEFT JOIN animals AS A ON O.id=A.owner_id GROUP BY O.full_name, A.name ORDER BY O.full_name;

-- How many animals are there per species?
SELECT species.name AS species, COUNT(animals.species_id) FROM animals JOIN species ON animals.species_id=species.id GROUP BY species.name; 

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name Pet_name, owners.full_name Owner, species.name FROM animals JOIN species ON animals.species_id=species.id JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Jennifer Orwell' AND species.name='Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, animals.escape_attempts, owners.full_name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Dean Winchester' AND animals.escape_attempts=0;

-- Who owns the most animals?
SELECT owners.full_name, owners.age, COUNT(name) as number_of_pets FROM animals JOIN owners ON animals.owner_id=owners.id GROUP BY owners.full_name, owners.age ORDER BY number_of_pets DESC;



-- ..................... JUNCTION TABLES QUERIES ....................

-- Who was the last animal seen by William Tatcher?
SELECT A.name AS Pet_name, S.name AS species, vets.name AS Vet_name, visits.date_of_visit AS date_of_visit FROM animals AS A 
    JOIN visits 
        ON A.id=visits.animal_id 
    JOIN vets 
        ON vets.id=visits.vet_id 
    JOIN species AS S 
        ON A.species_id=S.id 
    WHERE vets.name='William Tatcher'
    ORDER BY date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT A.name Pet_name, SP.name Species from animals as A 
    JOIN species AS SP 
        ON A.species_id=SP.id
    JOIN visits as V
        ON V.animal_id=A.id
    JOIN vets 
        ON vets.id = V.vet_id
    WHERE vets.name='Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT V.name AS name, SP.name AS specializations FROM vets as V 
    LEFT JOIN specializations AS S
        ON V.id=S.vet_id
    LEFT JOIN species AS SP 
        ON s.species_id=SP.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT A.name Pet_name, SP.name Species, V.date_of_visit AS Visit_date from animals as A 
    JOIN species AS SP 
        ON A.species_id=SP.id
    JOIN visits as V
        ON V.animal_id=A.id
    JOIN vets 
        ON vets.id = V.vet_id
    WHERE vets.name='Stephanie Mendez' AND V.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT A.name AS Pet_name, COUNT(V.animal_id) AS Visits FROM animals AS A
    JOIN visits AS V 
        ON A.id=V.animal_id 
    GROUP BY Pet_name ORDER BY visits DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT  A.name AS Pet_name, v.date_of_visit AS First_Visit FROM animals as A 
    JOIN visits AS V
        ON A.id=V.animal_id
    JOIN vets
        ON vets.id=V.vet_id
    WHERE vets.name='Maisy Smith' ORDER BY First_Visit LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name as Pet_name, animals.date_of_birth, animals.escape_attempts, animals.neutered, animals.weight_kg,
    species.name Species, owners.full_name AS Owner, visits.date_of_visit,
    vets.name As Vet_name, vets.age, vets.date_of_graduation FROM animals 
    JOIN visits
        ON visits.animal_id=animals.id
    JOIN owners
        ON animals.owner_id=owners.id
    JOIN species
        ON animals.species_id=species.id
    JOIN vets
        ON vets.id=visits.vet_id ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name, species.name as Specialization FROM vets
    JOIN visits
        ON vets.id=visits.vet_id
    LEFT JOIN specializations
        ON specializations.vet_id=vets.id
    LEFT JOIN species 
        ON species.id=specializations.species_id
    WHERE specializations.vet_id IS NULL GROUP BY vets.name, species.name ORDER BY vets.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "species", COUNT(animals.species_id) FROM vets
  JOIN visits
    ON visits.vet_id=vets.id
  JOIN animals
    ON animals.id = visits.animal_id
  JOIN species
    ON species.id = animals.species_id
  WHERE vets.name = 'Maisy Smith' GROUP BY species.name ORDER BY count DESC LIMIT 1;

