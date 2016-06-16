class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit
  end

  # POST /friendships
  # POST /friendships.json
   def create
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id], approved: "false")
      if @friendship.save
        flash[:notice] = "Friend requested."
        # flash.alert = "Friend requested."
        redirect_to :back
      else
        flash[:error] = "Unable to request friendship."
        redirect_to :back
      end
    end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
   def update

    @friendship = Friendship.where(friend_id: current_user.id, user_id: params[:id]).first
    @friendship.update(approved: true)
      if @friendship.save
        redirect_to current_user, :notice => "Friend confirmed!"
      else
        redirect_to current_user, :notice => "Sorry! Could not confirm friend!"
      end
    end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
def destroy
      @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
      @friendship.destroy
      flash[:notice] = "Friendship rejected."

      redirect_to :back
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      # binding.pry
      # @friendship = Friendship.find(params[:id])
      @friendship = Friendship.find_by(user_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id, :approved)
    end
end
