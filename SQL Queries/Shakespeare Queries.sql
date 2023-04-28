USE Shakespeare;
GO

/*	Retrieve each character’s name whose abbreviation starts with the letter ’B’ 
and say a paragraph that includes either the word ’sir’ or the word ’lady’.  */


SELECT DISTINCT 
	c.CharName
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON p.character_id = c.id
WHERE c.Abbrev LIKE 'B%'
AND c.id IN 
	(SELECT DISTINCT p.character_id
	FROM dbo.Paragraphs AS p 
	WHERE p.PlainText LIKE '%sir%' OR p.PlainText LIKE '%lady%')
ORDER BY c.CharName


/*	List the names of characters who have at least two scenes in the Macbeth play.  */


SELECT 
	c.CharName,
	COUNT(DISTINCT ch.Scene) AS SceneCount
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON p.character_id = c.id
JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
JOIN dbo.Works AS w ON w.id = ch.work_id
WHERE w.Title = 'Macbeth'
AND CharName NOT LIKE '(stage directions)' AND CharName NOT LIKE 'All'
GROUP BY c.CharName
HAVING COUNT(DISTINCT ch.Scene) > 2


/*	Find the number of characters in each work, ordered from the top down.  */


SELECT 
	w.Title,
	COUNT(DISTINCT p.character_id) AS CharacterCount
FROM dbo.Paragraphs AS p 
JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
JOIN dbo.Works AS w ON w.id = ch.work_id
GROUP BY w.Title
ORDER BY CharacterCount DESC


/*	Retrieve the number of paragraphs for each character in ’Hamlet’.  */


SELECT 
	c.CharName,
	COUNT(DISTINCT p.id) AS ParagraphCount
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON p.character_id = c.id
JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
JOIN dbo.Works AS w ON w.id = ch.work_id
WHERE w.Title = 'Hamlet'
AND c.CharName NOT LIKE '(stage directions)'
GROUP BY c.CharName
ORDER BY ParagraphCount DESC


/*	Find characters with more than 200 paragraphs of dialogue, and the number of 
works in which the character appears.  */


SELECT CharacterName, ParagraphCount, WorkCount
FROM 
	(SELECT 
	p.character_id AS char_id1,
	COUNT(DISTINCT p.id) AS ParagraphCount
	FROM dbo.Paragraphs AS p
	GROUP BY p.character_id) AS Results1
JOIN
	(SELECT 
	p.character_id AS char_id2,
	c.CharName AS CharacterName,
	COUNT(DISTINCT ch.work_id) as WorkCount
	FROM dbo.Characters AS c
	JOIN dbo.Paragraphs AS p ON p.character_id = c.id
	JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
	JOIN dbo.Works AS w ON w.id = ch.work_id
	GROUP BY p.character_id, c.CharName) AS Results2
ON Results1.char_id1 = Results2.char_id2
WHERE ParagraphCount > 200
AND Results2.CharacterName NOT LIKE '(stage directions)'
ORDER BY ParagraphCount DESC


/*	Retrieve the names of all characters who appear in the work that have the 
highest number of paragraphs among all of Shakespeare’s works.  */


SELECT DISTINCT c.CharName
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON p.character_id = c.id
JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
WHERE ch.work_id IN 
	(SELECT
		ch.work_id
	FROM dbo.paragraphs AS p
	JOIN dbo.chapters AS ch ON ch.id = p.chapter_id
	GROUP BY ch.work_id
	HAVING COUNT(DISTINcT p.id) =
		(SELECT MAX(mycount)
		FROM (
			SELECT 
				ch.work_id,
				COUNT(DISTINcT p.id) AS "mycount"
			FROM dbo.paragraphs AS p
			JOIN dbo.chapters AS ch ON ch.id = p.chapter_id
			GROUP BY ch.work_id) AS Results))
AND c.CharName NOT LIKE '(stage directions)'


/*	List the paragraphs that more than five different characters have said.  */


SELECT
	p.PlainText
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON p.character_id = c.id
WHERE p.PlainText NOT LIKE '[%%]'
GROUP BY p.PlainText
HAVING COUNT(p.PlainText) > 4 
AND COUNT(DISTINCT c.id) > 4
ORDER BY p.PlainText


/*	 Retrieve the name of Hamlet characters who appear in Shakespeare’s other works  */


SELECT DISTINCT CharName1
FROM 
	(SELECT 
		c.CharName AS CharName1
	FROM dbo.Characters AS c
	JOIN dbo.Paragraphs AS p ON p.character_id = c.id
	JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id
	GROUP BY CharName
	HAVING COUNT(DISTINCT ch.work_id) > 1) AS Results1
JOIN
	(SELECT
		p.id AS ParagraphID,
		ch.work_id AS WorkID,
		c.CharName AS CharName2
	FROM dbo.Characters AS c
	JOIN dbo.Paragraphs AS p ON p.character_id = c.id
	JOIN dbo.Chapters AS ch ON ch.id = p.chapter_id) AS Results2
ON Results1.CharName1 = Results2.CharName2
WHERE Results2.WorkID IN ('8')
AND CharName1 NOT LIKE '(stage directions)'
ORDER BY CharName1