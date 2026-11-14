import db

def add_reference(citation_key, cite_type, title, year):
    sql = """
        INSERT INTO all_references
        (citation_key, cite_type, title, year)
        VALUES (?, ?, ?, ?)
    """
    db.execute(sql, [citation_key, cite_type, title, year])
    return db.last_insert_id()

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