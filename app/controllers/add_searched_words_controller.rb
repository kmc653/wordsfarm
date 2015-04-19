class AddSearchedWordsController < ApplicationController
  def search
    if params[:word]
      @word = params[:word]
      api = '296ba566-058e-45a6-9a58-e62253ff0238'
      
      string = @word + '?key=' + api

      url = URI.join('http://www.dictionaryapi.com/api/v1/references/learners/xml/', string)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      
      if Nokogiri::XML(res.body)
        @doc = Nokogiri::XML(res.body)
        # document = Nokogiri::XML(res.body)
        # template = Nokogiri::XSLT(File.read('word.xslt'))
        # @doc = template.transform(document)
        @entry = @doc.xpath("//entry")[0]
        
        if @entry == nil
          flash[:error] = "Couldn't find '#{@word}'. Please try another one."
          redirect_to search_path
        else
          @entry_def = @entry.at_css("def") # get the definition of the word
          
          # #count the amount of vi of each dt
          # if @entry_def.css("dt")
          #   @amount_of_vi = Array.new
          #   @entry_def_dt = @entry_def.css("dt")
          #   @entry_def_dt.each do |dt|
          #     amount = dt.css("vi").count
          #     @amount_of_vi.push(amount)
          #   end
          # end
          
          # modify the the parent of vi tag from dt to def 
          if @entry_def.css("vi")
            vi = @entry_def.css("vi")
            vi.each do |ex|
              ex.parent = @entry_def
            end
          end
          
          @pos = @entry.css("fl")         # get the part of speech
          @degree = @entry.css("in if")   # get the degree of word
          @vi = @entry_def.css("vi")      # get the examples
        end
      end
    end
  end

  def create   
  end

  def show
  end
end