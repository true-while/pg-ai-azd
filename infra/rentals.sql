/*********************************************************************************
Create tables
*********************************************************************************/

DROP TABLE IF EXISTS listings;

CREATE TABLE listings (
	id int,
	name varchar(100),
	description text,
	property_type varchar(25),
	room_type varchar(30),
	price numeric,
	weekly_price numeric
);

DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews (
	id int,
	listing_id int, 
	date date,
	comments text
);

DROP TABLE IF EXISTS languages;

CREATE TABLE languages (
    code VARCHAR(7) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS listing_translations;

CREATE TABLE listing_translations(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    listing_id INT,
    language_code VARCHAR(7),
    description TEXT
);

/*********************************************************************************
Insert data
*********************************************************************************/

INSERT INTO languages(code)
VALUES
    ('de'),
    ('zh-Hans'),
    ('hi'),
    ('hu'),
    ('sw');

/*********************************************************************************
Load data
*********************************************************************************/

\COPY listings FROM './infra/listings.csv' CSV HEADER
\COPY reviews FROM './infra/reviews.csv' CSV HEADER
    