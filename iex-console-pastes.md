# Create some mock_assigns that most functions can live with:
mock_assigns = %{current_scope: %{id: 2, name: "Default Scope", user: 2}, user: %{id: 2}}

# Get user from database, turn into scope, fetch task
user = Vbv.Users.get_user!(2)
scope = Vbv.Users.Scope.for_user(user)
Vbv.Tasks.get_task!(scope,7)


# Test a function using the mock_assigns:
Vbv.States.list_states()

