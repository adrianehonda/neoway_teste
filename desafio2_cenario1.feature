Feature: User registration and management

    As a user,
    I want to register, log in, and manage my account,
    So that I can access and update my personal information and account status

Scenario: Validating the API response when the a new regular user is registered
  Given the application displays the Login page
    And the user clicks on the “Cadastre-se” CTA
    And the application displays the “Cadastro” page
  When the user fills in the field with a valid name
    And the user fills in the field with a valid email
    And the user fills in the field with a valid password
    And the user unchecks the “Administrador” checkbox
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “email”, “password” and “administrador” values
  Then the application should display the “Cadastro realizado com sucesso” message
    And the “/usuarios” API response should return status 201
    And the “/usuarios” API response body should display the “Cadastro realizado com sucesso” message
    And the “/usuarios” API response body should display the “_id” information

Scenario: Creating a new user with administrador role
  Given the application displays the Login page
    And the user clicks on the “Cadastre-se” CTA
    And the application displays the “Cadastro” page
  When the user fills in the field with a valid name
    And the user fills in the field with a valid email
    And the user fills in the field with a valid password
    And the user checks the “Administrador” checkbox
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “email”, “password” and “administrador” values
  Then the application should display the “Cadastro realizado com sucesso” message
    And the “/usuarios” API response should return status 201
    And the “/usuarios” API response body should display the “Cadastro realizado com sucesso” message
    And the “/usuarios” API response body should display the “_id” information

Scenario: Failing to register an existing user
  Given the application displays the Login page
    And the user clicks on the “Cadastre-se” CTA
    And the application displays the “Cadastro” page
  When the user fills in the fields with an existing user data
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “email”, “password” and “administrador” values
  Then the application should display the “Este email já está sendo usado” error message
    And the “/usuarios” API response should return status 400
    And the “/login” API response body should display the “Este email já está sendo usado” message

Scenario: Validating the API structure for user registration
  Given the application sends a POST request to register a user
  Then the parameters should have the <option> key as a <type> type

  Examples:
    | option        | type   |
    | nome          | String |
    | email         | String |
    | password      | String |
    | administrator | String |

Scenario: Checking the Login flow with a valid user
  Given the application displays the “Login” page
  When the user fills in the “email” field with a valid email
    And the user fills in the “password” field with a valid password
    And the user clicks on the “Entrar” button
    And the application sends a POST request containing “email” and “password” values
  Then the application should display the homepage
    And the “/login” API response should return status 200
    And the “/login” API response body should display the “Login realizado com sucesso” message
    And the “/login” API response body should display the token authorization

Scenario Outline: Failing to log in with an invalid user
  Given the application displays the “Login” page
  When the user fills in the “<option>” field with an invalid <option>
    And the application sends a POST request containing “email” and “password” values
  Then the application should display the “Email e/ou senha inválidos” error message
    And the application should not display the homepage
    And the “/login” API response should return status 401
    And the “/login” API response body should display the “Email e/ou senha inválidos” message
    
  Examples:
    | option   |
    | email    |
    | password |

Scenario: Validating the token expiration time
  Given the user authenticates in the application
    And the user receives a token authorization with 600 seconds duration
  When the logged time exceeds 600 seconds
  Then the user should be logged out
    And the “/login”  API response should return status 401 Unauthorized
    And the “/login”  API response body should display the “Token de acesso ausente, inválido, expirado ou usuário do token não existe mais” message

Scenario: Validating the API structure for login
  Given the application sends a POST request to login
  Then the parameters should have the <option> key as a <type> type

  Examples:
    | option   | type   |
    | email    | String |
    | password | String |

Scenario Outline: Editing the information of a user with existing ID
  Given the user with an existing ID edits his information
    And the user provides a new <option>
  When the application sends a PUT request containing  “nome”, “email”, “password” and “ administrador” new values
  Then the application should display the “Registro alterado com sucesso” message
    And the “/usuarios/{_id}” API response should return status 200
    And the “/usuarios/{_id}” API response body should display the “Registro alterado com sucesso” message

  Examples:
    | option        |
    | nome          |
    | email         |
    | password      |
    | administrator |

Scenario Outline: Editing the information of a user with a non-existent ID
  Given the user with a non-existent ID edits his information
    And the user provides a new <option>
  When the application sends a PUT request containing  “nome”, “email”, “password” and “ administrador” new values
  Then the application should display the “Cadastro realizado com sucesso” message
    And the “/usuarios/{_id}” API response should return status 201
    And the “/usuarios/{_id}” API response body should display the “Cadastro realizado com sucesso” message
    And the “/usuarios/{_id}”API response body should display the “_id” information

  Examples:
    | option        |
    | nome          |
    | email         |
    | password      |
    | administrator |

Scenario Outline: Failing to update user due to duplicate email
  Given the user with an existing ID edits his information
    And the user provides a new <option>
    And the email is already in use by another user
  When the application sends a PUT request containing  “nome”, “email”, “password” and “ administrador” new values
  Then the application should display the “Este email ja está em uso” message
    And the “/usuarios/{_id}” API response should return status 400
    And the “/usuarios/{_id}” API response body should display the “Este email já está em uso” message

  Examples:
    | option        |
    | nome          |
    | email         |
    | password      |
    | administrator |

Scenario Outline: Failing to update user due to missing information
  Given the user with an existing ID edits his information
    And the user does not fill in the <option> field
  When the application sends a PUT request containing  “nome”, “email”, “password” and “ administrador” new values
  Then the application should display the “<message>” message
    And the “/usuarios/{_id}” API response should return status 400
    And the “/usuarios/{_id}” API response body should display the “<message>” message

  Examples:
    | option        | message                                  |
    | nome          | nome não pode ficar em branco            |
    | email         | email não pode ficar em branco           |
    | password      | password não pode ficar em branco        |
    | administrator | administrador deve ser ‘true’ ou ‘false’ |

Scenario: Deleting a valid user 
  Given the user with an existing ID wants to delete his account
    And the user does not have an active cart
  When the application sends a DELETE request containing “_id” value to remove the user
  Then the application should display the “Registro excluído com sucesso | Nenhum registro excluído” message
    And the “/usuarios/{_id}” API response should return status 200
    And the “/usuarios/{_id}” API response body should display the “Registro excluído com sucesso | Nenhum registro excluído” message

Scenario: Failing to delete a valid user with an active cart
  Given the user with an existing ID wants to delete his account
    And the user has an active cart
  When the application sends a DELETE request containing “_id” value to remove the user
  Then the application should display the “Não é permitido excluir usuário com carrinho cadastrado” message
    And the “/usuarios/{_id}” API response should return status 400
    And the “/usuarios/{_id}” API response body should display the “Não é permitido excluir usuário com carrinho cadastrado” message
