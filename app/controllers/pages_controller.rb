 class PagesController < WikiparseController

  def home
  end

  def search
  	
  	searchString = params[:search]

  	node = Entry.where(node: searchString).take

  	if node == nil
  		# WikiparseController.parseSearch
  	else 
  		@nodes = Entry.where(node: searchString, type: "child").take(5)
  	end
  		
  end
end
