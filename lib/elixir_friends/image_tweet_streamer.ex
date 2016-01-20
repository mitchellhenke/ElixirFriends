defmodule ElixirFriends.ImageTweetStreamer do
  # We want to allow you to pass a search term in...
  def stream(search_term) do
    # We'll search for that with a stream filter
    ExTwitter.stream_filter(track: search_term)
    # We'll filter out any tweets that don't have images
    |> Stream.filter(&has_images?/1)
    # And we'll store them in our database
    |> Stream.map(&store_tweet/1)
  end

  # Checking a tweet for images is easy:
  defp has_images?(%ExTwitter.Model.Tweet{}=tweet) do
    Map.has_key?(tweet.entities, :media) &&
    Enum.any?(photos(tweet))
  end

  # Storing a tweet just consists of grabbing the first photo from the tweet and
  # creating a Post in our database
  defp store_tweet(%ExTwitter.Model.Tweet{}=tweet) do
    post = %ElixirFriends.Post{
      image_url: first_photo(tweet).media_url,
      content: tweet.text,
      source_url: first_photo(tweet).expanded_url,
      username: tweet.user.screen_name,
    }
    ElixirFriends.Repo.insert(post)
  end

  # Now we need to write the `photos` function, which will return a list of the
  # photos attached to a tweet.  These are media under the entities key.
  defp photos(%ExTwitter.Model.Tweet{}=tweet) do
    tweet.entities.media
    |> Enum.filter(fn(medium) ->
      medium.type == "photo"
    end)
  end

  # Finally, we want a convenience function to grab the first photo
  defp first_photo(%ExTwitter.Model.Tweet{}=tweet) do
    photos(tweet)
    |> hd
  end
end
