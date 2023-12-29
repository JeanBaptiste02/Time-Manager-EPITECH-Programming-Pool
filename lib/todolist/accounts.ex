defmodule Todolist.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Todolist.Repo

  alias Todolist.Accounts.User

  @doc """
  Returns the list of users.
  
  ## Examples
  
      iex> list_users()
      [%User{}, ...]
  
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  
  Raises `Ecto.NoResultsError` if the User does not exist.
  
  ## Examples
  
      iex> get_user!(123)
      %User{}
  
      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get!(User, id)

  @spec get_user_by_username!(any()) :: any()
  def get_user_by_username!(username) do
    from(
      u in User,
      where: u.username == ^username
    )
    |> Repo.one!()
  end

  @doc """
  Creates a user.
  end
  
  @doc \"""
  Creates a user.
  
  ## Examples
  
      iex> create_user(%{field: value})
      {:ok, %User{}}
  
      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  
  ## Examples
  
      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}
  
      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  
  ## Examples
  
      iex> delete_user(user)
      {:ok, %User{}}
  
      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  
  ## Examples
  
      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}
  
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Todolist.Accounts.Clock

  @doc """
  Returns the list of clocks.
  
  ## Examples
  
      iex> list_clocks()
      [%Clock{}, ...]
  
  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.
  
  Raises `Ecto.NoResultsError` if the Clock does not exist.
  
  ## Examples
  
      iex> get_clock!(123)
      %Clock{}
  
      iex> get_clock!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.
  
  ## Examples
  
      iex> create_clock(%{field: value})
      {:ok, %Clock{}}
  
      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clock.
  
  ## Examples
  
      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}
  
      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.
  
  ## Examples
  
      iex> delete_clock(clock)
      {:ok, %Clock{}}
  
      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.
  
  ## Examples
  
      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}
  
  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias Todolist.Accounts.Workingtime

  @doc """
  Returns the list of workingtimes.
  
  ## Examples
  
      iex> list_workingtimes()
      [%Workingtime{}, ...]
  
  
  ##original
  def list_workingtimes do
    Repo.all(Workingtime)
  end
  """

  def list_workingtimes(user_id \\ nil, start_time \\ nil, end_time \\ nil) do
    query = from(w in Workingtime)

    query =
      case {user_id, start_time, end_time} do
        {nil, nil, nil} ->
          query

        {user_id, start_time, end_time} ->
          query
          |> where([w], w.user_id2 == ^user_id and w.start >= ^start_time and w.end <= ^end_time)
      end

    Repo.all(query)
  end

  def list_workingtime(user_id \\ nil, start_time \\ nil, end_time \\ nil) do
    query =
      from w in Todolist.Accounts.Workingtime,
        where: w.user_id2 == ^user_id,
        select: w

    Repo.all(query)
  end

  @doc """
  Gets a single workingtime.
  
  Raises `Ecto.NoResultsError` if the Workingtime does not exist.
  
  ## Examples
  
      iex> get_workingtime!(123)
      %Workingtime{}
  
      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)
  
      original
      def get_workingtime!(id), do: Repo.get!(Workingtime, id)
  
  def get_workingtime_2_params!(user_id2,id) do
    query = from(w in Workingtime, where: w.user_id2 == ^user_id2 and w.id == ^id)
    Repo.all(query)
  end
  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  @doc """
  Creates a workingtime.
  
  ## Examples
  
      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}
  
      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.
  
  ## Examples
  
      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}
  
      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workingtime.
  
  ## Examples
  
      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}
  
      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.
  
  ## Examples
  
      iex> change_workingtime(workingtime)
      %Ecto.Changeset{data: %Workingtime{}}
  
  """
  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end
end
