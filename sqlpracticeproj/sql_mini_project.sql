/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/*av. execution time 0.00016 sec*/
SELECT name AS "facility_name" FROM Facilities
WHERE membercost = 0

/* Q2: How many facilities do not charge a fee to members? */

/*av. execution time 0.0002 sec*/
SELECT COUNT(*) AS "no_of_free_facilities" FROM Facilities
WHERE membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/*av. execution time 0.0002 sec*/
SELECT facid AS "facid",name AS "facility_name",membercost AS "member_cost" ,monthlymaintenance AS "monthly_maintenance"
FROM Facilities 
WHERE membercost != 0
AND membercost < (0.2 * monthlymaintenance)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

/*av. execution time 0.00016 sec*/
SELECT *
FROM Facilities 
WHERE facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

/*av. execution time 0.00018 sec*/
SELECT name AS "facility_name", monthlymaintenance AS "monthly_maintenance", 
CASE WHEN monthlymaintenance > 100 THEN "expensive" ELSE "cheap" END AS "cheap_or_expensive"
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/*av. execution time 0.00024 sec*/
SELECT joindate AS "signup_date", firstname AS "first_name", surname AS "last_name"
FROM Members 
WHERE joindate = 
(SELECT MAX(joindate) FROM Members)

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/*two ways of writing this, method one using implicit join and no subquery*/
/*av. execution time 0.00196 sec*/
SELECT DISTINCT f.facid AS "facid",f.name AS "facility_name", 
CASE WHEN m.memid = 0 THEN "Guest" ELSE concat(m.surname, concat(" ",m.firstname)) END AS "member_name"  
FROM Bookings b, Facilities f, Members m
WHERE b.facid = f.facid
AND b.memid = m.memid
AND f.name LIKE "%tennis court%"
ORDER BY member_name


/*method two using explicit join and subquery*/
/*av. execution time 0.00254 sec*/
SELECT DISTINCT bf.facid AS "facid",bf.name AS "facility_name", 
CASE WHEN m.memid = 0 THEN "Guest" ELSE concat(m.surname, concat(" ",m.firstname)) END AS "member_name"
FROM
/*subquery joining Bookings and Facilities as table bf */
(SELECT f.facid AS "facid",f.name AS "name", b.memid AS "memid"
FROM Bookings b JOIN Facilities f
ON b.facid = f.facid
AND f.name LIKE "%tennis court%") bf
JOIN Members m
ON bf.memid = m.memid
ORDER BY member_name

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/*av. execution time 0.00072 sec*/
SELECT f.name AS "facility_name",
/*when guest, use Guest as name otherwise conact surname with firstname */
CASE WHEN m.memid = 0 THEN "Guest" ELSE concat(m.surname, concat(" ",m.firstname)) END AS "member_name", 
/*when guest, use guestcost otherwise use membercost */ 
CASE WHEN m.memid = 0 THEN (f.guestcost * b.slots) ELSE (f.membercost * b.slots) END AS "cost" 
FROM Bookings b, Members m, Facilities f
WHERE b.memid = m.memid
AND b.facid = f.facid
AND LEFT(b.starttime,10) = "2012-09-14"
/*when guest, use guestcost otherwise use membercost */
AND ( CASE WHEN m.memid = 0 THEN (f.guestcost * b.slots) > 30 
     ELSE (f.membercost * b.slots) > 30 END )
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

/*av. execution time 0.00075 sec*/
SELECT f.name AS "facility_name",
/*when guest, use Guest as name otherwise conact surname with firstname */
CASE WHEN bm.memid = 0 THEN "Guest" ELSE concat(bm.surname, concat(" ",bm.firstname)) END AS "member_name",  
/*when guest, use guestcost otherwise use membercost */
CASE WHEN bm.memid = 0 THEN (f.guestcost * bm.slots) ELSE (f.membercost * bm.slots) END AS "cost"
FROM
/*subquery joining Bookings and Members as table bm */
(SELECT m.memid AS "memid",b.facid AS "facid",m.surname AS "surname", m.firstname AS "firstname", b.slots AS "slots"
FROM Bookings b JOIN Members m
ON b.memid = m.memid
AND LEFT(b.starttime,10) = "2012-09-14") bm
JOIN Facilities f
ON bm.facid = f.facid
/*when guest, use guestcost otherwise use membercost */
AND ( CASE WHEN bm.memid = 0 THEN (f.guestcost * bm.slots) > 30 
     ELSE (f.membercost * bm.slots) > 30 END )
ORDER BY cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/*av. execution time 0.00158 sec*/
SELECT f.name AS "facility_name", 
SUM( (CASE WHEN b.memid = 0 THEN (f.guestcost * b.slots) ELSE (f.membercost * b.slots) END) ) AS "total_revenue" 
FROM Bookings b, Facilities f 
WHERE b.facid = f.facid 
GROUP BY f.facid
HAVING total_revenue < 1000
ORDER BY total_revenue
