# VerifyHeader

You can add it to your Phoenix router.ex, for example:

```elixir
# This pipeline if intended for API requests the require user login. It looks
# for the token in the "authorization" header -> authorization: <token>
pipeline :api_auth do
  pipe_through :api
  plug App.VerifyHeader
end
```
