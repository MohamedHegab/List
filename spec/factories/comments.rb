FactoryBot.define do
  factory :comment do
    content { "MyString" }
    user
    factory :comment_for_comment do
	    commentable { |a| a.association(:comment) }
		end

		factory :comment_for_card do
	    commentable { |a| a.association(:card) }
		end
  end
end
