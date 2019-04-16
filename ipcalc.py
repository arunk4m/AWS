#!/usr/bin/python
import json
import urllib


def total_ip_address():
        aws = 0
        URL = 'https://ip-ranges.amazonaws.com/ip-ranges.json'
        count_region = {}
        count_service = {}

        response = urllib.urlopen(URL)
        data = json.aloads(response.read())

        for entry in data['prefixes']:
                #print count_regino.keys()
                if str(entry['region']) in count_region.keys():
                        pass
                else:
                        count_region[str(entry['region'])] = 0
                if str(entry['service']) in count_service.keys():
                        pass
                else:
                        count_service[str(entry['service'])] = 0

        for entry in data['prefixes']:
                var1 = str(entry['ip_prefix'])
                var2 = var1.split('/')
                var2 = var2[-1:]        
                results = map(int, var2)
                ip =  (2**32 - 2**int(results.pop()) - 2)
                if str(entry['region']) in count_region.keys():
                        count_region[str(entry['region'])] += ip
                if str(entry['service']) in count_service.keys():
                        count_service[str(entry['service'])] += ip
                aws += ip
        print "The list of IPAddress in a region are : "
        for region,val in count_region.items():
                print  region,val
        print "The list of IPAddress in a service are : "
        for service,val in count_service.items():
                print  service,val
        return  aws


if __name__=="__main__":
        ip = total_ip_address()
        print "The number of IPAddress are :  %d" %ip