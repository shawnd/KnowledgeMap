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

        elsif source.include? '#REDIRECT'
            searchString = rmDBrakets source[source.index('#REDIRECT')..-1]
            print "SEARCH STRING: " + searchString
            source = redirectWiki(searchString)
        else
            searchString = inputURL
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
                currentEntry.gsub "Category:", ""
                print "\nCurrent Entry: " + currentEntry + "\n"
                currentEntryHits = entryHash[currentEntry]  #get current entry hits
                if currentEntry != ''
                    if currentEntryHits == 0  #if hits == nil new entry
                        entryHash[currentEntry] = 1
                    else
                        entryHash[currentEntry] = (currentEntryHits.to_i + 1)  #elsif hits > 1 then increment value
                    end
                end
            end
        end
        parent = Entry.create(:node => searchString)
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
    
        def redirectWiki (searchString) 
            return Net::HTTP.get(searchBuild(searchString))
        end

        #get the string inside the first [[]]
        def rmDBrakets (str) 
            return str[(str.index('[[')) + 2..(str.index(']]') - 1)]
        end
    
        def searchForCallback(searchArray, valueArray)  
            len = searchArray.length
            largestKeys = Array.new #array storing largest value keys
            keysLeft = SEARCH_LIMIT #how many of the largest keys left to find
            max = 0 #largest array item

            while keysLeft > 0 && keysLeft < len
                for i in 0..len
                    if valueArray[i].to_i > valueArray[max].to_i
                        max = i
                    end
                end #max = largest index in array
                largestKeys.insert(0, searchArray[max])
                valueArray[max] = 0
                keysLeft -= 1
                max = 0
            end
                    
            for i in 0..SEARCH_LIMIT
                print "\nLargest Value: " + searchArray[i].to_s + "\n"
                #Entry.create(:node => searchArray[i])
            end
        end
        
end
    