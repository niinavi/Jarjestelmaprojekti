# Logstash notes

Notes are mainly based on:
[Elastic website](https://www.elastic.co/guide/en/logstash/current/pipeline.html) and logstash webinar [here](https://www.elastic.co/webinars/getting-started-logstash?baymax=default&elektra=docs&storm=top-video)
Logstash is a tool to centralize, transform and stash your data.


### Structure

Logstash process Events. Event processing pipeline has three stages. 

#### Inputs
Inputs define how data gets into Logstash. Some of the common inputs are: 
  - File 
  - syslog 
  - redis (redis server)
  - beats (events sent by Beats)

#### Filters
With filters you can structure, transform and normalize data. Filters have plugins. 
  - grok (parse and structure text)
  - mutate (field manipulation, rename, remove, replace and modify fields)
  - drop (drop an event, for example debug)
  - clone (make a copy of an event, adding or removing)
  - geoip (geographical location of IP address)

Core Manipulation (manipulate data, control flow of the data). Few examples on fictional data models:
```
filter {
  mutate {
    split => "field_that_is_an_array"
	add_field => {"foo" => "bar-%{other_field}"}
	}
}
```

```
filter {
# any string inside the field account will be lowercase
  mutate {  lowercase => "account" }

# check if the type is "batch" type. Batch event has special field actions that has different arrays.
  if [type] == "batch" {
    split { field => actions target => action }
  }
# if action has event "special" it will be dropped
  if { "action" =~ /special/ } {
    drop {}
	
  }
}
```

```
filter {
  geoip {
    fields => "my_geoip_field"
	}
}
```
#### Outputs
Outputs send the event data to the defined output. Can also send data with public protocols (TCP, UDP, HTTP). Commonly used:
  - elasticsearch
  - file (write event data to a file on disk)
  - graphite (open source tool for storing and graphing metrics)
  - statsd (service for statistic)
  - codecs (stream filters that can operate as part of an input or output)

  
Simple example of logstash configuration. The logstash configuration files will be /etc/logstash/conf.d directory.
```
input {
  beats {
    port => 5044
  }
}

filter {

# Grok pattern that contains the full text, "message" should match the pattern
# Greedydata means the rest of the data, it is the text itself. "line" means that it will be copied into a line
  grok {
    match => [
	  "message", "%{TIMESTAMP_ISO8601:timestamp_string}%{SPACE}%{GREEDYDATA:line}"
	]
	}
# Parsing the timestamp_string into a time date type
  date {
    match => ["timestamp_string", "ISO8601"]
	}
# Remove the timestamp_string because we now have the parsed date type	
  mutate {
    remove_field => [message, timestamp_string]
	}
}

output {
  elasticsearch { hosts => ["localhost:9200"] }
}	  
```


## Logstash Administrator
Can be done with Kibana dashboard's Monitoring.

- gives the metrics of logstash deployment
- you can see pipelines and plugins
- you can make changes to the pipeline and logstash will automatically reload it 
- For example statistic CPU and system load


 ---------
Sources:
https://www.elastic.co/guide/en/logstash/current/pipeline.html
 
Webinar by Alvin Chen and Andrew Cholakian:
https://www.elastic.co/webinars/getting-started-logstash?baymax=default&elektra=docs&storm=top-video
 
