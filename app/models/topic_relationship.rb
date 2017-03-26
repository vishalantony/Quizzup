class TopicRelationship < ApplicationRecord
	belongs_to :parent, class_name: 'Topic', inverse_of: :parenting_relationships
	belongs_to :subtopic, class_name: 'Topic', inverse_of: :subtopic_relationship
end
