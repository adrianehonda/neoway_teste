Feature: As a user,
         I want to upload files and search for book titles,         
         So that I can easily access and manage mu data.

Scenario Outline: Reading a valid file
  Given the user has a valid file
    And the file is in the format <format> 
  When the user sends the file
  Then the application should read the file successfully
    And the application should display the API response
    And the application should display the confirmation message

  Examples:
    | format |
    | CSV    |
    | XLSX   |
    | PDF    |

Scenario Outline: Reading an invalid file
  Given the user has a <problem> file
  When the user uploads the file
  Then the application should display an error message indicating the issue

  Examples:
    | problem   |
    | empty     |
    | malformed |

Scenario: Uploading a file with an unsupported format
  Given the user has a file in an unsupported format
  When the user uploads the file
  Then the application should display an error message indicating that the file type is not supported

Scenario: Validating the structure and format of the file
  Given the user uploads a file
  Then the file should contain the mandatory data 
    And the file should contain the correct structure

Scenario: Uploading a file that exceeds the size limit
  Given the user has a file that exceeds the maximum size limit
  When the user uploads the file
  Then the application should display an error message indicating that the file is too large

Scenario: Canceling the file upload
  Given the user has a valid file
  When the user chooses to cancel the upload
  Then the application should not process the file
    And the application should display a message confirming the cancellation

Scenario: Checking the search using a valid book title
  Given the application displays the search filter
  When the user fills in the field with a valid book title
  Then the application should display the API response
    And the application should display the details of the searched book

Scenario: Checking the application behavior when searches an invalid title
  Given the application displays the search filter
  When the user fills in the field with a invalid book title
  Then the application should display the API response
    And the application should display a message indicating that the book does not exist in the database

Scenario: Checking the response time when the user performs a search
  Given the application displays the search field
  When the user fills in the field
    And the user clicks on the “Search” button
  Then the application should display the response
    And the application response time should be up to 1 second

Scenario: Checking the search returns multiple results
  Given the application displays the search filter
  When the user fills in the field with a book title that has multiple matches
  Then the application should display the API response
    And the application should list all matching books

Scenario: Searching with an empty title field
  Given the application displays the search filter
  When the user leaves the title field empty
    And the user clicks on the “Search” button
  Then the application should display an error message indicating that the title cannot be empty

Scenario: Viewing details of a selected book
  Given the application displays a list of books
  When the user selects a specific book from the list
  Then the application should display the detailed information of the selected book