-- Q1 ---
SELECT school_nam
FROM public."publicschools"
WHERE ST_Contains(geom, ST_GeometryFromText('POINT(413797.2016872928 124604.24301644415)', 26985));

--Q2 ----
SELECT * 
FROM publicschools
WHERE ST_DWithin(geom,
				ST_GeomFromText('POINT(413797.2016872928 124604.24301644415)', 26985),
				1000
				);
				
--- Q3 ---
SELECT * 
FROM public."pgcensus "
WHERE ST_Contains(geom,
				ST_GeomFromText('POINT(417108 129547)', 26985));

--- Q4 ----
SELECT * 
FROM public."pgroads "
WHERE ST_DWithin(geom,
				ST_GeomFromText('POINT(406286 124178)', 26985),
				5000
				);
--- Q5 ----
SELECT ST_AsTEXT(geom), school_nam, city
FROM public."publicschools"
WHERE school_nam='Baden'

SELECT
  pgrd.fename,
  pgrd.fetype
FROM public."pgroads " AS pgrd
JOIN public."publicschools" AS pubsch
ON ST_DWithin(pgrd.geom,
				ST_GeomFromText('POINT(419875.79606161953 110341.10564772133)', 26985),
				1000)
WHERE pubsch.city = 'Brandywine';

-- Q6 --
SELECT
  DISTINCT pgrd.fename,
  pgrd.fetype
FROM public."pgroads " AS pgrd
JOIN public."publicschools" AS pubsch
ON ST_DWithin(pgrd.geom,
				ST_GeomFromText('POINT(419875.79606161953 110341.10564772133)', 26985),
				1000)
WHERE pubsch.city = 'Brandywine';

-- Q6 ---
SELECT 
 COUNT(school_nam) AS school_count,
 census.geodesc
FROM public."publicschools" AS pubsch
JOIN public."pgcensus " AS census
ON ST_Contains(census.geom, pubsch.geom)
GROUP BY census.geodesc;

--- Q7 ---
SELECT 
 COUNT(school_nam) AS school_count,
 COUNT(roads.gid) AS road_seg,
 SUM(population) AS total_population,
 census.geodesc AS census_tract
FROM public."publicschools" AS pubsch
JOIN public."pgcensus " AS census
ON ST_Contains(census.geom, pubsch.geom)
JOIN public."pgroads " AS roads
ON ST_Contains(census.geom, roads.geom)
GROUP BY census.geodesc
ORDER BY total_population ASC
LIMIT 1;


SELECT 
	COUNT(school_nam), geodesc
FROM public."publicschools"
GROUP BY geodesc;

SELECT 
 	COUNT(DISTINCT geodesc), geodesc
FROM public."pgcensus "
GROUP BY geodesc;