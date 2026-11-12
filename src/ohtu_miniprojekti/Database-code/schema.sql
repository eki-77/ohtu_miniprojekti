CREATE TABLE article (
    author TEXT, title TEXT, year INTEGER,
    journal TEXT, volume INTEGER, pages TEXT,
);

CREATE TABLE book (
    author TEXT, title TEXT, year INTEGER,
    volume INTEGER, pages TEXT,
    publisher TEXT, edition TEXT
);

CREATE TABLE inproceedings (
    author TEXT, title TEXT, year INTEGER,
    booktitle TEXT, volume INTEGER, pages TEXT,
);

CREATE TABLE misc (
    author TEXT, title TEXT, year INTEGER,
    publisher TEXT, link TEXT
);
