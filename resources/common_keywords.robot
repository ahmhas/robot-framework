*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Wait Until Element Visible
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}

Click Element Safely
    [Arguments]    ${locator}
    Wait Until Element Visible    ${locator}
    Click Element    ${locator}