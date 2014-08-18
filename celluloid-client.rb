require 'celluloid/autostart'

class ApnsConcurrent
  include Celluloid

  def manage_clients(options)
    thread_pool = Pool.new(options.pool_size)
    apns_client_hash = Array.new
    registered_apns_clients = Hash.new
    apns_client_holder = Hash.new
    FileUtils.mkdir_p('tmp')
    supervisor = nil
    options.credentials_range.each do |credentials|
      device_name = "SCALE-#{credentials.identifier}"
      jmeter_file_name = "tmp/#{device_name}.csv"
      puts "in credential loop"

      thread_pool.schedule  do device_name
        apns_client_hash = [device array]
      end

      while true
        supervisor = nil
        puts "in while true #{apns_client_hash.size} "
        apns_client_hash.each do |device_array|
          device_name = device_array[0]
          apns_client = device_array[1]
          File.open("tmp/#{device_name}_mdm.log", 'a') do |logf|
            puts "while true - open the file"
            begin
              apns_client.read()
            rescue StandardError => e
              puts "error happened"
              logger.error("Exception: #{e}, #{e.backtrace}")
            end
          end
          puts "#{Time.new} end of loop for  #{device_name}"

        end
        true
      end # client hash.each
      puts "sleep 1"

      sleep 1
    end #while true
  end
end

apnsConcurrent = ApnsConcurrent.new
apnsConcurrent.manage_clients(options)
