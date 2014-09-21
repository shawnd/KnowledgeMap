class WikiparseController < ApplicationController
    require 'net/http'

    def searchBuild(searchString)
        wikiURL = 'https://en.wikipedia.org/w/index.php?title=' + searchString + '&action=edit'
        return URI(wikiURL)
    end

    def parseSearch
        $inputURL = params[:searchTerm]
        inputURL = params[:searchTerm]
        print(params[:searchTerm])
        print(inputURL)
        source = Net::HTTP.get(searchBuild(inputURL))

        source = source.partition("==Notes==")[0]
        
        sourceHead = 0
        sourceTail = 0
        sourceLength = source.length()
@@ -28,27 +24,39 @@ class WikiparseController < ApplicationController
            elsif source[i] == ']' && source[i+1] == ']' #closing brace
                sourceTail = i-1
                currentEntry = source[sourceHead..sourceTail]
                print "\nCurrent Entry: " + currentEntry + "\n"
                currentEntryHits = entryHash[currentEntry]  #get current entry hits
                if currentEntryHits == 0  #if hits == nil new entry
                    entryHash[currentEntry] = 1
                else
                    entryHash[currentEntry] = currentEntryHits + 1  #elsif hits > 1 then increment value
                    entryHash[currentEntry] = (currentEntryHits.to_i + 1)  #elsif hits > 1 then increment value
                end
            end
        end
        searchForCallback(entryHash.keys, entryHash.values)
        #for every hash entry we want to get and search the related page for an entry back to the original page (if found then store in DB)
        print ("text")
        redirect_to "/"
    end
    
    def searchForCallback(searchArray, valueArray)
        for i in 0..searchArray.length
            source = Net::HTTP.get(searchBuild(searchArray[i]))
            if source.include? entry
            if source.include? searchArray[i]
                #create DB tuple for entry and valueArray[i]
                print "*************CREATE DB TUPLE****************"
            end
        end        
    end
    
    private
        
        def searchBuild(searchString)
            #wikiURL = "http://en.wikipedia.org/w/index.php?title=" << searchString << "&action=edit"
            wikiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + searchString + '&prop=revisions&rvprop=content'
            wikiURL = wikiURL.gsub " ", "%20" #replace whitespace with %20
            print "\nwikiURL: " + wikiURL + "\n"
            return URI(wikiURL)
        end
        
end
