USE Shakespeare;
GO

/* Retrieve each character’s name whose abbreviation starts with the letter ’B’ 
and say a paragraph that includes either the word ’sir’ or the word ’lady’. */


SELECT DISTINCT
	c.CharName
FROM dbo.Characters AS c
JOIN dbo.Paragraphs AS p ON c.id = p.character_id
WHERE c.Abbrev LIKE 'B%' 
AND (p.PlainText LIKE '%sir%' OR p.PlainText LIKE '%lady%')


/* List the names of characters who have at least two scenes in the Macbeth play. */


SELECT 
	c.CharName,
	COUNT(DISTINCT ch.Scene) AS SceneCount
FROM dbo.Works AS w
JOIN dbo.Chapters AS ch ON w.id = ch.work_id
JOIN dbo.Paragraphs AS p ON ch.id = p.chapter_id
JOIN dbo.Characters AS c ON p.character_id = c.id
WHERE w.Title = 'Macbeth'
AND c.CharName NOT IN ('All', '(stage directions)')
GROUP BY c.CharName
HAVING COUNT(DISTINCT ch.Scene) > 2


/* Find the number of characters in each work, ordered from the top down. */


SELECT
	w.Title,
	COUNT(DISTINCT c.id) AS CharacterCount
FROM dbo.Works AS w
JOIN dbo.Chapters AS ch ON w.id = ch.work_id
JOIN dbo.Paragraphs AS p ON ch.id = p.chapter_id
JOIN dbo.Characters AS c ON p.character_id = c.id
WHERE c.CharName NOT IN ('All','Both','(stage directions)')
GROUP BY w.Title
ORDER BY CharacterCount DESC


/* Retrieve the number of paragraphs for each character in ’Hamlet’. */


SELECT
	c.CharName,
	COUNT(DISTINCT p.id) AS ParagraphCount
FROM dbo.Works AS w
JOIN dbo.Chapters AS ch ON w.id = ch.work_id
JOIN dbo.Paragraphs AS p ON ch.id = p.chapter_id
JOIN dbo.Characters AS c ON p.character_id = c.id
WHERE w.Title = 'Hamlet' 
AND c.CharName NOT IN ('All', '(stage directions)')
GROUP BY c.CharName
ORDER BY ParagraphCount DESC


/* Retrieve the name of Hamlet characters who appear in Shakespeare’s other works. */


WITH HamletCharacters AS
	(SELECT DISTINCT
		ch.CharName
	FROM dbo.Chapters AS c
	JOIN dbo.Paragraphs AS p ON c.id = p.chapter_id
	JOIN dbo.Characters AS ch ON p.character_id = ch.id
	WHERE c.work_id = 8
	AND ch.CharName NOT IN ('All', '(stage directions)'))

SELECT * 
FROM HamletCharacters
WHERE EXISTS
	(SELECT * 
	FROM dbo.Chapters AS c
	JOIN dbo.Paragraphs AS p ON c.id = p.chapter_id
	JOIN dbo.Characters AS ch ON p.character_id = ch.id
	WHERE c.work_id != 8
	AND ch.CharName = HamletCharacters.CharName)


/* Find characters with more than 200 paragraphs of dialogue, and the number of 
works in which the character appears. */


WITH Combined AS
	(SELECT 
		p.character_id AS char_id,
		p.id AS para_id,
		c.CharName AS CharName,
		ch.work_id AS work_id
	FROM dbo.Works AS w
	JOIN dbo.Chapters AS ch ON w.id = ch.work_id
	JOIN dbo.Paragraphs AS p ON ch.id = p.chapter_id
	JOIN dbo.Characters AS c ON p.character_id = c.id)

SELECT 
	CharName,
	COUNT(DISTINCT para_id) AS ParagraphCount,
	COUNT(DISTINCT work_id) AS WorkCount
FROM Combined
WHERE CharName != '(stage directions)'
GROUP BY char_id, CharName
HAVING COUNT(DISTINCT para_id) > 200 
ORDER BY ParagraphCount DESC


/* Retrieve the names of all characters who appear in the work that have the 
highest number of paragraphs among all of Shakespeare’s works. */


SELECT DISTINCT
	ch.CharName
FROM dbo.Characters AS ch
JOIN dbo.Paragraphs AS p ON ch.id = p.character_id
JOIN dbo.Chapters AS c ON p.chapter_id = c.id
WHERE c.work_id IN 
	(SELECT 
		c.work_id
	FROM dbo.Chapters AS c
	JOIN dbo.Paragraphs AS p ON c.id = p.chapter_id
	GROUP BY c.work_id
	ORDER BY COUNT(DISTINCT p.id) DESC
	OFFSET 0 ROWS
	FETCH NEXT 1 ROWS ONLY)
AND CharName NOT IN ('All','(stage directions)')


/* List the paragraphs that more than five different characters have said. */


SELECT 
	p.PlainText
FROM dbo.Works AS w
JOIN dbo.Chapters AS ch ON w.id = ch.work_id
JOIN dbo.Paragraphs AS p ON ch.id = p.chapter_id
JOIN dbo.Characters AS c ON p.character_id = c.id
GROUP BY p.PlainText
HAVING COUNT(DISTINCT c.id) > 5
ORDER BY p.PlainText
