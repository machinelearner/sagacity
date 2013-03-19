class SentimentPredictController < ActionController::Base
    respond_to :html, :xml, :json
    protect_from_forgery
    def index
    end

    def predict
        Rails.logger.info "################## value #{params[:text]}"
        tweet = Tweet.new(:text=>params[:text])
        tweet.save
        class_label = LibLinear.predict(tweet.feature_hash)
        json_response = {"class" => class_label,"text" => tweet.text}.to_json
        respond_to do |format|
            format.json{ render :json => json_response}
        end
    end
end
