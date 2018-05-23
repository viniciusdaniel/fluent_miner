[Fluentd](http://fluentd.org)/kibana
=================

A fluentd buffered output filter that posts to https a json array of records on kibana format

Installation
=================

gem install 'fluent-kibana-plugin'

Usage
=================

```
<match SOME_EVENT>
  type kibana
  buffer_path /tmp/buffer

  buffer_chunk_limit 256m
  buffer_queue_limit 128
  flush_interval 10s
  endpoint    http://127.0.0.1:3000/consume_json_arrays_of_some_event/

</match>
```