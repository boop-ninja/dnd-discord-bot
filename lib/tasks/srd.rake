require 'json'
require 'kramdown-asciidoc'

WORKING_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
SRD_BASE = File.expand_path(File.join(WORKING_DIR, 'data', 'WOTC_5e_SRD_v5.1'))
SRD_BASE_EXIST = File.exist? SRD_BASE
SRD_OUTPUT_FILE = File.expand_path(File.join(WORKING_DIR, 'data', 'wotc_5e_srd_output.json'))
SRD_OUTPUT_FILE_EXISTS = File.exist? SRD_OUTPUT_FILE

def parse_srd_file(json_file)
  JSON.parse(File.read(File.expand_path(File.join(SRD_BASE, json_file))), symbolize_names: true)
end

def edit_output
  json = JSON.parse(File.read(SRD_OUTPUT_FILE), symbolize_names: true)
  yield json
  File.write(SRD_OUTPUT_FILE, JSON.pretty_generate(json))
end

def sanitize(markdown)
  Kramdoc.convert markdown
end

# namespace :srd do
#   desc 'Runs an formatter on the SRD.'
#   task :format do
#     File.delete SRD_OUTPUT_FILE if SRD_OUTPUT_FILE_EXISTS
#     File.write(SRD_OUTPUT_FILE, '[]')
#     tasks = %w[add_documentation display_output]
#     tasks.each { |t| Rake::Task["srd:format:#{t}"].invoke }
#
#   end
#   namespace :format do
#     task :display_output do
#       puts JSON.pretty_generate(JSON.parse(File.read(SRD_OUTPUT_FILE), symbolize_names: true))
#     end
#     task :add_documentation do
#       documentation = parse_srd_file('document.json')[0]
#       documentation[:tags] = documentation[:title].downcase.tr(' ', '_')
#       edit_output { |json| json << documentation }
#     end
#     task :add_armour do
#
#     end
#   end
#
# end

markdown = <<~EOS
  Acolytes are shaped by their experience in temples or other religious communities. Their study of the history and tenets of their faith and their relationships to temples, shrines, or hierarchies affect their mannerisms and ideals. Their flaws might be some hidden hypocrisy or heretical idea, or an ideal or bond taken to an extreme.
  
  **Suggested Acolyte Characteristics (table)**
  
  | d8 | Personality Trait                                                                                                  |
  |----|--------------------------------------------------------------------------------------------------------------------|
  | 1  | I idolize a particular hero of my faith, and constantly refer to that person's deeds and example.                  |
  | 2  | I can find common ground between the fiercest enemies, empathizing with them and always working toward peace.      |
  | 3  | I see omens in every event and action. The gods try to speak to us, we just need to listen                         |
  | 4  | Nothing can shake my optimistic attitude.                                                                          |
  | 5  | I quote (or misquote) sacred texts and proverbs in almost every situation.                                         |
  | 6  | I am tolerant (or intolerant) of other faiths and respect (or condemn) the worship of other gods.                  |
  | 7  | I've enjoyed fine food, drink, and high society among my temple's elite. Rough living grates on me.                |
  | 8  | I've spent so long in the temple that I have little practical experience dealing with people in the outside world. |
  
  | d6 | Ideal                                                                                                                  |
  |----|------------------------------------------------------------------------------------------------------------------------|
  | 1  | Tradition. The ancient traditions of worship and sacrifice must be preserved and upheld. (Lawful)                      |
  | 2  | Charity. I always try to help those in need, no matter what the personal cost. (Good)                                  |
  | 3  | Change. We must help bring about the changes the gods are constantly working in the world. (Chaotic)                   |
  | 4  | Power. I hope to one day rise to the top of my faith's religious hierarchy. (Lawful)                                   |
  | 5  | Faith. I trust that my deity will guide my actions. I have faith that if I work hard, things will go well. (Lawful)    |
  | 6  | Aspiration. I seek to prove myself worthy of my god's favor by matching my actions against his or her teachings. (Any) |
  
  | d6 | Bond                                                                                     |
  |----|------------------------------------------------------------------------------------------|
  | 1  | I would die to recover an ancient relic of my faith that was lost long ago.              |
  | 2  | I will someday get revenge on the corrupt temple hierarchy who branded me a heretic.     |
  | 3  | I owe my life to the priest who took me in when my parents died.                         |
  | 4  | Everything I do is for the common people.                                                |
  | 5  | I will do anything to protect the temple where I served.                                 |
  | 6  | I seek to preserve a sacred text that my enemies consider heretical and seek to destroy. |
  
  | d6 | Flaw                                                                                          |
  |----|-----------------------------------------------------------------------------------------------|
  | 1  | I judge others harshly, and myself even more severely.                                        |
  | 2  | I put too much trust in those who wield power within my temple's hierarchy.                   |
  | 3  | My piety sometimes leads me to blindly trust those that profess faith in my god.              |
  | 4  | I am inflexible in my thinking.                                                               |
  | 5  | I am suspicious of strangers and expect the worst of them.                                    |
  | 6  | Once I pick a goal, I become obsessed with it to the detriment of everything else in my life. |
EOS

# puts sanitize(markdown)