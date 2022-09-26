# http://stackoverflow.com/questions/18646223/ruby-model-output-id-as-object-oid/20813109
module BSON
  class ObjectId
    # alias :to_json :to_s
    # alias :as_json :to_s
    def to_json(*args); to_s.to_json end
    def as_json(*args); to_s.as_json end
  end
end
