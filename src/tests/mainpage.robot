*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
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

References Are Listed From Newest To Oldest
    Create Reference  oldest  Oldest Book  Oldest Author  2018  Publisher
    Create Reference  newest  Newest Book  Newest Author  2022  Publisher
    Create Reference  middle  Middle Book  Middle Author  2020  Publisher
    Go To Starting Page
    ${page}=  Get Text  body
    Should Be True  $page.index('Newest Book') < $page.index('Middle Book')
    Should Be True  $page.index('Middle Book') < $page.index('Oldest Book')

*** Keywords ***
Create Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Go To New Reference Page
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Submit Reference
