
USE CUSTOMER_BUILD

/* Question 1:

Using data from the CUSTOMER_BUILD database, organize and count people into seven categories
based on the living American generation classification:
    1.   GI Generation
    2.   Silent Generation
    3.   Baby Boomers
    4.   Generation X
    5.   Generation Y
    6.   Generation Z
    7.   Other generations
*/

SELECT (CASE
    WHEN Year(DateOfBirth) BETWEEN 1901 AND 1927
    THEN 'GI Generation'
    WHEN Year(DateOfBirth) BETWEEN 1928 AND 1945
    THEN 'Silent'
    WHEN Year(DateOfBirth) BETWEEN 1946 AND 1964
    THEN 'Baby Boomers'
    WHEN Year(DateOfBirth) BETWEEN 1965 AND 1980
    THEN 'Generation X'
    WHEN Year(DateOfBirth) BETWEEN 1989 AND 1994
    THEN 'Generation Y'
    WHEN Year(DateOfBirth) BETWEEN 1995 AND 2012
    THEN 'Generation Z'
    ELSE 'Other'
    END
) AS 'Generation', COUNT(*) AS '# of Customers'

FROM tblCUSTOMER

GROUP BY(
    CASE
        WHEN Year(DateOfBirth) BETWEEN 1901 AND 1927
        THEN 'GI Generation'
        WHEN Year(DateOfBirth) BETWEEN 1928 AND 1945
        THEN 'Silent'
        WHEN Year(DateOfBirth) BETWEEN 1946 AND 1964
        THEN 'Baby Boomers'
        WHEN Year(DateOfBirth) BETWEEN 1965 AND 1980
        THEN 'Generation X'
        WHEN Year(DateOfBirth) BETWEEN 1989 AND 1994
        THEN 'Generation Y'
        WHEN Year(DateOfBirth) BETWEEN 1995 AND 2012
        THEN 'Generation Z'
        ELSE 'Other'
    END
)

ORDER BY Generation DESC

/*
    Question 2: 
        If they work for Hamilton Disposal Managers or Benton Engine Cleaning, label them "Messy"
        If they work for any company with 'Cheatham' in the title (LIKE '%Cheatham%') as "Suspect"
        Everyone else is "Probably Friendly"
*/

SELECT (
    CASE
        WHEN BusinessName IN ('Hamilton Disposal Managers', 'Benton Engine Cleaning')
        THEN 'Messy'
        WHEN BusinessName LIKE '%Cheatham%'
        THEN 'Suspect'
        ELSE 'Probably Friendly'
    END
) AS 'Character', COUNT(*) AS '# of Employees'
FROM tblCUSTOMER
GROUP BY(
    CASE
        WHEN BusinessName IN ('Hamilton Disposal Managers', 'Benton Engine Cleaning')
        THEN 'Messy'
        WHEN BusinessName LIKE '%Cheatham%'
        THEN 'Suspect'
        ELSE 'Probably Friendly'
    END
)
ORDER BY Character DESC

/* 
    Question 3:
    a.   If people live in Arkansas, Louisiana, Florida; label them as "Fanatical"
    b.   If people live in California, Washington, Montana, Utah; label them as "Somewhat passive"
    c.   If people live in North Carolina, South Carolina, Georgia; label them as "Intense"
    d.   If people live in Michigan, Illinois, Indiana; label them as "Academically Intrigued"
    e.   Everyone else should be labeled "Unknown"
*/

SELECT(
    CASE
        WHEN CustomerState IN ('Arkansas, AR', 'Louisiana, LA', 'Florida, FL')
        THEN 'Fanatical'
        WHEN CustomerState IN ('California, CA', 'Washington, WA', 'Montana, MT', 'Utah, UT')
        THEN 'Somewhat Passive'
        WHEN CustomerState IN ('North Carolina, NC', 'South Carolina, SC', 'Georgia, GA')
        THEN 'Intense'
        WHEN CustomerState IN ('Michigan, MI', 'Illinois, IL', 'Indiana, IN')
        THEN 'Academically Intrigued'
        ELSE 'Unknown'
    END
) AS 'Category', COUNT(*) AS 'Population'
FROM tblCUSTOMER
GROUP BY(
    CASE
        WHEN CustomerState IN ('Arkansas, AR', 'Louisiana, LA', 'Florida, FL')
        THEN 'Fanatical'
        WHEN CustomerState IN ('California, CA', 'Washington, WA', 'Montana, MT', 'Utah, UT')
        THEN 'Somewhat Passive'
        WHEN CustomerState IN ('North Carolina, NC', 'South Carolina, SC', 'Georgia, GA')
        THEN 'Intense'
        WHEN CustomerState IN ('Michigan, MI', 'Illinois, IL', 'Indiana, IN')
        THEN 'Academically Intrigued'
        ELSE 'Unknown'
    END
)



