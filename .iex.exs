# iex set up to make local test or development more convenient
alias Randomer.Repo
alias Randomer.Users
alias Randomer.Users.User

# points within [0, 100]
valid_user_attrs = %{points: 75}

# points outside [0, 100]
invalid_user_attrs = %{points: 150}
