# Create some mock_assigns that most functions can live with:
mock_assigns = %{current_scope: %{id: 1, name: "Default Scope", user: 1}, user: %{id: 1}}

# Test a function using the mock_assigns:
Vbv.States.list_states(mock_assigns)