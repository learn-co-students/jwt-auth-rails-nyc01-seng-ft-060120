class Api::V1::UsersController < ApplicationController
    skip_before_action :authorized, only: [:create] #can create a user even if auth function in app controller is false 

    def profile
        render json: { user: UserSerializer.new(current_user) }, status: :accepted
    end

    def create #sign up new user - which is why it's skipped above 
        @user = User.create(user_params)
        if @user.valid?
            @token = encode_token({ user_id: @user.id })
            render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
        else
          render json: { error: 'failed to create user' }, status: :not_acceptable
        end
      end
     
      private
      def user_params
        params.require(:user).permit(:username, :password, :bio, :avatar)
      end
end
