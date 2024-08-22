# sql-chatbot

This project implements an AI-powered chatbot capable of interacting with a local SQLite database using natural language queries. The chatbot leverages LangChain, Hugging Face embeddings, and Gradio for the user interface. The chatbot processes user questions, generates corresponding SQL queries, validates them, and returns results in a user-friendly format.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Detailed Implementation](#detailed-implementation)
- [Examples](#examples)


  
## Features

- **Natural Language Processing**: Converts user questions into SQL queries using LangChain's large language models.
- **Database Interaction**: Directly interacts with an SQLite database, running queries and returning results.
- **Validation**: Automatically validates SQL queries before execution to prevent errors.
- **Customizable**: Easily extend the example queries and prompts for different databases or use cases.
- **User-Friendly Interface**: Simple and interactive interface built with Gradio.

## Installation

To set up and run this project, follow the steps below:

### Prerequisites

​	•	Python 3.8 or higher

​	•	SQLite database (chinook.db)

​	•	Jupyter Notebook

### Clone the Repository

```bash
git clone https://github.com/yourusername/sql-chatbot.git
cd sql-chatbot
```

### Install Required Python Packages

```bash
pip install langchain_ollama langchain langchain_community pyodbc mssql langchain_huggingface faiss-cpu gradio
```

### Environment Setup

Ensure you have the following environment variables set in your environment:

```bash
export LANGCHAIN_API_KEY="your_langchain_api_key"
export LANGCHAIN_TRACING_V2="true"
export LANGCHAIN_PROJECT="Local SQL Agent"
export LANGCHAIN_ENDPOINT="https://api.smith.langchain.com"
export TOKENIZERS_PARALLELISM="false"
```

Replace `your_langchain_api_key` with your actual LangChain API key.

### Database Setup

Ensure you have the `chinook.db` SQLite database file and the `chinook.sql` script. The `chinook.sql` script is used to create the necessary tables and populate the database.

### Running the Application

After setting up the environment and database, open the SQL_Chatbot.ipynb Jupyter Notebook in your preferred environment (e.g., Jupyter Notebook, JupyterLab, or VSCode).

Run all cells in the notebook to start the Gradio interface. You will be able to interact with the chatbot directly from the notebook.

## Usage

Once the Gradio interface is up and running, you can interact with the chatbot by entering questions about the database in natural language. The chatbot will process the input, generate the SQL query, execute it, and return the results.

### Example Questions:

- "List all artists."
- "Find all albums for the artist 'AC/DC'."
- "How many tracks are there in the album with ID 5?"
- "Who are the top 5 customers by total purchase?"

## Project Structure

```plaintext
sql-chatbot/
├── chinook.db                # SQLite database file
├── chinook.sql               # SQL script to set up the database
├── SQL_Chatbot.ipynb         # Main application code in Jupyter Notebook format
├── README.md                 # Project documentation
└── requirements.txt          # Python package requirements
```

## How It Works

### 1. Environment Setup

The project initializes environment variables for LangChain API access and configures the LLM model using LangChain's `ChatOllama`.

### 2. Database Setup

The SQLite database is set up by executing an SQL script that creates the necessary tables and populates them with data.

### 3. Query Generation

The core functionality involves converting user input into SQL queries using LangChain's prompt templates and large language models. Example queries are provided to guide the model in generating accurate SQL queries.

### 4. Query Validation and Execution

Before executing the SQL query, the system validates it to ensure correctness. If validation fails, it retries a few times before aborting. Upon successful validation, the query is executed, and the results are returned.

### 5. User Interface

The Gradio interface provides a user-friendly way to interact with the system. Users can type in questions, and the chatbot responds with the corresponding results from the database.

## Detailed Implementation

### 1. Setting Up the SQLite Database

The project begins by setting up the SQLite database. The `setup_sqlite_db` function is responsible for creating the database and populating it with data from an SQL script. This function connects to the database file `chinook.db` and executes the SQL script `chinook.sql`, which contains the necessary commands to create tables and insert data. After executing the script, the function verifies the creation of tables by querying the SQLite master table.

```python
def setup_sqlite_db(db_path='chinook.db', sql_script_path='chinook.sql'):
    conn = sqlite3.connect(db_path)
    with open(sql_script_path, 'r') as file:
        sql_script = file.read()
    cursor = conn.cursor()
    cursor.executescript(sql_script)
    conn.commit()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    print("Tables in the database:", tables)
    return conn
```

### 2. Creating the SQLDatabase Object

The project uses LangChain's `SQLDatabase` utility to interact with the SQLite database. The `SQLDatabase.from_uri` method is used to create a `db` object, which provides an interface to the SQLite database. This object is used by various LangChain tools to execute SQL queries and retrieve information.

```python
database_path = 'chinook.db'
connection_url = f"sqlite:///{database_path}"
db = SQLDatabase.from_uri(connection_url, sample_rows_in_table_info=3)
```

### 3. Setting Up Embeddings and Example Selector

To help the model understand and generate SQL queries, the project uses Hugging Face embeddings and FAISS for semantic similarity search. The `SemanticSimilarityExampleSelector` is configured with example queries, allowing the model to select relevant examples based on user input.

```python
embeddings = HuggingFaceEmbeddings(model_name='sentence-transformers/all-MiniLM-L6-v2')
example_selector = SemanticSimilarityExampleSelector.from_examples(
    examples,
    embeddings,
    FAISS,
    k=2,
    input_keys=["input"],
)
```

### 4. Defining System Prompt Templates

The system prompt templates guide the model in generating SQL queries. The `dynamic_few_shot_prompt` is created using LangChain's `FewShotPromptTemplate`, which dynamically selects examples based on the user's question. This prompt is then integrated into a full chat prompt template using `ChatPromptTemplate`.

```python
dynamic_few_shot_prompt = FewShotPromptTemplate(
    example_selector=example_selector,
    example_prompt=PromptTemplate.from_template("User input: {input}\nSQL query: {query}"),
    input_variables=["input"],
    prefix=system_prefix,
    suffix=""
)

full_prompt = ChatPromptTemplate.from_messages(
    [
        SystemMessagePromptTemplate(prompt=dynamic_few_shot_prompt),
        ("human", "{input}"),
        ("system", "{agent_scratchpad}"),
    ]
)
```

### 5. Tool Creation and Query Execution

LangChain tools like `QuerySQLDataBaseTool`, `InfoSQLDatabaseTool`, `ListSQLDatabaseTool`, and `QuerySQLCheckerTool` are created using the `db` object. These tools are used to validate and execute SQL queries. The project includes utility functions like `check_sql_query` and `execute_sql_query` to handle query validation and execution.

```python
tools = [
    QuerySQLDataBaseTool(db=db),
    InfoSQLDatabaseTool(db=db),
    ListSQLDatabaseTool(db=db),
    QuerySQLCheckerTool(db=db, llm=llm)
]

def check_sql_query(query, max_retries=3):
    # Validation logic
    ...

def execute_sql_query(query):
    # Execution logic
    ...
```

### 6. Processing User Input

The `process_prompt` function is the core of the interaction logic. It takes user input, generates an SQL query using the `full_prompt`, validates the query, and executes it. The function handles errors gracefully and ensures that only valid queries are executed.

```python
def process_prompt(input_question):
    # Processing logic
    ...
```

### 7. Gradio Interface Setup

Finally, the project sets up a Gradio interface to interact with the user. The `respond` function processes the user's input and returns the response in a format suitable for display in the chatbot. The interface is launched using Gradio's `Blocks` API, making it accessible via a web browser.

```python
def respond(message):
    # Gradio interaction logic
    ...

with gr.Blocks() as demo:
    chatbot = gr.Chatbot()
    msg = gr.Textbox(label="Your Question", placeholder="Ask your database a question...")
    clear = gr.ClearButton([msg, chatbot])
    msg.submit(respond, [msg], chatbot)

demo.launch(share=True)
```



## Examples

Here are some example interactions:
<img width="1481" alt="image" src="https://github.com/user-attachments/assets/9e069016-ea76-488e-be23-0ae82bb2781e">
<img width="1482" alt="image" src="https://github.com/user-attachments/assets/8f9280b1-cf3f-41a8-9b7a-0eb8bfd7dfb1">
<img width="1480" alt="image" src="https://github.com/user-attachments/assets/67e06ba6-ec5a-4a7c-be45-bff16e9b3900">




