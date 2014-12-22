class ApiController < ApplicationController
  def encrypt
    render json: {
      :success => true,
      :base64_encrypted_string => params[:text]
    }
  end

  def decrypt
    render json: "Decrypted"
  end
end
