-- Populate tables
INSERT INTO version_system_users VALUES (seq_users_id.NEXTVAL, 'Alice', 'alice@email.com');
INSERT INTO version_system_users VALUES (seq_users_id.NEXTVAL, 'Bob', 'bob@email.com');
INSERT INTO version_system_users VALUES (seq_users_id.NEXTVAL, 'Cecil', 'cecil@email.com');
INSERT INTO version_system_users VALUES (seq_users_id.NEXTVAL, 'Daniel', 'daniel@email.com');
INSERT INTO version_system_users VALUES (seq_users_id.NEXTVAL, 'Eva', 'eva@email.com');

INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 1, 1, 'Repo A', SYSDATE, SYSDATE);
INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 2, 1, 'Repo B', SYSDATE, SYSDATE);
INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 3, 1, 'Repo C', SYSDATE, SYSDATE);
INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 4, 1, 'Repo D', SYSDATE, SYSDATE);
INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 5, 1, 'Solo project', SYSDATE, SYSDATE);
INSERT INTO system_repos VALUES (seq_repos_id.NEXTVAL, 2, 1, 'Secret repo', SYSDATE, SYSDATE);

INSERT INTO repo_users VALUES (1, 2);
INSERT INTO repo_users VALUES (1, 3);
INSERT INTO repo_users VALUES (2, 4);
INSERT INTO repo_users VALUES (2, 5);
INSERT INTO repo_users VALUES (3, 1);
INSERT INTO repo_users VALUES (4, 1);

-- Execute procedures
-- Repo A branches:
EXECUTE split_branch(1, 1, 'dev');
EXECUTE split_branch(1, 1, 'redesign-ui');
-- Repo B branches:
EXECUTE split_branch(2, 1, 'add-feature');
-- Repo C branches:
EXECUTE split_branch(3, 1, 'fix-bug');

-- Commits
EXECUTE add_commit(1, 1, 1, 'Init commit');
EXECUTE add_commit(1, 1, 2, 'Add files');
EXECUTE add_commit(1, 2, 2, 'Implement feature');
EXECUTE add_commit(1, 3, 3, 'Fix evil bug');
EXECUTE add_commit(1, 2, 1, 'Add another feature!');
EXECUTE add_commit(1, 1, 3, 'Update stuff');

EXECUTE add_commit(2, 1, 2, 'Init commit');
EXECUTE add_commit(2, 2, 4, 'Add stuff');
EXECUTE add_commit(2, 2, 5, 'Fix stuff');
EXECUTE add_commit(2, 1, 4, 'Remove stuff');
EXECUTE add_commit(2, 1, 5, 'Break everything');

EXECUTE add_commit(3, 1, 3, 'Init commit');
EXECUTE add_commit(3, 2, 1, 'Add a class');
EXECUTE add_commit(3, 2, 1, 'Implement interface');

EXECUTE add_commit(5, 1, 5,'Init commit')
EXECUTE add_commit(5, 1, 5,'Commit 1')
EXECUTE add_commit(5, 1, 5,'Commit 2')
EXECUTE add_commit(5, 1, 5,'Commit 3')
EXECUTE add_commit(5, 1, 5,'Commit 4')

EXECUTE add_commit(2, 1, 5,'Commit 1 by Eva')
EXECUTE add_commit(2, 1, 5,'Commit 2 by Eva')