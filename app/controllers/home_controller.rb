class HomeController < ApplicationController

  def top
  	@books = Book.where(finish: 2).order(updated_at: :desc)
	@users = User.where.not(self_messeage: "").limit(20).order(updated_at: :desc)
  end
  
  def termOfUse
  end
  
  def privacy_policy
  end
  
  def company_information
  end
  
  def author_menu
  	@users = User.where.not(self_messeage: "")
  end
  
  def category_all
  end
  
  def aozora_books
  	@users = User.where(open_unopen: "1")
	render layout: 'another_application'
  end
  
  def each_category
  	@number = params[:cat_number].to_i
	@word = params[:cat_word]
	@url = params[:cat_image]
	@books = Book.where(book_category: @number, finish: 2).order(updated_at: :desc)
	render layout: 'another_application'
  end
  
  def book_brief
  	@book = Book.find_by(id: params[:book_id])
	@user = User.find_by(id: @book.user_id)
	@chat = Chat.where(book_id: @book.id, open_unopen: 2)
	@first_chapter = Chat.where(book_id: @book.id, open_unopen: 2).first
	@character = Character.where(book_id: @book.id)
	@reviews = Review.where(book_id: @book.id)
	@good = Review.where(book_id: @book.id, point: 5)
	@normal = Review.where(book_id: @book.id, point: 3)
	@bad = Review.where(book_id: @book.id, point: 1)
	render layout: 'user_mokuji'
  end
  
  def read_comment
  	@book = Book.find_by(id: params[:book_id])
	@author = User.find_by(id: @book.user_id)
	@chat = Chat.find_by(book_id: @book.id, chapter_id: params[:chapter_id])
	@comments = Comment.where(book_id: @book.id, chapter_id: params[:chapter_id], owner: 1)
	render layout: 'user_reading'
  end
  
  def read_chapter
  	@book = Book.find_by(id: params[:book_id])
	@author = User.find_by(id: @book.user_id)
	@chat = Chat.find_by(book_id: @book.id, chapter_id: params[:chapter_id])
	@character = Character.where(book_id: @book.id)
	@script = Script.where(chat_id: @chat.id)
	@comments = Comment.where(book_id: @book.id, chapter_id: params[:chapter_id], owner: 1)
	@next = params[:chapter_id].to_i + 1
	@previous = params[:chapter_id].to_i - 1
	@next_chat = Chat.find_by(book_id: @book.id, chapter_id: @next)
	@previous_chat = Chat.find_by(book_id: @book.id, chapter_id: @previous)
	if session[:user_id] 
		@review = Review.find_by(user_id: @current_user.id, book_id: @book.id)
		@reading = Reading.find_by(user_id: @current_user.id, book_id: @book.id)
		@like = Like.find_by(user_id: @current_user.id, author_id: @book.user_id, author_love: 1)
		if @reading
			@reading.chapter_id = @chat.chapter_id
			@reading.save
		else 
			@reading = Reading.new(
				user_id: @current_user.id,
				book_id: @book.id,
				chapter_id: @chat.chapter_id,
				finish: 1
			)
			@reading.save
		end
		if @like
		else
			@Like = Like.new(
			user_id: @current_user.id,
			author_id: @book.user_id,
			author_love: 1
			)
			@Like.save
		end
	end
	render layout: 'user_reading'
  end
  
  def good_comment
  	@comment = Comment.find_by(id: params[:comment_id])
	@user = User.find_by(id: params[:id])
	@like = Like.new(
		user_id: params[:id],
		author_id: @comment.user_id,
		book_id: params[:book_id],
		comment_id: @comment.id,
		good: 1
	)
	@like.save
	if @user.good_point
	else
		@user.good_point = 0
	end
	@user.good_point += 1
	@user.save
	if @comment.good
	else
		@comment.good = 0
	end
	@comment.good += 1
	@comment.save
	redirect_to("/#{params[:book_id]}/#{params[:chapter_id]}/read_comment/#comment#{@comment.id}")
  end
  
  def bad_comment
  	@comment = Comment.find_by(id: params[:comment_id])
	@user = User.find_by(id: params[:id])
	@like = Like.new(
		user_id: params[:id],
		author_id: @comment.user_id,
		book_id: params[:book_id],
		comment_id: @comment.id,
		bad: 1
	)
	@like.save
	if @comment.bad
	else
		@comment.bad = 0
	end
	@comment.bad += 1
	@comment.save
	redirect_to("/#{params[:book_id]}/#{params[:chapter_id]}/read_comment/#comment#{@comment.id}")
  end
  
  def good_destroy
  	@comment = Comment.find_by(id: params[:comment_id])
	@user = User.find_by(id: params[:id])
  	@like = Like.find_by(user_id: params[:id], author_id: @comment.user_id, book_id: params[:book_id], comment_id: @comment.id, good: 1)
	@like.destroy
	@user.good_point -= 1
	@user.save
	@comment.good -= 1
	@comment.save
	redirect_to("/#{params[:book_id]}/#{params[:chapter_id]}/read_comment/#comment#{@comment.id}")
  end
  
  def bad_destroy
  	@comment = Comment.find_by(id: params[:comment_id])
	@user = User.find_by(id: params[:id])
  	@like = Like.find_by(user_id: params[:id], author_id: @comment.user_id, book_id: params[:book_id], comment_id: @comment.id, bad: 1)
	@like.destroy
	@comment.bad -= 1
	@comment.save
	redirect_to("/#{params[:book_id]}/#{params[:chapter_id]}/read_comment/#comment#{@comment.id}")
  end
  
  def author_introduce
  	@user = User.find_by(id: params[:id])
	@books = Book.where(user_id: @user.id).where(finish: 2)
	render layout: 'author_introduce'
  end
  
  def book_review
  	@book = Book.find_by(id: params[:book_id])
	@reading = Reading.find_by(user_id: params[:id], book_id: @book.id)
	@reading.finish = 2
	@reading.save
  	@review = Review.new(
	  user_id: params[:id],
	  book_id: params[:book_id],
	  point: params[:book_review],
	  content: params[:book_comment]
	  )
	 if @review.save
	 	 flash[:notice] = "「#{@book.book_title}」を読破しました。読破した本はマイページでご確認頂けます。"
		 redirect_to("/#{params[:book_id]}/book_brief")
	 end
  end
  
  def edit_review
  	@book = Book.find_by(id: params[:book_id])
	@review = Review.find_by(user_id: params[:id], book_id: @book.id)
	@review.point = params[:book_review]
	@review.content = params[:book_comment]
	if @review.save
		flash[:notice] = "「#{@book.book_title}」の評価を編集しました。"
		redirect_to("/#{params[:book_id]}/book_brief")
	end
  end
  
  def question
  	@email = params[:contact_email]
	@subject = params[:contact_subject]
	@message = params[:contact_msg]
	@our = "Receivingbox@medicihiroba.com"
	BookChatMailer.send_customer_question_our(@email,@subject,@message,@our).deliver
	flash[:notice] = "お問い合わせを受け付けいたしました。"
	redirect_to("/")
  end
  
end
