#!/usr/bin/env python3
"""
Selenium test script for DevOps Assignment Django app
Tests login, register, and home page functionality
"""

import time
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException

class DjangoAppTest(unittest.TestCase):
    def setUp(self):
        """Set up Chrome driver with headless options"""
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920,1080")
        
        self.driver = webdriver.Chrome(options=chrome_options)
        self.wait = WebDriverWait(self.driver, 10)
        self.base_url = "http://localhost:8000"
    
    def tearDown(self):
        """Close the browser"""
        self.driver.quit()
    
    def test_register_new_user(self):
        """Test user registration functionality"""
        print("Testing user registration...")
        
        # Navigate to register page
        self.driver.get(f"{self.base_url}/register/")
        
        # Fill registration form
        username_field = self.wait.until(
            EC.presence_of_element_located((By.NAME, "username"))
        )
        password_field = self.driver.find_element(By.NAME, "password")
        
        username_field.send_keys("ITA737")
        password_field.send_keys("2022PE0000")
        
        # Submit form
        submit_button = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        submit_button.click()
        
        # Check if redirected to login page
        self.wait.until(EC.url_contains("/"))
        self.assertIn("login", self.driver.current_url)
        print("✓ Registration successful")
    
    def test_login_functionality(self):
        """Test user login functionality"""
        print("Testing user login...")
        
        # Navigate to login page
        self.driver.get(f"{self.base_url}/")
        
        # Fill login form
        username_field = self.wait.until(
            EC.presence_of_element_located((By.NAME, "username"))
        )
        password_field = self.driver.find_element(By.NAME, "password")
        
        username_field.send_keys("ITA737")
        password_field.send_keys("2022PE0000")
        
        # Submit form
        submit_button = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        submit_button.click()
        
        # Check if redirected to home page
        self.wait.until(EC.url_contains("/home/"))
        self.assertIn("home", self.driver.current_url)
        print("✓ Login successful")
    
    def test_home_page_display(self):
        """Test home page displays correct username"""
        print("Testing home page display...")
        
        # First login
        self.driver.get(f"{self.base_url}/")
        username_field = self.wait.until(
            EC.presence_of_element_located((By.NAME, "username"))
        )
        password_field = self.driver.find_element(By.NAME, "password")
        
        username_field.send_keys("ITA737")
        password_field.send_keys("2022PE0000")
        
        submit_button = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        submit_button.click()
        
        # Check home page content
        self.wait.until(EC.url_contains("/home/"))
        
        # Verify username is displayed
        page_source = self.driver.page_source
        self.assertIn("Hello ITA737", page_source)
        self.assertIn("How are you", page_source)
        print("✓ Home page displays correct username")
    
    def test_logout_functionality(self):
        """Test logout functionality"""
        print("Testing logout...")
        
        # First login
        self.driver.get(f"{self.base_url}/")
        username_field = self.wait.until(
            EC.presence_of_element_located((By.NAME, "username"))
        )
        password_field = self.driver.find_element(By.NAME, "password")
        
        username_field.send_keys("ITA737")
        password_field.send_keys("2022PE0000")
        
        submit_button = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        submit_button.click()
        
        # Wait for home page
        self.wait.until(EC.url_contains("/home/"))
        
        # Click logout
        logout_link = self.wait.until(
            EC.element_to_be_clickable((By.LINK_TEXT, "Logout"))
        )
        logout_link.click()
        
        # Check if redirected to login page
        self.wait.until(EC.url_contains("/"))
        self.assertIn("login", self.driver.current_url)
        print("✓ Logout successful")
    
    def test_navigation_links(self):
        """Test navigation between login and register pages"""
        print("Testing navigation links...")
        
        # Start at login page
        self.driver.get(f"{self.base_url}/")
        
        # Click register link
        register_link = self.wait.until(
            EC.element_to_be_clickable((By.LINK_TEXT, "Register"))
        )
        register_link.click()
        
        # Verify on register page
        self.wait.until(EC.url_contains("/register/"))
        self.assertIn("register", self.driver.current_url)
        
        # Click login link
        login_link = self.wait.until(
            EC.element_to_be_clickable((By.LINK_TEXT, "Login"))
        )
        login_link.click()
        
        # Verify back on login page
        self.wait.until(EC.url_contains("/"))
        self.assertIn("login", self.driver.current_url)
        print("✓ Navigation links working correctly")

def run_tests():
    """Run all tests and print results"""
    print("🚀 Starting Selenium tests for DevOps Assignment Django app...")
    print("=" * 60)
    
    # Create test suite
    suite = unittest.TestLoader().loadTestsFromTestCase(DjangoAppTest)
    
    # Run tests
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    print("=" * 60)
    if result.wasSuccessful():
        print("🎉 All tests passed!")
        return True
    else:
        print(f"❌ {len(result.failures)} test(s) failed, {len(result.errors)} error(s)")
        return False

if __name__ == "__main__":
    success = run_tests()
    exit(0 if success else 1)
