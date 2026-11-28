*** Settings ***
Resource  resource.robot
Library   OperatingSystem
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
Bibtex Page Displays References In Correct Format
    Create Reference  example-book  Example Book  Book Author  2020  Example Publisher
    Create Article Reference  example-article  Example Article  Article Author  2022  Example Journal  12  3
    Go To Starting Page
    Click  text="Generate a BibTeX file"

    ${page}=  Get Text  body
    Should Contain  ${page}  @book{example-book,
    Should Contain  ${page}  author = {Book Author}
    Should Contain  ${page}  title = {Example Book}
    Should Contain  ${page}  publisher = {Example Publisher}
    Should Contain  ${page}  year = {2020}

    Should Contain  ${page}  @article{example-article,
    Should Contain  ${page}  author = {Article Author}
    Should Contain  ${page}  title = {Example Article}
    Should Contain  ${page}  journal = {Example Journal}
    Should Contain  ${page}  year = {2022}
    Should Contain  ${page}  volume = {12}
    Should Contain  ${page}  number = {3}

Download Button Works
    Create Reference  download-book  Download Book  Download Book Author  2021  Download Publisher
    Create Article Reference  download-article  Download Article  Download Article Author  2023  Download Journal  4  2
    Go To Starting Page
    Click  text="Generate a BibTeX file"

    ${download_promise}=  Promise To Wait For Download  download_timeout=10s
    Click  text="Download .bib file"
    ${download}=  Wait For  ${download_promise}

    Should Be Equal  ${download}[suggestedFilename]  references.bib
    ${bibtex}=  Get File  ${download}[saveAs]
    Should Contain  ${bibtex}  @book{download-book,
    Should Contain  ${bibtex}  publisher = {Download Publisher}
    
    Should Contain  ${bibtex}  @article{download-article,
    Should Contain  ${bibtex}  journal = {Download Journal}
    Should Contain  ${bibtex}  volume = {4}
    Should Contain  ${bibtex}  number = {2}

*** Keywords ***
Create Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Go To New Reference Page
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Submit Reference

Create Article Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${journal}  ${volume}  ${number}
    Go To New Article Reference Page
    Fill In Article Reference Form  ${key}  ${title}  ${author}  ${year}  ${journal}  ${volume}  ${number}
    Submit Reference
