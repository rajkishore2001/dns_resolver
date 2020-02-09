def get_command_line_argument
    

    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end
  
  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument
  
  
  dns_raw = File.readlines("zone")
  
    def parse_dns(local_copy_dns)
        domain_info_hash={}
        local_copy_dns.each do|record_info|
            record_array=[]
            record_info.split(",").each do|record_info_elemt|
                record_array.push(record_info_elemt.strip)
            end
            domain_info_hash[record_array[1]]={"zone_type"=>record_array[0],"ip_address"=>record_array[2].to_s}
        end
        domain_info_hash
    end
    
    def resolve(loopup_hash,lookup_chain,searched_domain)
        if(loopup_hash[searched_domain].nil?)
            lookup_chain.push("not found")
        elsif(loopup_hash[searched_domain]["zone_type"].to_s=='A')
            lookup_chain.push(loopup_hash[searched_domain]["ip_address"])
        elsif(loopup_hash[searched_domain]["zone_type"].to_s=='CNAME')
            lookup_chain.push(loopup_hash[searched_domain]["ip_address"])
            resolve(loopup_hash,lookup_chain,loopup_hash[searched_domain]["ip_address"])
        end
    end
  
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join("=>")
