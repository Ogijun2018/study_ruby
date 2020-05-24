# Study of Ruby on Rails

### RubyGems
- 幅広いライブラリがgemという形式で公開。
- よく使う機能などがgemで公開されており、利用することで開発工数が削減できる。
- RubyGemsは、ライブラリの作成や公開、インストールを助けるシステム。

### 採用事例
Airbnb, GitHub, Square, Cookpad, freee etc...
スタートアップやベンチャー企業によく使われる

### 学習環境について
このチューチュートリアルはRuby on Rails バージョン5を前提に進めていく。

## MVCアーキテクチャ
- Modal
    - データベースアクセスなどデータ関連処理
- View
    - 画面表示
- Controller
    - ViewとModelの橋渡し

## Railsの基本理念
- 設定より規約
例) データベースのテーブル名はモデルの複数形にする。
モデル名: User -> テーブル名: users

- 同じことを繰り返さない
例) 消費税の計算用のコードが、複数箇所に重複して書かれている。

## Hello World!
- Controller (users) を作成する
- 作成されたcontroller(ここではusers_controller)のindexアクション（メソッド）で、以下の文を実行する。
render plain: 'Hello, World!'
render -> 「Webページで表示させる」コマンド
plain: 平文を指定

すると、https://~~~~/users/indexに"Hello World!"が表示される

- ルーティング
get 'users/index' to: 'users#index'
usersコントローラーのindexアクションを発動したらusers/indexに表示することを指示

## View (テンプレート)
- ERB
Embedded Rubyの略
htmlの中に、rubyのプロフラムを埋め込むことができる。
テンプレートエンジン

- 規約
app/views/users/index.html.erb
->
app/views/コントローラー名/アクション名.html.erb
のように規約が決まっているので、UsersControllerに指示がきたときにviewを指定するコードを書く必要はない

UsersControllerのindexアクションが呼ばれると、index.html.erbが描画される（View）

## ControllerからViewに値を渡す
Controllerの中で `@num = 10 + 1` などを書く
@をつけるとインスタンス変数となり、index以外でも参照できるようになる -> viewでも見れる
index.html.erbで　`<%= @num %>` で表示できる

## データベースの確認と変更
->
```
  User Load (1.3ms)  SELECT  "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
 => #<ActiveRecord::Relation []> 
 ```
 SQL文がかえってくる

 - 新しいUserモデルのインスタンスを作成し、値をセットして保存する
```
2.6.3 :002 > user = User.new
 => #<User id: nil, name: nil, age: nil, created_at: nil, updated_at: nil> 
2.6.3 :003 > user.name = 'Yuta Nakamura'
 => "Yuta Nakamura" 
2.6.3 :004 > user.age = 20
 => 20 
2.6.3 :005 > user.save
```

```
(0.1ms)  begin transaction
User Create (1.2ms)  INSERT INTO "users" ("name", "age", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["name", "Yuta Nakamura"], ["age", 20], ["created_at", "2020-05-24 03:57:39.752977"], ["updated_at", "2020-05-24 03:57:39.752977"]]
(5.9ms)  commit transaction
=> true 
```
trueが返ってくれば成功

もう一度 `User.all` をすると
```
2.6.3 :010 > User.all
User Load (0.1ms)  SELECT  "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<User id: 1, name: "Yuta Nakamura", age: 20, created_at: "2020-05-24 03:57:39", updated_at: "2020-05-24 03:57:39">, #<User id: 2, name: "Taro Yamada", age: 24, created_at: "2020-05-24 04:01:03", updated_at: "2020-05-24 04:01:03">]> 
 ```
新しいインスタンスが入っている。

- インスタンスの値を変更する
```
2.6.3 :012 > yamada = User.find(2)
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 2], ["LIMIT", 1]]
 => #<User id: 2, name: "Taro Yamada", age: 24, created_at: "2020-05-24 04:01:03", updated_at: "2020-05-24 04:01:03"> 
2.6.3 :013 > yamada.name = 'Hanako Yamada'
 => "Hanako Yamada" 
2.6.3 :014 > yamada.age = 30
 => 30 
2.6.3 :015 > yamada.save
   (0.1ms)  begin transaction
  User Update (0.9ms)  UPDATE "users" SET "name" = ?, "age" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["name", "Hanako Yamada"], ["age", 30], ["updated_at", "2020-05-24 04:03:29.720393"], ["id", 2]]
   (6.1ms)  commit transaction
 => true 
 ```

 - レコードの削除
 `変数.destroy`で削除できる
 ```
 2.6.3 :018 > yamada = User.find(2)
  User Load (0.2ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 2], ["LIMIT", 1]]
 => #<User id: 2, name: "Hanako Yamada", age: 30, created_at: "2020-05-24 04:01:03", updated_at: "2020-05-24 04:03:29"> 
2.6.3 :019 > yamada.destroy
   (0.1ms)  begin transaction
  User Destroy (1.1ms)  DELETE FROM "users" WHERE "users"."id" = ?  [["id", 2]]
   (6.4ms)  commit transaction
 => #<User id: 2, name: "Hanako Yamada", age: 30, created_at: "2020-05-24 04:01:03", updated_at: "2020-05-24 04:03:29"> 
 ```

`User.find(2).destroy`でも可

- データベースの値をWebページに表示
最初にレコードを作成する
```
2.6.3 :001 > nakamura = User.new(name: 'Nakamura', age: 20)                 
 => #<User id: nil, name: "Nakamura", age: 20, created_at: nil, updated_at: nil> 
2.6.3 :002 > nakamura.save
```
上のコードの省略形

値を入れ終わったら、modelで@usersインスタンスを作成して、Userのレコードを入れる

`@users = User.all`

これでviewから参照できるようになる

```
<ul>
  <% @users.each do |user| %>
      <li><%= user.id %>, <%= user.name %>, <%= user.age %></li>
  <% end %>
</ul>
```