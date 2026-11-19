*** Settings ***
Resource  resource.robot
Suite Setup     Open And Configure Browser
Suite Teardown  Close Browser

*** Test Cases ***
Creating A Reference Succeeds
    Go To New Reference Page
    Fill In Reference Form  key=example  title=Example Book  author=Example Author  year=2026
    Submit Reference
    Reference Should Be Created
