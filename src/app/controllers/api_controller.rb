class ApiController < ApplicationController
  def encrypt
    render json: "Encrypted"
  end

  def decrypt
    render json: "Decrypted"
  end
end
