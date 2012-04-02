require 'csv'

module Rack
  module Redirect

    class CSVError < StandardError; end

    class FileRedirector

      attr_reader :redirect_hash

      def initialize(file_path)
        raise ArgumentError, "FileRedirector expects a valid existing file. File path given was [ #{file_path} ]" unless valid_file_path?(file_path)
        @redirect_hash ||= load_redirects_from_file(file_path)
      end

      def redirect_uri string
        return nil if string.nil?
        value = @redirect_hash[string]
        invalid_url?(value) ? nil : value
      end

      private
      
      def load_redirects_from_file(file_path)
        begin
          arr_of_arrs = CSV.read(file_path)
          @redirect_hash = Hash[arr_of_arrs]
        rescue => e
          raise CSVError, "Problem reading csv file [ #{e.message} ]"
        end
      end

      def invalid_url?(value)
        #TODO determine a better way to check if a url is invalid.
        value.nil? || value.strip.empty?
      end

      def valid_file_path?(file_path)
        ::File.exists?(file_path) && !::File.directory?(file_path)
      end
    end
  end
end
