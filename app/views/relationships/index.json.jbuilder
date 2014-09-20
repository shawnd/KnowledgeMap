json.array!(@relationships) do |relationship|
  json.extract! relationship, :id, :ID, :Parent_Entry_ID, :Child_Entry_ID, :Type_ID
  json.url relationship_url(relationship, format: :json)
end
