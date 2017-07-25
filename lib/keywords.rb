module Keywords

  # convert an array of keyword objects to a single string
  # with multiple-word keywords surrounded by double quotes
  #
  def self.keywordArrayToKeywordString(keywordArray)
    keywordString = ""

    keywordArray.each do |kw|
      test = kw.word =~ /\s+/
      if test.nil?
        keywordString += " #{kw.word} "
      else
        keywordString += " \"#{kw.word}\" "
      end
    end

    return keywordString
  end

  # function that takes a string of space separated keywords
  # and returns an array of keywords
  #
  def self.keywordStringToKeywords(keywordString)

    # first split out any double quoted strings from the keyword list
    #
    quotes = keywordString.downcase.scan(/"([^"]*)"/).flatten

    # also remove any quoted strings from the keyword list, to
    # be added later
    #
    keywords = keywordString.gsub(/"([^"]*)"/, '')

    # process keyword array to replace commas or other punctuation with whitespace
    #
    keywords.downcase.gsub(/[^[:word:]\s]/, '')

    # split keyword string into individual keywords
    #
    singleKeywords = keywords.split(" ")

    # now push each of the multi-string keywords back onto
    # the master list of keywords
    #
    quotes.each do |q|
      if q != ""
        singleKeywords.push q
      end
    end

    return singleKeywords

  end

end
