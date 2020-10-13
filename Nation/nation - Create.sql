--
-- Current Database: nation
--

-- CREATE DATABASE nation;
-- USE nation;

-- CREATE DATABASE nation2;
-- USE nation2;


--
-- Table structure for table `continents`
--

CREATE TABLE continents (
  continent_id int NOT NULL IDENTITY(1,1),
  name varchar(255) NOT NULL,
  PRIMARY KEY (continent_id)
);


--
-- Table structure for table `regions`
--

CREATE TABLE regions (
  region_id int NOT NULL IDENTITY(1,1),
  name varchar(100) NOT NULL,
  continent_id int NOT NULL,
  PRIMARY KEY (region_id),
  CONSTRAINT regions_ibfk_1 FOREIGN KEY (continent_id) REFERENCES continents (continent_id)
);
--KEY continent_id (continent_id),


--
-- Table structure for table `countries`
--

CREATE TABLE countries (
  country_id int NOT NULL IDENTITY(1,1),
  name varchar(50) DEFAULT NULL,
  area decimal(10,2) NOT NULL,
  national_day date DEFAULT NULL,
  country_code2 char(2) NOT NULL UNIQUE,
  country_code3 char(3) NOT NULL UNIQUE,
  region_id int NOT NULL,
  PRIMARY KEY (country_id),
  CONSTRAINT countries_ibfk_1 FOREIGN KEY (region_id) REFERENCES regions (region_id)
);
--UNIQUE KEY country_code2 (country_code2),
--UNIQUE KEY country_code3 (country_code3),
--KEY region_id (region_id),


--
-- Table structure for table `languages`
--

CREATE TABLE languages (
  language_id int NOT NULL IDENTITY(1,1),
  language varchar(50) NOT NULL,
  PRIMARY KEY (language_id)
);


--
-- Table structure for table `country_languages`
--

CREATE TABLE country_languages (
  country_id int NOT NULL,
  language_id int NOT NULL,
  official tinyint NOT NULL,
  PRIMARY KEY (country_id,language_id),
  CONSTRAINT country_languages_ibfk_1 FOREIGN KEY (country_id) REFERENCES countries (country_id),
  CONSTRAINT country_languages_ibfk_2 FOREIGN KEY (language_id) REFERENCES languages (language_id)
);
--KEY language_id (language_id),


--
-- Table structure for table `country_stats`
--

CREATE TABLE country_stats (
  country_id int NOT NULL,
  year int NOT NULL,
  population int DEFAULT NULL,
  gdp decimal(15,0) DEFAULT NULL,
  PRIMARY KEY (country_id,year),
  CONSTRAINT country_stats_ibfk_1 FOREIGN KEY (country_id) REFERENCES countries (country_id)
);
