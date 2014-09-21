#Controller to parse wikipedia and determine subjects (their parents, and children)
class WikiparseController < ApplicationController
    require 'net/http'

    def searchBuild(searchString)
        wikiURL = 'https://en.wikipedia.org/w/index.php?title=' + searchString + '&action=edit'
        return URI(wikiURL)
    end

    def parseSearch
        $inputURL = params[:searchTerm]
        print(params[:searchTerm])
        print(inputURL)
        source = Net::HTTP.get(searchBuild(inputURL))

        sourceHead = 0
        sourceTail = 0
        sourceLength = source.length()
        
        entryHash = Hash.new
        entryHash.default(0) #if not found return 0
        
        #search string for links to other articles
        for i in 0..(sourceLength-1) #parse the links to other wiki articles
            if source[i] == '[' && source[i+1] == '[' #opening brace
                sourceHead = i+2
                
            elsif source[i] == ']' && source[i+1] == ']' #closing brace
                sourceTail = i-1
                currentEntry = source[sourceHead..sourceTail]
                currentEntryHits = entryHash[currentEntry]  #get current entry hits
                if currentEntryHits == 0  #if hits == nil new entry
                    entryHash[currentEntry] = 1
                else
                    entryHash[currentEntry] = currentEntryHits + 1  #elsif hits > 1 then increment value
                end
            end
        end
        searchForCallback(entryHash.keys, entryHash.values)
        #for every hash entry we want to get and search the related page for an entry back to the original page (if found then store in DB)
        print ("text")
    end
    
    def searchForCallback(searchArray, valueArray)
        for i in 0..searchArray.length
            source = Net::HTTP.get(searchBuild(searchArray[i]))
            if source.include? entry
                #create DB tuple for entry and valueArray[i]
            end
        end        
    end

    # Method to return all text before the String match
    def searchBeforeMatch(searchArray, match)
        searchArray.partition(match)[0];
    end
        
end
    