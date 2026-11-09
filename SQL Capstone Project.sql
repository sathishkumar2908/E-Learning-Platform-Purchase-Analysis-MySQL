
-- PROJECT: E-LEARNING PLATFORM PURCHASE ANALYSIS
-- DATABASE: elearning_platform

-- 1. CREATE DATABASE
CREATE DATABASE elearning_platform;

USE elearning_platform;

-- 2. CREATE LEARNERS TABLE

CREATE TABLE learners (
    learner_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    Country VARCHAR(50)
);

-- 3. CREATE COURSES TABLE

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_price DECIMAL(10,2) NOT NULL
);

-- 4. CREATE PURCHASES TABLE

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    Quantity INT NOT NULL,
    purchase_date DATE,

    FOREIGN KEY (learner_id)
        REFERENCES learners(learner_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);


-- 5. INSERT LEARNER DATA

INSERT INTO learners
(learner_id, full_name, Country)
VALUES
(1, 'Sathishkumar', 'India'),
(2, 'Gideon prince', 'Russia'),
(3, 'John Smith', 'USA'),
(4, 'David Lee', 'UK'),
(5, 'Leo das', 'Singapore');


-- 6. INSERT COURSE DATA

INSERT INTO courses
(course_id, course_name, category, unit_price)
VALUES
(101, 'SQL for Beginners', 'Database', 1500.00),
(102, 'Python Programming', 'Programming', 2500.00),
(103, 'Power BI Dashboard', 'Data Analytics', 3000.00),
(104, 'Advanced Excel', 'Data Analytics', 2000.00),
(105, 'Java Programming', 'Programming', 3500.00);

-- 7. INSERT PURCHASE DATA

INSERT INTO purchases
(purchase_id, learner_id, course_id, Quantity, purchase_date)
VALUES
(1001, 1, 101, 1, '2026-01-10'),
(1002, 1, 103, 2, '2026-01-15'),
(1003, 2, 102, 1, '2026-02-05'),
(1004, 2, 104, 1, '2026-02-10'),
(1005, 3, 101, 2, '2026-02-15'),
(1006, 3, 103, 1, '2026-03-01'),
(1007, 4, 102, 2, '2026-03-05'),
(1008, 5, 104, 1, '2026-03-10');

-- 8. VERIFY TABLE DATA

SELECT * FROM learners;

SELECT * FROM courses;

SELECT * FROM purchases;


SELECT
    l.learner_id,
    l.full_name,
    l.Country,
    c.course_name,
    c.category,
    p.Quantity,
    FORMAT(p.Quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date

FROM learners AS l

INNER JOIN purchases AS p
    ON l.learner_id = p.learner_id

INNER JOIN courses AS c
    ON p.course_id = c.course_id

ORDER BY total_amount DESC;


-- Using Left join


SELECT
    l.learner_id,
    l.full_name,
    l.Country,
    c.course_name,
    c.category,
    p.Quantity,
    FORMAT(
        COALESCE(p.Quantity * c.unit_price, 0), 2
    ) AS total_amount,
    p.purchase_date

FROM learners AS l

LEFT JOIN purchases AS p
    ON l.learner_id = p.learner_id

LEFT JOIN courses AS c
    ON p.course_id = c.course_id

ORDER BY l.learner_id;

-- Using Right join


SELECT
    c.course_id,
    c.course_name,
    c.category,
    l.full_name,
    p.Quantity,
    FORMAT(
        COALESCE(p.Quantity * c.unit_price, 0), 2
    ) AS total_amount

FROM purchases AS p

RIGHT JOIN courses AS c
    ON p.course_id = c.course_id

LEFT JOIN learners AS l
    ON p.learner_id = l.learner_id

ORDER BY c.course_id;

-- each learner's total spending along with their country


SELECT
    l.learner_id,
    l.full_name,
    l.Country,

    FORMAT(
        COALESCE(SUM(p.Quantity * c.unit_price), 0),
        2
    ) AS total_spent

FROM learners AS l

LEFT JOIN purchases AS p
    ON l.learner_id = p.learner_id

LEFT JOIN courses AS c
    ON p.course_id = c.course_id

GROUP BY
    l.learner_id,
    l.full_name,
    l.Country

ORDER BY
    COALESCE(SUM(p.Quantity * c.unit_price), 0) DESC;
    
-- top 3 most purchased courses based on total quantity sold


SELECT
    c.course_id,
    c.course_name,
    c.category,
    SUM(p.Quantity) AS total_quantity_sold

FROM courses AS c

INNER JOIN purchases AS p
    ON c.course_id = p.course_id

GROUP BY
    c.course_id,
    c.course_name,
    c.category

ORDER BY
    total_quantity_sold DESC

LIMIT 3;

-- Show each course category's total revenue and number of unique learners


SELECT
    c.category,

    FORMAT(
        SUM(p.Quantity * c.unit_price), 2
    ) AS total_revenue,

    COUNT(DISTINCT p.learner_id)
        AS unique_learners


INNER JOIN purchases AS p
    ON c.course_id = p.course_id

GROUP BY
    c.category

ORDER BY
    SUM(p.Quantity * c.unit_price) DESC;
    
-- List learners who purchased courses from more than one category


SELECT
    l.learner_id,
    l.full_name,

    COUNT(DISTINCT c.category)
        AS total_categories

FROM learners AS l

INNER JOIN purchases AS p
    ON l.learner_id = p.learner_id

INNER JOIN courses AS c
    ON p.course_id = c.course_id

GROUP BY
    l.learner_id,
    l.full_name

HAVING COUNT(DISTINCT c.category) > 1;

-- Identify courses that have not been purchased at all.


SELECT
    c.course_id,
    c.course_name,
    c.category,
    FORMAT(c.unit_price, 2) AS unit_price

FROM courses AS c

LEFT JOIN purchases AS p
    ON c.course_id = p.course_id

WHERE p.purchase_id IS NULL;











