# Top Movies Web Application Automation Tests

This repository contains Robot Framework automation tests for the Top Movies web application (https://top-movies-qhyuvdwmzt.now.sh/).  These tests validate core functionalities such as movie listing, search, and detailed metadata display.

## Prerequisites

Before running the tests, ensure you have the following installed:

*   **Python:** Version 3.7 or higher is recommended.
*   **pip:** Python package installer.  Generally comes with Python.
*   **Robot Framework:**  Installed using `pip install robotframework`.
*   **SeleniumLibrary:** Installed using `pip install robotframework-seleniumlibrary`.
*   **WebDriver:** Download the appropriate WebDriver for your browser (e.g., ChromeDriver for Chrome, GeckoDriver for Firefox) and ensure it is in your system's PATH or specify the path in the test setup.  The current tests are configured for Chrome.

## Installation

1.  **Clone the repository:**

    ```bash
    git clone <repository_url>
    cd top-movies-automation
    ```

2.  **Create a virtual environment (optional but recommended):**

    ```bash
    python -m venv venv
    source venv/bin/activate  # On Linux/macOS
    venv\Scripts\activate  # On Windows
    ```

3.  **Install dependencies:**

    ```bash
    pip install -r robot/requirements.txt
    ```

## Configuration

*   **`robot/tests/top_movies.robot`:** This file contains the Robot Framework test cases.
*   **`robot/resources/common_keywords.robot`:** This file contains reusable keywords for browser interaction, element handling, and validation.
*   **Browser:** The tests are currently configured to use Chrome.  You can change the `BROWSER_TYPE` variable in `robot/tests/top_movies.robot` to use a different browser (e.g., `firefox`).  Make sure you have the appropriate WebDriver installed and configured.
*   **BASE_URL:** The tests are using the current URL of the app: https://top-movies-qhyuvdwmzt.now.sh/. You can change this directly in the Variables section of the robot file.

## Running the Tests

1.  **Navigate to the `robot` directory:**

    ```bash
    cd robot
    ```

2.  **Run the tests:**

    ```bash
    robot tests/top_movies.robot
    ```

    This will execute all test cases in the `top_movies.robot` file.

3.  **Run tests with specific tags:**

    ```bash
    robot --include smoke tests/top_movies.robot
    ```

    This will execute only the test cases tagged with `smoke`.  You can use `--exclude` to exclude tests with specific tags.

4.  **View the results:**  After the tests are complete, Robot Framework generates HTML reports and logs in the output directory.  Open `output.xml` or `log.html` for detailed results.

## Test Cases

The following test cases are included in the test suite:

*   **TC-001: Validate Movie List Display on Page Load:**  Verifies that movie tiles are displayed correctly upon initial page load.
*   **TC-002: Verify Shawshank Redemption Release Date:**  Validates the release date for "The Shawshank Redemption" in movie details.
*   **TC-003: Validate Search Functionality with Star Trek:** Verifies that searching for "Star Trek" returns relevant results and excludes irrelevant ones.
*   **TC-004: Verify Movie Details for Star Trek Into Darkness:** Validates detailed metadata (release date, popularity, vote average, and vote count) for "Star Trek Into Darkness".
*   **TC-005: Verify That Popularity is displayed with one decimal only** Validates that Popularity metadata field is displayed with one decimal only. This shows a bug that was present in the application. This test has been temporarily disabled.

## Test Tags

*   **smoke:** Smoke tests for basic functionality.
*   **regression:** Regression tests to ensure existing functionality is not broken.
*   **critical:** Critical tests that cover core features.
*   **ui:** User interface tests.
*   **data-validation:** Tests that validate data displayed in the application.
*   **search:** Tests related to search functionality.

## Potential Bugs & Testing Areas:

1.  Search Functionality:

    *   Bug 1 : Blank Result on Clear

        *   Description: As reported previously, entering a search term, then clearing the search box results in a blank page, instead of returning to the default listing or displaying a "no results" page. This bug still exists.
        *   Severity: Medium. Impacts usability.
        *   Repro Steps: Enter a search term. Observe results. Click "Clear" button (or equivalent). Page goes blank.

    *   Bug 2 : Special Character Search Disruption

        *   Description: Entering special characters can impact the ordering of results, as noted before. This likely still exists.
        *   Severity: Medium. Impacts relevancy.
        *   Repro Steps: Search "Star Trek". Search "Star Trek+". Compare Results.

    *   Bug 3 : Empty Search Handling:

        *   Description: Test what happens when the user clicks search with an empty search field. Does it throw an error? Does it do nothing? Does it return all movies? The expected behavior is returning all movies or displaying an empty display of the movies.
        *   Severity: Low-Medium depending on outcome.
        *   Repro Steps: Click the search button without entering any text in the search field.

    *   Bug 4 : Long Search Query:

        *   Description: Test with an extremely long search query (e.g., a paragraph of text). Does it break the search functionality? Is there a character limit?
        *   Severity: Low-Medium. Could lead to denial-of-service in extreme cases.
        *   Repro Steps: Enter a very long string of text into the search field.

    *   Bug 5 : Injection Vulnerability (Highly Unlikely on a Simple App, but Test):

        *   Description: Attempt to inject code (e.g., JavaScript or SQL, though SQL injection is less likely on a client-side application like this) into the search field. For example, `<script>alert('XSS')</script>`. This is a security concern.
        *   Severity: High if vulnerable.
        *   Repro Steps: Enter the above script into the search field and submit.

    *   Testing Recommendation: Implement robust unit tests for the search functionality, especially around query parsing and result filtering.

2.  UI/Display:

    *   Bug 6 : Movie Title Clickability:

        *   Description: The movie titles are not clickable. This reduces usability.
        *   Severity: Low-Medium. Impacts user experience.
        *   Repro Steps: Attempt to click on a movie title. Observe that it doesn't lead to a detail page.
        *   Recommendation: Make Movie titles clickable.

    *   Bug 7 : Placeholder text issue

        *   Description: The word "Search" should appear as a placeholder as reported before.
        *   Severity: Low. impacts visual polish
        *   Repro Steps: Go to the home page and observe that the word "Search" appears as text.

4.  Accessibility:

    *   Bug 13 : Total issues 25 issue. For more detials, please check the Accessibility folder
