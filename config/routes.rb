# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

    get '/autocomplete_issues', to: 'issues#autocomplete_issues', as: 'autocomplete_issues'      

end