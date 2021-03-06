class User::ReviewsController < ApplicationController

	before_action :authenticate_user!

	def create
		review = Review.new(review_params)
		if review.save
			redirect_to request.referer
		else
			item = review.item
			reviews = Review.where(item_id: item.id)
			average_score = Review.where(item_id: item.id).average(:score)
			reviews = Review.where(item_id: item.id).page(params[:page]).per(15)
			redirect_to request.referer, flash: { error: review.errors.full_messages }
		end
	end

	def destroy
		item = Item.find(params[:item_id])
		review = current_user.reviews.find(params[:id])
		review.destroy
		redirect_to request.referer
	end

	private

	def review_params
		params[:review][:item_id] = params[:item_id]
		params[:review][:score] = params[:score]
		# ↑item_idとscoreがparameterのreviewの中に入っていないので、↓を実行する前にここで指定している
    params.require(:review).permit(:user_id, :item_id, :review_text, :score)
	end
end
