*** Settings ***
Library    RequestsLibrary

Resource   ../variables/Variables.robot

*** Keywords ***

Create Employee Session

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    User-Agent=Chrome/ 151.0.7922.72

    Create Session
    ...    ${SESSION}
    ...    ${BASE_URL}
    ...    headers=${headers}
    ...    verify=${False}

    Log To Console    API Session Created Successfully