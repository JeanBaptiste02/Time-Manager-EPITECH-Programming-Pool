defmodule TodolistWeb.WorkingtimeController do
  use TodolistWeb, :controller

  import Ecto.Query
  alias Todolist.Repo
  alias Todolist.Accounts
  alias Todolist.Accounts.Workingtime

  action_fallback TodolistWeb.FallbackController

  """
  def index(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end
  """

  def index_all(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  # action index get : avec le id utilisateur, start et end
  def index(conn, %{"user_id2" => user_id, "start" => start_time, "end" => end_time}) do
    workingtimes = Accounts.list_workingtimes(user_id, start_time, end_time)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def index1(conn, %{"user_id2" => user_id}) do
    workingtimes = Accounts.list_workingtime(user_id)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  # action create post : avec workingtime_params et l'id de l'utilisateur
  def create(conn, %{"user_id2" => user_id2, "workingtime" => workingtime_params}) do
    currentTime = NaiveDateTime.local_now()

    # Extraction des valeurs de temps de travail
    start_time = Map.get(workingtime_params, "start_time")
    end_time = Map.get(workingtime_params, "end_time")

    # Mise à jour de la structure workingtime_params avec "end" et "user_id2"
    newmap = Map.merge(workingtime_params, %{"user_id2" => user_id2, "end" => currentTime})

    with {:ok, %Workingtime{} = workingtime} <- Accounts.create_workingtime(newmap) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  # action show get avec un seul paramètre
  def show(conn, %{"user_id2" => id}) do
    workingtime = Accounts.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  # action show get avec deux paramètres
  def show1(conn, %{"user_id2" => user_id2, "id" => id}) do
    query =
      from w in Workingtime,
        where: w.user_id2 == ^user_id2 and w.id == ^id,
        select: w

    workingtime = Repo.all(query)
    # Accounts.get_workingtime!(user_id2, id)
    render(conn, "show1.json", workingtime: workingtime)
  end

  def update(conn, %{"user_id2" => id, "workingtime" => workingtime_params}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <-
           Accounts.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Accounts.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
