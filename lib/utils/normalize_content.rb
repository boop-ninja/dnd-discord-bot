
# @param content [String]
def normalize_content(content)
  content.sub /^\!\w+\W/, ''
end
