-- Pengabungan Table yang sama menggunakan union
Create Table appleStore_description AS

SELECT * from appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALl 
SELECT * from appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4;

** EDA **

-- cek jumlah aplikasi di kedua table
SELECT COUNT(DISTINCT id) as UniqueAppId from AppleStore;
SELECT COUNT(DISTINCT id) as UniqueAppId from appleStore_description;


-- cek missing value
SELECT COUNT(*) as missing_value 
FROM AppleStore 
WHERE track_name is NULL or user_rating IS NULL or prime_genre is NULL;

SELECT COUNT(*) as missing_value 
FROM appleStore_description
WHERE track_name is NULL;

-- mencari genre atau kategori apa yang populer
SELECT prime_genre, COUNT(*) as jumlahApps
from AppleStore
GROUP by prime_genre
ORDER by jumlahApps DESC;

-- melihat rating aplikasi
SELECT min(user_rating) as minRating,
	   max(user_rating) as maxRating,
       avg(user_rating) as avgRating
from AppleStore


** DATA ANALYST **

-- menentukan apakah app berbayar memiliki rating lebih tinggi dari app gratis
SELECT case when price > 0 THEN 'Paid'
			ELSE 'Free'
       END as App_type, avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP by App_type;

-- mengecek rating yang memiliki bahasa banyak 
SELECT case when lang_num < 10 THEN '< 10 bahasa'
			when lang_num BETWEEN 10 and 30 THEN '10 - 30 bahasa'
            else '> 30 bahasa'
       END as Lang_bucket, avg(user_rating) as Avg_Rating
FROM AppleStore
GROUP by Lang_bucket ;

-- cek genre/kategori dengan rating rendah
SELECT prime_genre, avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
ORDER by Avg_Rating
LIMIT 10;
SELECT * from AppleStore;
SELECT * from appleStore_description;

-- cek apakah ada korelasi antara deskripsi dengan rating
SELECT case when length(b.app_desc) < 500 THEN 'Short'
			WHEN length(b.app_desc)BETWEEN 500 and 1000 THEN 'Medium'
            ELSE 'Long'
       end as description_length, avg(user_rating) as Avg_Rating
from AppleStore a
join appleStore_description b
on a.id = b.id
group by description_length;

-- cek top rank app berdasarkan genre
SELECT prime_genre, track_name, user_rating
FROM(
  SELECT prime_genre, 
  		 track_name, 
  		 user_rating,
  		 rank() over(partition by prime_genre ORDER by user_rating DESC, rating_count_tot DESC) AS rank
  from AppleStore) as a
where a.rank = 1;

