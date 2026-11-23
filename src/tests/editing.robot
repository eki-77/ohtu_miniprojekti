*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
Editing A Reference Updates Its Details
    Create Reference  example  Example Book  Example Author  2020  Example Publisher
    Edit Reference  Example Book  Updated Book  Updated Author  2021  Updated Publisher
    Page Should Contain  Reference updated successfully.
    Reference Details Should Be Listed  Updated Author  Updated Book  Updated Publisher  2021
    Page Should Not Contain  Example Book

Editing Can Remove The Optional Publisher
    Create Reference  example  Example Book  Example Author  2020  Example Publisher
    Edit Reference  Example Book  Example Book  Example Author  2020  ${EMPTY}
    Reference Details Should Be Listed  Example Author  Example Book
    Page Should Not Contain  Example Publisher

Editing Can Keep The Existing Citation Key
    Create Reference  example  Example Book  Example Author  2020  Publisher
    Edit Reference  Example Book  Updated Book  Example Author  2021  Publisher
    Reference Details Should Be Listed  Example Author  Updated Book  Publisher  2021
    Reference Count Should Be  1

Editing Rejects Duplicate Citation Keys
    Create Reference  first  First Book  First Author  2020  Publisher
    Create Reference  second  Second Book  Second Author  2021  Publisher
    Edit Reference  Second Book  Changed Book  Second Author  2021  Publisher  first
    Page Should Contain  This key already exists.
    Reference Details Should Be Listed  Second Author  Second Book  Publisher  2021

Editing Rejects Invalid Years
    Create Reference  example  Example Book  Example Author  2020  Publisher
    FOR  ${year}  ${error}  IN
    ...  12345  Year must be numbers and a maximum of 4 digits.
    ...  3000   Year cannot be in the future.
    ...  -1     Year cannot be negative.
        Edit Reference  Example Book  Updated Book  Example Author  ${year}  Publisher
        Page Should Contain  ${error}
        Reference Details Should Be Listed  Example Author  Example Book  Publisher  2020
    END

*** Keywords ***
Create Reference
    [Arguments]  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Go To New Reference Page
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Submit Reference

Edit Reference
    [Arguments]  ${original_title}  ${title}  ${author}  ${year}  ${publisher}  ${key}=example
    Go To Starting Page
    Click  text=${original_title}
    Fill In Reference Form  ${key}  ${title}  ${author}  ${year}  ${publisher}
    Click  text="Proceed with changes"

Page Should Contain
    [Arguments]  ${expected}
    ${page}=  Get Text  body
    Should Contain  ${page}  ${expected}

Page Should Not Contain
    [Arguments]  ${unexpected}
    ${page}=  Get Text  body
    Should Not Contain  ${page}  ${unexpected}

Reference Details Should Be Listed
    [Arguments]  ${author}  ${title}  ${publisher}=${EMPTY}  ${year}=2020
    Go To Starting Page
    Page Should Contain  ${author}.
    Page Should Contain  ${title}
    Page Should Contain  ${year}
    IF  $publisher != ''
        Page Should Contain  ${publisher}
    END

Reference Count Should Be
    [Arguments]  ${count}
    Go To Starting Page
    Page Should Contain  Current references count: ${count}
