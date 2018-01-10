require "httparty"

class FoodTruckWrapper
  BASE_URL_SCHEDULE = "http://data.sfgov.org/resource/bbb8-hzi6.json"
  BASE_URL_ADDRESS = "https://data.sfgov.org/resource/6a9r-agq8.json"

  #display opened food cart
  def self.getOpenTrucks
    current_time = "\"" + DateTime.now.strftime('%H:%M') + "\""
    current_weekday = DateTime.now.wday

    time_url = BASE_URL_SCHEDULE + "?$order=applicant"  #trucks sorted by name
    time_url2 = time_url + "&$where=dayorder=" + current_weekday.to_s + " AND start24 <= " + current_time + " AND end24 >= " + current_time  #only opening trucks at the current time

    response = HTTParty.get(time_url2).parsed_response

    if response.count == 0
      puts "There is no openning food truck now"
      return
    end

    counter = 1
    printf("|%-8s|%75s|%30s|\n\n", '=======', '='*75 , '='*30)
    printf("|%-8s|%75s|%30s|\n\n", 'Counter', 'Truck Name'.ljust(75), 'Address'.ljust(30))
    printf("|%-8s|%75s|%30s|\n\n", '=======', '='*75 , '='*30)

    response.each do |item|
        printf("|%-8s|%75s|%30s|\n", counter, item['applicant'].ljust(75), getTruckAddress(item['locationid']).ljust(30))

        counter += 1

        if counter % 10 == 1 #display maximum 10 trucks per page

          puts "\n........... press Enter to continue"
          gets.chomp
        end
    end
    printf("|%-8s|%75s|%30s|\n\n", '=======', '='*75 , '='*30)
  end

  #fetch truck address per unique objectid
  def self.getTruckAddress(locationid)
    address_url = BASE_URL_ADDRESS + "?$where=objectid="+locationid
    response = HTTParty.get(address_url).parsed_response
    return response[0]['address']
  end
end

startProgram = FoodTruckWrapper.getOpenTrucks
