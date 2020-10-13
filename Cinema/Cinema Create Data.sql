--CREATE DATABASE Cinema

CREATE TABLE City(
	cityID int IDENTITY(1,1) NOT NULL,
	cityName varchar (100) NOT NULL,
PRIMARY KEY (cityID)
);

CREATE TABLE Cinema(
	cinemaID int IDENTITY(1,1) NOT NULL,
	cityID int foreign key REFERENCES City (cityID),
	[name] varchar(100) NOT NULL,
	operator varchar(100) NOT NULL,
PRIMARY KEY (cinemaID)
);

CREATE TABLE CinemaHall(
	CinemaHall_ID int IDENTITY(1,1) NOT NULL,
	cinemaID int foreign key REFERENCES Cinema(cinemaID),
	[playerName] int NOT NULL,
	[captain] bit NOT NULL,
	[position] varchar (100) NOT NULL,
	[skillLevel] varchar (100) NOT NULL,
PRIMARY KEY (CinemaHall_ID)
);

CREATE TABLE Film(
	filmID int IDENTITY(1,1) NOT NULL,
	title varchar (100) NOT NULL,
	filmLenght int NOT NULL,
	PRIMARY KEY(filmID)
); 

CREATE TABLE HallFilm(
	CinemaHall_ID int foreign key REFERENCES CinemaHall(CinemaHall_ID),
	FilmID int foreign key REFERENCES Film (FilmID),
PRIMARY KEY(CinemaHall_ID,FilmID)
);


