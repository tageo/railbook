class Book < ActiveRecord::Base
  has_many :reviews
  has_many :users, through: :reviews
  has_and_belongs_to_many :authors
  has_many :memos, as: :memoable

  validates :isbn,
    presence: true,
    uniqueness: true,
    # uniqueness: { allow_blank: true },
    length: { is: 17 },
    # length: { is: 17 , allow_blank: true },
    format: { with: /\A[0-9]{3}-[0-9]{1}-[0-9]{3,5}-[0-9]{4}-[0-9X]{1}\z/ }
    # format: { with: /\A[0-9]{3}-[0-9]{1}-[0-9]{3,5}-[0-9]{4}-[0-9X]{1}\z/, allow_blank: true }
    # isbn: true
    # isbn: { allow_old: true }



  validates :isbn,
    presence: { message: 'は必須です'},
    uniqueness: { allow_blank: true,
      message: '%{value}は一意でなければなりません' },
    length: { is: 17 , allow_blank: true,
      message: '%{value}は%{count}桁でなければなりません' },
    format: { with: /\A[0-9]{3}-[0-9]{1}-[0-9]{3,5}-[0-9]{4}-[0-9X]{1}\z/,
      allow_blank: true, message: '%{value}は正しい形式ではありません'}


  # validate :isbn_valid? 


  validates :title,
    presence: true,
    length: { minimum: 1, maximum: 100 }


  # validates :title, uniqueness: { scope: :publish }


  validates :price,
    numericality: { only_integer: true, less_than: 10000 }

  validates :publish,
    inclusion:{ in: ['技術評論社', '翔泳社', '秀和システム', '日経BP社', 'ソシム'] }


end
