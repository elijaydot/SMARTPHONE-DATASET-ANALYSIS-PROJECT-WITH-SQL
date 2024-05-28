--	creating a backup

SELECT *
INTO dbo.smartphone_backup
FROM dbo.smartphone;

-- handling missing values 
SELECT 
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS Missing_model,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS Missing_price,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS Missing_rating,
    SUM(CASE WHEN has_5g IS NULL THEN 1 ELSE 0 END) AS Missing_has_5g,
    SUM(CASE WHEN has_nfc IS NULL THEN 1 ELSE 0 END) AS Missing_has_nfc,
    SUM(CASE WHEN has_ir_blaster IS NULL THEN 1 ELSE 0 END) AS Missing_has_ir_blaster,
    SUM(CASE WHEN processor_name IS NULL THEN 1 ELSE 0 END) AS Missing_processor_name,
    SUM(CASE WHEN processor_brand IS NULL THEN 1 ELSE 0 END) AS Missing_processor_brand,
    SUM(CASE WHEN num_cores IS NULL THEN 1 ELSE 0 END) AS Missing_num_cores,
    SUM(CASE WHEN processor_speed IS NULL THEN 1 ELSE 0 END) AS Missing_processor_speed,
    SUM(CASE WHEN battery_capacity IS NULL THEN 1 ELSE 0 END) AS Missing_battery_capacity,
    SUM(CASE WHEN fast_charging IS NULL THEN 1 ELSE 0 END) AS Missing_fast_charging,
	SUM(CASE WHEN ram_capacity IS NULL THEN 1 ELSE 0 END) AS Missing_ram_capacity,
SUM(CASE WHEN internal_memory IS NULL THEN 1 ELSE 0 END) AS Missing_internal_memory,
SUM(CASE WHEN refresh_rate IS NULL THEN 1 ELSE 0 END) AS Missing_refresh_rate,
SUM(CASE WHEN resolution IS NULL THEN 1 ELSE 0 END) AS Missing_resolution,
SUM(CASE WHEN num_rear_cameras IS NULL THEN 1 ELSE 0 END) AS Missing_num_rear_cameras,
SUM(CASE WHEN num_front_cameras IS NULL THEN 1 ELSE 0 END) AS Missing_num_front_cameras,
SUM(CASE WHEN os IS NULL THEN 1 ELSE 0 END) AS Missing_os,
SUM(CASE WHEN primary_camera_rear IS NULL THEN 1 ELSE 0 END) AS Missing_primary_camera_rear,
SUM(CASE WHEN primary_camera_front IS NULL THEN 1 ELSE 0 END) AS Missing_primary_camera_front,
SUM(CASE WHEN extended_memory IS NULL THEN 1 ELSE 0 END) AS Missing_extended_memory
FROM [SmartPhones].[dbo].[smartphone]

/*

Missing_model: 0
Missing_price: 0
Missing_rating: 102
Missing_has_5g: 0
Missing_has_nfc: 0
Missing_has_ir_blaster: 0
Missing_processor_name: 20
Missing_processor_brand: 20
Missing_num_cores: 7
Missing_processor_speed: 43
Missing_battery_capacity: 12
Missing_fast_charging: 0
Missing_ram_capacity: 0
Missing_internal_memory: 2
Missing_refresh_rate: 0
Missing_resolution: 1
Missing_num_rear_cameras: 0
Missing_num_front_cameras: 0
Missing_os: 34
Missing_primary_camera_rear: 0
Missing_primary_camera_front: 5
Missing_extended_memory: 0


Total Records: 980
*/

-- handling Missing_rating: 102
-- Calculate the average rating from non-null values
DECLARE @avg_rating FLOAT;
SELECT @avg_rating = ROUND(AVG(CAST(rating AS FLOAT)), 0)
FROM dbo.smartphone
WHERE rating IS NOT NULL;

-- Print the calculated and rounded average rating
SELECT @avg_rating AS 'Rounded Average Rating';
/*
Rounded Average Rating
78
*/

-- select * from [dbo].[smartphone]

-- Update the missing rating values with the rounded average rating
UPDATE dbo.smartphone
SET rating = @avg_rating
WHERE rating IS NULL;


-- handling Missing_processor_name: 20
-- Create a new category "Unknown" for missing processor_name
UPDATE dbo.smartphone
SET processor_name = 'Unknown'
WHERE processor_name IS NULL;


-- handling Missing_processor_brand: 20
-- Create a new category "Unknown" for missing processor_brand
UPDATE dbo.smartphone
SET processor_brand = 'Unknown'
WHERE processor_brand IS NULL;

-- handling Missing_num_cores: 7
-- Get the mode (most frequent value) of num_cores
DECLARE @mode_num_cores NVARCHAR(50);
WITH cte AS (
    SELECT num_cores, COUNT(*) AS cnt
    FROM dbo.smartphone
    WHERE num_cores IS NOT NULL
    GROUP BY num_cores
)
SELECT @mode_num_cores = num_cores
FROM cte
WHERE cnt = (SELECT MAX(cnt) FROM cte);

-- Print the mode num_cores value
SELECT @mode_num_cores AS 'Mode Num Cores';
/*
Mode Num Cores
Octa Core
*/

-- Update the missing num_cores with the mode value
UPDATE dbo.smartphone
SET num_cores = @mode_num_cores
WHERE num_cores IS NULL;


-- handling Missing_processor_speed: 43
-- Calculate the mean processor_speed from non-null values
DECLARE @mean_processor_speed FLOAT;
SELECT @mean_processor_speed = AVG(CAST(processor_speed AS FLOAT))
FROM dbo.smartphone
WHERE processor_speed IS NOT NULL;

-- Print the mean processor_speed value
SELECT @mean_processor_speed AS 'Mean Processor Speed';
/*
Mean Processor Speed
2.4263927535797
*/

-- Update the missing processor_speed with the mean value
UPDATE dbo.smartphone
SET processor_speed = @mean_processor_speed
WHERE processor_speed IS NULL;

-- handling Missing_battery_capacity: 12
-- Calculate the median battery_capacity from non-null values
DECLARE @median_battery_capacity FLOAT;
WITH cte AS (
    SELECT CAST(battery_capacity AS FLOAT) AS battery_capacity
    FROM dbo.smartphone
    WHERE battery_capacity IS NOT NULL
)
SELECT @median_battery_capacity = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY battery_capacity) OVER ()
FROM cte;

-- Print the median battery_capacity value
SELECT @median_battery_capacity AS 'Median Battery Capacity'; 
/*
Median Battery Capacity
5000
*/

-- Update the missing battery_capacity with the median value
UPDATE dbo.smartphone
SET battery_capacity = @median_battery_capacity
WHERE battery_capacity IS NULL;

-- handling Missing_internal_memory: 2
-- Get the mode (most frequent value) of internal_memory
DECLARE @mode_internal_memory FLOAT;
WITH cte AS (
    SELECT CAST(internal_memory AS FLOAT) AS internal_memory, COUNT(*) AS cnt
    FROM dbo.smartphone
    WHERE internal_memory IS NOT NULL
    GROUP BY CAST(internal_memory AS FLOAT)
)
SELECT @mode_internal_memory = internal_memory
FROM cte
WHERE cnt = (SELECT MAX(cnt) FROM cte);

-- Print the mode internal_memory value
SELECT @mode_internal_memory AS 'Mode Internal Memory';
/*
Mode Internal Memory
128
*/

-- Update the missing internal_memory with the mode value
UPDATE dbo.smartphone
SET internal_memory = @mode_internal_memory
WHERE internal_memory IS NULL;

-- handling Missing_resolution: 1
-- Get the mode (most frequent value) of resolution
DECLARE @mode_resolution NVARCHAR(50);
WITH cte AS (
    SELECT resolution, COUNT(*) AS cnt
    FROM dbo.smartphone
    WHERE resolution IS NOT NULL
    GROUP BY resolution
)
SELECT @mode_resolution = resolution
FROM cte
WHERE cnt = (SELECT MAX(cnt) FROM cte);

-- Print the mode resolution value
SELECT @mode_resolution AS 'Mode Resolution';
/*
Mode Resolution
1080 x 2400 
*/

-- Update the missing resolution with the mode value
UPDATE dbo.smartphone
SET resolution = @mode_resolution
WHERE resolution IS NULL;

-- handling Missing_os: 34
-- Get the mode (most frequent value) of os
DECLARE @mode_os NVARCHAR(50);
WITH cte AS (
    SELECT os, COUNT(*) AS cnt
    FROM dbo.smartphone
    WHERE os IS NOT NULL
    GROUP BY os
)
SELECT @mode_os = os
FROM cte
WHERE cnt = (SELECT MAX(cnt) FROM cte);

-- Print the mode os value
SELECT @mode_os AS 'Mode OS';
/*
Mode OS
android
*/

-- Update the missing os with the mode value
UPDATE dbo.smartphone
SET os = @mode_os
WHERE os IS NULL;

-- handling Missing_primary_camera_front: 5
-- Get the mode (most frequent value) of primary_camera_front
DECLARE @mode_primary_camera_front NVARCHAR(10);
WITH cte AS (
    SELECT primary_camera_front, COUNT(*) AS cnt
    FROM dbo.smartphone
    WHERE primary_camera_front IS NOT NULL
    GROUP BY primary_camera_front
)
SELECT @mode_primary_camera_front = primary_camera_front
FROM cte
WHERE cnt = (SELECT MAX(cnt) FROM cte);

-- Print the mode primary_camera_front value
SELECT @mode_primary_camera_front AS 'Mode Primary Camera Front';

/*
Mode Primary Camera Front
16
*/

-- Update the missing primary_camera_front with the mode value
UPDATE dbo.smartphone
SET primary_camera_front = @mode_primary_camera_front
WHERE primary_camera_front IS NULL;



/*
DATA ANALYSIS PROPOSED QUESTIONS

I suggest we count the number of smartphones by brand

1. Average price of smart phones by brand

2. Max and minimum battery capacity of smartphones by brand

3. Number of smartphones supporting 5G and having g NFC capability

4. Average primary rear camera resolution for smartphones with more than 2 rear camera

5. How do smartphones ratings correlater with price, brand or camera quality

6. Is there a correlation between processor specifications and smartphone price

7. Do smartphones with larger batteries have higher ratings

8. What is the correlation between operating systems and price and ratings

9. Is there a correlation between fast charging and other features like price and rating

10. Is there a correlation between Internal memory and other features like price and rating

11. Comparison between phone model and price and rating
*/


-- 1. Average price of smartphones by brand:
SELECT brand_name, AVG(CAST(price AS FLOAT)) AS 'Average Price'
FROM dbo.smartphone
GROUP BY brand_name
ORDER BY 'Average Price' DESC;

-- 2. Max and minimum battery capacity of smartphones by brand:
SELECT brand_name,
       MAX(battery_capacity) AS 'Max Battery Capacity',
       MIN(battery_capacity) AS 'Min Battery Capacity'
FROM dbo.smartphone
GROUP BY brand_name
ORDER BY 'Max Battery Capacity' DESC;

-- 3. Number of smartphones supporting 5G and having NFC capability:
SELECT COUNT(*) AS 'Number of Smartphones'
FROM dbo.smartphone
WHERE has_5g = 1 AND has_nfc = 1;

-- 4. Average primary rear camera resolution for smartphones with more than 2 rear cameras:
SELECT ROUND(AVG(CAST(rating AS FLOAT)), 2) AS 'Avg Primary Rear Camera'
FROM dbo.smartphone
WHERE num_rear_cameras > 2;

-- 5. Correlation between smartphone ratings and price, brand, or camera quality:
-- 5a. Correlation between smartphone ratings and price calculate the correlation coefficient manually
WITH cte AS (
    SELECT 
        rating,
        price,
        (rating - (SELECT AVG(CAST(rating AS FLOAT)) FROM dbo.smartphone)) AS rating_deviation,
        (price - (SELECT AVG(CAST(price AS FLOAT)) FROM dbo.smartphone)) AS price_deviation
    FROM dbo.smartphone
)
SELECT
    SUM(rating_deviation * price_deviation) /
    (
        SQRT(SUM(POWER(rating_deviation, 2))) *
        SQRT(SUM(POWER(price_deviation, 2)))
    ) AS 'Rating vs Price Correlation'
FROM cte;

-- 5b.  Correlation with brand
-- Correlation between smartphone ratings and brand calculate the correlation coefficient manually
DECLARE @avgRating FLOAT;
DECLARE @avgBrandValue FLOAT;

SELECT @avgRating = AVG(CAST(rating AS FLOAT)) FROM dbo.smartphone;
SELECT @avgBrandValue = AVG(CASE brand_name
    WHEN 'vertu' THEN 1
	WHEN 'royole' THEN 2
	WHEN 'leitz' THEN 3
	WHEN 'apple' THEN 4
	WHEN 'huawei' THEN 5
	WHEN 'asus' THEN 6
	WHEN 'tesla' THEN 7
	WHEN 'lg' THEN 8
	WHEN 'sony' THEN 9
	WHEN 'sharp' THEN 10
	WHEN 'lenovo' THEN 11
	WHEN 'nubia' THEN 12
	WHEN 'google' THEN 13
	WHEN 'zte' THEN 14
	WHEN 'samsung' THEN 15
	WHEN 'oneplus' THEN 16
	WHEN 'nothing' THEN 17
	WHEN 'doogee' THEN 18
	WHEN 'iqoo' THEN 19
	WHEN 'honor' THEN 20
	WHEN 'oppo' THEN 21
	WHEN 'xiaomi' THEN 22
	WHEN 'vivo' THEN 23
	WHEN 'oukitel' THEN 24
	WHEN 'motorola' THEN 25
	WHEN 'nokia' THEN 26
	WHEN 'poco' THEN 27
	WHEN 'realme' THEN 28
	WHEN 'redmi' THEN 29
	WHEN 'cat' THEN 30
	WHEN 'cola' THEN 31
	WHEN 'blu' THEN 32
	WHEN 'infinix' THEN 33
	WHEN 'tecno' THEN 34
	WHEN 'lava' THEN 35
	WHEN 'leeco' THEN 36
	WHEN 'duoqin' THEN 37
	WHEN 'tcl' THEN 38
	WHEN 'blackview' THEN 39
	WHEN 'ikall' THEN 40
	WHEN 'jio' THEN 41
	WHEN 'micromax' THEN 42
	WHEN 'gionee' THEN 43
	WHEN 'letv' THEN 44
	WHEN 'itel' THEN 45
	WHEN 'lyf' THEN 46
	ELSE 0
END) FROM dbo.smartphone;

SELECT
    (
        SUM((rating - @avgRating) * (brand_value - @avgBrandValue)) /
        SQRT(SUM(POWER(rating - @avgRating, 2)) * SUM(POWER(brand_value - @avgBrandValue, 2)))
    ) AS 'Rating vs Brand Correlation'
FROM
    (
        SELECT
            rating,
            CASE brand_name
                WHEN 'vertu' THEN 1
				WHEN 'royole' THEN 2
				WHEN 'leitz' THEN 3
				WHEN 'apple' THEN 4
				WHEN 'huawei' THEN 5
				WHEN 'asus' THEN 6
				WHEN 'tesla' THEN 7
				WHEN 'lg' THEN 8
				WHEN 'sony' THEN 9
				WHEN 'sharp' THEN 10
				WHEN 'lenovo' THEN 11
				WHEN 'nubia' THEN 12
				WHEN 'google' THEN 13
				WHEN 'zte' THEN 14
				WHEN 'samsung' THEN 15
				WHEN 'oneplus' THEN 16
				WHEN 'nothing' THEN 17
				WHEN 'doogee' THEN 18
				WHEN 'iqoo' THEN 19
				WHEN 'honor' THEN 20
				WHEN 'oppo' THEN 21
				WHEN 'xiaomi' THEN 22
				WHEN 'vivo' THEN 23
				WHEN 'oukitel' THEN 24
				WHEN 'motorola' THEN 25
				WHEN 'nokia' THEN 26
				WHEN 'poco' THEN 27
				WHEN 'realme' THEN 28
				WHEN 'redmi' THEN 29
				WHEN 'cat' THEN 30
				WHEN 'cola' THEN 31
				WHEN 'blu' THEN 32
				WHEN 'infinix' THEN 33
				WHEN 'tecno' THEN 34
				WHEN 'lava' THEN 35
				WHEN 'leeco' THEN 36
				WHEN 'duoqin' THEN 37
				WHEN 'tcl' THEN 38
				WHEN 'blackview' THEN 39
				WHEN 'ikall' THEN 40
				WHEN 'jio' THEN 41
				WHEN 'micromax' THEN 42
				WHEN 'gionee' THEN 43
				WHEN 'letv' THEN 44
				WHEN 'itel' THEN 45
				WHEN 'lyf' THEN 46
				ELSE 0
            END AS brand_value
        FROM dbo.smartphone
    ) AS avg_values;


/*
while trying to working on comparison between smartphone ratings and primary rear camera resolution 
it was discovered that the primary_camera_rear has a text values somewhere.
*/

SELECT primary_camera_rear
FROM SmartPhone
WHERE ISNUMERIC(primary_camera_rear) = 0;
/*
primary_camera_rear
Kaios
*/

SELECT primary_camera_rear
FROM SmartPhone
WHERE ISNUMERIC(primary_camera_rear) = 0;

select * FROM SmartPhone 
where primary_camera_rear = 'Kaios'

-- find the mode of the primary_camera_rear
SELECT
    primary_camera_rear,
    COUNT(*) AS count
FROM
    dbo.smartphone
GROUP BY
    primary_camera_rear
HAVING
    COUNT(*) = (
        SELECT
            MAX(count_values)
        FROM
            (
                SELECT
                    COUNT(*) AS count_values
                FROM
                    dbo.smartphone
                GROUP BY
                    primary_camera_rear
            ) AS temp
    );

-- replacing Kaios with 50 which is the mode
UPDATE SmartPhone
SET primary_camera_rear = 50
WHERE primary_camera_rear = 'Kaios';


-- Convert column from nvarchar to float (but nor required anymore since i will be using CAST in my next correlation)
-- ALTER TABLE SmartPhone ALTER COLUMN primary_camera_rear FLOAT;

-- 5c. Correlation between smartphone ratings and primary rear camera resolution calculate the correlation coefficient manually
-- Calculate the correlation coefficient manually
DECLARE @avgRating FLOAT;
DECLARE @avgCameraResolution FLOAT;

-- Calculate the average rating
SELECT @avgRating = AVG(CAST(rating AS FLOAT)) FROM dbo.smartphone;

-- Calculate the average primary rear camera resolution
SELECT @avgCameraResolution = AVG(CAST(primary_camera_rear AS FLOAT)) FROM dbo.smartphone;

-- Calculate the correlation coefficient
SELECT
    (
        SUM((rating - @avgRating) * (primary_camera_rear - @avgCameraResolution)) /
        SQRT(SUM(POWER(rating - @avgRating, 2)) * SUM(POWER(primary_camera_rear - @avgCameraResolution, 2)))
    ) AS 'Rating vs Primary Rear Camera Resolution Correlation'
FROM
    dbo.smartphone;

-- 6a. calculate summary statistics such as average price for each combination of processor specifications
SELECT 
    processor_brand,
    processor_name,
    num_cores,
    AVG(price) AS avg_price
FROM 
    smartphone
GROUP BY 
    processor_brand,
    processor_name,
    num_cores;


-- 6b. the correlation between processor specifications and smartphone prices
/*
here is the approach
Calculate the mean of each variable (processor specifications and price).
Calculate the covariance between each variable pair.
Calculate the standard deviation of each variable.
Use the covariance and standard deviations to compute the correlation coefficient.
*/
-- Calculate the mean of price
DECLARE @avg_price FLOAT;
SELECT @avg_price = AVG(price) FROM smartphone;

-- Calculate the mean of processor speed
DECLARE @avg_processor_speed FLOAT;
SELECT @avg_processor_speed = AVG(processor_speed) FROM smartphone;

-- Calculate the covariance between price and processor speed
DECLARE @covariance FLOAT;
SELECT @covariance = SUM((price - @avg_price) * (processor_speed - @avg_processor_speed)) / COUNT(*) 
FROM smartphone;

-- Calculate the standard deviation of price
DECLARE @stddev_price FLOAT;
SELECT @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*))
FROM smartphone;

-- Calculate the standard deviation of processor speed
DECLARE @stddev_processor_speed FLOAT;
SELECT @stddev_processor_speed = SQRT(SUM(POWER(processor_speed - @avg_processor_speed, 2)) / COUNT(*))
FROM smartphone;

-- Calculate the correlation coefficient
DECLARE @correlation FLOAT;
SET @correlation = @covariance / (@stddev_price * @stddev_processor_speed);

-- Display the correlation coefficient
SELECT @correlation AS 'processor specifications Vs smartphone prices';



-- 7 Correlation between battery capacity and smartphone ratings
-- Step 1: Calculate the mean of battery capacity and smartphone ratings
DECLARE @avg_battery_capacity FLOAT;
DECLARE @avg_rating FLOAT;

SELECT 
    @avg_battery_capacity = AVG(battery_capacity),
    @avg_rating = AVG(rating)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between battery capacity and smartphone ratings
DECLARE @covariance FLOAT;

SELECT 
    @covariance = SUM((battery_capacity - @avg_battery_capacity) * (rating - @avg_rating)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of battery capacity and smartphone ratings
DECLARE @stddev_battery_capacity FLOAT;
DECLARE @stddev_rating FLOAT;

SELECT 
    @stddev_battery_capacity = SQRT(SUM(POWER(battery_capacity - @avg_battery_capacity, 2)) / COUNT(*)),
    @stddev_rating = SQRT(SUM(POWER(rating - @avg_rating, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient
DECLARE @correlation FLOAT;
SET @correlation = @covariance / (@stddev_battery_capacity * @stddev_rating);

-- Display the correlation coefficient
SELECT @correlation AS 'battery capacity VS smartphone ratings';

-- 8a. Correlation between operating systems and price and ratings
/*
Here's the approach:
Calculate the mean of each variable (price, ratings).
Calculate the covariance between each variable pair (price and ratings).
Calculate the standard deviation of each variable.
Use the covariance and standard deviations to compute the correlation coefficient.
*/
-- Step 1: Calculate the mean of price and ratings
DECLARE @avg_price FLOAT;
DECLARE @avg_rating FLOAT;

SELECT 
    @avg_price = AVG(price),
    @avg_rating = AVG(rating)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between price and ratings for each operating system
DECLARE @covariance_price_rating FLOAT;

SELECT 
    @covariance_price_rating = SUM((price - @avg_price) * (rating - @avg_rating)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of price and ratings
DECLARE @stddev_price FLOAT;
DECLARE @stddev_rating FLOAT;

SELECT 
    @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*)),
    @stddev_rating = SQRT(SUM(POWER(rating - @avg_rating, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient for each operating system
SELECT 
    os,
    SUM((price - @avg_price) * (rating - @avg_rating)) / (COUNT(*) * @stddev_price * @stddev_rating) AS 'operating systems VS price and ratings'
FROM 
    smartphone
GROUP BY 
    os;


-- 8b. Correlation between operating systems and price
-- Step 1: Calculate the mean of price
DECLARE @avg_price FLOAT;

SELECT @avg_price = AVG(price)
FROM smartphone;

-- Step 2: Calculate the covariance between price and operating systems
DECLARE @covariance_price_os FLOAT;

SELECT @covariance_price_os = SUM((price - @avg_price) * 
    CASE 
        WHEN UPPER(os) = 'ANDROID' THEN 1
        WHEN UPPER(os) = 'IOS' THEN 2
        ELSE 0 -- Assigning 0 to other operating systems
    END) / COUNT(*) 
FROM smartphone;

-- Step 3: Calculate the standard deviation of price
DECLARE @stddev_price FLOAT;

SELECT @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*))
FROM smartphone;

-- Step 4: Calculate the correlation coefficient between price and operating systems
DECLARE @correlation_price_os FLOAT;
SET @correlation_price_os = @covariance_price_os / @stddev_price;

-- Display the correlation coefficient
SELECT @correlation_price_os AS 'operating systems VS price';

-- 8c Correlation between operating systems and ratings
-- Step 1: Calculate the mean of ratings
DECLARE @avg_rating FLOAT;

SELECT @avg_rating = AVG(rating)
FROM smartphone;

-- Step 2: Calculate the covariance between ratings and operating systems
DECLARE @covariance_rating_os FLOAT;

SELECT @covariance_rating_os = SUM((rating - @avg_rating) * 
    CASE 
        WHEN UPPER(os) = 'ANDROID' THEN 1
        WHEN UPPER(os) = 'IOS' THEN 2
        ELSE 0 -- Assigning 0 to other operating systems
    END) / COUNT(*) 
FROM smartphone;

-- Step 3: Calculate the standard deviation of ratings
DECLARE @stddev_rating FLOAT;

SELECT @stddev_rating = SQRT(SUM(POWER(rating - @avg_rating, 2)) / COUNT(*))
FROM smartphone;

-- Step 4: Calculate the correlation coefficient between ratings and operating systems
DECLARE @correlation_rating_os FLOAT;
SET @correlation_rating_os = @covariance_rating_os / @stddev_rating;

-- Display the correlation coefficient
SELECT @correlation_rating_os AS 'operating systems VS rating';



SELECT COUNT(*) FROM smartphone
WHERE UPPER(os) NOT IN ('ANDROID', 'IOS');
-- there are 203 records that are not Android or iOS

-- 9a. Correlation between fast charging and price and ratings:
-- Step 1: Calculate the mean of price and ratings
DECLARE @avg_price FLOAT;
DECLARE @avg_rating FLOAT;

SELECT 
    @avg_price = AVG(price),
    @avg_rating = AVG(rating)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between fast charging and price
DECLARE @covariance_price_fc FLOAT;

SELECT 
    @covariance_price_fc = SUM((price - @avg_price) * (fast_charging - @avg_rating)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of price and fast charging
DECLARE @stddev_price FLOAT;
DECLARE @stddev_fc FLOAT;

SELECT 
    @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*)),
    @stddev_fc = SQRT(SUM(POWER(fast_charging - @avg_rating, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between price and fast charging
DECLARE @correlation_price_fc FLOAT;
SET @correlation_price_fc = @covariance_price_fc / (@stddev_price * @stddev_fc);

-- Display the correlation coefficient
SELECT @correlation_price_fc AS 'fast charging VS price and ratings';


-- 9b. Correlation between fast charging and price
-- Step 1: Calculate the mean of price and fast charging
DECLARE @avg_price FLOAT;
DECLARE @avg_fast_charging FLOAT;

SELECT 
    @avg_price = AVG(price),
    @avg_fast_charging = AVG(fast_charging)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between price and fast charging
DECLARE @covariance_price_fast_charging FLOAT;

SELECT 
    @covariance_price_fast_charging = SUM((price - @avg_price) * (fast_charging - @avg_fast_charging)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of price and fast charging
DECLARE @stddev_price FLOAT;
DECLARE @stddev_fast_charging FLOAT;

SELECT 
    @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*)),
    @stddev_fast_charging = SQRT(SUM(POWER(fast_charging - @avg_fast_charging, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between price and fast charging
DECLARE @correlation_price_fast_charging FLOAT;
SET @correlation_price_fast_charging = @covariance_price_fast_charging / (@stddev_price * @stddev_fast_charging);

-- Display the correlation coefficient
SELECT @correlation_price_fast_charging AS 'price VS fast charging';


-- 9c. Correlation between fast charging and rating
-- Step 1: Calculate the mean of ratings and fast charging
DECLARE @avg_rating FLOAT;
DECLARE @avg_fast_charging FLOAT;

SELECT 
    @avg_rating = AVG(rating),
    @avg_fast_charging = AVG(fast_charging)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between ratings and fast charging
DECLARE @covariance_rating_fast_charging FLOAT;

SELECT 
    @covariance_rating_fast_charging = SUM((rating - @avg_rating) * (fast_charging - @avg_fast_charging)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of ratings and fast charging
DECLARE @stddev_rating FLOAT;
DECLARE @stddev_fast_charging FLOAT;

SELECT 
    @stddev_rating = SQRT(SUM(POWER(rating - @avg_rating, 2)) / COUNT(*)),
    @stddev_fast_charging = SQRT(SUM(POWER(fast_charging - @avg_fast_charging, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between ratings and fast charging
DECLARE @correlation_rating_fast_charging FLOAT;
SET @correlation_rating_fast_charging = @covariance_rating_fast_charging / (@stddev_rating * @stddev_fast_charging);

-- Display the correlation coefficient
SELECT @correlation_rating_fast_charging AS 'rating VS fast charging';



-- 10a. Correlation between internal memory and price and ratings:
-- Step 1: Calculate the mean of price and ratings
DECLARE @avg_price FLOAT;
DECLARE @avg_rating FLOAT;

SELECT 
    @avg_price = AVG(price),
    @avg_rating = AVG(rating)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between internal memory and price
DECLARE @covariance_price_memory FLOAT;

SELECT 
    @covariance_price_memory = SUM((price - @avg_price) * (internal_memory - @avg_rating)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of price and internal memory
DECLARE @stddev_price FLOAT;
DECLARE @stddev_memory FLOAT;

SELECT 
    @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*)),
    @stddev_memory = SQRT(SUM(POWER(internal_memory - @avg_rating, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between price and internal memory
DECLARE @correlation_price_memory FLOAT;
SET @correlation_price_memory = @covariance_price_memory / (@stddev_price * @stddev_memory);

-- Display the correlation coefficient
SELECT @correlation_price_memory AS 'internal memory VS price and ratings';


-- 10b. Correlation between internal memory and price
-- Step 1: Calculate the mean of price and internal memory
DECLARE @avg_price FLOAT;
DECLARE @avg_internal_memory FLOAT;

SELECT 
    @avg_price = AVG(price),
    @avg_internal_memory = AVG(internal_memory)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between price and internal memory
DECLARE @covariance_price_internal_memory FLOAT;

SELECT 
    @covariance_price_internal_memory = SUM((price - @avg_price) * (internal_memory - @avg_internal_memory)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of price and internal memory
DECLARE @stddev_price FLOAT;
DECLARE @stddev_internal_memory FLOAT;

SELECT 
    @stddev_price = SQRT(SUM(POWER(price - @avg_price, 2)) / COUNT(*)),
    @stddev_internal_memory = SQRT(SUM(POWER(internal_memory - @avg_internal_memory, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between price and internal memory
DECLARE @correlation_price_internal_memory FLOAT;
SET @correlation_price_internal_memory = @covariance_price_internal_memory / (@stddev_price * @stddev_internal_memory);

-- Display the correlation coefficient
SELECT @correlation_price_internal_memory AS 'internal memory VS price';


-- 10c. Correlation between internal memory and ratings
-- Step 1: Calculate the mean of ratings and internal memory
DECLARE @avg_rating FLOAT;
DECLARE @avg_internal_memory FLOAT;

SELECT 
    @avg_rating = AVG(rating),
    @avg_internal_memory = AVG(internal_memory)
FROM 
    smartphone;

-- Step 2: Calculate the covariance between ratings and internal memory
DECLARE @covariance_rating_internal_memory FLOAT;

SELECT 
    @covariance_rating_internal_memory = SUM((rating - @avg_rating) * (internal_memory - @avg_internal_memory)) / COUNT(*) 
FROM 
    smartphone;

-- Step 3: Calculate the standard deviation of ratings and internal memory
DECLARE @stddev_rating FLOAT;
DECLARE @stddev_internal_memory FLOAT;

SELECT 
    @stddev_rating = SQRT(SUM(POWER(rating - @avg_rating, 2)) / COUNT(*)),
    @stddev_internal_memory = SQRT(SUM(POWER(internal_memory - @avg_internal_memory, 2)) / COUNT(*))
FROM 
    smartphone;

-- Step 4: Calculate the correlation coefficient between ratings and internal memory
DECLARE @correlation_rating_internal_memory FLOAT;
SET @correlation_rating_internal_memory = @covariance_rating_internal_memory / (@stddev_rating * @stddev_internal_memory);

-- Display the correlation coefficient
SELECT @correlation_rating_internal_memory AS 'internal memory VS ratings';



-- 11. Comparison between phone model and price and ratings:
-- Calculate the average price and ratings for each phone model
SELECT 
    model,
    AVG(price) AS avg_price,
    AVG(rating) AS avg_rating
FROM 
    smartphone
GROUP BY 
    model
ORDER BY avg_rating DESC;

-- 12. Data Retrieval:
-- Retrieve all smartphone models from the 'Apple' brand with their prices and ratings
SELECT brand_name,model, price, rating
FROM dbo.smartphone
WHERE brand_name = 'Apple'
ORDER BY rating DESC;

-- 13a Data Manipulation:
-- Get the list of smartphones with 5G support, sorted by price in descending order
SELECT model, price, has_5g
FROM dbo.smartphone
WHERE has_5g = 1
ORDER BY price DESC;

--13b. Calculate the average rating for smartphones with NFC capability
SELECT AVG(rating) AS 'Average Rating (NFC Enabled)'
FROM dbo.smartphone
WHERE has_nfc = 1;

-- 14a. Data Analysis:
-- Count the number of smartphones by processor brand
SELECT processor_brand, COUNT(*) AS 'Smartphone Count'
FROM dbo.smartphone
GROUP BY processor_brand
ORDER BY 'Smartphone Count' DESC;

--14b. Get the maximum battery capacity and the corresponding model
SELECT TOP 1 model, MAX(battery_capacity) AS 'Max Battery Capacity'
FROM dbo.smartphone
GROUP BY model
ORDER BY 'Max Battery Capacity' DESC;


-- 15. Conditional Logic:
-- Categorize smartphones based on their RAM capacity
SELECT 
    model, 
    ram_capacity,
    CASE
        WHEN ram_capacity < 4 THEN 'Low RAM'
        WHEN ram_capacity >= 4 AND ram_capacity < 8 THEN 'Medium RAM'
        ELSE 'High RAM'
    END AS 'RAM Category'
FROM 
    smartphone
ORDER BY ram_capacity DESC;


-- 16. Find the highest-rated phone for each brand
-- Find the highest-rated phone for each brand
WITH HighestRatedPhones AS (
    SELECT 
        brand_name,
        model,
        rating,
        ROW_NUMBER() OVER (PARTITION BY brand_name ORDER BY rating DESC) AS RowNum
    FROM 
        smartphone
)
SELECT 
    brand_name,
    model,
    rating
FROM 
    HighestRatedPhones
WHERE 
    RowNum = 1
ORDER BY rating DESC;

-- 16b.
-- Identify similarities among highest-rated phones across brands
WITH HighestRatedPhones AS (
    SELECT 
        brand_name,
        model,
        processor_name,
        ram_capacity,
        internal_memory,
        primary_camera_rear,
        primary_camera_front,
        num_rear_cameras,
        num_front_cameras,
        refresh_rate,
        resolution,
        ROW_NUMBER() OVER (PARTITION BY brand_name ORDER BY rating DESC) AS RowNum
    FROM 
        smartphone
)
SELECT 
    brand_name,
    model,
    processor_name,
    ram_capacity,
    internal_memory,
    primary_camera_rear,
    primary_camera_front,
    num_rear_cameras,
    num_front_cameras,
    refresh_rate,
    resolution
FROM 
    HighestRatedPhones
WHERE 
    RowNum = 1;
