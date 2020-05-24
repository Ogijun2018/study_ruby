# Q&Aミニサービスの構築

### 新規railsプロジェクトの作成
`rails _5.2.1_ new qanda`

### 設定の変更
- Gemfileにて`gem 'sqlite3', '~> 1.3.6'`を追記
- `bundle update`
- `rails db:create`

### controllerの作成
`$ rails g controller questions index show new edit`

### modelの作成
`$ rails g model question name:string title:string content:text`

### 設定をデータベースに反映
`$ rails db:migrate`
確認
`$ rails dbconsole`
`sqlite> .schema`

### ルーティングの設定
qanda/app/config/routes.rb
get...
get...
get...
get...
を削除し、`resources :questions` を記入することでquestions関係のルーティングを自動でやってくれる

### rootメソッドの設定
qanda/app/config/routes.rb
`root 'questions#index'` を記入することでURLに何も記入しない状態でquestions/indexが呼ばれるようになる

### 質問一覧ページの作成
qanda/app/constollers/questions_controller
`def index`の部分に`@questions = Question.all`を追記
インスタンス変数questionsにQuestionのデータベース全てが入っている
qanda/app/views/questions/index.html.erb
で`<% @questions.each do |question| %>`とすることで変数を取り出せる

### シードファイルを使った初期データの投入
rails consoleを使って一つずついれるのでもよいが、db/seeds.rbにコードを書くことでも追加できる
```
Question.create(id: 1, name: 'Test name 1', title: 'Test Question 1', content: 'Test content 1')
Question.create(id: 2, name: 'Test name 2', title: 'Test Question 2', content: 'Test content 2')
Question.create(id: 3, name: 'Test name 3', title: 'Test Question 3', content: 'Test content 3')
```
- もしidを重複してしまいエラーが出てしまったら？
一回その状態で`rails db:seed`をしていると、id:1の部分だけ反映された状態になってしまうのでエラーが出る。
`rails console`, `Question.destroy_all`,`exit`, `rails db:seed`で復活できる。 

### bootstrapの導入
- Gemfileに追記
```
gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails', '~> 4.3.1'
```

- app/assets/stylesheets/application.css(scss)に追記
`@import "bootstrap";`

- app/assets/javascripts/application.jsに追記
```
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3　ここを追記
//= require popper ここを追記
//= require bootstrap-sprockets　ここを追記
//= require_tree .
```
追記した文は https://github.com/twbs/bootstrap-rubygem より。

- 要素を中央揃えにする
views/layouts/application.html.erbを編集
このファイルはhtmlタグやheadタグなど、html全体で必要なstyleが当てられる
ここで
```
<div class="container">
    <%= yield %>
</div>
```

### 新規質問の投稿 view
/views/questions/new.html.erb
```
<div>
  <div class="col-md-4 offset-md-4">
    <h2 class"text-center">New question</h2>
    <%= form_with model: @question, local:true do |f| %>
      <div class="form-group">
        <label>Name</label>
        <%= f.text_field :name, class: "form-control" %>
      </div>
      <div class="form-group">
        <label>Title</label>
        <%= f.text_field :title, class: "form-control" %>
      </div>
      <div class="form-group">
        <label>Content</label>
        <%= f.text_field :content, class: "form-control" %>
      </div>
      <div class="text-center">
        <%= f.submit "Save", class: "btn btn-primary" %>
      </div>
    <% end %>
  </div>
</div>
```

form_with, text_fieldなどはフォームヘルパーと呼ばれるもので自動で生成してくれる
form_with...フォームを作成してくれるメソッド
model...コントローラーから渡されたモデルオブジェクトを設定
local...非同期通信のなしあり

### 投稿データの保存
controllers/questions_controller.rb
このように記述する。
```
class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to root_path, notice: 'Success!'
    else
      flash[:alert] = 'Save error!'
      render :new
    end
  end

  def edit
  end
  
  private
    def question_params
      params.require(:question).permit(:name, :title, :content)
    end
end
```

resources :questionsを書いたことにより、新しいレコードを作成した時はcreateメソッドが呼ばれることになっている。その中で、
`@question = Question.new(question_params)`
これはquestion_paramsメソッドの返り値を@questionに入れている。
question_paramsは
```
private
    def question_params
      params.require(:question).permit(:name, :title, :content)
    end
```
ストロングパラメーターを使ってフォームから送られてきた特定のデータのみ受け付けるようにする。
params...フォームから送られてきたデータが格納されている
requireの中でquestionの中でname,title,contentの要素のみ受け付ける
これをすることで値を勝手に書き換えられた時に変な更新が起きないようになる

もしsaveが成功したら、redirect_to root_path, notice: 'Success!'でrootにリダイレクトしsuccessをアラートで表示する。

失敗したら、
```
else
    flash[:alert] = 'Save error!'
    render :new
```
でもう一度newページに戻るという指示をしている。
paramsに入っている値を確認するにはbyebugを使用する

### バリデートの追加
空のデータを入れることをできなくするために、値が正当か確認するバリデートを追加する。
models/question.rb
```
class Question < ApplicationRecord
    validates :name, presence: true
    validates :title, presence: true
    validates :content, presence: true
end
```
これで入力必須になる

### エラーメッセージの表示
views/layouts/application.html.erb
```
<% if flash[:notice] %>
    <p class="text-success"><%= flash[:notice] %></p>
<% end %>
<% if flash[:alert] %>
    <p class="text-danger"><%= flash[:alert] %></p>
<% end %>
```
成功した時の動作（上）、失敗した時の動作（下）

### 質問投稿画面へのリンク
views/questions/index
```
<div>
    <%= link_to 'New question', new_question_path %>
</div>
```
link_to...viewヘルパーと呼ばれるメソッド htmlを書かなくてもリンクできる
第一引数がリンクテキスト
第二引数がリンクURL
new_questions_pathは
```
new_question GET    /questions/new(.:format)                                                                 questions#new
```
ここからきている。

### 質問編集画面へのリンク
Editにリンクを繋げる
```
edit_question GET    /questions/:id/edit(.:format)                                                            questions#edit
```
これを使う。
`[<%= link_to 'Edit', edit_question_path(question)%>]`
edit_question_pathの引数にquestionをいれることでidが渡り、使えるようになる

### 質問編集画面 View
基本的なUIは新規作成画面と同じなので、コードをそのまま使う。

### 質問編集画面 Controller
controllers/questions_controller.rb
`@question = Question.find(params[:id])`
edit画面にはparamsでidが渡されているのでidが使える

edit画面でsaveを押した場合はupdateメソッドが呼ばれる
```
def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
        redirect_to root_path, notice: 'Success!'
    else
        flash[:alert] = 'Save error!'
        render :edit
    end
end
```
フォームから送られてくるIDを基にデータベースからデータを引っ張ってくる
updateメソッドを使うquestion_params(ストロングパラメータを使って判定)
そしてrootに戻る

### コードの共通化
newとeditはほとんどがコードが同じなので、共通化する。
view/questionsフォルダに`_form.html.erb`を作成する
共通化するファイルには頭に"_"をつけるのが慣習

こうすることで、もともと必要だった部分に
`<%= render 'form' %>`を記述するだけで読み込むことができる。

### 質問削除機能の追加
controllers/questions_controller.rb
```
def destroy
    @question = Question.fine(params[:id])
    @question.destroy
    redirect_to root_path, notice: 'Success!'
end
```

index.html.erb
`[<%= link_to 'Delete', question_path(question), method: :delete, data:{ confirm: 'Are you sure?'}%>`

### 質問詳細画面へのリンク
`<%= link_to question.title, question_path(question) %>`
これでQuestions#showに繋がるルーティングができる(rails routesで確認)

### 質問編集画面の実装
controllers/questions_controller.rb
```
def show
    @question = Question.find(params[:id])
end
```

show.html.erb
```
<div class="row">
    <div class="col-md-12">
        <h2><%= @question.title %></h2>
        <div>
            Content: <%= @question.content %>
        </div>
        <div>
            Name: <%= @question.name %>
        </div>
        <hr>
        <div>
            <%= link_to '> Home', root_path %>
        </div>
    </div>
</div>
```

### Answersコントローラーの作成
`$ rails g controller answers edit`

### Answersモデルの作成
テーブルの構造
質問（questions）1　対　回答（answers）多
`$ rails g model answer question:references name:string content:text`
question:referencesで1対多の関係を定義することができる

models/answer.rb
`belongs_to :question`というコードでquestionに紐づくという意味

models/question.rbに追記
`has_many :answers, dependent: :destroy`
has_manyで一つのquestionに複数のanswerを持つことを定義
dependent: :destroyでquestionが削除された時に紐づけられているanswerを削除することを定義

### 回答関連のルーティング設定
以下のように書き換え
```
resources :questions do
    resources :answers
end
```

### 回答の投稿機能の追加
controllers/questions_controller.rb
```
def show
    @question = Question.find(params[:id])
    @answer = Answer.new
end
```

views/show.html
追記
```
<h3>Post new answer.</h3>
    <%= form_with model: [@question, @answer], local: true do |f| %>
        <%= f.hidden_field :question_id, {value: @question.id} %>
        <div class="form-group">
            <label>Name</label>
            <%= f.text_field :name, class: 'form-control' %>
        </div>
        <div class="form-group">
            <label>Content</label>
            <%= f.text_area :content, class: 'form-control' %>
        </div>
        <div class="text-center">
            <%= f.submit "Post", class: 'btn btn-primary' %>
        </div>
<% end %>
```
<%= form_with model: [@question, @answer], local: true do |f| %>
questionモデルに紐づくanswerモデルをformで送信する場合は`[@question, @answer]`とかく

<%= f.hidden_field :question_id, {value: @question.id} %>
HTMLには表示されないけどフィールドを置いておく

### 回答が投稿されたときの保存処理
controller/answers_controller.rb
```
class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new
    if @answer.update(answer_params)
      redirect_to question_path(@question), notice: 'Success!'
    else
      redirect_to question_path(@question), alert: 'Invalid!'
    end
  end
  def edit
  end
  
  private
  def answer_params
    params.require(:answer).permit(:content, :name, :question_id)
  end
end
```

### answerモデルのバリデーション設定
models/answer.rb
追記
```
validates :content, presence: true
validates :name, presence: true
```

### 回答一覧表示
views/questions/show.html.erb
質問詳細画面で回答が1以上あれば表示、0ならno answerと表示する
追記
```
<h3>Answer</h3>
<table class="table table-striped">
    <% if @question.answers.any? %>
        <thead class="thead-light">
            <tr>
                <td>Answer</td>
                <td>Name</td>
                <td>Menu</td>
            </tr>
        </thead>
        <tbody>
            <% @question.answers.each do |answer| %>
                <tr>
                    <td>
                        <%= answer.content %>
                    </td>
                    <td>
                        <%= answer.name %>
                    </td>
                    <td>
                        [Edit][Delete]
                    </td>
                </tr>
            <% end %>
        </tbody>
    <% else %>
        <p>No answer yet.</p>
    <% end %>
</table>
```

こうすることで、
controllers/question_controllerのshowを見ると
@question = Question.findというようにQuestionsテーブルからfindしかしていないが、modelsのquestions.rbでhas_may :answersとすることでQuestionモデルからfindすると自動的に紐づくAnswerのデータも取得することができる。
@question.answersでそのデータを使うことができる。（配列でくる）

### 回答の編集①
ルーティングで確認
```
 edit_question_answer GET    /questions/:question_id/answers/:id/edit(.:format)                                       answers#edit
 ```
 views/questions/show.html.erb
Editとなっているところを
`[<%= link_to 'Edit', edit_question_answer_path(@question, answer) %>][Delete]`
と書き換え
edit_question_answer_pathは先ほどのルーティングから

controller
```
def edit
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
end
```

views/answers/edit.html.erb
```
<div>
    <h2>Update answer</h2>
    <%= form_with model:[@question, @answer], local: true do |f| %>
        <div class="form-group">
            <div class="form-group">
                <label>Name</label>
                <%= f.text_field :name, class:"form-control" %>
            </div>
            <div class="form-group">
                <label>Content</label>
                <%= f.text_area :content, class:"form-control" %>
            </div>
            <div class="form-center">
                <%= f.submit "Update", class:"btn btn-primary" %>
            </div>
        </div></div>
    <% end %>
</div>
```

### 回答の編集②
Submitボタンを押した時の動作を変更
answers_controller
```
def update
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if @answer.update(answer_params)
      redirect_to question_path(@question), notice: 'Success!'
    else
      flash[:alert] = "Invalid!"
      render :edit
    end
  end
```

### 回答の削除
views/questions/show.html.erb
`[<%= link_to 'Delete', question_answer_path(@question, answer), method: :delete, data:{confirm: 'Are you sure?'} %>]`
を追記

controllers/answers_controller
```
def destroy
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    redirect_to question_path(@question), notice: 'Deleted!'
end
```

共通化
controllerで重複している文（`@question = Question.find(params[:id])`）があるので、まとめる。
```
 private
    def set_question
      @question = Question.find(params[:id])
    end
```
と記述した後、class Questions...のすぐ下に
```
before_action :set_question, only: [:show, :edit, :update, :destroy]
```
と記述する。こうすることで、actionが呼び出されるまえ、show,edit,update,destroyではset_questionを呼び出す、ということができる。

# 完成！！！

# デプロイする時の設定
1. Gemfile
herokuはpostgreSQLしかDBに使えないので、ずっと使ってきたsqliteが使えないので変更する
```
group :production do
  gem 'pg', '~> 0.18.4'
end
```
`$ bundle install --without production`


2. database.ymlの変更
```
production:
  <<: *default
  adapter: postgresql
  encoding: unicode
```

3. config/production.rb
`config.assets.compile = false`をtrueに変更

4. config/routes.rb
`root 'questions#index'`を設定する