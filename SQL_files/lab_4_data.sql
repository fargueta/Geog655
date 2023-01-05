CREATE TABLE geometries (name varchar, geom geometry);

INSERT INTO geometries VALUES
('Point', 'POINT(0 0)'),
('Linestring', 'LINESTRING(0 0, 1 1, 2 1, 2 2)'),
('Polygon', 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
('PolygonWithHole', 'Polygon((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');

select st_srid(geom) from geometries;

select updateGeometrySRID('geometries','geom', 4326);

SELECT  ST_AsText(ST_GeometryFromText('LINESTRING(0 0 0, 1 0 0, 1 1 2)', 4326));
--Q2 S1 --
SELECT school_nam, city, category FROM public."publicschools " WHERE city= 'Laurel';

--Q3 ---
SELECT school_nam, street, city, zip FROM public."publicschools " WHERE street LIKE'%Oxon Hill%';

--Q4 ---
SELECT COUNT(city), city FROM public."publicschools " GROUP BY city;

--Q5 ---

SELECT * FROM public."publicschools " WHERE category= 'public elementary sch' AND zip != 20744;

--Q6 ---

SELECT * FROM public."pgroads " WHERE fename = 'Queen Anne' AND fetype = 'Ave';

--Q7 ---
SELECT 
	*
FROM
	public."pgroads " as a,
	public."pgroads " as b
WHERE
	ST_Intersects(a.geom,b.geom)
	AND a.gid != b.gid
	AND a.fename = 'Prairie'
    AND a.fetype = 'Ct';
-- Q8 -- 
SELECT * 
FROM public."pgroads "
ORDER BY length DESC
LIMIT 1;

---Q9--
SELECT * 
FROM public."pgroads "
ORDER BY length ASC
LIMIT 1;

--Q10---

SELECT 
	*
FROM
	public."pgroads " as a,
	public."pgroads " as b
WHERE
	ST_Touches(a.geom,b.geom)
	AND a.gid != b.gid
	AND a.gid = 8407
ORDER BY ST_Intersection(a.geom, b.geom);

-- Q11 ---

SELECT 
	SUM(length), cfcc
FROM
	public."pgroads "
	WHERE cfcc = 'A41' OR cfcc = 'A45'
GROUP BY cfcc;

-- Q12 --

SELECT 
	population,
	zip,
	school_nam,
	category
FROM public."pgcensus " AS census
JOIN public."publicschools " AS pubsch
ON ST_Contains(census.geom, pubsch.geom)
WHERE pubsch.category = 'public high school' AND pubsch.school_nam = 'Laurel'

--Q13 ---
SELECT 
	SUM(population) AS pop_sum_20737
FROM public."pgcensus " AS census
JOIN public."publicschools " AS pubsch
ON ST_Contains(census.geom, pubsch.geom)
WHERE pubsch.zip = '20737'

--Q14 ---

SELECT 
	cfcc, SUM(ST_Length(geom)) AS length
FROM 
	public."pgroads "
GROUP BY cfcc
ORDER BY length DESC;

--Q15-- 
DROP TABLE public."publicschools "

--Q16 ---
Delete from public."pgroads "
WHERE cfcc != 'A41'

--SECTION 2----
--- Q1 -----
INSERT INTO geometries VALUES
('Point1', 'POINT(2 2)'),
('Linestring1', 'LINESTRING(0 0, 3 3, 5 1, 6 6)'),
('Polygon1', 'POLYGON((0 0, 3 0, 6 6, 0 6, 0 0))');
SELECT * FROM geometries WHERE name='Point1'
SELECT * FROM geometries WHERE name='Linestring1'
SELECT * FROM geometries WHERE name='Polygon1'


SELECT  ST_AsText(ST_GeometryFromText('POINT(2 2)', 4326));
SELECT  ST_AsText(ST_GeometryFromText('LINESTRING(0 0, 3 3, 5 1, 6 6)', 4326));
SELECT  ST_AsText(ST_GeometryFromText('POLYGON((0 0, 3 0, 6 6, 0 6, 0 0))', 4326));

----Q2 ----
SELECT ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom) FROM public."publicschools ";
SELECT ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom) FROM public."pgroads ";
SELECT ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom) FROM public."pgcensus ";

-- Q3 ---
SELECT school_nam, ST_X(geom), ST_Y(geom) FROM public."publicschools "; 

--Q4 ---
SELECT ST_Length(geom),fename FROM public."pgroads " WHERE fename = 'Fenno'

--Q5 -- 
SELECT ST_ASText(geom) FROM public."pgcensus ";

--Q6 ---
SELECT geodesc, ST_Area(geom), ST_Perimeter(geom) FROM public."pgcensus " WHERE geodesc = '8004.02';

--Q7---
SELECT ST_NumGeometries(geom) FROM public."pgcensus ";
SELECT ST_NumGeometries(geom) FROM public."pgroads ";
SELECT ST_NumGeometries(geom) FROM public."publicschools ";