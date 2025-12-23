# Create some mock_assigns that most functions can live with:
mock_assigns = %{current_scope: %{id: 1, name: "Default Scope", user: 1}, user: %{id: 1}}

# Test a function using the mock_assigns:
Vbv.States.list_states()


Changeset after validation: %Phoenix.HTML.Form{
  source: #Ecto.Changeset<
    action: nil,
    changes: %{state_id: 5},
    errors: [],
    data: #Vbv.Tasks.Task<>,
    valid?: true,
    ...
  >,
  impl: Phoenix.HTML.FormData.Ecto.Changeset,
  id: "task",
  name: "task",
  data: %Vbv.Tasks.Task{
    __meta__: #Ecto.Schema.Metadata<:loaded, "tasks">,
    id: 4,
    name: "Testing",
    description: "test",
    deadline: ~D[2026-01-01],
    user_id: 2,
    rrule: nil,
    freq: nil,
    interval: nil,
    category_id: 4,
    category: %Vbv.Categories.Category{
      __meta__: #Ecto.Schema.Metadata<:loaded, "categories">,
      id: 4,
      name: "Garden",
      colour: "#000000",
      user_id: 2,
      inserted_at: ~U[2025-12-18 22:37:26Z],
      updated_at: ~U[2025-12-18 22:37:26Z]
    },
    state_id: 4,
    state: %Vbv.States.State{
      __meta__: #Ecto.Schema.Metadata<:loaded, "states">,
      id: 4,
      name: "Backlog",
      colour: "#000000",
      user_id: 2,
      inserted_at: ~U[2025-12-18 22:36:40Z],
      updated_at: ~U[2025-12-18 22:36:40Z]
    },
    inserted_at: ~U[2025-12-18 22:37:47Z],
    updated_at: ~U[2025-12-21 09:12:50Z]
  },
  action: :validate,
  hidden: [id: 4],
  params: %{
    "_unused_category_id" => "",
    "_unused_deadline" => "",
    "_unused_description" => "",
    "_unused_interval" => "",
    "_unused_name" => "",
    "category_id" => "4",
    "deadline" => "2026-01-01",
    "description" => "test",
    "freq" => "WEEKLY",
    "interval" => "1",
    "name" => "Testing",
    "state_id" => "5"
  },
  errors: [],
  options: [method: "put"],
  index: nil
}