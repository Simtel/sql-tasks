CREATE VIEW members
AS
SELECT u.id, u.name,up.email
FROM tasks.users as u
LEFT JOIN tasks.user_profiles up ON u.id = up.user_id;


SELECT * FROM tasks.members