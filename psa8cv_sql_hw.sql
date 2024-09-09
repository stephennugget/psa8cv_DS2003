-- 1. 
SELECT NAME
FROM
    country
WHERE
    Continent = 'South America';

# 2. 
SELECT
    Population
FROM
    country
WHERE NAME
    = 'Germany';

-- 3.
SELECT
    city.Name
FROM
    city
JOIN country ON city.CountryCode = country.Code
WHERE
    country.Name = 'Japan';

-- 4.
SELECT NAME
    ,
    Population
FROM
    country
WHERE
    Continent = 'Africa'
ORDER BY
    Population
DESC
LIMIT 3;

-- 5.
SELECT NAME
    ,
    LifeExpectancy
FROM
    country
WHERE
    Population BETWEEN 1000000 AND 5000000;

-- 6.
SELECT DISTINCT
    country.Name
FROM
    country
JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE
    countrylanguage.Language = 'French' AND countrylanguage.IsOfficial = 'T';

-- 7.
SELECT
    Album.Title
FROM
    Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE
    Artist.Name = 'AC/DC';

-- 8.
SELECT
    FirstName,
    LastName,
    Email
FROM
    Customer
WHERE
    Country = 'Brazil';

-- 9.
SELECT NAME
FROM
    Playlist;

-- 10.
SELECT
    COUNT(*) AS Count
FROM
    Track
JOIN Genre ON Track.GenreId = Genre.GenreId
WHERE
    Genre.Name = 'Rock';

-- 11.
SELECT
    FirstName,
    LastName
FROM
    Employee
WHERE
    ReportsTo =(
    SELECT
        EmployeeId
    FROM
        Employee
    WHERE
        FirstName = 'Nancy' AND LastName = 'Edwards'
);

-- 12.
SELECT
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    SUM(Invoice.Total) AS TotalSales
FROM
    Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName  
ORDER BY `TotalSales` ASC


-- Part 2:

-- 1. Creating a database for a bookstore, with tables:
-- Books (BookID, Title, AuthorID, Price, PublicationYear)
-- Authors (AuthorID, FirstName, LastName, Nationality)
-- Sales (SaleID, BookID, SaleDate, Quantity)


-- 2. Create Tables

CREATE TABLE Authors(
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
); CREATE TABLE Books(
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    AuthorID INT,
    Price DECIMAL(10, 2) NOT NULL,
    PublicationYear INT,
    FOREIGN KEY(AuthorID) REFERENCES Authors(AuthorID)
); CREATE TABLE Sales(
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY(BookID) REFERENCES Books(BookID)
);


-- 3. Insert Data

INSERT INTO Authors(FirstName, LastName)
VALUES('George', 'Orwell'),
('Jane', 'Austen'),
('Haruki', 'Murakami'),
('Stephen', 'King'),
('Dr', 'Seuss');

INSERT INTO Books (Title, AuthorID, Price, PublicationYear) VALUES
('1984', 1, 9.99, 1949),
('Pride and Prejudice', 2, 7.99, 1813),
('Norwegian Wood', 3, 10.99, 1987),
('The Shining', 4, 12.99, 1977),
('The Lorax', 5, 6.99, 1971);

INSERT INTO Sales (BookID, SaleDate, Quantity) VALUES
(1, '2023-09-01', 3),
(2, '2023-09-02', 2),
(3, '2023-09-03', 1), 
(4, '2023-09-04', 4),
(5, '2023-09-05', 2);

-- 4. Data queries

-- query 1: Best selling books in the store and their author

SELECT
    b.Title,
    CONCAT(a.FirstName, ' ', a.LastName) AS Author,
    SUM(s.Quantity) AS TotalSold
FROM
    Books b
JOIN Authors a ON
    b.AuthorID = a.AuthorID
JOIN Sales s ON
    b.BookID = s.BookID
GROUP BY
    b.BookID,
    b.Title,
    Author
ORDER BY
    TotalSold
DESC
LIMIT 3;

-- query 2: Revenue from each book

SELECT
    b.Title,
    SUM(b.Price * s.Quantity) AS TotalRevenue
FROM
    Books b
JOIN Sales s ON
    b.BookID = s.BookID
GROUP BY
    b.BookID,
    b.Title
ORDER BY
    TotalRevenue
DESC
    ;

-- query 3: books and total # of sales

SELECT
    b.Title,
    COALESCE(SUM(s.Quantity),
    0) AS TotalSold
FROM
    Books b
LEFT JOIN Sales s ON
    b.BookID = s.BookID
GROUP BY
    b.BookID,
    b.Title
ORDER BY
    TotalSold
DESC
    ;
