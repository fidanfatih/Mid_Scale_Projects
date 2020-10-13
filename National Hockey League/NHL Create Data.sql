--CREATE DATABASE [NationalHockeyLeague]

CREATE TABLE InjuryRecords(
	[injuryID] int IDENTITY(1,1) NOT NULL,
	[description] varchar (100) NOT NULL,
PRIMARY KEY ([injuryID])
);

CREATE TABLE Teams(
	[teamID] [int] IDENTITY(1,1) NOT NULL,
	[teamName] [varchar](100) NOT NULL,
	[city] [varchar](100) NOT NULL,
	[coach] [varchar](100) NOT NULL,
PRIMARY KEY ([teamID])
);

CREATE TABLE Players(
	[playerID] int IDENTITY(1,1) NOT NULL,
	[teamID] int foreign key REFERENCES Teams ([teamID]),
	[playerName] int NOT NULL,
	[captain] bit NOT NULL,
	[position] varchar (100) NOT NULL,
	[skillLevel] varchar (100) NOT NULL,
PRIMARY KEY ([playerID],[teamID])
);

CREATE TABLE Games(
	[gameID] int IDENTITY(1,1) NOT NULL,
	[hostTeamID] int foreign key REFERENCES Teams ([teamID]),
	[guestTeamID] int foreign key REFERENCES Teams ([teamID]),
	[date] date NOT NULL,
	[hostTeamScore] int NOT NULL,
	[guestTeamScore] int NOT NULL,
PRIMARY KEY([gameID])
);

--CREATE TABLE Player_Injury(
--	[gameID] int foreign key REFERENCES Games ([gameID]),
--	[playerID] int foreign key REFERENCES Players ([playerID]),
--	[injuryID] int foreign key REFERENCES InjuryRecords ([injuryID]),
--	PRIMARY KEY([gameID],[playerID],[injuryID])
--);

CREATE TABLE Player_Injury(
	[gameID] int foreign key REFERENCES Games ([gameID]),
	[injuryID] int foreign key REFERENCES InjuryRecords ([injuryID]),
	PRIMARY KEY([gameID],[injuryID])
);