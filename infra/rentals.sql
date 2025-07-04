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

/*********************************************************************************
Create foreign keys
*********************************************************************************/

\COPY listings FROM './infra/listings.csv' CSV HEADER
\COPY reviews FROM './infra/reviews.csv' CSV HEADER
    