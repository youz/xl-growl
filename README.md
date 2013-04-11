# xl-growl
GNTP (Growl Network Transport Protocol) Client Library for xyzzy

[Growl for Windows](http://www.growlforwindows.com/gfw/default.aspx)へ
通知を送信する機能を提供します。
[Growl for Linux](https://github.com/mattn/growl-for-linux)への送信も
一部機能を除いて可能です。


## Install
- NetInstallerをよりインストール
 
    下記のURLのパッケージリストを登録し、パッケージ`*scrap*`よりインストールして下さい。

    http://youz.github.io/xyzzy/packages.l

- 手動インストール

    growl.l を`*load-path*`に配置してください。

## Usage
growlパッケージより、以下の3つの関数がexportされています。

- notify (title text &key host name icon priority sticky)

    ふつうの通知。

    * host -- gntpサーバーのホスト名。
              省略するとlocalhostになります。

    * name -- 通知アプリケーション名。
              省略すると"xyzzy"になります。

    * icon -- 通知に表示するアイコンのファイルパス or URL。
              省略時は[xyzzy wiki](http://xyzzy.s53.xrea.com/wiki/)のロゴ
              (Data URI schemeで指定)になります。

    * priority -- 通知の重要度(-2～2の範囲の整数)。
              省略時は0になります。

    * sticky -- non nilな値を指定すると、クリックするかキー操作で閉じない限り
                通知が消えません。


- notify-with-url-callback
    (title text url &key host name icon priority sticky)

    URLコールバック付き通知。
    通知をクリックすると指定したURLがシステム標準のWEBブラウザで表示されます。

- notify-with-socket-callback
    (title text context context-type
     &key host name icon priority sticky onclick onclose ontimeout handler)
    
    ソケットコールバック付き通知。
    通知へのアクションに応じてコールバックを実行します。

    ※ Growl for Linuxは現在ソケットコールバックをサポートしていません。

    * context -- 任意の文字列。コールバック関数に渡されます。
    * context-type -- 任意の文字列。コールバック関数に渡されます。
    * onclick -- クリックして閉じた時に実行するコールバック関数。
    * onclose -- キー操作で閉じた時に実行するコールバック関数。
    * ontimeout -- タイムアウトで閉じた時に実行するコールバック関数。
    * handler -- 上記3つを使わず、全てのアクションで同一の処理をする場合に使用。

        コールバックには、以下のレスポンスデータがキーワード引数で渡されます。

        * result -- アクション ("CLICK" or "CLOSE" or "TIMEDOUT")
        * timestamp -- 時刻
        * name -- 通知時に指定した通知アプリケーション名
        * context -- 通知時に指定したcontext
        * context-type -- 通知時に指定したcontext-type


GNTPの仕様については
http://www.growlforwindows.com/gfw/help/gntp.aspx
を参照してください。


## Examples

    (require "growl")
    
    (growl:notify "test" "Hello, world!")
    
    (growl:notify-with-url-callback
     "xyzzy" "xyzzy wiki" "http://xyzzy.s53.xrea.com/wiki/")
    
    (growl:notify-with-socket-callback
     "xyzzy" "Click Me!" "from *scratch*" "test"
     :handler (lambda (&key result timestamp context context-type)
                (msgbox "[~A: ~A]~%result: ~A~%time: ~A"
                        context-type context result timestamp)))

## Author
Yousuke Ushiki (<citrus.yubeshi@gmail.com>)

[@Yubeshi](http://twitter.com/Yubeshi/)

## Copyright
MIT License を適用しています。

