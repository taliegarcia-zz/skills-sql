-- 1. Select all columns for all brands in the Brands table.
SELECT * FROM Brands;

-- 2. Select all columns for all car models made by Pontiac in the Models table.
SELECT * FROM Models WHERE brand_name = 'Pontiac';

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.
SELECT brand_name, name FROM Models WHERE year = 1964;

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.
SELECT m.name, m.brand_name, b.headquarters FROM Models AS m 
    -- m.brand_name and b.headquarters may be a little redundant since those fields are not shared between tables
    -- but I like to be explicit ! ! ! 
    JOIN Brands AS b 
    ON m.brand_name = b.name
        WHERE m.name = 'Mustang';


-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).
SELECT * FROM Brands ORDER BY founded LIMIT 3;

-- 6. Count the Ford models in the database (output should be a **number**).
SELECT COUNT(*) FROM Models WHERE brand_name = 'Ford';

-- 7. Select the **name** of any and all car brands that are not discontinued.
SELECT name FROM Brands WHERE discontinued IS NULL;

-- 8. Select rows 15-25 of the DB in alphabetical order by model name.
SELECT * FROM Models ORDER BY name LIMIT 11 OFFSET 14;

-- 9. Select the **brand, name, and year the model's brand was 
--    founded** for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be ``null`` if 
--    the brand is not in the Brands table.)
SELECT m.brand_name AS brand, m.name AS model_name, b.founded AS year_brand_founded 
    -- if .headers on : the header names should make the info more clear! 
    FROM Models AS m
        LEFT JOIN Brands AS b 
        ON m.brand_name = b.name
            WHERE m.year = 1960;


-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all **brands** that are not discontinued
-- regardless of whether they have any cars in the cars table.
-- before:
    """SELECT b.name, b.founded, m.name
            FROM Models AS m
                LEFT JOIN Brands AS b
                    ON b.name = m.brand_name
                        WHERE b.discontinued IS NULL;"""
                        -- changed to """ because I'm sad there is no python in this homework... :(
                        -- and also...just looked strangely like a multiple choice question with b. and m. -- eh.

-- 1. Answer:
"""SELECT b.name AS brand_name, b.founded AS year_founded, m.name AS model_name 
    FROM Brands as b 
        LEFT JOIN Models as m 
            ON b.name = m.brand_name
                WHERE b.discontinued IS NULL;"""
    -- can check against... """SELECT name FROM Brands WHERE discontinued IS NULL;""" -- right?
    -- changing to FROM Brands and LEFT JOIN Models means Brands info is prioritized...
    -- so even if nothing comes from a query into the Models table, the Brand info is still listed


-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;
-- 2. Answer:
    """SELECT m.name, m.brand_name, b.founded
        FROM Models AS m
            INNER JOIN Brands AS b
            ON (m.brand_name=b.name)
            ORDER BY m.brand_name;"""
    
    -- unless I was really really supposed to make Left join work anyway?:
    """SELECT m.name, m.brand_name, b.founded
            FROM Models AS m
            LEFT JOIN Brands AS b
            ON (m.brand_name=b.name)
            WHERE (m.brand_name=b.name)
            ORDER BY m.brand_name;"""

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.
-- ! ! ! Happy Words ! ! !:
-- The Left Join returns all data requested from the original table 
-- that the the FROM clause is fetching
-- it joins with the table specified by LEFT JOIN
-- If nothing is found in the LEFT JOIN table, the query simply returns NULL for those fields
-- We still get the complete data request from the original table, 
-- regardless of the results of the LEFT JOIN
-- Alternatively, if we only want to see data with records aka references 
-- present in OR shared by both tables, we would use INNER JOIN

-- 3. Modify the query so that it only selects brands that don't have any car models in the cars table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;
    """SELECT b.name, b.founded
        FROM Brands as b
            LEFT JOIN Models as m
                ON b.name = m.brand_name
                    WHERE m.year > 1940
                        ORDER BY b.name;"""
-- 3. Answer
"""SELECT b.name, b.founded
        FROM Brands as b
            LEFT JOIN Models as m
                ON b.name = m.brand_name
                WHERE m.id IS NULL;"""
-- Where: no id is found for the query! == no data in Models table for that brand name
-- m.year does not matter at that point if it doesn't exist...so removed from query.


-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model *until* the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;
    """SELECT b.name, m.name, m.year, b.discontinued
        FROM Models AS m
            LEFT JOIN brands AS b
                ON m.brand_name = b.name
                    WHERE b.discontinued NOT NULL;"""
-- 4. Answer:
"""SELECT b.name, m.name, m.year, b.discontinued, (b.discontinued - b.founded) AS years_until_brand_discontinued
        FROM Models AS m
            LEFT JOIN brands AS b
                ON m.brand_name = b.name
                    WHERE b.discontinued NOT NULL;"""



-- Part 3: Futher Study

-- 1. Select the **name** of any brand with more than 5 models in the database.
SELECT brand_name FROM Models GROUP BY brand_name HAVING COUNT(*) > 5;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback
-- I think the brand_name and model name are mixed up in this table?
-- Also if the table was set up with AUTOINCREMENT, couldn't I avoid writing in the id#?
INSERT INTO Models VALUES (49, 2015, 'Chevrolet', 'Malibu');
INSERT INTO Models VALUES (50, 2015, 'Subaru', 'Outback');


-- 3. Write a SQL statement to crate a table called ``Awards`` 
--    with columns ``name``, ``year``, and ``winner``. Choose 
--    an appropriate datatype and nullability for each column.
CREATE TABLE Awards (
name VARCHAR(50) NOT NULL,
year INT(4) NOT NULL,
winner VARCHAR(50)
);

-- changed when I saw question below:
DROP TABLE Awards;

CREATE TABLE Awards (
name VARCHAR(50) NOT NULL,
year INT(4) NOT NULL,
winner_model_id INTEGER 
    REFERENCES Models
);
-- VARCHAR(50) is the standard in the other tables: Models, Brands
-- I thought winner was the "name" of a brand or model, but the next question makes me rethink that...

-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      # get the ``id`` of the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      # get the ``id`` of the 2015 Subaru Outback
-- Sooo maybe instead of a table of Awards with name, year, winner....it should be name, year, winner_model_id?

-- redo setup of Awards table:
DROP TABLE Awards;

-- turn on referential integrity:
PRAGMA foreign_keys=ON;

-- new Awards table with referential integrity:
CREATE TABLE Awards (
name VARCHAR(50) NOT NULL,
year INT(4) NOT NULL,
winner_model_id INTEGER 
    REFERENCES Models
);

-- yoyoyo now I can add awards with a subquery to the Models table!
INSERT INTO Awards VALUES ('IIHS Safety Award',  2015, (SELECT id FROM Models WHERE name = 'Malibu'));
INSERT INTO Awards VALUES ('IIHS Safety Award',  2015, (SELECT id FROM Models WHERE name = 'Outback'));
-- I really wanted to try id INTEGER PRIMARY KEY AUTOINCREMENT
-- I couldn't make it work on the Awards table though...so got rid of the id field...which wasn't required anyway, eh?

-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.
"""SELECT name
FROM Models
WHERE year IN
  (
   SELECT founded
   FROM brands
  );"""


-- With join...
"""SELECT m.name
FROM Models AS m
JOIN Brands as b
ON m.year = b.founded;"""









