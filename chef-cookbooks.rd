= Chefを使うなら知っておいた方が便利なn個のCookbook

: author
  西田雄也
: place
  松江Ruby会議05
: theme
  lightning-simple
: allotted-time
  5m

= 自己紹介

= 仕事はRubyとJavaScript
= 趣味
= Chefとか
= Vagrantとか
= その辺で遊んでいます

= Chef使っている人

= サーバ構成変更ツール
= 他人のCookbook
= で
= 楽できる
= 他人のふんど^h^h^h Cookbook

* （程度の差はあるけど）よく作り込まれているものが多い．
* Node Objectに書くだけでインストール・設定できる．
* 追加Resourceが使えるようになる．
* クロスプラットホームで同じように書ける．Debian系とRedHat系とか

= いくつか
= 便利なCookbookの
= 紹介

= database
= database

* 各種RDBMSのためのCookbook
* データベースの作成 (database Resource)

    database "redmine_production" do
      provider Chef::Provider::Database::Postgresql
      connection {...} # 接続先ホストとか...省略
      owner "redmine"
      encoding "UTF8"
      action :create
    end

= database

* 各種RDBMSのためのCookbook
* データベースユーザの作成 (database_user Resource)

    database_user "redmine" do
      provider Chef::Provider::Database::PostgresqlUser
      connection {...} # 接続先ホストとか...省略
      password node["redmine_database_password"]
      privileges [:select, :update, :insert]
      action :create
    end

= rbenv
= rbenv

* やれること
  * rbenvそのもののインストールやruby-buildによるrubyのインストール
  * rbenvで管理しているRubyにgemをインストール
  * ユーザごとにrbenvインストール
* Chef社が出しているもの ((*じゃない*)) ものが特に便利
    # Berksfile
    cookbook "rbenv", github: "fnichol/chef-rbenv"

= rbenv

* 使うRubyのバージョン指定ができるscript Resourceがある．
    rbenv_script "migrate_rails_database" do
      rbenv_version "2.1.1"
      user          "redmine"
      group         "redmine"
      cwd           "/opt/redmine/current"
      code          %{rake RAILS_ENV=production db:migrate}
    end

= build-essential
= build-essential

* Cのコンパイル環境が必要な場合はこのCookbook
  * rubyをビルドするとき
  * 拡張ライブラリが入ったgemをインストールするとき
  * その他もろもろ

= build-essential

* Cのコンパイル環境が必要なCookbookで依存していることが多いCookbook．
* gccやmakeが ((*早い*)) 段階で必要な場合は次のような指定を行う．
    # nodes/HOST.json
    ...
      "build_essential": {
        "compiletime": true
      },
    ...

= gem_binary
= gem_binary

* 他人のCookbookでgemがインストールされるときに使うgemコマンドのパスを指定するのに使ったりする．
* 通常（使わないとき）はChefが動作するときのRubyが使うgemにインストールされる．
  * debパッケージでChefを入れた場合はdebパッケージに同梱されているgemにインストールされる．
* 自分のCookbookであればrbenv Cookbookのrbenv_gem Resourceを使えばいいでしょう．

= gem_binary

  # Berksfile
  cookbook "gem_binary",
    github: "royratcliffe/gem_binary-cookbook"
  
  # nodes/HOST.json
  ...
    "gem_binary": "/usr/bin/gem1.9.1",
  ...

= ロカール関連
= ロカール関連

* ロカール関連Cookbook
  * locale-gen ロカールの生成
  * locales 設定変更
* ロカールがen-USになっているときにja_JP.UTF-8にするために使用する．
  * 例えばどこかから拾ってきたVagrantのBoxがen-USになっているときとか．

= ロカール関連

  # nodes/HOST.json
  ...
  "localegen": {
    "lang": [
      "ja_JP.UTF-8 UTF-8"
    ]
  },
  "locales": {
    "default": "ja_JP.UTF-8",
    "available": [
      "ja_JP.UTF-8 UTF-8"
    ]
  },
  ...

= まとめ
= まとめ

* 他人のふんど^h^h^hCookbook怖くない．
  * Serverspecでサーバの振舞いを記述すればよい．
  * 自前で書いても数ヶ月・数年先には忘れる．
* README.mdに使い方書いてあるし，なかったらrecipe/default.rbとかを読めばおk
* 自分の管理ポリシーに合わせられなかったら合うように修正してより汎用的にできたらpull-requestしましょう．

#= まとめ

= ご静聴ありがとうございました

# = cron
# 
# # https://github.com/opscode-cookbooks/cron
# = etckeeper
# = iptables_pot
# = apache2
