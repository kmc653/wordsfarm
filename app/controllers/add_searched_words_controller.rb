class AddSearchedWordsController < ApplicationController
  def search
    if params[:word]
      word = params[:word]
      api = '296ba566-058e-45a6-9a58-e62253ff0238'
      
      string = word << '?key=' << api

      url = URI.join('http://www.dictionaryapi.com/api/v1/references/learners/xml/', string)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      @hash = Hash.from_xml(res.body)
    end
  end

  def create   
  end

  def show
  end
end