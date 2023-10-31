%TIFFANY KAWAMURA 10/16/2023
%-------------------------------------------------------------------------
% QUERY 1. Which songs appeared on the CD rated number one in 2003? 'S17' Day's Go By
% Order results in ascending order on track number.
% (songCode, songTitle, trackNumber)
%topSongs, song(songTitle), composedOf(trackNumber)
%-------------------------------------------------------------------------

query1 := 
SELECT S.songCode, S.songTitle, C.trackNumber
FROM topCDs T, song S, composedOf C
WHERE T.cdCode=C.cdCode AND S.songCode=C.songCode AND T.year=2003 AND T.rating=1
ORDER BY C.trackNumber asc;

%-------------------------------------------------------------------------
% QUERY 2. For each group in the database, find the number of CDs rated in the top 10. 
% Order the results in descending order of the number of top 10 CDs. 
% (groupCode, groupName, numberOfTop10CDs)
% musicalGroup(groupCode, groupName)
%-------------------------------------------------------------------------

query2 :=
SELECT M.groupCode, M.groupName, COUNT(*) AS numberOfTop10CDs
FROM musicalGroup M, topCDs T, cd C
WHERE M.groupCode=C.groupCode AND T.cdCode=C.cdCode AND rating<11
GROUP BY M.groupCode, M.groupName
ORDER BY numberOfTop10CDs desc;

%-------------------------------------------------------------------------
% QUERY 3. What is the maximum, the minimum, and average number of tracks on CDs published since the year 2000? 
% Order the results in chronological order by year. 
% (year, maxNumber, minNumber, avgNumber) 
%-------------------------------------------------------------------------
trackCount :=
SELECT cdCode, COUNT(*) AS trackNumber
FROM composedOf
GROUP BY cdCode;

query3 :=
SELECT C.year, max(TC.trackNumber) AS maxNumber, min(TC.trackNumber) AS minNumber, avg(TC.trackNumber) AS avgNumber
FROM cd C, trackCount TC
WHERE C.year>1999 AND C.cdCode=TC.cdCode
GROUP BY C.year
ORDER BY C.year;

%-------------------------------------------------------------------------
% QUERY 4. Find the total number of CDs sold by a group with a recording label. 
% Order the results in descending order by the total number of CDs sold. 
% (groupCode, groupName, labelID, labelName, totalNumberSold)
%cd.numberSold, cd.labelID=recordingLabel.labelID
%-------------------------------------------------------------------------

query4 :=
SELECT M.groupCode, M.groupName, R.labelID, R.labelName, SUM(numberSold) AS totalNumberSold
FROM musicalGroup M, recordingLabel R, cd C
WHERE M.groupCode=C.groupCode AND C.labelID=R.labelID
GROUP BY M.groupCode, M.groupName, R.labelID, R.labelName
ORDER BY totalNumberSold desc;

%-------------------------------------------------------------------------
% QUERY 5. Which artists that have written a top 5 song are currently not members of any group? 
% Order the results alphabetically by last name and first name. 
% (artistID, firstName, lastName, yearBorn) 
% topSongs.rating, artist.artistID <> member.artistID
%-------------------------------------------------------------------------

query5 :=
SELECT distinct A.artistID, A.firstName, A.lastName, A.yearBorn
FROM artist A, topSongs T, writtenBy W
WHERE rating<6 AND T.songCode=W.songCode AND A.artistID=W.artistID AND A.artistID NOT IN (SELECT artistID FROM member WHERE toDate=0) 
ORDER BY A.lastName, A.firstName;
