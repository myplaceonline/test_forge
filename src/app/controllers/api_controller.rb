class ApiController < ApplicationController
  def encrypt
    success = false
    error = nil
    base64_encrypted_string = nil
    base64_salt = nil
    
    begin
      text = params[:text]
      password = params[:password]
      key_size = params[:key_size]
      if text.nil? || text == ""
        error = "Please specify a value to encrypt"
      else
        if password.nil? || password == ""
          error = "Please specify a password"
        else
          if key_size.nil? || key_size.to_i <= 0
            error = "Please specify a key size"
          else
            encrypted_value, salt = perform_encryption(text, password, key_size.to_i)
            base64_encrypted_string = ::Base64.strict_encode64(encrypted_value)
            base64_salt = ::Base64.strict_encode64(salt)
            success = true
          end
        end
      end
    rescue => e
      puts e.backtrace
      error = e.message
    end
    render json: {
      :success => success,
      :base64_encrypted_string => base64_encrypted_string,
      :base64_salt => base64_salt,
      :error => error
    }
  end

  def decrypt
    success = false
    error = nil
    decrypted_string = nil
    
    begin
      base64_encrypted_string = params[:base64_encrypted_string]
      base64_salt = params[:base64_salt]
      password = params[:password]
      key_size = params[:key_size]
      if base64_encrypted_string.nil? || base64_encrypted_string == ""
        error = "Please specify a base64_encrypted_string"
      else
        if base64_salt.nil? || base64_salt == ""
          error = "Please specify a base64_salt"
        else
          if password.nil? || password == ""
            error = "Please specify a password"
          else
            if key_size.nil? || key_size.to_i <= 0
              error = "Please specify a key size"
            else
              decrypted_string = perform_decryption(base64_encrypted_string, base64_salt, password, key_size.to_i)
              success = true
            end
          end
        end
      end
    rescue => e
      puts e.backtrace
      error = e.message
    end
    render json: {
      :success => success,
      :decrypted_string => decrypted_string,
      :error => error
    }
  end
  
  private
    def perform_encryption(text, password, key_size)
      salt = SecureRandom.random_bytes(key_size)
      generated_key = ActiveSupport::KeyGenerator.new(password).generate_key(salt, key_size)
      crypt = ActiveSupport::MessageEncryptor.new(generated_key, :serializer => SimpleSerializer.new)
      encrypted_value = crypt.encrypt_and_sign(text)
      [ encrypted_value, salt ]
    end
    
    def perform_decryption(base64_encrypted_string, base64_salt, password, key_size)
      generated_key = ActiveSupport::KeyGenerator.new(password).generate_key(::Base64.strict_decode64(base64_salt), key_size)
      crypt = ActiveSupport::MessageEncryptor.new(generated_key, :serializer => SimpleSerializer.new)
      crypt.decrypt_and_verify(::Base64.strict_decode64(base64_encrypted_string))
    end
    
    class SimpleSerializer
      def dump(value)
        value
      end
      
      def load(value)
        value
      end
    end
end
