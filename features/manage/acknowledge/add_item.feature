Feature: Add Item during acknowledge process

  In order to add more items to a contract
  As a Lending Manager
  I want to have quick adding functionalities as well as adding a model by browsing trough all possible models

  Background:
    Given personas existing
      And I am "Pius"
     When I open a contract for acknowledgement

  @javascript
  Scenario: Adding a model quickly to a contract by just typing in the inventory_number
     When I add a model by typing in the inventory code of an item of that model to the quick add
     Then the model is added to the contract

  @javascript
  Scenario: Autocompletion of the quick add input by model name
     When I start to type the name of a model
      And I wait until the autocompletion is loaded
     Then I already see possible matches of models
     When I select one of the matched models
     Then the model is added to the contract

  @javascript
  Scenario: Increase the quantity of a contract line by adding an model from the same type and date range to the contract
     When I add a model to the acknowledge which is already existing in the selected date range by providing an inventory code
     Then the existing line quantity is not increased
      And an additional line has been created in the backend system
      And the new line is getting visually merged with the existing line
