require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else 
			puts "Error... your tweet is longer than 140 characters."
			exit
		end
	end

	def run
		puts "Welcome to the JD's Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q' then puts "Goodbye!"
				when 't' then puts tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt' then everyones_last_tweet
				else
					puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def dm(target, message)
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		if screen_names.include?(target)
			puts "Trying to send #{target} a direct message:"
			message = "d @#{target} #{message}"
			puts message
			tweet(message)
			
		else
			puts "Error, you may only dm people you follow..."
		end
	end

	def followers_list
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		return screen_names
	end

	def spam_my_followers(message)
		#followers_list.each { |x| puts x }
		#puts message
		followers_list.each { |x| dm(x, message)}
	end

	def everyones_last_tweet
		friends = @client.friends
		friends.each { |friend| puts friend.screen_name }
	end



end

blogger = MicroBlogger.new
blogger.run

