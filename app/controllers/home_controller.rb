class HomeController < ApplicationController
  	def index
  	    if request.xhr?
     		render :layout => false
     	else
     		render "index"
     	end
  	end

  	def contact
  	    if request.xhr?
     		render :layout => false
     	else
     		render "contact"
     	end
    end
end
