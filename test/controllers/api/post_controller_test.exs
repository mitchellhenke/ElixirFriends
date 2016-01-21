defmodule ElixirFriends.API.PostControllerTest do
  use ElixirFriends.ConnCase
  alias ElixirFriends.Post

  setup do
    # We're going to only accept json from the server
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all posts", %{conn: conn} do
    # We'll insert a post to get back in our api call
    post = %Post{
      image_url: "http://elixirfriends.com",
      content: "this is some content",
      username: "knewter",
      source_url: "http://elixirfriends.com"
    }
    |> ElixirFriends.Repo.insert!

    # Now let's get the posts from the API
    conn = get conn, "/api/posts"
    # We'll define what we expect to receive
    # Remember we'll have our data wrapped in a scrivener pagination map
    expected_response = %{
      total_pages: 1,
      total_entries: 1,
      page_size: 20,
      page_number: 1,
      entries: [post]
    } |> Poison.encode!

    # Now let's assert that we receive what we expected
    assert json_response(conn, 200) == expected_response
  end
end
