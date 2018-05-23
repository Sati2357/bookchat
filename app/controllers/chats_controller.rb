class ChatsController < ApplicationController

  before_action :authenticate_user, {only: [:writing_book, :add_chracter, :book_open, :book_unopen, :change_title, :add_character_post, :edit_character_post, :creat_script, :edit_script, :delete_script]}
  before_action :ensure_correct_user, {only: [:writing_book, :add_chracter, :book_open, :book_unopen, :change_title, :add_character_post, :edit_character_post, :creat_script, :edit_script, :delete_script]}

  def top
  end
  
  def writing_book
  	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.find_by(book_id: @book.id, chapter_id: params[:chapter_id])
	@character = Character.where(book_id: @book.id).order(updated_at: :desc)
	@script = Script.where(chat_id: @chat.id)
  	render layout: 'author_writing'
  end
  
  def edit_script
	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@chat = Chat.find_by(chapter_id: params[:chapter_id], book_id: @book.id)
	@script = Script.where(chat_id: @chat.id)
	@character = Character.where(book_id: @book.id).order(updated_at: :desc)
  	@scripto = Script.find_by(id: params[:script_id])
	@content = params[:script_content]
	  if params[:who_script] == "" && params[:who_feeling] == "" && params[:back_description] != "0"
	  	flash[:notice] = "情景描写であるか、誰のセリフあるいは気持ちか選択ください。"
		render("chats/writing_book")
	  elsif @content == ""
	  	flash[:notice] = "内容をご入力ください"
	  	render("chats/writing_book")
	  elsif params[:back_description] == "0" 
	  	@scripto.content = params[:script_content]
		@scripto.script_feeling = 0
		@scripto.character_id = ""
		@scripto.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{params[:chapter_id]}/writing_book/#script#{@scripto.id}")
	  elsif params[:who_script] != "" && params[:who_feeling] != ""
	  	flash[:notice] = "セリフか気持ちどちらか一方をご選択ください。"
		render("chats/writing_book")
	  elsif params[:who_script] != ""
	  	@scripto.script_feeling = 1
		@scripto.character_id = params[:who_script].to_i
		@scripto.content = @content
		@scripto.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{params[:chapter_id]}/writing_book/#script#{@scripto.id}")
	  elsif params[:who_feeling] != ""
	  	@scripto.script_feeling = 2
		@scripto.character_id = params[:who_feeling].to_i
		@scripto.content = @content
		@scripto.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{params[:chapter_id]}/writing_book/#script#{@scripto.id}")
	  else
	  	flash[:notice] = "エラー"
		render("chats/writing_book")
	  end
  end
  
  def delete_script
  	@script = Script.find_by(id: params[:script_id])
	@script.destroy 
	@Ascript = params[:script_id].to_i - 1
	redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{params[:chapter_id]}/writing_book/#script#{@Ascript}")
  end
  
  def book_open
  	@chat = Chat.find_by(book_id: params[:book_id], chapter_id: params[:chapter_id])
	@chat.open_unopen = 2
	@book = Book.find_by(id: params[:book_id])
	@book.finish = 2
	if @chat.save && @book.save
		flash[:notice] = "指定した「話」を公開しました。"
		redirect_to("/users/#{@current_user.id}/#{@chat.book_id}/book_table_author")
	end
  end
  
  def book_unopen
  	@chat = Chat.find_by(book_id: params[:book_id], chapter_id: params[:chapter_id])
	@chat.open_unopen = 1
	@chat.save
	@book_chat = Chat.find_by(book_id: params[:book_id], open_unopen: 2)
	if @book_chat
	
	else
		@book = Book.find_by(id: params[:book_id])
		@book.finish = 1
		@book.save
	end	
	flash[:notice] = "指定した「話」を非公開にしました。"
	redirect_to("/users/#{@current_user.id}/#{@chat.book_id}/book_table_author")
  end
  
  def change_title
  	@chat = Chat.find_by(book_id: params[:book_id], chapter_id: params[:chapter_id])
	@chat.chapter_title = params[:chapter_title]
	@chat.save
	redirect_to("/users/#{@current_user.id}/#{@chat.book_id}/book_table_author")
  end
  
  def add_chracter
  	@user = User.find_by(id: params[:id])
  	@book = Book.find_by(id: params[:book_id])
	@character = Character.where(book_id: @book.id)
  	render layout: 'author_central'
  end
  
  def add_character_post
  	@user = User.find_by(id: params[:id])
  	@book = Book.find_by(id: params[:book_id])
	@character = Character.new(
		book_id: @book.id,
		character_name: params[:character_name],
		character_explain: params[:character_detail],
		main: 2
	)
	if @character.save 
		flash[:notice] = "登場人物が登録されました。"
		redirect_to("/chats/#{@user.id}/#{@book.id}/#{params[:chapter_id]}/writing_book")
	else
		render("chats/add_chracter")
	end
  end
  
  def edit_character_post
  	@character = Character.find_by(id: params[:character_id])
	@character.character_name = params[:character_name]
	@character.character_explain = params[:character_explain]
	@character.main = params[:main]
	if @character.save 
		flash[:notice] = "登場人物の編集が完了しました"
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{params[:chapter_id]}/writing_book")
	else
		render("chats/add_chracter")
	end
  end
  
  def creat_script
  	@chat = Chat.find_by(id: params[:chat_id])
	@user = User.find_by(id: params[:id])
	@book = Book.find_by(id: params[:book_id])
	@character = Character.where(book_id: @book.id).order(updated_at: :desc)
	@content = params[:script]
	@script = Script.where(chat_id: @chat.id)
	  if params[:who_script] == "" && params[:who_feeling] == "" && params[:back_description] != "0"
	  	flash[:notice] = "情景描写であるか、誰のセリフあるいは気持ちか選択ください。"
		render("chats/writing_book")
	  elsif @content == ""
	  	flash[:notice] = "内容をご入力ください"
	  	render("chats/writing_book")
	  elsif params[:back_description] == "0" 
	  	@script = Script.new(
		  	chat_id: @chat.id,
			script_feeling: 0,
			character_id: 0,
			content: @content
		  )
		@script.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{@chat.chapter_id}/writing_book/#edit_script_final")
	  elsif params[:who_script] != "" && params[:who_feeling] != ""
	  	flash[:notice] = "セリフか気持ちどちらか一方をご選択ください。"
		render("chats/writing_book")
	  elsif params[:who_script] != ""
	  	@script = Script.new(
		  	chat_id: @chat.id,
			script_feeling: 1,
			character_id: params[:who_script].to_i,
			content: @content
		  )
		@script.save
		@who = Character.find_by(id: params[:who_script])
		@who.updated_at = Time.now
		@who.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{@chat.chapter_id}/writing_book/#edit_script_final")
	  elsif params[:who_feeling] != ""
	  	@script = Script.new(
		  	chat_id: @chat.id,
			script_feeling: 2,
			character_id: params[:who_feeling].to_i,
			content: @content
		  )
		@script.save 
		@who = Character.find_by(id: params[:who_feeling])
		@who.updated_at = Time.now
		@who.save
		redirect_to("/chats/#{params[:id]}/#{params[:book_id]}/#{@chat.chapter_id}/writing_book/#edit_script_final")
	  else
	  	flash[:notice] = "エラー"
		render("chats/writing_book")
	  end
  end
  
end
