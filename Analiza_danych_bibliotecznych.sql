# Oblicz liczbę dni, przez które każda książka była wypożyczona – uwzględnij książki niezwrócone.

select 
	B.Title
	,sum(
		datediff(
			ifnull(BB.ReturnDate, curdate()),
			BB.BorrowDate
			)
		) as rental_days
from borrowedbooks as BB
left join books as B 
on BB.BookID = B.BookID
group by B.Title
order by rental_days desc 

# Znajdź wszystkich klientów, którzy dołączyli w ostatnich trzech miesiącach i posortuj według daty dołączenia.

select 
	FirstName
	,LastName
from members 
where JoinDate > "2024-11-08"
order by JoinDate desc 

# Pogrupuj książki według gatunku i oblicz całkowitą cenę książek w każdym gatunku.

select
	Genre
	,round(SUM(Price),2) as total_price
from books 
group by Genre
order by total_price desc 

# Znajdź liczbę książek wypożyczonych przez klientów każdej kategorii członkostwa – sprawdź, kto jest najbardziej aktywny, znajdź imiona i nazwiska top 10 osób.

select 
	M.MembershipType
	,Count(BB.borrowID) as number_of_borrowed_books
from members as M
left join borrowedbooks as BB
on M.MemberID = BB.MemberID
group by M.MembershipType

select 
	concat( M.FirstName, ' ' ,M.LastName) as FullName
	,COALESCE(COUNT(BB.borrowID), 0)  as NumberOfBorrowedBooks
from members as M
left join borrowedbooks as BB
on M.MemberID = BB.MemberID
group by FullName
order by NumberOfBorrowedBooks desc 
limit 10


# Wylistuj wszystkie książki wraz z imieniem i nazwiskiem klienta, który je wypożyczył 

select 
	B.Title
	,Concat(M.FirstName, " ", M.LastName) as FullName
from borrowedbooks as BB
left join members as M 
on BB.MemberID = M.MemberID
left join books as B 
on BB.BookID = B.BookID
order by B.Title


# Znajdź klientów, którzy nie zwrócili książek

select distinct(concat(M.FirstName, " ", M.LastName))
from members as M
left join borrowedbooks as BB
on M.MemberID = BB.MemberID
where BB.ReturnDate is null 


# Użyj CTE, aby znaleźć całkowitą liczbę książek wypożyczonych przez każdego członka, i przefiltruj klientów, którzy wypożyczyli mniej niż 3 książki.


WITH TotalBorrowedBooks AS (
    SELECT 
		concat(M.FirstName, " ", M.LastName) as FullName
		,count(BB.BookID) as NumberOfBooks
    FROM members as M
    left join borrowedbooks as BB
    on M.MemberID = BB.MemberID
    group by FullName
)
SELECT *
FROM TotalBorrowedBooks
WHERE NumberOfBooks < 3
order by NumberOfBooks desc 

# Dodaj kolumnę klasyfikującą książki według ceny: "Niska" (Price < 10), "Średnia" (10 ≤ Price < 30). "Wysoka" (Price ≥ 30)


select 
	Title
	,case 
		when Price < 10 then 'Low'
		when Price >= 10 and Price < 30 then 'Middle'
		when Price >=30 then 'High'
	end as Rating
from books
	

# Utwórz raport klasyfikujący klientów: "Nowi" – jeśli dołączyli w ciągu ostatniego roku. "Stali"

select
	FirstName
	,LastName
	,case 
		when JoinDate > curdate() - interval 1 year then 'Nowi'
		else 'Stali'
	end as Status 
from members 
	

# Znajdź klientów, którzy regularnie wypożyczają książki – np. co najmniej raz na dwa miesiące.



# Wykryj książki, które zalegają najdłużej oraz posortuj według liczby dni od wypożyczenia.


WITH BooksNotReturned AS (
    SELECT 
		BookID
		,sum(
			datediff(
				ifnull(ReturnDate, curdate()),
				BorrowDate	
				) 
			) as RentalDays
				
    FROM borrowedbooks 
    where ReturnDate is null
    group by BookID
)
select
	B.Title
	,BNR.RentalDays
FROM BooksNotReturned as BNR
left join books as B 
on BNR.BookID = B.BookID
order by BNR.RentalDays desc 


# Zidentyfikuj klientów, którzy wypożyczali książki przez minimum 3 kolejne miesiace ostatniego roku.






