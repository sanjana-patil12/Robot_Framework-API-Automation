*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

Resource   common.robot

*** Keywords ***

Get All Employees

    ${response}=    GET On Session
    ...    ${SESSION}
    ...    /employees

    Log To Console    ${response.status_code}

    Log To Console    ${response.text}

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200

Get Employee By ID

    [Arguments]    ${id}

    ${response}=    GET On Session
    ...    ${SESSION}
    ...    /employee/${id}

    Log To Console    ${response.text}

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200

Create Employee

      # Read JSON payload
    ${body}=    Get File
    ...    ${CURDIR}/../payloads/CreateEmployee.json

    # Convert JSON string to Dictionary
    ${body}=    Evaluate
    ...    json.loads('''${body}''')
    ...    json

    # Request Headers
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json

    # Wait before sending POST request
    Sleep    5s

    # First Attempt
    ${response}=    POST On Session
    ...    ${SESSION}
    ...    /create
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Log To Console    Status Code: ${response.status_code}
    Log To Console    ${response.text}

    # Retry once if rate limited
    IF    ${response.status_code} == 429
        Log To Console    Too many requests received. Waiting 30 seconds before retry...
        Sleep    30s

        ${response}=    POST On Session
        ...    ${SESSION}
        ...    /create
        ...    json=${body}
        ...    headers=${headers}
        ...    expected_status=any

        Log To Console    Retry Status Code: ${response.status_code}
        Log To Console    ${response.text}
    END

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200

    ${json}=    Evaluate
    ...    $response.json()

    ${id}=    Set Variable
    ...    ${json["data"]["id"]}

    Set Suite Variable
    ...    ${EMPLOYEE_ID}
    ...    ${id}

    Log To Console    Employee Created Successfully
    Log To Console    Employee ID: ${EMPLOYEE_ID}




Update Employee

    ${body}=    Get File
    ...    ${CURDIR}/../payloads/UpdateEmployee.json

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json

    ${response}=    PUT On Session
    ...    ${SESSION}
    ...    /update/${EMPLOYEE_ID}
    ...    data=${body}
    ...    headers=${headers}

    Log To Console    ${response.text}

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200

Delete Employee

    ${response}=    DELETE On Session
    ...    ${SESSION}
    ...    /delete/${EMPLOYEE_ID}

    Log To Console    ${response.text}

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200