# Mini Address Book App - Fullstack App
Python(Flask) + HTML/CSS + MySQL

## Overview

This is a simple address book application. 

 - **Frontend:** HTML with Bootstrap
 - **Backend:** Flask
 - **Database:** MySQL
 - **ORM:** SQLAlchemy
 - **Envvironemnt Variables/Sensitive Data:** dotenv


## Project Structure

Here’s the folder structure for the app:

```
address-book-python/
│
├── app/
│   ├── __init__.py             # Flask app and configuration setup
│   ├── config.py               # Configuration file (DB details, hidden using .env)
│   ├── models.py               # Database schema
│   ├── routes.py               # Routes for input and display pages
│   ├── templates/              # HTML templates for the app
│   │   ├── base.html           # Base template with navigation bar
│   │   ├── form.html           # Input form template
│   │   └── display.html        # Display template for submitted data
│   ├── static/                 # Static files (e.g., CSS)
│   │   └── style.css           # Custom styles for the app
│
├── venv/                       # Virtual environment folder
├── .env                        # Environment variables (e.g., DB password)
├── requirements.txt            # Dependencies for the project
├── run.py                      # Main entry point to run the Flask app
└── schema.sql                  # SQL script for creating the database and tables

```

## Detailed Steps:
1. **Install MySQL database to your machine**:
 - Install Python to your machine
 - Download and install mysql using the following credentials: 
   root/Pa55word

```bash
$ python3
Python 3.11.1 (v3.11.1:a7a450f84a, Dec  6 2022, 15:24:06) [Clang 13.0.0 (clang-1300.0.29.30)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> exit()
```

2. **Create the database**:
```bash
$ mysql -u root -p < schema.sql
```
Subsequently, you only need to ensure that the mysql service is up and running.

3. **Run the App**:
```bash
# Ensure you are in the project root folder
cd devboot02-ab

# Create a virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows use venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the Flask App
python run.py
```

Your Address Book app should now be accessible at `http://127.0.0.1:5000`, with a navigation bar to add and view contacts!

Type "exit" to quit the python development server
```bash
exit
```