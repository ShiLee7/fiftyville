# SQL Crime Investigation Log: The Bakery Heist

This project documents the process of solving a fictional SQL-based crime mystery as part of a CS50 Lab. The crime involves a theft that occurred on **July 28, 2021**, on **Humphrey Street**, involving a **bakery** and a **getaway plan involving a flight**.

---

## 🔍 Investigation Steps and Queries

### 1. 🔧 Initial Setup
- Used `.schema` and `.tables` to explore the structure of the database.
- Saved output in a separate file to avoid repeating this step.

### 2. 🧾 Crime Scene Report
```sql
SELECT description FROM crime_scene_reports
WHERE year = 2021
  AND month = 7
  AND day = 28
  AND street = "Humphrey Street";
```
> 🗒️ Revealed the crime took place at **10:15 a.m.** at a **bakery**, and three interviews were conducted.

---

### 3. 📼 Surveillance Logs (Bakery)
```sql
SELECT activity, license_plate FROM bakery_security_logs
WHERE year = 2021
  AND month = 7
  AND day = 28
  AND hour = 10
  AND minute BETWEEN 15 AND 20;
```
> 🎥 Listed 5 cars that exited the bakery parking lot shortly after the crime.

---

### 4. 🕵️ First Suspects List
```sql
SELECT name FROM people
WHERE license_plate IN (
  "5P2BI95", "94KL13X", "6P58WS2", "4328GD8", "G412CB7"
);
```
> 🚨 **Suspects Identified**: Vanessa, Barry, Sofia, Luca, and Bruce

---

### 5. 🏧 ATM Transactions at Leggett Street
```sql
SELECT name
FROM people, bank_accounts
WHERE people.id = bank_accounts.person_id
  AND account_number IN (
    SELECT account_number
    FROM atm_transactions
    WHERE year = 2021
      AND month = 7
      AND day = 28
      AND atm_location LIKE "%Leggett Street%"
      AND transaction_type = "withdraw"
)
ORDER BY name;
```
> 💵 **ATM Users**: Includes **Bruce** and **Luca** among others.

✅ **Intersection**: Bruce appears in both the suspect list and ATM log. **He is the thief.**

---

### 6. 📞 Phone Call Check (Accomplice Identification)
```sql
SELECT name FROM people WHERE phone_number = (
  SELECT receiver FROM phone_calls
  WHERE caller IN (
    SELECT phone_number FROM people WHERE name = "Bruce"
  )
  AND year = 2021
  AND month = 7
  AND day = 28
);
```
> 📱 Bruce called **Robin** → **Accomplice Identified**

---

### 7. 🛫 Flight Information
**Find first flight out of Fiftyville on July 29:**
```sql
SELECT flights.id FROM flights
WHERE origin_airport_id IN (
  SELECT id FROM airports WHERE city = "Fiftyville"
)
AND year = 2021
AND month = 7
AND day = 29
ORDER BY hour ASC
LIMIT 1;
```
> ✈️ Flight ID: **36**

**Find destination of that flight:**
```sql
SELECT city FROM airports WHERE id = (
  SELECT destination_airport_id FROM flights WHERE id = 36
);
```
> 🏙️ Destination: **New York City**

---

## 🧠 Conclusion

- **Thief**: Bruce  
- **Accomplice**: Robin  
- **Escape City**: New York City  
- **Escape Method**: First flight out of Fiftyville, July 29, 2021

---

## 📌 Notes

- All queries were executed using SQLite3.
- `.schema` output was saved separately to avoid repeated queries.

---

## 📚 Credits

This project is based on the **SQL Lab: Fiftyville Mystery** from the [CS50](https://cs50.harvard.edu/) course by Harvard University.

**Author**: Leonardo Jiménez

---
🔎 *Solving mysteries, one query at a time.*