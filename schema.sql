/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals ( 
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    name VARCHAR(100) NOT NULL, 
    date_of_birth DATE, 
    escape_attempts INT, 
    neutered BOOLEAN, 
    weight_kg DECIMAL NOT NULL
);

ALTER TABLE animals ADD species VARCHAR(150);

CREATE TABLE owners(id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, full_name VARCHAR(255) NOT NULL, age INT);

CREATE TABLE species(id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, name VARCHAR(255) NOT NULL);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals
 ADD species_id INT, 
 ADD owner_id INT,
 ADD CONSTRAINT FK_species FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE,
 ADD CONSTRAINT FK_owners FOREIGN KEY(owner_id) REFERENCES owners(id) ON DELETE CASCADE;

CREATE TABLE vets(id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, name VARCHAR(255), age INT, date_of_graduation DATE);

-- JUNCTION TABLES
CREATE TABLE specializations(
    vet_id INT, 
    species_id INT,
    PRIMARY KEY(vet_id, species_id),     
    CONSTRAINT FK_vets
        FOREIGN KEY (vet_id)
            REFERENCES vets(id)
        ON DELETE CASCADE,
    CONSTRAINT FK_species
        FOREIGN KEY (species_id)
            REFERENCES  species(id)
        ON DELETE CASCADE
);

CREATE TABLE visits(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    animal_id INT,
    vet_id INT, 
    date_of_visit DATE,     
    CONSTRAINT FK_vets
        FOREIGN KEY(vet_id)
            REFERENCES vets(id)
        ON DELETE CASCADE,
    CONSTRAINT FK_animals
        FOREIGN KEY(animal_id)
            REFERENCES  animals(id)
        ON DELETE CASCADE
);
