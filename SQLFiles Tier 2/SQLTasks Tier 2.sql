/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
/* MY CODE
SELECT DISTINCT name
FROM Facilities
WHERE membercost > 0;
*/

/* Q2: How many facilities do not charge a fee to members? */
/* MY ANSWER
4 */

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/* MY CODE
SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost < (0.2 * monthlymaintenance); */

/*RESULT

facid	
name	
membercost	
monthlymaintenance	
0
Tennis Court 1
5.0
200
1
Tennis Court 2
5.0
200
2
Badminton Court
0.0
50
3
Table Tennis
0.0
10
4
Massage Room 1
9.9
3000
5
Massage Room 2
9.9
3000
6
Squash Court
3.5
80
7
Snooker Table
0.0
15
8
Pool Table
0.0
15 */

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

/* MY CODE
SELECT *
FROM Facilities
WHERE facid IN (1, 5); */

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

/* MY CODE
SELECT 
    name,
    monthlymaintenance,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END AS label
FROM Facilities;
*/

/* RESULTS
Springboard PHPMyadmin Server/country_club/Facilities/		https://frankfletcher.co/springboard_phpmyadmin/index.php?route=/table/sql&db=country_club&table=Facilities

   Showing rows 0 -  8 (9 total, Query took 0.0004 seconds.)


SELECT 
    name,
    monthlymaintenance,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END AS label
FROM Facilities;


name	monthlymaintenance	label	
Tennis Court 1	200	expensive	
Tennis Court 2	200	expensive	
Badminton Court	50	cheap	
Table Tennis	10	cheap	
Massage Room 1	3000	expensive	
Massage Room 2	3000	expensive	
Squash Court	80	cheap	
Snooker Table	15	cheap	
Pool Table	15	cheap	
*/

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

/* MY CODE
SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members);
*/

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/* MY CODE
SELECT DISTINCT CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
                Facilities.name AS court_name
FROM Bookings
INNER JOIN Members ON Bookings.memid = Members.memid
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Facilities.name LIKE 'Tennis Court%'
ORDER BY member_name;
*/

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/* MY CODE
SELECT CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
       Facilities.name AS facility_name,
       CASE
           WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
           ELSE Facilities.membercost * Bookings.slots
       END AS cost
FROM Bookings
INNER JOIN Members ON Bookings.memid = Members.memid OR Bookings.memid = 0
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE DATE(Bookings.starttime) = '2012-09-14'
HAVING cost > 30
ORDER BY cost DESC;
*/

/* RETURN
Springboard PHPMyadmin Server/country_club/Facilities/		https://frankfletcher.co/springboard_phpmyadmin/index.php?route=/table/sql&db=country_club&table=Facilities

   Showing rows 0 - 99 (342 total, Query took 0.0072 seconds.)


SELECT CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
       Facilities.name AS facility_name,
       CASE
           WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
           ELSE Facilities.membercost * Bookings.slots
       END AS cost
FROM Bookings
INNER JOIN Members ON Bookings.memid = Members.memid OR Bookings.memid = 0
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE DATE(Bookings.starttime) = '2012-09-14'
HAVING cost > 30
ORDER BY cost DESC;


member_name	facility_name	cost   	
Charles Owen	Massage Room 2	320.0	
Millicent Purview	Massage Room 2	320.0	
Jemima Farrell	Massage Room 2	320.0	
Erica Crumpet	Massage Room 2	320.0	
Timothy Baker	Massage Room 2	320.0	
GUEST GUEST	Massage Room 2	320.0	
Anna Mackenzie	Massage Room 2	320.0	
Tim Rownam	Massage Room 2	320.0	
Douglas Jones	Massage Room 2	320.0	
Burton Tracy	Massage Room 2	320.0	
Henry Worthington-Smyth	Massage Room 2	320.0	
Ponder Stibbons	Massage Room 2	320.0	
Anne Baker	Massage Room 2	320.0	
John Hunt	Massage Room 2	320.0	
Florence Bader	Massage Room 2	320.0	
Matthew Genting	Massage Room 2	320.0	
Tracy Smith	Massage Room 2	320.0	
Ramnaresh Sarwin	Massage Room 2	320.0	
Gerald Butters	Massage Room 2	320.0	
David Farrell	Massage Room 2	320.0	
Tim Boothe	Massage Room 2	320.0	
David Jones	Massage Room 2	320.0	
Hyacinth Tupperware	Massage Room 2	320.0	
Jack Smith	Massage Room 2	320.0	
Darren Smith	Massage Room 2	320.0	
David Pinker	Massage Room 2	320.0	
Darren Smith	Massage Room 2	320.0	
Joan Coplin	Massage Room 2	320.0	
Janice Joplette	Massage Room 2	320.0	
Henrietta Rumney	Massage Room 2	320.0	
Nancy Dare	Massage Room 2	320.0	
Jemima Farrell	Massage Room 1	160.0	
Erica Crumpet	Massage Room 1	160.0	
Anne Baker	Massage Room 1	160.0	
John Hunt	Massage Room 1	160.0	
Anne Baker	Massage Room 1	160.0	
John Hunt	Massage Room 1	160.0	
GUEST GUEST	Massage Room 1	160.0	
Timothy Baker	Massage Room 1	160.0	
Florence Bader	Massage Room 1	160.0	
Florence Bader	Massage Room 1	160.0	
Tim Rownam	Massage Room 1	160.0	
Anna Mackenzie	Massage Room 1	160.0	
Tracy Smith	Massage Room 1	160.0	
Matthew Genting	Massage Room 1	160.0	
Tracy Smith	Massage Room 1	160.0	
Matthew Genting	Massage Room 1	160.0	
Burton Tracy	Massage Room 1	160.0	
Douglas Jones	Massage Room 1	160.0	
Gerald Butters	Massage Room 1	160.0	
Ramnaresh Sarwin	Massage Room 1	160.0	
Gerald Butters	Massage Room 1	160.0	
Ramnaresh Sarwin	Massage Room 1	160.0	
Ponder Stibbons	Massage Room 1	160.0	
Henry Worthington-Smyth	Massage Room 1	160.0	
Tim Boothe	Massage Room 1	160.0	
David Farrell	Massage Room 1	160.0	
Tim Boothe	Massage Room 1	160.0	
David Farrell	Massage Room 1	160.0	
Anne Baker	Massage Room 1	160.0	
John Hunt	Massage Room 1	160.0	
David Jones	Massage Room 1	160.0	
Hyacinth Tupperware	Massage Room 1	160.0	
David Jones	Massage Room 1	160.0	
Hyacinth Tupperware	Massage Room 1	160.0	
Florence Bader	Massage Room 1	160.0	
Jack Smith	Massage Room 1	160.0	
Darren Smith	Massage Room 1	160.0	
Jack Smith	Massage Room 1	160.0	
Darren Smith	Massage Room 1	160.0	
Tracy Smith	Massage Room 1	160.0	
Matthew Genting	Massage Room 1	160.0	
Darren Smith	Massage Room 1	160.0	
David Pinker	Massage Room 1	160.0	
Darren Smith	Massage Room 1	160.0	
David Pinker	Massage Room 1	160.0	
Gerald Butters	Massage Room 1	160.0	
Ramnaresh Sarwin	Massage Room 1	160.0	
Janice Joplette	Massage Room 1	160.0	
Joan Coplin	Massage Room 1	160.0	
Janice Joplette	Massage Room 1	160.0	
Joan Coplin	Massage Room 1	160.0	
Tim Boothe	Massage Room 1	160.0	
David Farrell	Massage Room 1	160.0	
Nancy Dare	Massage Room 1	160.0	
Henrietta Rumney	Massage Room 1	160.0	
Nancy Dare	Massage Room 1	160.0	
Henrietta Rumney	Massage Room 1	160.0	
David Jones	Massage Room 1	160.0	
Hyacinth Tupperware	Massage Room 1	160.0	
Charles Owen	Massage Room 1	160.0	
Millicent Purview	Massage Room 1	160.0	
Charles Owen	Massage Room 1	160.0	
Millicent Purview	Massage Room 1	160.0	
Jack Smith	Massage Room 1	160.0	
Darren Smith	Massage Room 1	160.0	
Jemima Farrell	Massage Room 1	160.0	
Erica Crumpet	Massage Room 1	160.0	
Jemima Farrell	Massage Room 1	160.0	
Erica Crumpet	Massage Room 1	160.0	
*/

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
/* MY CODE
SELECT member_name, facility_name, cost
FROM (
    SELECT CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
           Facilities.name AS facility_name,
           CASE
               WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
               ELSE Facilities.membercost * Bookings.slots
           END AS cost
    FROM Bookings
    INNER JOIN Members ON Bookings.memid = Members.memid OR Bookings.memid = 0
    INNER JOIN Facilities ON Bookings.facid = Facilities.facid
    WHERE DATE(Bookings.starttime) = '2012-09-14'
) AS subquery
WHERE cost > 30
ORDER BY cost DESC;
*/

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

