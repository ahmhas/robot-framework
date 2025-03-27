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

## GitLab CI (Optional)

A `.gitlab-ci.yml` file is provided for running the tests automatically in a GitLab CI/CD pipeline. This file defines the stages (e.g., test) and jobs required to execute the tests.  To use this, you need a GitLab repository and a runner configured to execute Robot Framework tests.

**Example `.gitlab-ci.yml`:**

```yaml
stages:
  - test

test:
  image: python:3.9
  services:
    - selenium/standalone-chrome:latest  # Or Firefox
  before_script:
    - pip install -r robot/requirements.txt
    - apt-get update -yq
    - apt-get install -yq chromium-driver
  script:
    - robot robot/tests/top_movies.robot
  artifacts:
    paths:
      - robot/output.xml
      - robot/log.html
    expire_in: 1 week
