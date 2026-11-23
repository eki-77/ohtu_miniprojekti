*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
Deleting A Reference Removes Only That Reference
    Create Reference  first  First Book  First Author  2020  Publisher
    Create Reference  second  Second Book  Second Author  2021  Publisher
    Delete Reference  First Book  ACCEPT
    ${page}=  Get Text  body
    Should Contain  ${page}  Second Book
    Should Not Contain  ${page}  First Book
    Should Contain  ${page}  Current references count: 1

Canceling Reference Deletion Keeps It
    Create Reference  example  Example Book  Example Author  2020  Publisher
    Delete Reference  Example Book  DISMISS
    ${page}=  Get Text  body
    Should Contain  ${page}  Example Book
    Should Contain  ${page}  Current references count: 1

Deleting An Article Reference Removes It
    Create Article Reference  article  Example Article  Example Author  2020  Example Journal  Volume 1  Number 1
    Delete Reference  Example Article  ACCEPT
    ${page}=  Get Text  body
    Should Not Contain  ${page}  Example Article
    Should Contain  ${page}  Current references count: 0

*** Keywords ***
Create Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Go To New Reference Page
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Submit Reference

Delete Reference
    [Arguments]  ${title}  ${confirmation}
    Go To Starting Page
    Handle Future Dialogs  ${confirmation}
    Click  xpath=//a[contains(., "${title}")]/preceding-sibling::form[1]//button
