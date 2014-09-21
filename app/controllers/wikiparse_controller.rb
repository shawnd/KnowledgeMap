#Controller to parse wikipedia and determine subjects (their parents, and children)
class WikiparseController < ApplicationController
    require 'net/http'
    
    SEARCH_LIMIT = 5

    def parseSearch
        inputURL = params[:searchTerm]
        print(params[:searchTerm])
        print(inputURL)
        source = Net::HTTP.get(searchBuild(inputURL))
        
        if source.include? 'missing' or source == nil
             redirect_to "/"

        elsif source.include? '#REDIRECT'
            searchString = rmDBrakets source[source.index('#REDIRECT')..-1]
            source = redirect(searchString)
        end
        
        source = source.partition("==Notes==")[0]
        
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
                currentEntry = currentEntry.partition("|")[0]
                currentEntry = currentEntry.partition("]")[0] #used to sanitize
                currentEntry = currentEntry.partition("\\")[0]
                currentEntry = currentEntry.partition("File")[0]
                print "\nCurrent Entry: " + currentEntry + "\n"
                currentEntryHits = entryHash[currentEntry]  #get current entry hits
                if
                    if currentEntryHits == 0  #if hits == nil new entry
                        entryHash[currentEntry] = 1
                    else
                        entryHash[currentEntry] = (currentEntryHits.to_i + 1)  #elsif hits > 1 then increment value
                    end
                end
            end
        end
        searchForCallback(entryHash.keys, entryHash.values)
        #for every hash entry we want to get and search the related page for an entry back to the original page (if found then store in DB)
        redirect_to "/"
    end
    
    
    private
        
        def searchBuild(searchString)
            #wikiURL = "http://en.wikipedia.org/w/index.php?title=" << searchString << "&action=edit"
            wikiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + searchString + '&prop=revisions&rvprop=content'
            wikiURL = wikiURL.gsub " ", "%20" #replace whitespace with %20
            return URI(wikiURL)
        end
    
        def redirect (searchString) 
            return Net::HTTP.get(searchBuild(searchString))
        end

        #get the string inside the first [[]]
        def rmDBrakets (str) 
            return str[(str.index('[[')) + 2..(str.index(']]') - 1)]
        end
    
        def searchForCallback(searchArray, valueArray)
            len = searchArray.length
            
            for i in 0..(len-1)
                source = Net::HTTP.get(searchBuild(searchArray[i]))
                if source.include? searchArray[i]
                    #create DB tuple for entry and valueArray[i]
                end
            end        
        end
        
end
    