class InvitationTokensController < ApplicationController
  # GET /invitation_tokens
  # GET /invitation_tokens.json
  def index
    @invitation_tokens = InvitationToken.includes(:created_by).all.reverse
  end

  # POST /invitation_tokens
  # POST /invitation_tokens.json
  def create
    ttl = 6.months
    expired_at = Time.now + ttl
    @invitation_token = current_user.invitation_tokens.build(expired_at: expired_at)

    respond_to do |format|
      if @invitation_token.save
        format.html { redirect_to invitation_tokens_path, notice: "Invitation token was successfully created." }
        format.json { render :show, status: :created, location: @invitation_token }
      else
        flash[:errors] = @invitation_token.errors.full_messages
        format.html { redirect_to invitation_tokens_path }
        format.json { render json: @invitation_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitation_tokens/1
  # DELETE /invitation_tokens/1.json
  def destroy
    @invitation_token = InvitationToken.find(params[:id])
    @invitation_token.destroy
    respond_to do |format|
      format.html { redirect_to invitation_tokens_url, notice: "Invitation token was successfully destroyed." }
      format.json { head :no_content }
    end
  end
end
