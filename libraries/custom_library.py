from robot.api.deco import keyword
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class CustomLibrary:
    ROBOT_LIBRARY_SCOPE = 'TEST'

    def __init__(self):
        self.driver = None

    @keyword("Set WebDriver")
    def set_webdriver(self, driver):
        """Sets the Selenium WebDriver instance"""
        self.driver = driver

    @keyword("Wait For Element Text")
    def wait_for_element_text(self, locator, expected_text, timeout=10):
        """Waits until element contains expected text"""
        WebDriverWait(self.driver, timeout).until(
            EC.text_to_be_present_in_element((By.ID, locator), expected_text)
        )

    @keyword("Get Element Count")
    def get_element_count(self, locator):
        """Returns the number of elements matching the locator"""
        elements = self.driver.find_elements(By.XPATH, locator)
        return len(elements)