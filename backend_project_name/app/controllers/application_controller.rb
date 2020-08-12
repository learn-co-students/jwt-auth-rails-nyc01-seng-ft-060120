class ApplicationController < ActionController::API
    before_action :authorized 


    def encode_token(payload)
        JWT.encode(payload, 'my_s3cr3t') #string: eyJhbGciOiJIUzI1NiJ9.eyJiZWVmIjoic3RlYWsifQ._IBTHTLGX35ZJWTCcY30tLmwU9arwdpNVxtVU0NpAuI
    end 

    def auth_header 
        request.headers['Authorization'] #Authorization: Bearer <token>
    end 

    def decoded_tocken(token) #token: eyJhbGciOiJIUzI1NiJ9.eyJiZWVmIjoic3RlYWsifQ._IBTHTLGX35ZJWTCcY30tLmwU9arwdpNVxtVU0NpAuI
        if auth_header 
            token = auth_header.split(' ')[1] #Authorization: Bearer <token>
            begin #rescue out of an except in Ruby - if srever receives and attempts to decode an invalid token 
                JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256') #0 gives us the payload
            rescue JWT::DecodeError 
                nil #return nil instead of crashing server if invalid token 
            end 
        end 
    end 

    def current_user 
        if decoded_token #either nil or [{"user_id"=>2}, {"alg"=>"HS256"}]
            user_id = decoded_token[0]['user_id'] #grabs user id number
            @user = User.find_by(id: user_id) #find user by id identified above
        end 
    end 

    def logged_in? 
        !!current_user #if there is a current user (someone logged in) then this will eval to true 
    end 

    def authorized #will check before any other functions are run 
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?  #will read method unless logged_in is true 
    end 

end
