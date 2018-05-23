class UserController < ApplicationController

  before_action :authenticate_user, {only: [:author_central, :reader_central, :new_book_register, :edit_user, :edit_reader, :edit_book_register, :first_chapter, :next_chapter, :book_table_author, :confirm_chapter, :edit_book_register_post, :edit_writer, :edit_reading, :create_book, :first_chapter_register, :next_chapter_register, :post_comment, :comment_destroy, :central_commentDestroy, :likeReading_destroy, :comment_share, :chat_allOpen, :chat_allOpen, :ManagerAccount]}
  before_action :ensure_correct_user, {only: [:author_central, :reader_central, :new_book_register, :edit_user, :edit_reader, :edit_book_register, :first_chapter, :next_chapter, :book_table_author, :confirm_chapter, :edit_book_register_post, :edit_writer, :edit_reading, :create_book, :first_chapter_register, :next_chapter_register, :post_comment, :comment_destroy, :central_commentDestroy, :likeReading_destroy, :comment_share, :chat_allOpen, :chat_allOpen]}
  
  
  def reader_register
  	@user = User.new
  end
  
  def author_register
  	@user = User.new
  end
  
  def ManagerAccount
  	if @current_user.id != 5
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/")
    end
  	@users = User.all.order(created_at: :desc)
  end
  
  def login_form
  	@user = User.new
  end
  
  def forget_password
  	@user = User.new
  end
  
  def new_book_register
   	@user = User.find_by(id: params[:id])
	@book = Book.new
	@character = Character.new
	render layout: 'author_central'
  end
  
  def edit_user
  	@user = User.find_by(id: params[:id])
	render layout: 'author_central'
  end
  
  def edit_reader
  	@user = User.find_by(id: params[:id])
	render layout: 'reader_central'
  end
  
  def edit_book_register
  	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.find_by(id: params[:chat_id])
	render layout: 'author_central'
  end
  
  def edit_book_register_post
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.find_by(id: params[:chat_id])
	@book.book_title = params[:book_title]
	@book.book_description = params[:book_description]
	@book.book_category = params[:book_category]
	@book.category_others = params[:category_others]
	if params[:book_image]
		@book.book_image = "book#{@book.id}.jpg"
		image = params[:book_image]
		File.binwrite("public/book_images/#{@book.book_image}", image.read)
	end
	if @book.save 
		flash[:notice] = "小説の基本情報の編集が完了いたしました。"
		redirect_to("/chats/#{@book.user_id}/#{@book.id}/#{@chat.chapter_id}/writing_book")
	end
  end
  
  def create_reader
  	@user = User.new(
	  email: params[:email],
	  password: params[:password],
	  phrase: params[:phrase], 
	  gender: params[:gender],
	  user_name: params[:user_name],
	  user_image: "default_user.jpeg"
	  )
	@password = params[:password]
	@passowrd_confirm = params[:password_confirmation]
	@email = params[:email]
	@email_confirm = params[:email_confirmation]
	if @password != @passowrd_confirm || @email != @email_confirm
		@error_message = "パスワードまたはメールアドレスが一致していませんのでご確認ください。"
	  	render("user/reader_register") and return
	end
	if @user.save
		if params[:user_image]
	  		@user.user_image = "user#{@user.id}.jpg"
			image = params[:user_image]
			File.binwrite("public/user_images/#{@user.user_image}", image.read)
			@user.save(validate: false)
		end
      	session[:user_id] = @user.id
	 	flash[:notice] = "読者登録が完了いたしました。お気に入り登録した本がこちらに表示されます。"
      	redirect_to("/users/#{@user.id}/reader_central")
    else
      	render("user/reader_register")
    end
	
  end
  
  def create_writer
  	  @user = User.new(
	  email: params[:email],
	  password: params[:password],
	  phrase: params[:phrase], 
	  gender: params[:gender],
	  user_name: params[:user_name],
	  self_messeage: params[:self_messeage],
	  user_image: "default_user.jpeg"
	  )
	  @password = params[:password]
	  @passowrd_confirm = params[:password_confirmation]
	  @email = params[:email]
	  @email_confirm = params[:email_confirmation]
	  if @password != @passowrd_confirm || @email != @email_confirm
	  	  @error_message = "パスワードまたはメールアドレスが一致していませんのでご確認ください。"
	  	   render("user/author_register") and return
	  elsif @user.self_messeage.length < 100
	  	  @error_message = "自己紹介文は100字以上ご入力ください"
	  	   render("user/author_register") and return
	  end
	  if @user.save
	  	if params[:user_image]
	  		@user.user_image = "user#{@user.id}.jpg"
			image = params[:user_image]
			File.binwrite("public/user_images/#{@user.user_image}", image.read)
			@user.save(validate: false)
		end
      	session[:user_id] = @user.id
	 	flash[:notice] = "小説登録が完了いたしました。次は本を執筆しましょう。"
      	redirect_to("/users/#{@user.id}/author_central")
      else
      	render("user/author_register")
      end
  end
  
  def edit_writer
  	@user = User.find_by(id: params[:id])
  	@user.email = params[:email]
	@user.password = params[:password]
	@user.phrase = params[:phrase]
	@user.gender = params[:gender]
	@user.user_name = params[:user_name]
	@user.self_messeage = params[:self_messeage]
	if params[:user_image]
		@user.user_image = "user#{@user.id}.jpg"
		image = params[:user_image]
		File.binwrite("public/user_images/#{@user.user_image}", image.read)
	end
	@password = params[:password]
	@passowrd_confirm = params[:password_confirmation]
	@email = params[:email]
	@email_confirm = params[:email_confirmation]
	if @password != @passowrd_confirm || @email != @email_confirm
		@error_message = "パスワードまたはメールアドレスが一致していませんのでご確認ください。"
	  	render("user/edit_user") and return
	elsif @user.self_messeage.length < 100
		@error_message = "自己紹介文は100字以上ご入力ください"
	  	render("user/edit_user") and return
	end
	if @user.save
	 	flash[:notice] = "プロフィールの編集が完了いたしました。"
      	redirect_to("/users/#{@user.id}/author_central")
    else
      	render("user/edit_user")
    end
  end
  
  def edit_reading
  	@user = User.find_by(id: params[:id])
  	@user.email = params[:email]
	@user.password = params[:password]
	@user.phrase = params[:phrase]
	@user.gender = params[:gender]
	@user.user_name = params[:user_name]
	if params[:user_image]
		@user.user_image = "user#{@user.id}.jpg"
		image = params[:user_image]
		File.binwrite("public/user_images/#{@user.user_image}", image.read)
	end
	@password = params[:password]
	@passowrd_confirm = params[:password_confirmation]
	@email = params[:email]
	@email_confirm = params[:email_confirmation]
	if @password != @passowrd_confirm || @email != @email_confirm
		@error_message = "パスワードまたはメールアドレスが一致していませんのでご確認ください。"
	  	render("user/edit_reader") and return
	end
	if @user.save
	 	flash[:notice] = "プロフィールの編集が完了いたしました。"
      	redirect_to("/users/#{@user.id}/reader_central")
    else
      	render("user/edit_reader")
    end
  
  end
  
  def create_book
  	@user = User.find_by(id: params[:id])
	@book = Book.new(
	user_id: @user.id,
	book_title: params[:book_title],
	book_description: params[:book_description],
	book_category: params[:book_category],
	category_others: params[:category_others],
	book_image: "default_book.jpg"
	)
	if @book.save
	
	else
		render("user/new_book_register")
	end
	@character = Character.new(
	book_id: @book.id,
	character_name: params[:character_name],
	character_explain: "主人公",
	main: 1
	)
	if @character.save
		if params[:book_image]
			@book.book_image = "book#{@book.id}.jpg"
			image = params[:book_image]
			File.binwrite("public/book_images/#{@book.book_image}", image.read)
			@book.save
		end
		flash[:notice] = "本を書き始めるまであと一歩！まずは第1話のタイトルを決めましょう"
		redirect_to("/users/#{@user.id}/#{@book.id}/first_chapter")
	else
		render("user/new_book_register")
	end
  end
  
  def first_chapter
  	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.new
	render layout: 'author_central'
  end
  
  def next_chapter
  	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chapter = params[:chapter_id].to_i + 1
	render layout: 'author_central'
  end
  
  def first_chapter_register
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.new(
		book_id: @book.id,
		chapter_id: 1,
		open_unopen: 1,
		chapter_title: params[:book_chapter]
	)
	if @chat.save 
		flash[:notice] = "「話の主体」を選択の後、内容を書き始めよう！"
		redirect_to("/chats/#{@current_user.id}/#{@book.id}/#{@chat.chapter_id}/writing_book") and return
	else
		render("user/first_chapter")
	end
  end
  
  def next_chapter_register
  	@book = Book.find_by(id: params[:book_id])
	@chapter = params[:chapter_id]
	@chat = Chat.new(
		book_id: @book.id,
		chapter_id: @chapter,
		open_unopen: 1,
		chapter_title: params[:book_chapter]
	)
	if @chat.save 
		flash[:notice] = "「話の主体」を選択の後、内容を書き始めよう！"
		redirect_to("/chats/#{@current_user.id}/#{@book.id}/#{@chapter}/writing_book") and return
	else
		@title = params[:book_chapter]
		render("user/next_chapter")
	end
  end
  
  def confirm_chapter
  	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chapter = params[:chapter_id].to_i + 1
	@chat = Chat.find_by(book_id: @book.id, chapter_id: @chapter)
	if @chat 
		redirect_to("/chats/#{@user.id}/#{@book.id}/#{@chapter}/writing_book") and return
	else
		redirect_to("/users/#{@user.id}/#{@book.id}/#{params[:chapter_id]}/next_chapter")
	end
  end
  
  def login_post
  	@user = User.find_by(email: params[:email])
	 if @user && @user.authenticate(params[:password])
	 	session[:user_id] = @user.id
		redirect_to("/users/#{@user.id}/reader_central")
	 else 
	 	@error_message = "メールアドレスまたはパスワードが間違っています"
      	@email = params[:email]
      	@password = params[:password]
      	render("user/login_form")
	 end
  end
  
  def login_forget
  	@user = User.find_by(email: params[:email])
	 if @user && @user.phrase == params[:phrase]
	 	session[:user_id] = @user.id
		redirect_to("/users/#{@user.id}/reader_central")
	 else 
	 	@error_message = "「メールアドレス」または「好きな言葉やフレーズ」が間違っています"
      	@email = params[:email]
      	@phrase = params[:phrase]
      	render("user/forget_password")
	 end
  end
  
  def author_central
  	@user = User.find_by(id: params[:id])
	if @user.self_messeage == nil
		flash[:notice] = "作家になるには画面下の自己紹介文を追記ください。"	
		redirect_to("/users/#{@user.id}/edit_user/#selfIntroduceMsg") and return
	end
	@book = Book.where(user_id: @user.id).order(updated_at: :desc)
	render layout: 'author_central'
  end
  
  def reader_central
  	@user = User.find_by(id: params[:id])
	@reading = Reading.where(user_id: @user.id, finish: 1)
	@readed = Reading.where(user_id: @user.id, finish: 2)
	@likes = Like.where(user_id: @user.id, author_love: 1)
	@comments = Comment.where(user_id: @user.id)
	render layout: 'reader_central'
  end
  
  def book_table_author
  	@book = Book.find_by(id: params[:bookId])
	@user = User.find_by(id: @book.user_id)
	@chat = Chat.where(book_id: @book.id)
	@chat_check = Chat.find_by(book_id: @book.id, open_unopen: 1)
	@chat_exist = Chat.find_by(book_id: @book.id)
	if @chat_exist
	else
		redirect_to("/users/#{@user.id}/#{@book.id}/first_chapter") and return
	end
	render layout: 'author_central'
  end
  
  def chat_allOpen
  	@book = Book.find_by(id: params[:book_id])
	@book.finish = 2
	@book.save 
	@chat = Chat.where(book_id: @book.id)
	@chat.each do |chat|
		chat.open_unopen = 2
		chat.save
	end 
	flash[:notice] = "全話公開にいたしました。"
	redirect_to("/users/#{params[:id]}/#{@book.id}/book_table_author")
  end
  
  def chat_allUnopen
  	@book = Book.find_by(id: params[:book_id])
	@book.finish = 1
	@book.save 
	@chat = Chat.where(book_id: @book.id)
	@chat.each do |chat|
		chat.open_unopen = 1
		chat.save
	end 
	flash[:notice] = "全話非公開にいたしました。"
	redirect_to("/users/#{params[:id]}/#{@book.id}/book_table_author")
  end
  
  def comment_share
  	@book = Book.find_by(id: params[:book_id])
	@author = User.find_by(id: @book.user_id)
	@chat = Chat.find_by(book_id: @book.id, chapter_id: params[:chapter_id])
	@comments = Comment.where(book_id: @book.id, chapter_id: params[:chapter_id], owner: 1)
	@share = Comment.find_by(id: params[:comment_id])
	@user = User.find_by(id: @share.user_id)
  	render layout: 'reading_comment'
  end
  
  def post_comment
  	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.find_by(book_id: @book.id, chapter_id: params[:chapter_id])
	@character = Character.where(book_id: @book.id)
	@script = Script.where(chat_id: @chat.id)
	@next = params[:chapter_id].to_i + 1
	@previous = params[:chapter_id].to_i - 1
	@next_chat = Chat.find_by(book_id: @book.id, chapter_id: @next)
	@previous_chat = Chat.find_by(book_id: @book.id, chapter_id: @previous)
	@comment = Comment.new(
		user_id: params[:id],
		book_id: @book.id,
		chapter_id: params[:chapter_id],
		owner: 1,
		content: params[:book_comment]
	)
	if @comment.save 
		redirect_to("/users/#{@current_user.id}/#{@book.id}/#{@chat.chapter_id}/#{@comment.id}/comment_share")
	else
		render("home/read_chapter")
	end
  end
  
  def logout
  	  session[:user_id] = nil
	  flash[:notice] = "ログアウトしました"
	  redirect_to("/")
  end
  
  def comment_destroy
  	@comment = Comment.find_by(id: params[:comment_id])
	@comment.destroy
	flash[:notice] = "対象の投稿が削除されました。"
	redirect_to("/#{params[:book_id]}/#{params[:chapter_id]}/read_chapter")
  end
  
  def central_commentDestroy
  	@comment = Comment.find_by(id: params[:comment_id])
	@comment.destroy
	flash[:notice] = "対象の投稿が削除されました。"
	redirect_to("/users/#{@current_user.id}/reader_central")
  end
  
  def likeReading_destroy
  	@reading = Reading.find_by(user_id: params[:id], book_id: params[:book_id])
	@reading.destroy
	redirect_to("/users/#{@current_user.id}/reader_central")
  end
  
  def aozora
  	if @current_user.id != 5
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/")
    end
	@user = User.find_by(id: params[:user_id])
	@user.open_unopen = 1
	@user.save(validate: false)
	flash[:notice] = "青空作家にしました"
	redirect_to("/users/ManagerAccount")
  end
  
  def unopen_user
  	if @current_user.id != 5
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/")
    end
	@user = User.find_by(id: params[:user_id])
	@user.open_unopen = 2
	@user.save(validate: false)
	flash[:notice] = "この作家を非公開にしました"
	redirect_to("/users/ManagerAccount")
  end
  
  def open_user
  	if @current_user.id != 5
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/")
    end
	@user = User.find_by(id: params[:user_id])
	@user.open_unopen = 0
	@user.save(validate: false)
	flash[:notice] = "この作家を公開にしました"
	redirect_to("/users/ManagerAccount")
  end
  
  def MNG_userDelete
  	if @current_user.id != 5
      flash[:notice] = "権限がありません | You do not have right to access"
      redirect_to("/")
    end
	@user = User.find_by(id: params[:user_id])
	@user.open_unopen = 3
	@user.save(validate: false)
	flash[:notice] = "この作家を退会処理しました"
	redirect_to("/users/ManagerAccount")
  end
  
end
