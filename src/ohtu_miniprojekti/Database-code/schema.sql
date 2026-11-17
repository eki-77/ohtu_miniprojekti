PRAGMA foreign_keys = ON;

-- All references
CREATE TABLE all_references (
-- Base queries
    id INTEGER PRIMARY KEY,
    citation_key TEXT NOT NULL UNIQUE,
    cite_type TEXT NOT NULL,
    title TEXT NOT NULL,
    year INTEGER,

-- Optionals:
    journal TEXT,
    booktitle TEXT,
    publisher TEXT,
    volume TEXT,
    number TEXT,
    pages TEXT,
    edition TEXT,

    doi TEXT,
    url TEXT
);

-- Only authors (This way they are easier to put in order or filter)
CREATE TABLE authors (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Connecting references id to author (one author can have multiple references)
CREATE TABLE reference_authors (
    reference_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    position INTEGER NOT NULL,
    
    PRIMARY KEY (reference_id, author_id),

    FOREIGN KEY (reference_id)
        REFERENCES references(id) ON DELETE CASCADE,

    FOREIGN KEY (author_id)
        REFERENCES authors(id) ON DELETE CASCADE
);

CREATE TABLE tags (
-- tags/categories
);

CREATE TABLE reference_tags (
-- tags/categories
);