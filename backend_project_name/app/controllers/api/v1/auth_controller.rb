class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create #user logging back in - why it needs to be skipped above and why we need to issue a token 
        @user = User.find_by(username: user_login_params[:username])
        if @user && @user.authenticate(user_login_params[:password]) #@user is above so if it's false and can't find a user by username it won't evaluate right side 
                                                                    #authenticate comes from bcrypt 
            token = encode_token({ user_id: @user.id }) #issue token passing found user's id in as a payload 
            render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        else 
            render json: { message: 'Invalid username or password' }, status: :unauthorized
        end 
    end 

    private
    def user_login_params
      params.require(:user).permit(:username, :password)# params { user: {username: 'Chandler Bing', password: 'hi' } }
    end

end
