# Git-like database
Oracle SQL and PL/SQL scripts for a versioning system database similar to Git

## Execution order
1. [gitlike-db.sql](https://github.com/SvybGit/git-like-db/blob/main/scripts/gitlike-db.sql)
    - Creates all the necessary constructions for the database to work properly
1. [populate-tables.sql](https://github.com/SvybGit/git-like-db/blob/main/scripts/populate-tables.sql)
    - Populates the tables with testing data
1. [show-data.sql](https://github.com/SvybGit/git-like-db/blob/main/scripts/show-data.sql)
    - Selects everything from all the tables, executes procedures that show data and reveals views

## Documentation
The documentation of this project is available in the [docs-cz.pdf](https://github.com/SvybGit/git-like-db/blob/main/docs-cz.pdf) file.
Currently available only in the **Czech** language.

## ER-diagram
![ER-diagram of the database](https://github.com/SvybGit/git-like-db/blob/ad651c153dcb28eb6f5d5b11d16c50b902bf9624/er-diagram.png)
