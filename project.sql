DROP TABLE IF EXISTS PROJECT RESTRICT;

CREATE TABLE PROJECT(
    Pname VARCHAR (25) NOT NULL,
    Pnumber INTEGER(4) NOT NULL,
    Plocation VARCHAR(25) NOT NULL, 
    Dnum INTEGER(4) NOT NULL,
    PRIMARY KEY (Pnumber),
    UNIQUE (Pname),
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT_LOCATION(Dnumber)
);