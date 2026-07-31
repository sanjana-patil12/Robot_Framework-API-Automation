*** Settings ***

Documentation     Employee CRUD API Testing

Resource    ../resources/keywords.robot

Suite Setup    Create Employee Session

*** Test Cases ***

Verify Employee CRUD Operations

    Get All Employees

    Get Employee By ID    1

    Create Employee

    Update Employee

    Delete Employee