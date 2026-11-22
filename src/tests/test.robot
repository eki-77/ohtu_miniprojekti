*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
Creating A Reference Succeeds
    Create Reference  example  Example Book  Example Author  2026  Example Publisher
    Reference Should Be Created

References Are Listed On The Main Page
    Create Reference  first  First Book  First Author  2026  First Publisher
    Create Reference  second  Second Book  Second Author  2020  Second Publisher
    Go To Starting Page
    ${page}=  Get Text  body
    Should Contain  ${page}  First Author.
    Should Contain  ${page}  First Book
    Should Contain  ${page}  First Publisher
    Should Contain  ${page}  Second Author.
    Should Contain  ${page}  Second Book
    Should Contain  ${page}  Second Publisher
    Should Contain  ${page}  Current references count: 2

Duplicate Citation Keys Are Rejected
    Create Reference  duplicate  First Book  First Author  2020  Publisher
    Create Reference  duplicate  Second Book  Second Author  2021  Publisher
    Should Be Rejected With  This key already exists.
    Reference Count Should Be  1

Missing Required Fields Are Rejected
    FOR  ${field}  IN  key  title  author  year  publisher
        Go To New Reference Page
        Fill In Reference Form  key=missing-field  title=Example Book  author=Example Author  year=2020  publisher=Example Publisher
        Fill Text  id=${field}  ${EMPTY}
        Submit Reference
        Page Should Contain  All fields are required.
    END
    Reference Count Should Be  0

Years Longer Than Four Digits Are Rejected
    Create Reference  long-year  Book With Long Year  Example Author  12345  Example Publisher
    Should Be Rejected With  Year must be numbers and a maximum of 4 digits.
    Reference Count Should Be   0

Future Years Are Rejected
    ${future_year}=  Evaluate  datetime.datetime.now().year + 1  modules=datetime
    Create Reference  future-year  Book From The Future  Example Author  ${future_year}  Example Publisher
    Should Be Rejected With  Year cannot be in the future.
    Reference Count Should Be  0

Negative Years Are Rejected
    Create Reference  negative-year  Book With Negative Year  Example Author  -1  Example Publisher
    Should Be Rejected With  Year cannot be negative.
    Reference Count Should Be  0

References Are Listed From Newest To Oldest
    Create Reference  oldest  Oldest Book  Oldest Author  2018  Publisher
    Create Reference  newest  Newest Book  Newest Author  2022  Publisher
    Create Reference  middle  Middle Book  Middle Author  2020  Publisher
    Go To Starting Page
    ${page}=  Get Text  body
    Should Be True  $page.index('Newest Book') < $page.index('Middle Book')
    Should Be True  $page.index('Middle Book') < $page.index('Oldest Book')

*** Keywords ***
Reset Database
    Go To  ${RESET_URL}

Create Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Go To New Reference Page
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Submit Reference

Page Should Contain
    [Arguments]  ${expected}
    ${page}=  Get Text  body
    Should Contain  ${page}  ${expected}

Reference Count Should Be
    [Arguments]  ${count}
    Go To Starting Page
    Page Should Contain  Current references count: ${count}

Should Be Rejected With
    [Arguments]  ${error}
    Page Should Contain  ${error}
