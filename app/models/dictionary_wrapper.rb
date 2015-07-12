module DictionaryWrapper
  class Search
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def self.create(word)
      api = '296ba566-058e-45a6-9a58-e62253ff0238'
      string = word + '?key=' + api
      url = URI.join('http://www.dictionaryapi.com/api/v1/references/learners/xml/', string)
      req = Net::HTTP::Get.new(url.to_s)
      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      new(response)
    end

    def document
      Nokogiri::XML(response.body)
    end

    def entry
      document.xpath("//entry")[0]
    end

    def entry_def
      entry.at_css("def")
    end

    def part_of_speech
      entry.css("fl")
    end

    def degree_of_word
      entry.css("in if")
    end

    def examples
      entry_def.css("vi")
    end
  end
end