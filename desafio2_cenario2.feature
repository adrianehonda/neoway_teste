Feature: Cart creation and management

    As a user,
    I want to create a cart, add products, and complete purchases,
    So that I can manage mu shopping experience effectively.

Scenario: Registering a new user admin
  Given the user admin is authenticated
    And the application displays the “Cadastro de usuários” page
  When the user fills in the “Nome” field with a valid name
    And the user fills in the “Email” field with a valid email
    And the user fills in the “Senha” field with a valid password
    And the user checks the “Cadastrar como administrador?” checkbox
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “email”, “password” and “administrador” values
  Then the application should display the “Lista dos usuários” page
    And the application should display the new user in the list
    And the “/usuarios” API response should return status 201
    And the “/usuarios” API response body should display the “Cadastro realizado com sucesso” message
    And the “/usuarios” API response body should display the “_id” information

Scenario: Registering a new product
  Given the user admin is authenticated
    And the application displays the “Cadastro de Produtos” page
  When the user fills in the “Nome” field
    And the user fills in the “Preço” field
    And the user fills in the “Descrição” field
    And the user fills in the “Quantidade” field
    And the user uploads a image
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “preco”, “descricao” and “quantidade” values
  Then the application should display the “Lista de Produtos” page
    And the application should display the new product in the list
    And the “/produtos” API response should return status 201
    And the “/produtos” API response body should display the “Cadastro realizado com sucesso” message
    And the “/produtos” API response body should display the “_id” information

Scenario: Registering another new product
  Given the user admin is authenticated
    And the application displays the “Cadastro de Produtos” page
  When the user fills in the “Nome” field
    And the user fills in the “Preço” field
    And the user fills in the “Descrição” field
    And the user fills in the “Quantidade” field
    And the user uploads a image
    And the user clicks on the “Cadastrar” button
    And the application sends a POST request containing “nome”, “preco”, “descricao” and “quantidade” values
  Then the application should display the “Lista de Produtos” page
    And the application should display the new product in the list
    And the “/produtos” API response should return status 201
    And the “/produtos” API response body should display the “Cadastro realizado com sucesso” message
    And the “/produtos” API response body should display the “_id” information

Scenario: Searching and finding a product
  Given the user admin is authenticated
    And the application displays the “Lista de produtos” page
  When the user search for a specific product
    And the product is registered in the database
  Then the application should display the product information
    And the user should be able to add the product in the cart
    And the “/produtos/{_id}” API response should return status 200
    And the “/produtos/{_id}” API response body should display the “nome”, “preco”, “descricao”, “quantidade” and “_id” values

Scenario: Searching and not finding a product
  Given the user admin is authenticated
    And the application displays the “Lista de produtos” page
  When the user search for a specific product
    And the product is not registered in the database
  Then the application should display the “Produto não encontrado” message
    And the “/produtos/{_id}” API response should return status 400
    And the “/produtos/{_id}” API response body should display the “Produto não encontrado” message

Scenario: Adding the product in the cart
  Given the user is authenticated in the application
    And the user adds a new product in the database
    And the user searches for this new product
    And the product is available 
  When the user adds the product in the cart
    And the application sends a POST request containing “idProduto” and “quantidade” values
  Then the application should reduce the quantity in the product registration
    And the user should be able to add more products in the cart
    And the user should be able to complete the purchase
    And the “/carrinhos” API response should return status 201
    And the “/carrinhos” API response body should display the “Cadastro realizado com sucesso” message
    And the “/carrinhos” API responde body should display the “_id” information

Scenario: Failing to add a product to the cart
  Given the user is authenticated in the application 
  When the user tries to <action> to the cart
    And the application sends a POST request
  Then the application should display the “<message>” message 
    And the “/carrinhos” API response should return status 400
    And the “/carrinhos” API response body should display the “<message>” message

  Examples:
    | action                                               | message                                  |
    | add a product with a quantity of 0 in the database   | Produto não possui quantidade suficiente |
    | add the same product that already exists in the cart | Não é permitido possuir produto duplicado|
    | create a new cart                                    | Não é permitido ter mais de 1 carrinho   |
    | add a product that does not exist in the database    | Produto não encontrado                   |

Scenario: Validating the cart view displays correct product information
  Given the user is authenticated in the application 
    And the user has added products to the cart
  When the user views the cart
    And the application sends a GET request containing "_id" value
  Then the application should display the correct products in the cart with the quantity and price
    And the “/carrinhos/{_id}" API response should return status 200
    And the “/carrinhos/{_id}" response body should display the "produtos" array with "idProduto", "quantidade" and "precoUnitario" values
    And the “/carrinhos/{_id}" response body should display the "precoTotal", "quantidadeTotal", "idUsuario" and "_id" values

Scenario: Completing the purchase
  Given the user is authenticated in the application
    And the user adds some products in the cart
    And the application reduces the quantity in the product registration
  When the user completes the purchase
    And the application sends a DELETE request
  Then the application should remove the cart
    And the application should link the deleted cart to the user authorization token
    And the “/carrinhos/concluir-compra” API response should return status 200
    And the “/carrinhos/concluir-compra” API response body should display the “Registro excluído com sucesso” message

Scenario: Failling to complete the purchase when the token is missing, invalid or expired
  Given the user has products in the cart
  When the user tries to complete the purchase
  Then the application should display the "Token ausente, inválido ou expirado" message 
    And the “/carrinhos/concluir-compra” API response should return status 401
    And the “/carrinhos/concluir-compra” API response body should display the "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais" message

Scenario: Validating the inventory
  Given the user is authenticated in the application
    And the user completes a purchase
  When the application displays the “Lista de Produtos” page
    And the user searches for the same product
    And the application sends a GET request
  Then the application should display the updated quantity of the available product by reducing the quantity purchased
    And the “/produtos/{_id}” API response should return status 200
    And the "/produtos/{_id} API should display the quantity of the available product

Scenario: Canceling a purchase
  Given the user is authenticated in the application 
    And the user has products in the cart
  When the user removes all products from the cart
    And the applications send a DELETE request
  Then the application should update the cart 
    And the application should display the "Registro excluído com sucesso" message
    And the “/carrinhos/cancelar-compra” API response should return status 200
    And the "/carrinhos/cancelar-compra" API

Scenario Outline: Failling to cancel the purchase when the token is missing, invalid or expired
  Given the user has products in the cart
    And the user token is <value>
  When the user tries to cancel the purchase
    And the applications send a DELETE request
  Then the application should display the "Token ausente, inválido ou expirado" message 
    And the “/carrinhos/concluir-compra” API response should return status 401
    And the “/carrinhos/concluir-compra” API response body should display the "Token de acesso ausente, inválido, expirado ou usuário do token não existe mais" message

  Examples:
    | value   |
    | missing |
    | invalid |
    | expired |
