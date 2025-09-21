from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
import time
import mysql.connector
from selenium.common.exceptions import NoSuchElementException

# -------- MySQL Connection --------
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="plasonisis"
)
cursor = db.cursor()
print("Connected to MySQL")

# -------- Selenium Setup --------
website = 'https://enam.gov.in/web/dashboard/trade-data'
service = Service(executable_path="/usr/local/bin/chromedriver")
driver = webdriver.Chrome(service=service)
driver.get(website)
time.sleep(5)

# Click Daily Prices and Refresh
try:
    driver.find_element(By.XPATH, '//option[@value="509"]').click()
    print("Clicked on Daily Prices")
except NoSuchElementException:
    print("Daily Prices menu not found")

try:
    driver.find_element(By.XPATH, '//input[@value="Refresh"]').click()
    print("Clicked on Refresh")
except NoSuchElementException:
    print("Refresh button not found")

time.sleep(5)

# -------- Scrape data with dynamic pagination --------
all_commodity_data = []
page_number = 1

while True:
    print(f"\n--- Scraping Page {page_number} ---")
    time.sleep(2)

    rows = driver.find_elements(By.TAG_NAME, 'tr')
    page_rows_scraped = 0
    for row in rows:
        cells = row.find_elements(By.TAG_NAME, 'td')
        if len(cells) == 10:
            commodity_info = {
                'state': cells[0].text,
                'apmc': cells[1].text,
                'commodity': cells[2].text,
                'min_price': int(cells[3].text.replace(',', '') or 0),
                'modal_price': int(cells[4].text.replace(',', '') or 0),
                'max_price': int(cells[5].text.replace(',', '') or 0),
                'commodity_arrivals': int(cells[6].text.replace(',', '') or 0),
                'commodity_traded': int(cells[7].text.replace(',', '') or 0),
                'unit': cells[8].text,
                'date': cells[9].text,
            }
            all_commodity_data.append(commodity_info)
            page_rows_scraped += 1

    print(f"Page {page_number} scraped: {page_rows_scraped} rows.")

    # Try to go to next page
    try:
        dropdown_box = driver.find_element(By.ID, "min_max_no_of_list")
        dropdown_box.click()
        time.sleep(1)
        option = driver.find_element(By.XPATH, f"//select[@id='min_max_no_of_list']/option[@value='{page_number}']")
        option.click()
        page_number += 1
        time.sleep(3)
    except NoSuchElementException:
        print("No more pages found, finishing scrape.")
        break

print(f"\nTotal records scraped: {len(all_commodity_data)}")

# -------- Insert into MySQL --------
if all_commodity_data:
    insert_query = """
    INSERT INTO daily_prices
    (state, apmc, commodity, min_price, modal_price, max_price, commodity_arrivals, commodity_traded, unit, date)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    for item in all_commodity_data:
        cursor.execute(insert_query, (
            item['state'], item['apmc'], item['commodity'], item['min_price'],
            item['modal_price'], item['max_price'], item['commodity_arrivals'],
            item['commodity_traded'], item['unit'], item['date']
        ))
    db.commit()
    print("Data inserted into MySQL table 'daily_prices'.")

# Clean up
driver.quit()
cursor.close()
db.close()
print("Scraper finished.")
