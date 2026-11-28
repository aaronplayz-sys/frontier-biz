#!/usr/bin/env ruby

require "yaml"
require "set"

ROOT = File.expand_path("..", __dir__)
GUIDES_FILE = File.join(ROOT, "_data", "guides.yml")
CATEGORIES_FILE = File.join(ROOT, "_data", "categories.yml")

VALID_STATUSES = %w[planned drafting review published archived].freeze
VALID_SOURCE_STATUSES = %w[new existing split merged shared unknown].freeze
VALID_MIGRATION_STATUSES = %w[not_started in_progress review_required completed].freeze

errors = []
warnings = []

def error(errors, message)
  errors << message
end

guides = YAML.safe_load_file(GUIDES_FILE)
categories = YAML.safe_load_file(CATEGORIES_FILE)

unless guides.is_a?(Array) && categories.is_a?(Array)
  abort "Catalog files must each contain a YAML array."
end

guide_ids = guides.map { |guide| guide["id"] }
category_ids = categories.map { |category| category["id"] }

guide_ids.compact.tally.each do |id, count|
  error(errors, "Duplicate guide ID: #{id}") if count > 1
end

category_ids.compact.tally.each do |id, count|
  error(errors, "Duplicate category ID: #{id}") if count > 1
end

guides_by_id = guides.to_h { |guide| [guide["id"], guide] }
categories_by_id = categories.to_h { |category| [category["id"], category] }

guides.each do |guide|
  id = guide["id"] || "(missing ID)"

  %w[id title description modes categories status source_status migration_status permalink].each do |field|
    error(errors, "#{id}: missing #{field}") if guide[field].nil?
  end

  error(errors, "#{id}: invalid status") unless VALID_STATUSES.include?(guide["status"])
  error(errors, "#{id}: invalid source_status") unless VALID_SOURCE_STATUSES.include?(guide["source_status"])
  error(errors, "#{id}: invalid migration_status") unless VALID_MIGRATION_STATUSES.include?(guide["migration_status"])

  unless guide["modes"].is_a?(Array) && !guide["modes"].empty?
    error(errors, "#{id}: modes must be a non-empty array")
  end

  unless guide["categories"].is_a?(Array) && !guide["categories"].empty?
    error(errors, "#{id}: categories must be a non-empty array")
  end

  permalink = guide["permalink"]
  unless permalink.is_a?(String) && permalink.start_with?("/") && permalink.end_with?("/")
    error(errors, "#{id}: malformed permalink")
  end

  Array(guide["categories"]).each do |category_id|
    error(errors, "#{id}: unknown category #{category_id}") unless categories_by_id.key?(category_id)
  end

  Array(guide["source_paths"]).each do |source_path|
    full_path = File.join(ROOT, source_path)
    warnings << "#{id}: source file not found: #{source_path}" unless File.file?(full_path)
  end

  if guide["status"] == "published" && guide["migration_status"] != "completed"
    error(errors, "#{id}: published guide has incomplete migration")
  end
end

guides.group_by { |guide| guide["permalink"] }.each do |path, records|
  error(errors, "Duplicate permalink: #{path}") if path && records.size > 1
end

categories.each do |category|
  id = category["id"] || "(missing category ID)"
  refs = category["guide_ids"]

  unless refs.is_a?(Array)
    error(errors, "#{id}: guide_ids must be an array")
    next
  end

  error(errors, "#{id}: duplicate guide IDs") if refs.uniq.size != refs.size

  refs.each do |guide_id|
    guide = guides_by_id[guide_id]
    unless guide
      error(errors, "#{id}: unknown guide #{guide_id}")
      next
    end

    unless Array(guide["categories"]).include?(id)
      error(errors, "#{guide_id}: missing reciprocal category #{id}")
    end

    unless (Array(category["modes"]) - Array(guide["modes"])).empty?
      error(errors, "#{guide_id}: incompatible modes for category #{id}")
    end
  end
end

guides.each do |guide|
  Array(guide["categories"]).each do |category_id|
    category = categories_by_id[category_id]
    next unless category

    unless Array(category["guide_ids"]).include?(guide["id"])
      error(errors, "#{guide['id']}: missing from category registry #{category_id}")
    end
  end
end

puts "Frontier Biz 2.0 Catalog Validation"
puts "-----------------------------------"
puts "Unique guides: #{guides.size}"
puts "Categories: #{categories.size}"
puts "Category placements: #{categories.sum { |category| Array(category['guide_ids']).size }}"

puts "\nGuides by mode:"
%w[campaign multiplayer frontier-defense].each do |mode|
  count = guides.count { |guide| Array(guide["modes"]).include?(mode) }
  puts "  #{mode}: #{count}"
end

puts "\nWarnings:"
warnings.each { |message| puts "  WARNING: #{message}" }

puts "\nErrors:"
errors.each { |message| puts "  ERROR: #{message}" }

if errors.empty?
  puts "\nCatalog structure validation passed."
  exit 0
else
  puts "\nCatalog validation failed: #{errors.size} error(s)."
  exit 1
end
