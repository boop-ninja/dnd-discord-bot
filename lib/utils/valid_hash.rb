def valid_hash?(string)
  string = string.gsub(/(\w+):\s*([^},])/, '"\1":\2')
  #=> "{:key_1=>true,\"key_2\":false}"
  string = string.gsub(/:(\w+)\s*=>/, '"\1":')
  #=> "{\"key_1\":true,\"key_2\":false}"
  my_hash = JSON.parse(string, symbolize_names: true)
  #=> {:key_1=>true, :key_2=>false}
  my_hash.is_a? Hash # or do whatever you want with your Hash
rescue JSON::ParserError
  false
end
