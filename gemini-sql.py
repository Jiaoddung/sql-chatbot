import pymssql
import google.generativeai as genai

# Database connection parameters
server = 'ahsxsp01.database.windows.net'
database = 'dps-make-output'
username = 'SA-ITS-AHSXSP01-DPSMAKEREAD'
password = 'z-iyXzX9MK'



def execute_sql_query(query):
    try:
        connection = pymssql.connect(server, username, password, database)
        cursor = connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        connection.close()
        return results
    except pymssql.InterfaceError as ex:
        print(f"Connection failed: {ex}")
        return None
    except pymssql.DatabaseError as ex:
        print(f"Database error: {ex}")
        return None

# Function to generate an SQL query from a user question using LLaMA through LangChain
def generate_sql_query(question):
    # Define the prompt template
    prompt_template = f"""
I have two tables: dbo.dpm_raynham_detail_scrap_units and dbo.dpm_raynham_targets_scrap_units.

The table dbo.dpm_raynham_detail_scrap_units has the following columns:
- KPI_Name: In all cases it is Financial Scrap (Units).
- Site: The specific location or site where the scrap(units) were made.
- Date: The date when the scrap(units) were made.
- Week: The week number within the year when the scrap(units) were made.
- Month: The month when the scrap(units) were made, represented as a numeric value.
- StandardDate: A standardized date format for consistency in date comparisons or calculations, which represented the date when the scrap(units) were made.
- ValueStream: The specific production line of the scrap(units).
- Material: The type of material involved in the production process.
- [Order]: The production order with the recorded data.
- MRP: Material Requirements Planning identifier.
- Value: The number of the Scrap (Units).

Sample data from dbo.dpm_raynham_detail_scrap_units:
[
  {{
    "KPI_Name": "Financial Scrap (Units)",
    "Site": "Raynham",
    "Date": "20230501",
    "Week": "202318",
    "Month": "202305",
    "StandardDate": "05/01/2023",
    "ValueStream": "Machine Room",
    "Material": "152020208",
    "[Order]": 11131175,
    "MRP": "DE6",
    "Value": 1.0
  }}
]

The table dbo.dpm_raynham_targets_scrap_units has the following columns:
- TargetType: The type of target being set (daily, weekly, or monthly).
- Year: The year for when the scrap(units) were made.
- Month: The month when the scrap(units) were made, represented as a numeric value.
- Week: The week number within the year for which the target is set.
- Date: The date when the scrap(units) were made.
- ValueStream: The specific production line of the scrap(units).
- Target: The numerical target value for the scrap(units).

Sample data from dbo.dpm_raynham_targets_scrap_units:
[
  {{
    "TargetType": "Weekly",
    "Year": "2024",
    "Month": 202412,
    "Week": "202449",
    "Date": "20241202",
    "ValueStream": "Other",
    "Target": 0.9090909090909092
  }}
]

Generate an SQL query based on the following question: '{question}'

Important notes:
- If filtering by month, use the Month column.
- Ensure the query properly joins the tables if needed.
- Use SQL Server compatible functions and syntax.
- To get the current date in SQL Server, use GETDATE().
- To subtract a day from the current date, use DATEADD(day, -1, GETDATE()).
- Convert datetime to date using CONVERT(DATE, ...).
- Format the output as a valid SQL query.
- Only include the SQL query in the response.
- Escape reserved keywords like '[Order]' using square brackets.
- If there is a specific date, use that specific date for time filtering.
- If year is not specified, always use the current year.
"""
    try:
        # Enter API Key
        genai.configure(api_key="")
        model = genai.GenerativeModel('gemini-1.5-flash')
        raw_response = model.generate_content(prompt_template)
        sql_query = raw_response.text.strip()
        return sql_query

    except Exception as e:
        print(f"Error occurred: {e}")
        return None

# Function to generate a natural language response from query results
def generate_natural_language_response(question, results):
    if not results:
        return "No data found for your query."

    response = f"Based on your question '{question}', here are the results:\n\n"
    for row in results:
        response += " | ".join(str(item) for item in row) + "\n"
    
    return response

# Chatbot function to handle user input
def chatbot():
    user_question = input("Please enter your question: ")
    sql_query = generate_sql_query(user_question)
    
    if sql_query:
        print(f"Generated SQL Query: {sql_query}")
        results = execute_sql_query(sql_query)
        
        if results:
            natural_language_response = generate_natural_language_response(user_question, results)
            print("Natural Language Response:")
            print(natural_language_response)
        else:
            print("Failed to execute SQL Query or no results found.")
    else:
        print("Failed to generate SQL Query.")

# Run the chatbot
if __name__ == "__main__":
    chatbot()


# How many scrap units were produced in June at Raynham site?
