*** Settings ***
Documentation    Test suite for validating core functionalities of the Top Movies web application.
...              This suite ensures movie listing, search, and detailed metadata display operate as expected.
Library          SeleniumLibrary    timeout=5    implicit_wait=2    run_on_failure=Capture Page Screenshot
Suite Setup      Initialize Browser Session
Suite Teardown   Terminate Browser Session
Resource         ../resources/common_keywords.robot

*** Variables ***
${BASE_URL}           https://top-movies-qhyuvdwmzt.now.sh/
${BROWSER_TYPE}       chrome
${SEARCH_FIELD}       xpath://*/input[@type='search']
${MOVIE_TILE}         xpath://div[contains(@class, 'movie-card')]
${LEARN_MORE_BTN}     xpath://span[@class='jss95'][text()='Learn More']
${CLOSE_MODAL_BTN}    xpath://*[contains(text(), 'Close')]
${RELEASE_DATE_LBL}   xpath://label[contains(text(), 'Released on')]/following-sibling::div//input
${POPULARITY_LBL}     xpath://label[contains(text(), 'Popularity')]/following-sibling::div//input
${VOTE_AVG_LBL}       xpath://label[contains(text(), 'Vote average')]/following-sibling::div//input
${VOTE_COUNT_LBL}     xpath://label[contains(text(), 'Vote count')]/following-sibling::div//input
${RELEASE_TEXT}       xpath://*[contains(text(), 'Released on')]

*** Test Cases ***
TC-001: Validate Movie List Display on Page Load
    [Tags]    smoke    critical    ui
    [Documentation]    Ensures movie tiles are rendered correctly upon initial page load.
    Wait Until Page Contains Element    ${MOVIE_TILE}    timeout=10s
    ${tile_count}=    Get Element Count    ${MOVIE_TILE}
    Should Be True    ${tile_count} > 19    msg=Expected at least 20 movie tiles, found ${tile_count}

TC-002: Verify Shawshank Redemption Release Date
    [Tags]    regression    data-validation
    [Documentation]    Validates the release date for "The Shawshank Redemption" in movie details.
    Open Movie Details    index=1
    ${release_date}=    Get Element Attribute    ${RELEASE_DATE_LBL}    value
    Log    Release Date Retrieved: ${release_date}    level=INFO
    Should Be Equal As Strings    ${release_date}    1994-09-23    msg=Incorrect release date for Shawshank Redemption
    Close Movie Details

TC-003: Validate Search Functionality with Star Trek
    [Tags]    regression    search    ui
    [Documentation]    Verifies that searching for "Star Trek" returns relevant results.
    Perform Search    query=Star Trek
    Wait Until Page Contains    Star Trek: Section 31    timeout=10s
    Page Should Contain    Star Trek: Section 31    msg=Expected Star Trek: Section 31 not found in search results
    Page Should Not Contain    The Shawshank Redemption    msg=Unexpected movie found in search results

TC-004: Verify Movie Details for Star Trek Into Darkness
    [Tags]    regression    data-validation    ui
    [Documentation]    Validates detailed metadata for "Star Trek Into Darkness".
    Open Movie Details    index=3
    Validate Movie Metadata    release_date=2013-05-05    popularity=5.2502    vote_average=7.322    vote_count=9194
    Close Movie Details

*** Keywords ***
Initialize Browser Session
    [Documentation]    Sets up the browser session with the specified URL and configurations.
    Open Browser    ${BASE_URL}    ${BROWSER_TYPE}
    Maximize Browser Window
    Wait Until Page Contains    Top Movies    timeout=10s
    Log    Browser session initialized successfully    level=INFO

Terminate Browser Session
    [Documentation]    Gracefully terminates all open browser instances.
    Close All Browsers
    Log    Browser session terminated    level=INFO

Open Movie Details
    [Documentation]    Opens the movie details modal for the specified movie index.
    [Arguments]    ${index}
    ${learn_more_locator}=    Set Variable    xpath:(//span[@class='jss95'][text()='Learn More'])[${index}]
    Wait Until Element Is Visible    ${learn_more_locator}    timeout=10s
    Click Element Safely    ${learn_more_locator}
    Wait Until Element Is Visible    ${CLOSE_MODAL_BTN}    timeout=7s
    Wait Until Element Is Visible    ${RELEASE_TEXT}    timeout=5s

Close Movie Details
    [Documentation]    Closes the movie details modal.
    Wait Until Element Is Visible    ${CLOSE_MODAL_BTN}    timeout=7s
    Click Element Safely    ${CLOSE_MODAL_BTN}
    Wait Until Element Is Not Visible    ${CLOSE_MODAL_BTN}    timeout=5s

Perform Search
    [Documentation]    Executes a search query in the search field.
    [Arguments]    ${query}
    Wait Until Element Is Visible    ${SEARCH_FIELD}    timeout=10s
    Click Element Safely    ${SEARCH_FIELD}
    Input Text    ${SEARCH_FIELD}    ${query}
    Press Keys    ${SEARCH_FIELD}    ENTER
    Sleep    2s    # Allow search results to load reliably

Validate Movie Metadata
    [Documentation]    Validates multiple metadata fields for a movie.
    [Arguments]    ${release_date}    ${popularity}    ${vote_average}    ${vote_count}
    ${actual_release}=    Get Element Attribute    ${RELEASE_DATE_LBL}    value
    ${actual_popularity}=    Get Element Attribute    ${POPULARITY_LBL}    value
    ${actual_vote_avg}=    Get Element Attribute    ${VOTE_AVG_LBL}    value
    ${actual_vote_count}=    Get Element Attribute    ${VOTE_COUNT_LBL}    value
    Log    Metadata - Release: ${actual_release}, Popularity: ${actual_popularity}, Vote Avg: ${actual_vote_avg}, Vote Count: ${actual_vote_count}    level=INFO
    Should Be Equal As Strings    ${actual_release}    ${release_date}    msg=Release date mismatch
    Should Be Equal As Strings    ${actual_popularity}    ${popularity}    msg=Popularity mismatch
    Should Be Equal As Strings    ${actual_vote_avg}    ${vote_average}    msg=Vote average mismatch
    Should Be Equal As Strings    ${actual_vote_count}    ${vote_count}    msg=Vote count mismatch

Click Element Safely
    [Documentation]    Safely clicks an element after ensuring it is visible and interactable.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Wait Until Element Is Enabled    ${locator}    timeout=10s
    Click Element    ${locator}