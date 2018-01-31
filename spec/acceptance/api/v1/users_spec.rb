require 'acceptance_helper'

resource "Users", acceptance: true do
  before do
    @user = create(:user)
  end

  get "/api/v1/users/:id" do
    parameter :id, "User id"

    example "Get user", document: :private do
      explanation "Get user"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @user.id})
      expect(status).to eq 200
    end
  end

  put "/api/v1/users/:id" do
    parameter :id, "Driver id"
    parameter :other, "name, surname, sex, photo, email"

    example "Update user", document: :private do
      explanation "Update user"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @user.id, surname: "Surname"})
      expect(status).to eq 200
    end
  end

  post "/api/v1/users/:id/initialization" do
    parameter :id, "User id"
    parameter :lat, "User current latitude"
    parameter :lon, "User current longitude"

    example "Initialize user", document: :private do
      explanation "Initialize user"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      card1 = Card.create!(last_four_numbers: "1234", token: "123", user_id: @user.id, expiration_date: "05/20")
      card2 = Card.create!(last_four_numbers: "5678", token: "123", user_id: @user.id, expiration_date: "08/19")

      do_request({id: @user.id, lat: 12.344312, lon: 15.231432})
      expect(status).to eq 200
    end
  end

  post "api/v1/users/:id/bind_card" do
    parameter :id, "User id"
    parameter :name, "User name from bank card (fromat: IVAN IVANOV)"
    parameter :card_cryptogram_packet, "Cryptogram"

    example "Bind bank card without 3ds", document: :private do
      explanation "Bind bank card without 3ds"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @user.id, name: "IVAN IVANOV", card_cryptogram_packet: "024111111111200504H66InXlyndJGvarKvdUYX75CfFpskkWgrsULsm21OzY0iGvnpPVnEc1042ozRamxlBdFG2mFA62efh4C5cA/KtimunlO91aT7XzBOe3dbBvY9h3QZ/Y9FMZk8Aa+xuItudiGgFWMIFUx0e0vRXV0zK/aMaausgUsFhNTyTBsUSWTT3XUzlX+OHxblr0OZCt6yXS78q6PJxTtI23B2mPPTpPLiuSnFzdOfOAFEVVH0AegZQ5LpjXgOvktTBB0H7ObUaGlHit3bhQB+Q/99I94oqL0FT8JeEuwyfCcN74O5S1496hAJdE472Q88UByve/x1E8WaUFqWRxncyZQBLCTsw=="})
      expect(status).to eq 200
    end
  end

  post "api/v1/users/:id/bind_card" do
    parameter :id, "User id"
    parameter :name, "User name from bank card (fromat: IVAN IVANOV)"
    parameter :card_cryptogram_packet, "Cryptogram"

    example "Bind bank card with 3ds", document: :private do
      explanation "Bind bank card with 3ds"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @user.id, name: "IVAN IVANOV", card_cryptogram_packet: "024242424242200504Jhf05ztWKDp2XAZhCkF1nbJGXPnKGx0KU3iZos2fYpL0tNoTLytJyOh0UviRJxKpkUslV7bdCUf+gUnCGajapuBg1a0cNqlRg22gCrVs0M64VCRW+KJjWwheA7tmyT3WnAhJNolBrLrLcr93xmlu0KHkYShpipp8dYEUYEdZ+WW8+XrFpJUuCP+YUCvVcQAQzwy9VP/yJWQO//g2bLDnUCWuYuldeqaK7+LwtHKMKgghraLFmJp1p+zTXicef9YBgzuJyLD86DKzowmkBUfTJNKMy1dVJbsITg2u2UR9YgBqMFunmhtHnBB8J28/qK2lqRMygQtO1Rf+4qGDJaXTvA=="})
      expect(status).to eq 200
    end
  end

  post "api/v1/users/accept_payment" do
    parameter :id, "User id"
    parameter :transaction_id, "or TransactionId. Transaction id from bind_card method"
    parameter :pa_res, "or PaRes. pa_res parameter from bind_card method"

    example "Bind bank card after 3ds", document: :private do
      explanation "Bind bank card after 3ds"

      do_request({MD: 123456, PaRes: "qwe123"})
      expect(status).to eq 200
    end
  end

  delete "/api/v1/users/:id/remove_card" do
    parameter :id, "User id"
    parameter :card_id, "Card id"

    example "Remove user card (for auth user only)", document: :private do
      explanation "Remove user card (for auth user only)"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      card = Card.create!(last_four_numbers: "1234", token: "123", user_id: @user.id, expiration_date: "05/20")
      do_request({id: @user.id, card_id: card.id})
      expect(status).to eq 200
    end
  end

  get "/api/v1/users/:id/cards" do
    parameter :id, "User id"

    example "Get user bank cards (for auth user only)", document: :private do
      explanation "Get user bank cards (for auth user only)"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      card1 = Card.create!(last_four_numbers: "1234", token: "123", user_id: @user.id, expiration_date: "05/20")
      card2 = Card.create!(last_four_numbers: "5678", token: "123", user_id: @user.id, expiration_date: "08/19")
      do_request({id: @user.id})
      expect(status).to eq 200
    end
  end

  post "/api/v1/users/:id/close_debt" do
    parameter :id, "User id"
    parameter :card_id, "User card"

    example "Close debt", document: :private do
      explanation "Close debt"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      card1 = Card.create!(last_four_numbers: "1234", token: "123", user_id: @user.id, expiration_date: "05/20")
      card2 = Card.create!(last_four_numbers: "5678", token: "123", user_id: @user.id, expiration_date: "08/19")
      do_request({id: @user.id, card_id: card1.id})
      expect(status).to eq 422
    end
  end

  put "/api/v1/users/:id/remove_image" do
    parameter :id, "User id"
    parameter :photo, "Random value"

    example "Remove user photo", document: :private do
      explanation "Remove user photo"

      token = JsonWebToken.encode( { user_id: @user.id } )
      header "Authorization", "Bearer #{token}"

      do_request({id: @user.id, photo: "remove"})
      expect(status).to eq 200
    end
  end

  post "/api/v1/users/send_password" do
    parameter :phone_number, "User phone number"

    example "Send password for existing user", document: :private do
      explanation "Send password for existing user"

      do_request({phone_number: @user.phone_number})
      expect(status).to eq 200
    end
  end

  post "/api/v1/users/send_password" do
    parameter :phone_number, "User phone number"

    example "Create user and send password for new user", document: :private do
      explanation "Create  user and send  password for new user"

      do_request({phone_number: '89041236745'})
      expect(status).to eq 200
    end
  end

  post "/api/v1/users/auth" do
    parameter :password, "User password"
    parameter :phone_number, "User phone number"

    example "Auth user", document: :private do
      explanation "Auth user"

      do_request({phone_number: @user.phone_number, password: @user.password})
      expect(status).to eq 200
    end
  end
end
