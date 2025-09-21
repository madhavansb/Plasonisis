from bs4 import BeautifulSoup

# Assuming html_content contains the HTML you provided

soup = BeautifulSoup(html_content, 'html.parser')

# --- Extracting the Ministry of Agriculture and Farmers Welfare section ---

# Find the specific h2 element with id="scheme-name-0"
scheme_name_0_h2 = soup.find('h2', id='scheme-name-0')

if scheme_name_0_h2:
    # The organization name is in the next sibling h2 element
    organization_h2 = scheme_name_0_h2.find_next_sibling('h2')
    if organization_h2:
        organization_name = organization_h2.text.strip()
        print(f"Organization Name: {organization_name}")

    # The description is within the span with class "line-clamp-2" inside a p tag
    description_span = scheme_name_0_h2.find_next_sibling('p').find('span', class_='line-clamp-2')
    if description_span:
        description = description_span.text.strip()
        print(f"Description: {description}")

# --- Extracting all "scheme" elements (if they are structured similarly) ---

# Find all div elements with class "article" and aria-labelledby starting with "scheme-name-"
scheme_articles = soup.find_all('div', class_='article', attrs={'aria-labelledby': lambda x: x and x.startswith('scheme-name-')})

print("\n--- All Scheme Articles ---")
for i, article in enumerate(scheme_articles):
    # The scheme name is typically associated with the aria-labelledby attribute
    # Let's try to find the h2 within the same 'flex' container as the article
    # This might require adjusting based on the full HTML structure
    scheme_id = article['aria-labelledby']
    scheme_name_tag = soup.find('h2', id=scheme_id)
    scheme_name = scheme_name_tag.text.strip() if scheme_name_tag else f"Scheme {i+1} Name Unknown"

    print(f"Scheme ID: {scheme_id}")
    print(f"Scheme Name: {scheme_name}")
    # You would add more specific selectors here to get other details within each scheme article
    # For example:
    # details = article.find('p', class_='some-detail-class')
    # if details:
    #    print(f"Details: {details.text.strip()}")
    print("-" * 20)