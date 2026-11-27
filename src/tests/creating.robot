*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser
Test Setup      Reset Database

*** Test Cases ***
Creating A Reference Succeeds
    Create Reference  example  Example Publication  Example Author  2026  Example Publisher
    Reference Should Be Created

Creating An Article Reference Succeeds
    Create Article Reference  example  Example Publication  Example Author  2026  Example Journal  Example Volume  Example Number
    Reference Should Be Created
    Article Reference Should Be Listed  Example Author  Example Publication  Example Journal  2026  Example Volume  Example Number

Invalid Article Reference Retains Entered Values
    Go To New Article Reference Page
    Fill In Article Reference Form  retained-article  Article With Invalid Year  Article Author  3000  Article Journal  Article Volume  Article Number
    Submit Reference
    Should Be Rejected With  Year cannot be in the future.
    Form Field Should Have Value  key  retained-article
    Form Field Should Have Value  title  Article With Invalid Year
    Form Field Should Have Value  author  Article Author
    Form Field Should Have Value  journal  Article Journal
    Form Field Should Have Value  year  3000
    Form Field Should Have Value  volume  Article Volume
    Form Field Should Have Value  number  Article Number

Invalid Book Reference Retains Entered Values
    Go To New Reference Page
    Fill In Reference Form  retained-book  Book With Invalid Year  Book Author  3000  Book Publisher
    Submit Reference
    Should Be Rejected With  Year cannot be in the future.
    Form Field Should Have Value  key  retained-book
    Form Field Should Have Value  title  Book With Invalid Year
    Form Field Should Have Value  author  Book Author
    Form Field Should Have Value  year  3000
    Form Field Should Have Value  publisher  Book Publisher

When Creating Duplicate Citation Keys Are Rejected
    Create Reference  duplicate  First Book  First Author  2020  Publisher
    Create Reference  duplicate  Second Book  Second Author  2021  Publisher
    Should Be Rejected With  This key already exists.
    Reference Count Should Be  1

When Creating Missing Required Fields Are Rejected
    FOR  ${field}  IN  key  title  author  year
        Go To New Reference Page
        Fill In Reference Form  key=missing-field  title=Example Book  author=Example Author  year=2020  publisher=Example Publisher
        Fill Text  id=${field}  ${EMPTY}
        Submit Reference
    END
    Reference Count Should Be  0

When Creating Years Longer Than Four Digits Are Rejected
    Create Reference  long-year  Book With Long Year  Example Author  12345  Example Publisher
    Should Be Rejected With  Year must be numbers and a maximum of 4 digits.
    Reference Count Should Be   0

When Creating Future Years Are Rejected
    Create Reference  future-year  Book From The Future  Example Author  3000  Example Publisher
    Should Be Rejected With  Year cannot be in the future.
    Reference Count Should Be  0

When Creating Negative Years Are Rejected
    Create Reference  negative-year  Book With Negative Year  Example Author  -1  Example Publisher
    Should Be Rejected With  Year cannot be negative.
    Reference Count Should Be  0

*** Keywords ***
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

Form Field Should Have Value
    [Arguments]  ${field}  ${expected}
    ${value}=  Get Attribute  id=${field}  value
    Should Be Equal  ${value}  ${expected}
