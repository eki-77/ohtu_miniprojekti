def generate_text(references):
    entries = []

    for reference in references:
        key = reference["citation_key"]
        title = reference["title"]
        author = reference["author"]
        year = reference["year"]

        if reference["cite_type"] == "book":
            publisher = reference["publisher"]

            s = "@book{%s,\n    author = {%s},\n    title = {%s}," %(key, author, title)
            if publisher and publisher != "None":
                s += "\n    publisher = {%s}," %publisher
            s += "\n    year = {%s}\n}\n\n" %year

        elif reference["cite_type"] == "article":
            journal = reference["journal"]
            volume = reference["volume"]
            number = reference["number"]

            s = "@article{%s,\n    author = {%s},\n    title = {%s}," %(key, author, title)
            s += "\n    journal = {%s},\n    year = {%s}" %(journal, year)
            if volume and volume != "None":
                s += ",\n    volume = {%s}" %(volume)
            if number and number != "None":
                s += ",\n    number = {%s}" %(number)
            s += "\n}\n\n"

        entries.append(s)

    return "\n".join(entries)
