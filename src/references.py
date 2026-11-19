import db


def add_reference(citation_key, cite_type, title, year, author, publisher=None):
    author_id = add_or_get_author(author)
    sql = """
        INSERT INTO all_references
        (citation_key, cite_type, title, year, publisher)
        VALUES (?, ?, ?, ?, ?)
    """
    db.execute(sql, [citation_key, cite_type, title, year, publisher])
    reference_id = db.last_insert_id()
    sql = """
        INSERT INTO reference_authors
        (reference_id, author_id, position)
        VALUES (?, ?, 1)
    """
    db.execute(sql, [reference_id, author_id])
    return reference_id


def add_or_get_author(name):
    sql = "SELECT id FROM authors WHERE name = ?"
    rows = db.query(sql, [name])
    if not rows:  # check if author doesn't exist yet
        sql = "INSERT INTO authors (name) VALUES (?)"
        db.execute(sql, [name])
        author_id = db.last_insert_id()
    else:
        author_id = rows[0]["id"]

    return author_id


def get_all_references(order_by="year"):
    if order_by == "author":
        sql = """
            SELECT r.*
            FROM all_references r
            JOIN reference_authors ra ON r.id = ra.reference_id
            JOIN authors a ON ra.author_id = a.id
            WHERE ra.position = 1
            ORDER BY a.name ASC
        """

    else:
        sql = """
            SELECT *
            FROM all_references
            ORDER BY year DESC
        """

    return db.query(sql)


# call get_all_references() for year order
# call get_all_references("author") for autho order
