defmodule Chat.Auth.Provider do
  @moduledoc """
  Defines the authentication with Keycloak and is responsible
  normalizing the client scopes.
  """
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      base_url: System.get_env("OAUTH_BASE_URL"),
      authorize_url: "/protocol/openid-connect/auth",
      token_url: "/protocol/openid-connect/token",
      user_url: "/protocol/openid-connect/userinfo",
      authorization_params: [scope: "email openid profile"],
      auth_method: :client_secret_post
    ]
  end

  @impl true
  def normalize(_config, user) do
    IO.inspect(user)
    
    {:ok,
     %{
       "sub" => user["sub"],
       "name" => user["name"],
       "email" => user["email"],
       "locale" => user["locale"],
       "role" => List.first(user["group"] || [])
     }}
  end
end
