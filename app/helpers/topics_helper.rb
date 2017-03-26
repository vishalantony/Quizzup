module TopicsHelper
	def quizzes_under_topic(topic)
		qs = Question.where('topic_id = (?)', topic.id).preload(:quizzes)
		qzs = []
		qs.each do |q|
			qzs += q.quizzes
		end
		qzs.uniq.count
	end
end
