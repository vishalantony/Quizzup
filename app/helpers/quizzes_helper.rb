module QuizzesHelper
	def self.mapper(durations, questions)
		m = durations.zip questions
		q_map = {}
		m.each do |k, v| 
			q_map[k] = v
		end
		return q_map 
	end
end
