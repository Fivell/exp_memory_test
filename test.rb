# frozen_string_literal: true
require 'prometheus_exporter'
require 'prometheus_exporter/server'
require 'memory_profiler'


collector = PrometheusExporter::Server::Collector.new


def process_log(&block)
  File.open('log.txt').each do |line|
    json = line.partition('process method called with: ').last
    block.call(json) unless json.length.zero?
  end
end

MemoryProfiler.start

process_log do |json|
  collector.process(json)
end


report = MemoryProfiler.stop
report.pretty_print

