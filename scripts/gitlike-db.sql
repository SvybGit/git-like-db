SET SERVEROUTPUT ON;

CREATE SEQUENCE seq_users_id START WITH 1 INCREMENT BY 1;

CREATE TABLE version_system_users (
                            id INTEGER PRIMARY KEY,
                            name VARCHAR2(15),
                            email VARCHAR2(64) UNIQUE
);


CREATE SEQUENCE seq_repos_id START WITH 1 INCREMENT BY 1;

CREATE TABLE system_repos (
                        id INTEGER PRIMARY KEY,
                        owner_id INTEGER REFERENCES version_system_users(id),
                        branch_count INTEGER DEFAULT 1,
                        name VARCHAR2(30),
                        created_date DATE DEFAULT SYSDATE,
                        updated_date DATE DEFAULT SYSDATE
);

CREATE TABLE repo_users (
                        repo_id INTEGER REFERENCES system_repos(id),
                        user_id INTEGER REFERENCES version_system_users(id),
                        PRIMARY KEY (repo_id, user_id)
);

CREATE TABLE branches (
                        id INTEGER,
                        repo_id INTEGER,
                        parent_branch_id INTEGER,
                        name VARCHAR2(50),
                        commit_count INTEGER,
                        is_main CHAR(1) DEFAULT 'N' CHECK (is_main IN ('Y', 'N')),
                        created_date DATE DEFAULT SYSDATE,
                        updated_date DATE DEFAULT SYSDATE,
                        PRIMARY KEY (repo_id, id),
                        FOREIGN KEY (repo_id) REFERENCES system_repos(id)
);


CREATE TABLE commits (
                        id INTEGER,
                        repo_id INTEGER,
                        branch_id INTEGER,
                        user_id INTEGER,                
                        message VARCHAR2(50),
                        created_date DATE DEFAULT SYSDATE,
                        PRIMARY KEY (id, repo_id, branch_id, user_id),
                        FOREIGN KEY (repo_id, branch_id) REFERENCES branches (repo_id, id),
                        FOREIGN KEY (user_id) REFERENCES version_system_users(id)
);

CREATE OR REPLACE TRIGGER create_main_branch AFTER INSERT ON system_repos FOR EACH ROW
BEGIN
    INSERT INTO repo_users VALUES (:new.id, :new.owner_id);
    INSERT INTO branches (id, repo_id, parent_branch_id, name, commit_count, is_main)
        VALUES (:new.branch_count, :new.id, NULL, 'main', 0, 'Y');
END;
/

CREATE OR REPLACE TRIGGER update_branch BEFORE UPDATE ON branches FOR EACH ROW
BEGIN
    :new.updated_date := SYSDATE;
    UPDATE system_repos SET updated_date = SYSDATE WHERE :new.repo_id = system_repos.id;
END;
/

CREATE OR REPLACE TRIGGER update_repo BEFORE UPDATE ON system_repos FOR EACH ROW
BEGIN
    :new.updated_date := SYSDATE;
END;
/

CREATE OR REPLACE PROCEDURE split_branch (repo_id INTEGER, branch_id INTEGER, new_name VARCHAR2) IS
    branch_commit_count INTEGER;
    new_repo_branch_count INTEGER;
BEGIN
    UPDATE system_repos SET branch_count = branch_count + 1 
        WHERE repo_id = system_repos.id
            RETURNING branch_count into new_repo_branch_count; 

    SELECT DISTINCT commit_count INTO branch_commit_count FROM branches 
        WHERE branch_id = branches.id and repo_id = branches.repo_id;
    INSERT INTO branches VALUES(new_repo_branch_count, repo_id, branch_id, new_name, branch_commit_count, 'N', SYSDATE, SYSDATE);
END;
/

CREATE OR REPLACE PROCEDURE add_commit (repo_id INTEGER, branch_id INTEGER, user_id INTEGER, message VARCHAR2) IS
    commit_id INTEGER;
BEGIN
    SELECT DISTINCT commit_count INTO commit_id FROM branches 
        WHERE repo_id = branches.repo_id AND branch_id = branches.id;
    commit_id := 1 + commit_id;
    UPDATE branches SET commit_count = commit_id 
        WHERE branch_id = branches.id AND repo_id = branches.repo_id;
    INSERT INTO commits VALUES (commit_id, repo_id, branch_id, user_id, message, SYSDATE);
END;
/

CREATE OR REPLACE PROCEDURE print_repo_users IS
  CURSOR repo_info_cur IS SELECT id AS repo_id, name AS repo_name FROM system_repos;
BEGIN
  FOR repo_info IN repo_info_cur LOOP
    DBMS_OUTPUT.PUT_LINE(repo_info.repo_name || ': ');
    FOR user_info IN (
        SELECT name, email FROM VERSION_SYSTEM_USERS users JOIN repo_users 
            ON (repo_users.user_id = users.id) 
                WHERE repo_users.REPO_ID = repo_info.repo_id
        ) LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(9) || '- ' || user_info.name || ', e-mail: ' || user_info.email);
    END LOOP;
  END LOOP;
END;
/

-- Selects an average number of commits per repo for each user
CREATE VIEW average_commits AS SELECT user_id, users.NAME, AVG(repo_commit_count) AS "AVG contributions per repo"
    FROM VERSION_SYSTEM_USERS users JOIN (
        SELECT user_id, repo_id, COUNT(id) AS repo_commit_count FROM commits GROUP BY user_id, repo_id
        ) 
        ON (user_id = users.id) GROUP BY user_id, users.NAME ORDER BY "AVG contributions per repo" DESC;

-- Selects all repos where there is more than one member (selects "group projects")
CREATE VIEW group_projects AS SELECT name, repo_id, user_count FROM SYSTEM_REPOS JOIN (SELECT repo_id, COUNT(user_id) AS user_count
    FROM repo_users
        GROUP BY repo_id HAVING COUNT(user_id) > 1
        ) ON (system_repos.id = repo_id);