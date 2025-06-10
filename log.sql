-- Keep a log of any SQL queries you execute as you solve the mystery.
--ran .schema to see data available keep a separate file with the result in order to not do it again every time I
--needed the information.
.schema
.tables
SELECT description FROM crime_scene_reports
 WHERE year = 2021
   AND month = 7
   AND day = 28
   AND street = "Humphrey Street";
--From this I get 3 intervies at the time, crime took place @10:15 am bakery involved from certainty

SELECT activity,license_plate FROM bakery_security_logs
 WHERE year = 2021
   AND month = 7
   AND day = 28
   AND hour = 10;
-- no results if minute = 15
SELECT name,transcript FROM interviews
    WHERE year = 2021
    AND month = 7
    AND day = 28;
--from this query I get that the theft ocurred between 10:15 and 10:20, also the thift withdraw some money before
--10:15
--also the thif said he was plannig to take the earliest flight from the city the next day
--ATM: Leggett Street
SELECT activity,license_plate FROM bakery_security_logs
 WHERE year = 2021
   AND month = 7
   AND day = 28
   AND hour = 10
   AND minute >= 15
   AND minute <= 20;
--list of suspect cars:  activity | license_plate |
--+----------+---------------+
--| exit     | 5P2BI95       |
--| exit     | 94KL13X       |
--| exit     | 6P58WS2       |
--| exit     | 4328GD8       |
--| exit     | G412CB7
SELECT name FROM people
    WHERE license_plate = "5P2BI95"
    OR license_plate = "94KL13X"
    OR license_plate = "6P58WS2"
    OR license_plate = "4328GD8"
    OR license_plate = "G412CB7";
--THIS QUERY RESULTS IN THE 1ST LIST OF SUSPECTS:
--Vanessa |
--| Barry   |
--| Sofia   |
--| Luca    |
--| Bruce
--NOW I CAN USE THE ATM TABLE TO GET A LIST OF PEOPLE THAT WITHDRAW MONEY IN THAT TIMEFRAME
SELECT name
  FROM people, bank_accounts
 WHERE people.id = bank_accounts.person_id
   AND account_number IN
       (SELECT account_number
          FROM atm_transactions
         WHERE year = 2021
           AND month = 7
           AND day = 28
           AND atm_location LIKE "%Leggett Street%"
           AND transaction_type = "withdraw")
 ORDER BY name;
--output of query:
--- name   |
--+---------+
--| Benista |
--| Brooke  |
--| Bruce   |
--| Diana   |
--| Iman    |
--| Kenny   |
--| Luca    |
--| Taylor  |
--The only name that appears twice in this table and the 1st table of subject is Bruce, hence Bruce must be the thief.
--With the following query I can see who Bruce called:

SELECT name FROM people WHERE phone_number =
(SELECT receiver FROM phone_calls WHERE caller IN
    (SELECT phone_number FROM people WHERE name LIKE "%Bruce%")
    AND year = '2021'
    AND month = '7'
    AND day = '28'
);
--Bruce just called one person: Robin hence, she is the accomplice

--With this query I can get the flight id of the 1st flight out of Fiftyville the 07/29/21:
SELECT flights.id FROM flights
        WHERE flights.origin_airport_id
        IN (SELECT id FROM airports WHERE city LIKE "%FiftyVille")
        AND year = 2021
        AND month = 7
        AND day = 29
        ORDER by hour ASC
        LIMIT 1;
--ID = 36, now I can get the city of destination
SELECT destination_airport_id FROM flights
WHERE flights.id = 36;
--THIS QUERY GIVES ME THAT FINAL AIRPORT ID IS 4

--Now for the City:
SELECT city FROM airports WHERE id IN
(SELECT destination_airport_id FROM flights
WHERE flights.id = 36);
--Answer: New York City