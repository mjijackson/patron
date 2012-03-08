module Patron
  module Caching
    attr_writer :response_cache_file

    def response_cache_file
      @response_cache_file || './patron.dump'
    end

    def read_response_cache
      if File.exist?(response_cache_file)
        Marshal.load(File.read(response_cache_file))
      else
        Hash.new
      end
    end

    def write_response_cache
      File.open(response_cache_file, 'w') do |file|
        file.write(Marshal.dump(response_cache))
      end
    end

    def write_response_cache_on_exit!
      @exit_handler ||= at_exit { write_response_cache }
    end

    def response_cache
      @response_cache ||= read_response_cache
    end

    def handle_request(request)
      write_response_cache_on_exit! if @response_cache_file
      response_cache[request] ||= super
    end
  end
end
