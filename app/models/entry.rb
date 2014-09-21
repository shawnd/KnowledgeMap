class Entry < ActiveRecord::Base
	has_many :parents, through: :relationships, source: :entries
    has_many :children, through: :relatoinships, source: :entries
    
    self.primary_key = "node"
    
end
