Rails.application.routes.draw do

  # ---
  # Properties
  # ---


  resources :properties
  resources :floorplans


  # ---
  # Feeds
  # ---


  resources :feed_sources, only: [:index, :show]
  resources :field_path_mappings, only: [:show, :edit, :update]


  # ---
  # Authentication
  # ---


  devise_for :identities,
    controllers: {
      sessions:           "identities/sessions",
      passwords:          "identities/passwords",
      registrations:      "identities/registrations",
      confirmations:      "identities/confirmations",
      omniauth_callbacks: "identities/omniauth_callbacks"
    },
    # https://github.com/plataformatec/devise#configuring-routes
    path: 'auth',
    path_names: { sign_up: 'signup', sign_in: 'login', sign_out: 'logout' }

  # Ask for email address after successful OAuth.
  match "/auth/:id/finish_signup" => "identities#finish_signup",
    via: [:get, :patch], as: :identity_finish_signup

  # To demonstarate Pundit authorization
  resources :identities

  # Soial profiles
  resources :social_profiles


  # ---
  # Users
  # ---


  # Frontend user (singular)
  resource :user

  # Backend users
  resources :admins, only: [:show]
  resources :account_executives, only: [:show]
  resources :management_clients, only: [:show]
  resources :property_clients, only: [:show]


  # ---
  # Root
  # ---


  root to: "pages#react"


  # ---
  # Developement
  # ---


  # For viewing delivered emails in development environment.
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end