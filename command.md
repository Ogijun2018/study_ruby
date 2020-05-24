# ruby command集

## バージョンの選択方法
確認... `ruby -v`, `rvm list`
変更... `rvm use ***(使用するrubyのバージョン)`
デフォルトに設定 `rvm --default use ***`

## 新規Railsプロジェクトの作成
`$ rails _5.2.1_ new hello`

## データベースの作成
`$ rails db:create`

## Webサーバー(Puma)の立ち上げ
`$ rails s(server)`

## コントローラーの作成
`$ rails generate controller users index`
controllerを作成する指示
users...controllerの名前
index...user controller内で定義するメソッドの名前（アクション）

## コントローラーの作成2
`$ rails g controller questions index show new edit`
rails g controller...controllerを作成する指示
index, show, new, edit...作成するメソッドの名前

## ルーティング
`$ rails routes`
URLとアクションの対応表が表示される。

routes.rbはルーティング情報を記述している
```
                   Prefix Verb URI Pattern                                                                              Controller#Action
              users_index GET  /users/index(.:format)                                                                   users#index
       rails_service_blob GET  /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
rails_blob_representation GET  /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
       rails_disk_service GET  /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
update_rails_disk_service PUT  /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
     rails_direct_uploads POST /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
```

## Modalの作成
`$ rails g model user name:string age:integer`
- モデル名は単数形を使う
- カラム名:データ型

/db/migrate/timestamp_create_users.rb
マイグレーションファイル マイグレーションとはデータベースのテーブルの構造に変更を加えることを指す

## データベースの確認
`$ rails dbconsole`
今回はsqliteのコンソールが開く
`sqlite> .tables`
で
```
ar_internal_metadata  schema_migrations     users
```

`sqlite> .schema users(テーブル名)`
で
```
CREATE TABLE "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "age" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
```

`sqlite> .q`
rails consoleを終了

## データベースの操作
- rails consoleを使用する(rails版のirbのようなもの)
`rails c(console)`

- Userモデルの中身をすべて表示
`2.6.3 :001 > User.all`

- idを取得して変数に格納
`変数 = User.find(num)`

- 値の保存
`変数.save`