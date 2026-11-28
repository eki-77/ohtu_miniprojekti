*** Settings ***
Library  Browser

*** Variables ***
${SERVER}        localhost:5001            # subject to change
${DELAY}         500ms
${HOME_URL}      http://${SERVER}/
${RESET_URL}     http://${SERVER}/reset-db
${BROWSER}       chromium
${HEADLESS}      false

*** Keywords ***
Open And Configure Browser
    IF  $HEADLESS == 'true'
        New Browser  browser=${BROWSER}  headless=True
    ELSE
        New Browser  browser=${BROWSER}  headless=False  slowMo=${DELAY}
    END
    New Context  acceptDownloads=True
    New Page  about:blank

Go To Starting Page
    Go to  ${HOME_URL}

Go To New Reference Page
    Go To  ${HOME_URL}new-reference

Go To New Article Reference Page
    Go To  ${HOME_URL}new-article-reference

Fill In Reference Form
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}=${EMPTY}
    Fill Text  id=key        ${key}
    Fill Text  id=title      ${title}
    Fill Text  id=author     ${author}
    Fill Text  id=year       ${year}
    Fill Text  id=publisher  ${publisher}

Fill In Article Reference Form
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${journal}  ${volume}=${EMPTY}  ${number}=${EMPTY}
    Fill Text  id=key        ${key}
    Fill Text  id=title      ${title}
    Fill Text  id=author     ${author}
    Fill Text  id=year       ${year}
    Fill Text  id=journal    ${journal}
    Fill Text  id=volume     ${volume}
    Fill Text  id=number     ${number}

Create Article Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${journal}  ${volume}  ${number}
    Go To New Article Reference Page
    Fill In Article Reference Form  ${key}  ${title}  ${author}  ${year}  ${journal}  ${volume}  ${number}
    Submit Reference

Submit Reference
    Click  text="Create"

Reference Should Be Created
    ${page}=  Get Text  body
    Should Contain  ${page}  Reference added successfully.
    Should Contain  ${page}  Example Publication

Reset Database
    Go To  ${RESET_URL}

Article Reference Should Be Listed
    [Arguments]  ${author}  ${title}  ${journal}  ${year}  ${volume}=${EMPTY}  ${number}=${EMPTY}
    Go To Starting Page
    ${page}=  Get Text  body
    Should Contain  ${page}  ${author}.
    Should Contain  ${page}  ${title}
    Should Contain  ${page}  ${journal}
    Should Contain  ${page}  ${year}
    IF  $volume != ''
        Should Contain  ${page}  ${volume}
    END
    IF  $number != ''
        Should Contain  ${page}  ${number}
    END
