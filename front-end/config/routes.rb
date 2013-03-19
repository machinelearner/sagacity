Sagacity::Application.routes.draw do
    match "/" =>  "sentiment_predict#index"
    post "predict", :to =>  "sentiment_predict#predict"
end
