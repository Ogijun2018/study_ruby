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

## Modelの作成
