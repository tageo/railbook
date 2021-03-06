class RecordController < ApplicationController
	def find
		@books = Book.find([2,5,10])
		render 'hello/list'
	end


	def find_by
		@book = Book.find_by(publish: '技術評論社')
		render 'books/show'
	end


	def find_by2
		@book = Book.find_by(publish: '技術評論社', price: '2919')
		render 'books/show'
	end

	def where
		@books = Book.where(publish: '技術評論社')
		render 'hello/list'
	end


	def ph1
		@books = Book.where('publish = ? AND price >= ?',
			params[:publish], params[:price])
		render 'hello/list'
	end

	def not
		@books = Book.where.not(isbn: params[:id])
		render 'books/index'
	end

	def order
		@books = Book.where(publish: '技術評論社').order(published: :desc)
		# @books = Book.where(publish: '技術評論社').order(published: :desc, price: :asc)
		# @books = Book.where(publish: '技術評論社').order(published: :desc, :price)
		render 'hello/list'
	end

	def reorder
		# @books = Book.order(:publish).order(:price)
		 @books = Book.order(:publish).reorder(:price)
		# @books = Book.order(:publish).reorder(nil)
		render 'books/index'
	end

	def select
		@books = Book.where('price >= 2000').select(:title, :price)
		render 'hello/list'
	end

	def select2
		@pubs = Book.select(:publish).distinct.order(:publish)
		# @pubs = Book.select(:publish).distinct.distinct(false)
	end

	def offset
		@books = Book.order(published: :desc).limit(3).offset(4)
		render 'hello/list'
	end

	def page 
		page_size = 3
		page_num = params[:id] == nil ? 0 : params[:id].to_i - 1
		@books = Book.order(publish: :desc).limit(page_size).offset(page_size * page_num)
		render 'hello/list'
	end

	def last
		@book = Book.order(published: :desc).last
		render 'books/show'
	end

	def groupby
		@books = Book.select('publish, AVG(price) AS avg_price').group(:published)
	end

	def havingby
		@books = Book.select('publish, AVG(price) AS avg_price').group(:publish).having('AVG(price) >= ?', 1500)
		render 'record/groupby'
	end


	def unscope
		@books = Book.where(publish: '技術評論社').order(:price).select(:isbn, :title).unscope(:where, :select)
		render 'books/index'
	end

	def belongs
		@review = Review.find(3)
	end

	def hasmany
		@book = Book.find_by(isbn: '978-4-7741-5878-5')
	end

	def has_and_belongs
		@book = Book.find_by(isbn: '978-4-7741-5611-8')
	end

	def has_many_through
		@user = User.find_by(username: 'isatou')
	end

	def cache_counter
		@user = User.find(1)
		render text: @user.reviews.size
	end

	def memorize
		@book = Book.find(1)
		#書籍情報に関するメモを登録
		@memo = @book.memos.build({body:'あとで買う'})
		if @memo.save
			render text: 'メモを作成しました。'
		else
			render text: @memo.errors.full_messages[0]
		end
	end

	def assoc_join
		@books = Book.joins(:reviews, :authors).
		order('books.title, reviews.updated_at').
		select('books.*, reviews.body, authors.name')
	end

	def assoc_join2
		@books = Book.joins(reviews: :user).
		select('books.*,reviews.body,users.username')
	end

	def assoc_join3
		@books = Book.joins('LEFT JOIN reviews ON reviews.book_id = books.id').
		select('books.*,reviews.body')
	end


	def assoc_includes
		@books = Book.includes(:authors).all
	end

end
